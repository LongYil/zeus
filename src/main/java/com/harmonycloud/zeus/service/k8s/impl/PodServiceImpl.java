package com.harmonycloud.zeus.service.k8s.impl;

import com.harmonycloud.caas.common.enums.DictEnum;
import com.harmonycloud.caas.common.enums.ErrorMessage;
import com.harmonycloud.caas.common.enums.middleware.ResourceUnitEnum;
import com.harmonycloud.caas.common.exception.BusinessException;
import com.harmonycloud.caas.common.model.ContainerWithStatus;
import com.harmonycloud.caas.common.model.StorageClassDTO;
import com.harmonycloud.caas.common.model.middleware.Middleware;
import com.harmonycloud.caas.common.model.middleware.MiddlewareQuota;
import com.harmonycloud.caas.common.model.middleware.PodInfo;
import com.harmonycloud.caas.common.model.middleware.PodInfoGroup;
import com.harmonycloud.tool.numeric.ResourceCalculationUtil;
import com.harmonycloud.zeus.integration.cluster.PodWrapper;
import com.harmonycloud.zeus.integration.cluster.bean.MiddlewareCR;
import com.harmonycloud.zeus.integration.cluster.bean.MiddlewareInfo;
import com.harmonycloud.zeus.service.k8s.MiddlewareCRService;
import com.harmonycloud.zeus.service.k8s.PodService;
import com.harmonycloud.zeus.service.k8s.StorageClassService;
import com.harmonycloud.zeus.service.middleware.impl.MiddlewareBackupServiceImpl;
import io.fabric8.kubernetes.api.model.Container;
import io.fabric8.kubernetes.api.model.ContainerStatus;
import io.fabric8.kubernetes.api.model.Pod;
import io.fabric8.kubernetes.api.model.ResourceRequirements;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;
import org.yaml.snakeyaml.Yaml;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicReference;
import java.util.stream.Collectors;

import static com.harmonycloud.caas.common.constants.NameConstant.CPU;
import static com.harmonycloud.caas.common.constants.NameConstant.MEMORY;
import static com.harmonycloud.caas.common.constants.middleware.MiddlewareConstant.PERSISTENT_VOLUME_CLAIMS;
import static com.harmonycloud.caas.common.constants.middleware.MiddlewareConstant.PODS;

/**
 * @author dengyulong
 * @date 2021/03/23
 */
@Service
public class PodServiceImpl implements PodService {

    @Autowired
    private PodWrapper podWrapper;
    @Autowired
    private MiddlewareCRService middlewareCRService;
    @Autowired
    private StorageClassService storageClassService;
    @Autowired
    private MiddlewareBackupServiceImpl middlewareBackupService;

    @Override
    public Middleware list(String clusterId, String namespace, String middlewareName, String type) {
        MiddlewareCR mw = middlewareCRService.getCR(clusterId, namespace, type, middlewareName);
        Middleware middleware = listPods(mw, clusterId, namespace, middlewareName, type);
        middleware.setHasConfigBackup(middlewareBackupService.checkIfAlreadyBackup(clusterId, middleware.getNamespace(), middleware.getType(), middleware.getName()));
        return middleware;
    }

    @Override
    public List<PodInfo> list(String clusterId, String namespace) {
        List<Pod> list = podWrapper.list(clusterId, namespace);
        if (CollectionUtils.isEmpty(list)) {
            return new ArrayList<>(0);
        }
        return list.stream().map(this::convertPodInfo).collect(Collectors.toList());
    }

    @Override
    public List<PodInfo> list(String clusterId, String namespace, String key) {
        List<Pod> list = podWrapper.list(clusterId, namespace).stream()
            .filter(pod -> pod.getMetadata().getName().contains(key)).collect(Collectors.toList());
        if (CollectionUtils.isEmpty(list)) {
            return new ArrayList<>(0);
        }
        return list.stream().map(this::convertPodInfo).collect(Collectors.toList());
    }

    @Override
    public List<PodInfo> list(String clusterId, String namespace, Map<String, String> labels) {
        List<Pod> list = podWrapper.list(clusterId, namespace, labels);
        if (CollectionUtils.isEmpty(list)) {
            return new ArrayList<>(0);
        }
        return list.stream().map(this::convertPodInfo).collect(Collectors.toList());
    }

    /**
     * 将podlist进行分组
     * @param podInfoList
     * @return
     */
    private PodInfoGroup convertListToGroup(List<PodInfo> podInfoList) {
        PodInfoGroup podInfoGroup = new PodInfoGroup();
        Map<String, List<PodInfo>> podMap = new HashMap<>();
        podInfoList.forEach(podInfo -> {
            String role = podInfo.getRole();
            List<PodInfo> infoList;
            if (role == null) {
                infoList = podMap.get("default");
                if (CollectionUtils.isEmpty(infoList)) {
                    infoList = new ArrayList<>();
                }
                podMap.put("default", infoList);
            } else {
                infoList = podMap.get(role);
                if (CollectionUtils.isEmpty(infoList)) {
                    infoList = new ArrayList<>();
                }
                podMap.put(role, infoList);
            }
            infoList.add(podInfo);
        });

        if (podMap.keySet().size() > 1) {
            List<PodInfoGroup> list = new ArrayList<>();
            podMap.forEach((k, v) -> {
                PodInfoGroup singlePodInfoGroup = new PodInfoGroup();
                singlePodInfoGroup.setRole(k);
                singlePodInfoGroup.setPods(v);
                singlePodInfoGroup.setHasChildGroup(false);
                list.add(singlePodInfoGroup);
            });
            podInfoGroup.setHasChildGroup(true);
            podInfoGroup.setListChildGroup(list);
        } else {
            podMap.forEach((k, v) -> {
                podInfoGroup.setRole(k);
                podInfoGroup.setPods(v);
                podInfoGroup.setHasChildGroup(false);
            });
        }
        return podInfoGroup;
    }
    /**
     * 获取pod真实状态
     * @param pod
     * @return
     */
    private String getPodRealState(Pod pod) {
        // 1. Terminating
        if (StringUtils.isNotBlank(pod.getMetadata().getDeletionTimestamp())) {
            return "Terminating";
        }

        // 2. Complete
        if ("Succeeded".equals(pod.getStatus().getPhase())) {
            return "Completed";
        }

        // 3. container not ready
        List<ContainerStatus> containerStatuses = pod.getStatus().getContainerStatuses();
        for (ContainerStatus containerStatus : containerStatuses) {
            if (!containerStatus.getReady()) {
                return "NotReady";
            }
        }
        return pod.getStatus().getPhase();
    }

    private PodInfo convertPodInfo(Pod pod) {
        PodInfo pi = new PodInfo()
                .setPodName(pod.getMetadata().getName())
                .setPodIp(pod.getStatus().getPodIP())
                .setNodeName(pod.getSpec().getNodeName())
                .setCreateTime(pod.getMetadata().getCreationTimestamp())
                .setRestartCount(0)
                .setHostIp(pod.getStatus().getHostIP());
        // set pod status
        pi.setStatus(getPodRealState(pod));

        // restart count and time
        for (ContainerStatus containerStatus : pod.getStatus().getContainerStatuses()) {
            if (containerStatus.getRestartCount() > pi.getRestartCount()) {
                pi.setRestartCount(containerStatus.getRestartCount());
                if (containerStatus.getLastState() != null && containerStatus.getLastState().getTerminated() != null) {
                    pi.setLastRestartTime(containerStatus.getLastState().getTerminated().getFinishedAt());
                }
            }
        }
        // initContainer
        if (!CollectionUtils.isEmpty(pod.getSpec().getInitContainers())) {
            pi.setInitContainers(pod.getSpec().getInitContainers().stream().map(container -> {
                ContainerWithStatus cs = new ContainerWithStatus();
                cs.setName(container.getName());
                return cs;
            }).collect(Collectors.toList()));
        }
        // container
        List<Container> containers = pod.getSpec().getContainers();
        pi.setContainers(containers.stream().map(container -> {
            ContainerWithStatus cs = new ContainerWithStatus();
            cs.setName(container.getName());
            return cs;
        }).collect(Collectors.toList()));

        // resource
        MiddlewareQuota resource = new MiddlewareQuota();
        double cpu = 0.0;
        double memory = 0.0;
        double limitCpu = 0.0;
        double limitMemory = 0.0;
        for (Container container : containers) {
            if (container.getName().contains("init")) {
                continue;
            }
            ResourceRequirements resources = container.getResources();
            if (!CollectionUtils.isEmpty(resources.getRequests())) {
                if (resources.getRequests().containsKey(CPU)) {
                    cpu = cpu + ResourceCalculationUtil.getResourceValue(resources.getRequests().get(CPU).toString(),
                        CPU, "");
                    resource.setCpu(String.valueOf(ResourceCalculationUtil
                        .getResourceValue(resources.getRequests().get(CPU).toString(), CPU, "")));
                }
                if (resources.getRequests().containsKey(MEMORY)) {
                    memory = memory + ResourceCalculationUtil.getResourceValue(
                        resources.getRequests().get(MEMORY).toString(), MEMORY, ResourceUnitEnum.GI.getUnit());
                    resource.setMemory(String.valueOf(ResourceCalculationUtil.getResourceValue(
                        resources.getRequests().get(MEMORY).toString(), MEMORY, ResourceUnitEnum.GI.getUnit())));
                }
            }
            if (!CollectionUtils.isEmpty(resources.getLimits())) {
                if (resources.getLimits().containsKey(CPU)) {
                    limitCpu = limitCpu
                        + ResourceCalculationUtil.getResourceValue(resources.getLimits().get(CPU).toString(), CPU, "");
                    resource.setLimitCpu(String.valueOf(
                        ResourceCalculationUtil.getResourceValue(resources.getLimits().get(CPU).toString(), CPU, "")));
                }
                if (resources.getLimits().containsKey(MEMORY)) {
                    limitMemory = limitMemory + ResourceCalculationUtil.getResourceValue(
                        resources.getLimits().get(MEMORY).toString(), MEMORY, ResourceUnitEnum.GI.getUnit());
                    resource.setLimitMemory(String.valueOf(ResourceCalculationUtil.getResourceValue(
                        resources.getLimits().get(MEMORY).toString(), MEMORY, ResourceUnitEnum.GI.getUnit())));
                }
            }
        }
        resource.setCpu(
            String.valueOf(ResourceCalculationUtil.roundNumber(BigDecimal.valueOf(cpu), 2, RoundingMode.CEILING)));
        resource.setMemory(
            String.valueOf(ResourceCalculationUtil.roundNumber(BigDecimal.valueOf(memory), 2, RoundingMode.CEILING)));
        resource.setLimitCpu(
            String.valueOf(ResourceCalculationUtil.roundNumber(BigDecimal.valueOf(limitCpu), 2, RoundingMode.CEILING)));
        resource.setLimitMemory(String
            .valueOf(ResourceCalculationUtil.roundNumber(BigDecimal.valueOf(limitMemory), 2, RoundingMode.CEILING)));
        return pi.setResources(resource);
    }

    @Override
    public void restart(String clusterId, String namespace, String middlewareName, String type, String podName) {
        checkExist(clusterId, namespace, middlewareName, type, podName);
        podWrapper.delete(clusterId, namespace, podName);
    }

    @Override
    public String yaml(String clusterId, String namespace, String middlewareName, String type, String podName) {
        checkExist(clusterId, namespace, middlewareName, type, podName);
        Yaml yaml = new Yaml();
        return yaml.dumpAsMap(podWrapper.get(clusterId, namespace, podName));
    }

    public void checkExist(String clusterId, String namespace, String middlewareName, String type, String podName){
        MiddlewareCR mw = middlewareCRService.getCR(clusterId, namespace, type, middlewareName);
        if (mw == null) {
            throw new BusinessException(DictEnum.MIDDLEWARE, middlewareName, ErrorMessage.NOT_EXIST);
        }
        if (CollectionUtils.isEmpty(mw.getStatus().getInclude())) {
            throw new BusinessException(ErrorMessage.FIND_POD_IN_MIDDLEWARE_FAIL);
        }
        List<MiddlewareInfo> pods = mw.getStatus().getInclude().get(PODS);
        if (CollectionUtils.isEmpty(pods) || pods.stream().noneMatch(po -> podName.equals(po.getName()))) {
            throw new BusinessException(ErrorMessage.FIND_POD_IN_MIDDLEWARE_FAIL);
        }
    }

    /**
     * 为pod设置绑定的pvc
     * @param podInfo pod信息
     * @param pvcInfos 服务所有pvc
     */
    private void setPodPvc(PodInfo podInfo, List<MiddlewareInfo> pvcInfos) {
        List<String> pvcs = new ArrayList<>();
        pvcInfos.forEach(pvc -> {
            if (pvc.getName().contains(podInfo.getPodName())) {
                pvcs.add(pvc.getName());
            }
        });
        podInfo.setPvcs(pvcs);
    }

    /**
     * 设置Pod备份状态
     *
     * @param clusterId      集群id
     * @param namespace      分区
     * @param type           类型
     * @param middlewareName 中间件名称
     * @param podInfo        pod信息
     */
    private void setPodBackupStatus(String clusterId, String namespace, String type, String middlewareName, PodInfo podInfo) {
        podInfo.setHasConfigBackup(middlewareBackupService.checkIfAlreadyBackup(clusterId, namespace, type, middlewareName, podInfo.getPodName()));
    }

    @Override
    public Middleware listPods(MiddlewareCR mw, String clusterId, String namespace, String middlewareName, String type){
        if (mw == null) {
            throw new BusinessException(DictEnum.MIDDLEWARE, middlewareName, ErrorMessage.NOT_EXIST);
        }
        Middleware middleware = middlewareCRService.simpleConvert(mw);
        if (CollectionUtils.isEmpty(mw.getStatus().getInclude())) {
            middleware.setPods(new ArrayList<>(0));
            return middleware;
        }
        List<MiddlewareInfo> pods = mw.getStatus().getInclude().get(PODS);
        if (CollectionUtils.isEmpty(pods)) {
            middleware.setPods(new ArrayList<>(0));
            return middleware;
        }
        List<MiddlewareInfo> pvcInfos = mw.getStatus().getInclude().get(PERSISTENT_VOLUME_CLAIMS);
        Map<String, StorageClassDTO> scMap = storageClassService.convertStorageClass(pvcInfos, clusterId, namespace);
        AtomicReference<Boolean> isAllLvmStorage = new AtomicReference<>(true);
        // 给pod设置存储
        List<PodInfo> podInfoList = new ArrayList<>();
        for (MiddlewareInfo po : pods) {
            Pod pod = podWrapper.get(clusterId, namespace, po.getName());
            if (pod == null) {
                continue;
            }
            PodInfo pi = convertPodInfo(pod)
                    .setRole(StringUtils.isBlank(po.getType()) ? null : po.getType().toLowerCase());
            // storage
            StorageClassDTO scDTO = storageClassService.fuzzySearchStorageClass(scMap, po.getName());
            if (scDTO != null) {
                pi.getResources().setStorageClassQuota(scDTO.getStorage()).setStorageClassName(scDTO.getStorageClassName())
                        .setIsLvmStorage(scDTO.getIsLvmStorage());
                isAllLvmStorage.set(isAllLvmStorage.get() & scDTO.getIsLvmStorage());
                // 给pod设置绑定的pvc
                setPodPvc(pi, pvcInfos);
            }
            // 设置pod备份状态
            setPodBackupStatus(clusterId, namespace, type, middlewareName, pi);
            podInfoList.add(pi);
        }
        middleware.setIsAllLvmStorage(isAllLvmStorage.get());
        middleware.setPodInfoGroup(convertListToGroup(podInfoList));
        middleware.setPods(podInfoList);
        return middleware;
    }

}
