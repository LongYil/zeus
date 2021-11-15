package com.harmonycloud.zeus.service.components.impl;

import com.harmonycloud.caas.common.enums.ComponentsEnum;
import com.harmonycloud.caas.common.model.middleware.MiddlewareClusterDTO;
import com.harmonycloud.caas.common.model.middleware.MiddlewareClusterMonitor;
import com.harmonycloud.caas.common.model.middleware.MiddlewareClusterMonitorInfo;
import com.harmonycloud.caas.common.model.middleware.PodInfo;
import com.harmonycloud.zeus.annotation.Operator;
import com.harmonycloud.zeus.service.components.AbstractBaseOperator;
import com.harmonycloud.zeus.service.components.api.AlertManagerService;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import static com.harmonycloud.caas.common.constants.CommonConstant.SIMPLE;

import java.io.File;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @author xutianhong
 * @Date 2021/10/29 2:47 下午
 */
@Service
@Operator(paramTypes4One = String.class)
public class AlertManagerServiceImpl extends AbstractBaseOperator implements AlertManagerService {

    @Override
    public boolean support(String name) {
        return ComponentsEnum.ALERTMANAGER.getName().equals(name);
    }

    @Override
    public void integrate(MiddlewareClusterDTO cluster) {
        MiddlewareClusterDTO existCluster = clusterService.findById(cluster.getId());
        if (existCluster.getMonitor() == null){
            existCluster.setMonitor(new MiddlewareClusterMonitor());
        }
        existCluster.getMonitor().setAlertManager(cluster.getMonitor().getAlertManager());
        clusterService.updateCluster(existCluster);
    }

    @Override
    public void delete(MiddlewareClusterDTO cluster, Integer status) {
        //uninstall
        if (status != 2){
            helmChartService.uninstall(cluster, "monitoring", ComponentsEnum.ALERTMANAGER.getName());
        }
        //更新集群
        if (cluster.getMonitor().getAlertManager() != null){
            cluster.getMonitor().setAlertManager(null);
        }
        clusterService.updateCluster(cluster);
    }

    @Override
    public String getValues(String repository, MiddlewareClusterDTO cluster, String type){
        String setValues = "image.alertmanager.repository=" + repository + "/alertmanager" +
                ",clusterHost=" + cluster.getHost();
        if (SIMPLE.equals(type)) {
            setValues = setValues + ",replicas=1";
        }else {
            setValues = setValues + ",replicas=3";
        }
        return setValues;

    }

    @Override
    public void install(String setValues, MiddlewareClusterDTO cluster){
        helmChartService.upgradeInstall(ComponentsEnum.ALERTMANAGER.getName(), "monitoring", setValues,
                componentsPath + File.separator + "alertmanager", cluster);
    }

    @Override
    public void updateCluster(MiddlewareClusterDTO cluster){
        MiddlewareClusterMonitorInfo alertManager = new MiddlewareClusterMonitorInfo();
        alertManager.setProtocol("http").setPort("31902").setHost(cluster.getHost());
        cluster.getMonitor().setAlertManager(alertManager);
        clusterService.updateCluster(cluster);
    }

    @Override
    protected List<PodInfo> getPodInfoList(String clusterId) {
        return podService.list(clusterId, "monitoring", ComponentsEnum.ALERTMANAGER.getName());
    }

}
