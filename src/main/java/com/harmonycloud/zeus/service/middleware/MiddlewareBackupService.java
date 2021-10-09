package com.harmonycloud.zeus.service.middleware;

import com.harmonycloud.caas.common.base.BaseResult;
import com.harmonycloud.caas.common.model.middleware.MiddlewareBackupRecord;

import java.util.List;

/**
 * @author dengyulong
 * @date 2021/03/24
 */
public interface MiddlewareBackupService {

    /**
     * 查询备份数据列表
     *
     * @param clusterId      集群id
     * @param namespace      命名空间
     * @param type           中间件类型
     * @param middlewareName 中间件名称
     * @return
     */
    List<MiddlewareBackupRecord> list(String clusterId, String namespace, String middlewareName, String type);

    /**
     * 创建备份
     *
     * @param clusterId      集群id
     * @param namespace      命名空间
     * @param type           中间件类型
     * @param middlewareName 中间件名称
     * @return
     */
    BaseResult create(String clusterId, String namespace, String middlewareName, String type, String cron, Integer limitRecord);

    /**
     * 更新备份配置
     *
     * @param clusterId      集群id
     * @param namespace      命名空间
     * @param type           中间件类型
     * @param middlewareName 中间件名称
     * @return
     */
    BaseResult update(String clusterId, String namespace, String middlewareName, String type, String cron, Integer limitRecord,String pause);

    /**
     * 删除备份记录
     *
     * @param clusterId
     * @param namespace
     * @param backupName
     * @return
     */
    BaseResult delete(String clusterId, String namespace, String backupName);

    /**
     * 查询备份设置
     *
     * @param clusterId      集群id
     * @param namespace      命名空间
     * @param type           中间件类型
     * @param middlewareName 中间件名称
     * @return
     */
    BaseResult get(String clusterId, String namespace, String middlewareName, String type);

    /**
     * 创建定时备份
     *
     * @param clusterId          集群id
     * @param namespace          命名空间
     * @param middlewareRealName 中间件名称
     * @param cron               cron表达式
     * @param limitRecord        备份保留个数
     * @return
     */
    BaseResult createScheduleBackup(String clusterId, String namespace, String middlewareName,String crdType, String middlewareRealName, String cron, Integer limitRecord);

    /**
     * 立即备份
     *
     * @param clusterId          集群id
     * @param namespace          命名空间
     * @param middlewareRealName 中间件名称
     * @return
     */
    BaseResult createNormalBackup(String clusterId, String namespace, String middlewareName,String crdType,String middlewareRealName);

    /**
     * 创建恢复
     *
     * @param clusterId
     * @param namespace
     * @param backupName 恢复服务名称
     * @param aliasName
     * @return
     */
    BaseResult createRestore(String clusterId, String namespace, String middlewareName, String type, String restoreName, String backupName, String aliasName);

}
