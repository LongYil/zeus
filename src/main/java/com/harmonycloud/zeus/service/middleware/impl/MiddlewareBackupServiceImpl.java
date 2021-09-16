package com.harmonycloud.zeus.service.middleware.impl;

import com.harmonycloud.caas.common.base.BaseResult;
import com.harmonycloud.caas.common.enums.middleware.MiddlewareTypeEnum;
import com.harmonycloud.caas.common.model.MiddlewareBackupScheduleConfig;
import com.harmonycloud.caas.common.model.middleware.Middleware;
import com.harmonycloud.caas.common.model.middleware.MiddlewareBackupRecord;
import com.harmonycloud.caas.common.model.middleware.MiddlewareClusterDTO;
import com.harmonycloud.tool.uuid.UUIDUtils;
import com.harmonycloud.zeus.integration.cluster.bean.*;
import com.harmonycloud.zeus.operator.impl.BaseOperatorImpl;
import com.harmonycloud.zeus.service.k8s.ClusterService;
import com.harmonycloud.zeus.service.k8s.MiddlewareBackupCRDService;
import com.harmonycloud.zeus.service.k8s.MiddlewareBackupScheduleCRDService;
import com.harmonycloud.zeus.service.k8s.MiddlewareRestoreCRDService;
import com.harmonycloud.zeus.service.middleware.MiddlewareBackupService;
import com.harmonycloud.zeus.service.middleware.MiddlewareService;
import com.harmonycloud.zeus.util.CronUtils;
import io.fabric8.kubernetes.api.model.ObjectMeta;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 中间件备份
 *
 * @author liyinlong
 * @since 2021/9/15 3:22 下午
 */
@Slf4j
@Service
public class MiddlewareBackupServiceImpl implements MiddlewareBackupService {

    @Autowired
    private MiddlewareBackupScheduleCRDService backupScheduleCRDService;
    @Autowired
    private MiddlewareBackupCRDService backupCRDService;
    @Autowired
    private MiddlewareRestoreCRDService restoreCRDService;
    @Autowired
    private BaseOperatorImpl baseOperator;
    @Autowired
    private MiddlewareService middlewareService;
    @Autowired
    private ClusterService clusterService;

    @Override
    public List<MiddlewareBackupRecord> list(String clusterId, String namespace, String middlewareName, String type) {
        String middlewareRealName = getRealMiddlewareName(type, middlewareName);
        Map<String, String> labels = new HashMap<>();
        labels.put("middleware", middlewareRealName);

        List<MiddlewareBackupRecord> recordList = new ArrayList<>();
        MiddlewareBackupList middlewareBackupList = backupCRDService.list(clusterId, namespace, labels);
        if (middlewareBackupList != null && !CollectionUtils.isEmpty(middlewareBackupList.getItems())) {
            List<MiddlewareBackupCRD> items = middlewareBackupList.getItems();
            items.forEach(item -> {
                String backupName = item.getMetadata().getName();
                MiddlewareBackupStatus backupStatus = item.getStatus();
                if (backupStatus != null) {
                    List<MiddlewareBackupStatus.BackupInfo> backupInfos = backupStatus.getBackupInfos();
                    MiddlewareBackupSpec.StorageProvider.Minio minio = item.getSpec().getStorageProvider().getMinio();
                    String backupAddressPrefix = minio.getEndpoint() + "/" + minio.getBucketName() + "/";
                    MiddlewareBackupRecord backupRecord = new MiddlewareBackupRecord();
                    backupRecord.setBackupName(backupName);
                    backupRecord.setBackupTime(backupStatus.getBackupTime());
                    List<String> backupAddressList = new ArrayList<>();
                    backupInfos.forEach(backInfo -> {
                        backupAddressList.add(backupAddressPrefix + backInfo.getRepository());
                    });
                    backupRecord.setBackupAddressList(backupAddressList);
                    recordList.add(backupRecord);
                }
            });
        }

        return recordList;
    }

    @Override
    public BaseResult create(String clusterId, String namespace, String middlewareName, String type, String cron, Integer limitRecord) {
        String middlewareRealName = getRealMiddlewareName(type, middlewareName);
        if (StringUtils.isBlank(cron)) {
            return createNormalBackup(clusterId, namespace, middlewareRealName);
        } else {
            return createScheduleBackup(clusterId, namespace, middlewareRealName, cron, limitRecord);
        }
    }

    @Override
    public BaseResult update(String clusterId, String namespace, String middlewareName, String type, String cron, Integer limitRecord) {
        String backupName = getRealMiddlewareName(type, middlewareName) + "-backup";
        MiddlewareBackupScheduleCRD middlewareBackupScheduleCRD = backupScheduleCRDService.get(clusterId, namespace, backupName);
        try {
            MiddlewareBackupScheduleSpec spec = middlewareBackupScheduleCRD.getSpec();
            spec.setCron(cron);
            spec.setLimitRecord(limitRecord);
            backupScheduleCRDService.update(clusterId, middlewareBackupScheduleCRD);
            return BaseResult.ok();
        } catch (IOException e) {
            log.error("中间件{}备份设置更新失败", middlewareName);
            return BaseResult.error();
        }
    }

    @Override
    public BaseResult delete(String clusterId, String namespace, String backupName) {
        try {
            backupCRDService.delete(clusterId, namespace, backupName);
            return BaseResult.ok();
        } catch (IOException e) {
            log.error("删除备份记录失败");
            return BaseResult.error();
        }
    }

    @Override
    public BaseResult get(String clusterId, String namespace, String middlewareName, String type) {
        String backupName = MiddlewareTypeEnum.findByType(type).getMiddlewareCrdType() + "-" + middlewareName + "-backup";
        MiddlewareBackupScheduleCRD middlewareBackupScheduleCRD = backupScheduleCRDService.get(clusterId, namespace, backupName);
        MiddlewareBackupScheduleSpec spec = middlewareBackupScheduleCRD.getSpec();
        if (spec != null) {
            MiddlewareBackupScheduleConfig config = new MiddlewareBackupScheduleConfig(spec.getCron(), spec.getLimitRecord(), CronUtils.calculateNextDate(spec.getCron()));
            return BaseResult.ok(config);
        }
        return BaseResult.ok();
    }


    public BaseResult createScheduleBackup(String clusterId, String namespace, String middlewareRealName, String cron, Integer limitRecord) {
        MiddlewareBackupScheduleCRD middlewareBackupScheduleCRD = new MiddlewareBackupScheduleCRD();
        middlewareBackupScheduleCRD.setKind("MiddlewareBackupSchedule");
        String backupName = middlewareRealName + "-backup";
        middlewareBackupScheduleCRD.setMetadata(getMiddlewareLabels(namespace, backupName, middlewareRealName));

        MiddlewareBackupScheduleSpec middlewareBackupScheduleSpec = new MiddlewareBackupScheduleSpec(middlewareRealName, cron, limitRecord);
        middlewareBackupScheduleSpec.setName(middlewareRealName);
        middlewareBackupScheduleCRD.setSpec(middlewareBackupScheduleSpec);

        try {
            backupScheduleCRDService.create(clusterId, middlewareBackupScheduleCRD);
            return BaseResult.ok();
        } catch (IOException e) {
            log.error("备份创建失败", e);
            return BaseResult.error();
        }
    }

    public BaseResult createNormalBackup(String clusterId, String namespace, String middlewareRealName) {
        MiddlewareBackupCRD middlewareBackupCRD = new MiddlewareBackupCRD();
        middlewareBackupCRD.setKind("MiddlewareBackup");
        String backupName = middlewareRealName + "-" + UUIDUtils.get8UUID();
        middlewareBackupCRD.setMetadata(getMiddlewareLabels(namespace, backupName, middlewareRealName));

        MiddlewareBackupSpec spec = new MiddlewareBackupSpec();
        spec.setName(middlewareRealName);
        middlewareBackupCRD.setSpec(spec);

        try {
            backupCRDService.create(clusterId, middlewareBackupCRD);
            return BaseResult.ok();
        } catch (IOException e) {
            log.error("立即备份失败", e);
            return BaseResult.error();
        }
    }

    /**
     * 获取中间件labels
     *
     * @param backupName         备份名称
     * @param namespace          命名空间
     * @param middlewareRealName 中间件名称
     * @return
     */
    public ObjectMeta getMiddlewareLabels(String namespace, String backupName, String middlewareRealName) {
        ObjectMeta metaData = new ObjectMeta();
        metaData.setNamespace(namespace);
        metaData.setName(backupName);
        Map<String, String> labels = new HashMap<>();
        labels.put("middleware", middlewareRealName);
        metaData.setLabels(labels);
        return metaData;
    }

    /**
     * 获取服务中间件名称
     *
     * @param type
     * @param middlewareName
     * @return
     */
    public String getRealMiddlewareName(String type, String middlewareName) {
        return MiddlewareTypeEnum.findByType(type).getMiddlewareCrdType() + "-" + middlewareName;
    }

    @Override
    public BaseResult createRestore(String clusterId, String namespace, String middlewareName, String type, String restoreName, String backupName, String aliasName) {
        //check if exit
        Middleware middleware = middlewareService.detail(clusterId, namespace, middlewareName, type);
        middleware.setName(restoreName);
        middleware.setClusterId(clusterId);
        MiddlewareClusterDTO cluster = clusterService.findByIdAndCheckRegistry(middleware.getClusterId());
        baseOperator.createPreCheck(middleware, cluster);

        MiddlewareRestoreCRD crd = new MiddlewareRestoreCRD();
        ObjectMeta meta = new ObjectMeta();
        meta.setNamespace(namespace);
        meta.setName(restoreName);
        crd.setMetadata(meta);

        MiddlewareRestoreSpec spec = new MiddlewareRestoreSpec();
        spec.setBackupName(backupName);
        spec.setName(getRealMiddlewareName(type, middlewareName));
        crd.setSpec(spec);
        try {
            restoreCRDService.create(clusterId, crd);
            return BaseResult.ok();
        } catch (IOException e) {
            log.error("备份服务创建失败");
            return BaseResult.error();
        }
    }
}
