package com.harmonycloud.zeus.service.components.impl;

import com.alibaba.fastjson.JSONObject;
import com.harmonycloud.caas.common.enums.ComponentsEnum;
import com.harmonycloud.caas.common.enums.ErrorMessage;
import com.harmonycloud.caas.common.enums.middleware.StorageClassProvisionerEnum;
import com.harmonycloud.caas.common.exception.BusinessException;
import com.harmonycloud.caas.common.model.ClusterComponentsDto;
import com.harmonycloud.caas.common.model.middleware.MiddlewareClusterDTO;
import com.harmonycloud.caas.common.model.middleware.PodInfo;
import com.harmonycloud.zeus.annotation.Operator;
import com.harmonycloud.zeus.service.components.AbstractBaseOperator;
import com.harmonycloud.zeus.service.components.api.LocalPathService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import java.io.File;
import java.util.*;

import static com.harmonycloud.caas.common.constants.NameConstant.SUPPORT;

/**
 * @author xutianhong
 * @Date 2021/10/29 4:26 下午
 */
@Service
@Operator(paramTypes4One = String.class)
public class LocalPathServiceImpl extends AbstractBaseOperator implements LocalPathService {
    @Override
    public boolean support(String name) {
        return ComponentsEnum.LOCAL_PATH.getName().equals(name);
    }

    @Override
    public void deploy(MiddlewareClusterDTO cluster, ClusterComponentsDto clusterComponentsDto) {
        try {
            super.deploy(cluster, clusterComponentsDto);
        } catch (Exception e){
            if (StringUtils.isNotEmpty(e.getMessage()) && e.getMessage().contains("already exists")) {
                throw new BusinessException(ErrorMessage.LOCAL_PATH_ALREADY_EXIST);
            } else {
                throw e;
            }
        }
    }

    @Override
    public void integrate(MiddlewareClusterDTO cluster) {
        MiddlewareClusterDTO existCluster = clusterService.findById(cluster.getId());
        if (!existCluster.getStorage().containsKey(SUPPORT)){
            existCluster.getStorage().put(SUPPORT, new ArrayList<JSONObject>());
        }
        List<JSONObject> existSupport = (List<JSONObject>)existCluster.getStorage().get(SUPPORT);
        List<JSONObject> support = (List<JSONObject>)cluster.getStorage().get(SUPPORT);
        existSupport.addAll(support);
        existCluster.getStorage().put(SUPPORT, existSupport);
        clusterService.update(existCluster);
    }

    @Override
    public void delete(MiddlewareClusterDTO cluster, Integer status) {
        helmChartService.uninstall(cluster, "middleware-operator", ComponentsEnum.LOCAL_PATH.getName());
        cluster.getStorage().remove(StorageClassProvisionerEnum.LOCAL_PATH.getType());
        clusterService.update(cluster);
    }

    @Override
    protected String getValues(String repository, MiddlewareClusterDTO cluster, ClusterComponentsDto clusterComponentsDto) {
        return "image.repository=" + repository + "/local-path-provisioner" +
                ",storage.storageClassName=" + "local-path" +
                ",helperImage.repository=" + repository + "/busybox" +
                ",localPath.path=" + "/opt/local-path-provisioner";
    }

    @Override
    protected void install(String setValues, MiddlewareClusterDTO cluster) {
        helmChartService.installComponents(ComponentsEnum.LOCAL_PATH.getName(), "middleware-operator", setValues,
            componentsPath + File.separator + "local-path-provisioner", cluster);
    }

    @Override
    protected void updateCluster(MiddlewareClusterDTO cluster) {
        if (!cluster.getStorage().containsKey(SUPPORT)){
            cluster.getStorage().put(SUPPORT, new ArrayList<JSONObject>());
        }
        JSONObject object = new JSONObject();
        object.put("name", "local-path");
        object.put("type", "local-path");
        object.put("namespace", "middleware-operator");
        List<JSONObject> support = (List<JSONObject>)cluster.getStorage().get(SUPPORT);
        support.add(object);
        cluster.getStorage().put(SUPPORT, support);
        clusterService.update(cluster);
    }

    @Override
    protected List<PodInfo> getPodInfoList(String clusterId) {
        return podService.list(clusterId, "middleware-operator", ComponentsEnum.LOCAL_PATH.getName());
    }
}
