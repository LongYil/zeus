DROP DATABASE IF EXISTS `middleware_platform`;
CREATE DATABASE `middleware_platform`
default character set utf8
default collate utf8_bin;

-- 如果没有middleware数据库，则需要先创建
-- CREATE DATABASE `middleware_platform`
-- default character set utf8mb4
-- default collate utf8mb4_general_ci;

USE `middleware_platform`;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `alert_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alert_record` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `cluster_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '集群id',
  `namespace` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '分区',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '中间件名称',
  `alert` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '告警名称',
  `summary` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '简讯',
  `message` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '告警信息',
  `level` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '告警等级',
  `time` timestamp NULL DEFAULT NULL COMMENT '告警时间',
  `type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '中间件类型',
  `lay` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '告警层面',
  `expr` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '规则描述',
  `alert_id` int DEFAULT NULL COMMENT '规则ID',
  `content` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '告警内容',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='告警记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alert_record`
--

LOCK TABLES `alert_record` WRITE;
/*!40000 ALTER TABLE `alert_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `alert_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `alert_rule`
--

DROP TABLE IF EXISTS `alert_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alert_rule` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `chart_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '类型名称',
  `chart_version` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '版本',
  `alert` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT 'prometheusRule内容',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='告警规则表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alert_rule`
--

LOCK TABLES `alert_rule` WRITE;
/*!40000 ALTER TABLE `alert_rule` DISABLE KEYS */;
/*!40000 ALTER TABLE `alert_rule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `alert_rule_id`
--

DROP TABLE IF EXISTS `alert_rule_id`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alert_rule_id` (
  `alert_id` int NOT NULL AUTO_INCREMENT COMMENT '规则ID',
  `cluster_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '集群ID',
  `namespace` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '命名空间',
  `middleware_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '中间件名称',
  `alert` text CHARACTER SET utf8 COLLATE utf8_bin COMMENT '规则名称',
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `silence` varchar(16) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '沉默时间',
  `symbol` varchar(16) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '符号',
  `threshold` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '阈值',
  `time` varchar(16) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '分钟周期',
  `type` varchar(16) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '中间件类型',
  `unit` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '单位',
  `expr` varchar(512) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '执行规则',
  `description` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '监控项',
  `annotations` text CHARACTER SET utf8 COLLATE utf8_bin COMMENT '备注',
  `labels` text CHARACTER SET utf8 COLLATE utf8_bin COMMENT '标签',
  `id` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `alert_time` varchar(16) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '告警时间',
  `alert_times` varchar(16) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '告警次数',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `status` varchar(16) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '状态',
  `enable` int DEFAULT NULL COMMENT '是否启用',
  `content` varchar(512) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '告警内容',
  `lay` varchar(16) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT 'system 系统告警 service 服务告警',
  `ding` varchar(16) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '是否选择钉钉通知',
  `mail` varchar(16) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '是否选择邮箱通知',
  `alert_expr` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '告警规则',
  `ip` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'ip地址',
  PRIMARY KEY (`alert_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alert_rule_id`
--

LOCK TABLES `alert_rule_id` WRITE;
/*!40000 ALTER TABLE `alert_rule_id` DISABLE KEYS */;
/*!40000 ALTER TABLE `alert_rule_id` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `alert_setting`
--

DROP TABLE IF EXISTS `alert_setting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alert_setting` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cluster_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '集群id',
  `namespace` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '分区名称',
  `middleware_name` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '服务名称',
  `lay` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '告警等级 service:服务告警 system:系统告警',
  `enable_ding_alert` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '是否开启钉钉告警',
  `enable_mail_alert` varchar(45) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '是否开启邮件告警',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='告警设置';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alert_setting`
--

LOCK TABLES `alert_setting` WRITE;
/*!40000 ALTER TABLE `alert_setting` DISABLE KEYS */;
/*!40000 ALTER TABLE `alert_setting` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `backup_address_cluster`
--

DROP TABLE IF EXISTS `backup_address_cluster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `backup_address_cluster` (
  `id` int NOT NULL AUTO_INCREMENT,
  `backup_address_id` int DEFAULT NULL COMMENT '备份地址ID',
  `cluster_id` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '集群ID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `backup_address_cluster`
--

LOCK TABLES `backup_address_cluster` WRITE;
/*!40000 ALTER TABLE `backup_address_cluster` DISABLE KEYS */;
/*!40000 ALTER TABLE `backup_address_cluster` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `backup_name`
--

DROP TABLE IF EXISTS `backup_name`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `backup_name` (
  `id` int NOT NULL AUTO_INCREMENT,
  `backup_id` varchar(16) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '备份任务标识',
  `backup_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '备份任务名称',
  `cluster_id` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '集群ID',
  `backup_type` varchar(16) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '备份类型',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `backup_name`
--

LOCK TABLES `backup_name` WRITE;
/*!40000 ALTER TABLE `backup_name` DISABLE KEYS */;
/*!40000 ALTER TABLE `backup_name` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache_middleware`
--

DROP TABLE IF EXISTS `cache_middleware`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache_middleware` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `cluster_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '集群id',
  `namespace` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '分区',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '中间件名称',
  `type` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '中间件类型',
  `chart_version` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '中间件版本',
  `pvc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT 'pvc列表',
  `values_yaml` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='已删除中间件信息缓存表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache_middleware`
--

LOCK TABLES `cache_middleware` WRITE;
/*!40000 ALTER TABLE `cache_middleware` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache_middleware` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cluster_components`
--

DROP TABLE IF EXISTS `cluster_components`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cluster_components` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增Id',
  `cluster_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '集群Id',
  `component` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '组件名称',
  `status` int DEFAULT NULL COMMENT '0-未安装接入 1-已接入 2-安装中 3-运行正常 4-运行异常 5-卸载中',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='集群组件表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cluster_components`
--

LOCK TABLES `cluster_components` WRITE;
/*!40000 ALTER TABLE `cluster_components` DISABLE KEYS */;
/*!40000 ALTER TABLE `cluster_components` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cluster_ingress_components`
--

DROP TABLE IF EXISTS `cluster_ingress_components`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cluster_ingress_components` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'ingress name',
  `ingress_class_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'ingress class name',
  `cluster_id` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '集群id',
  `namespace` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '分区',
  `address` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '访问地址',
  `config_map_name` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'tcp配置文件名称',
  `status` int DEFAULT NULL COMMENT '状态',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='集群ingress组件表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cluster_ingress_components`
--

LOCK TABLES `cluster_ingress_components` WRITE;
/*!40000 ALTER TABLE `cluster_ingress_components` DISABLE KEYS */;
/*!40000 ALTER TABLE `cluster_ingress_components` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cluster_middleware_info`
--

DROP TABLE IF EXISTS `cluster_middleware_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cluster_middleware_info` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `cluster_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '集群id',
  `chart_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'chart包名称',
  `chart_version` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'chart包版本',
  `status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'operator状态',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='集群-中间件关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cluster_middleware_info`
--

LOCK TABLES `cluster_middleware_info` WRITE;
/*!40000 ALTER TABLE `cluster_middleware_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `cluster_middleware_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cluster_role`
--

DROP TABLE IF EXISTS `cluster_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cluster_role` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `role_id` int DEFAULT NULL COMMENT '角色id',
  `cluster_id` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '集群id',
  `namespace` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '分区',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='角色集群权限表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cluster_role`
--

LOCK TABLES `cluster_role` WRITE;
/*!40000 ALTER TABLE `cluster_role` DISABLE KEYS */;
/*!40000 ALTER TABLE `cluster_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `custom_config`
--

DROP TABLE IF EXISTS `custom_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `custom_config` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `name` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '字段名称',
  `chart_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'chart包名称',
  `default_value` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '默认值',
  `restart` tinyint(1) DEFAULT NULL COMMENT '是否重启',
  `ranges` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '阈值',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '描述',
  `chart_version` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'chart版本',
  `pattern` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '正则校验',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='自定义配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `custom_config`
--

LOCK TABLES `custom_config` WRITE;
/*!40000 ALTER TABLE `custom_config` DISABLE KEYS */;
/*!40000 ALTER TABLE `custom_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `custom_config_history`
--

DROP TABLE IF EXISTS `custom_config_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `custom_config_history` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `cluster_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '集群id',
  `namespace` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '分区',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '中间件名称',
  `item` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '配置名称',
  `last` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改前',
  `after` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改后',
  `restart` tinyint(1) DEFAULT NULL COMMENT '是否需要重启',
  `status` tinyint(1) DEFAULT NULL COMMENT '是否已启用',
  `date` timestamp NULL DEFAULT NULL COMMENT '日期',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='自定义配置修改历史表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `custom_config_history`
--

LOCK TABLES `custom_config_history` WRITE;
/*!40000 ALTER TABLE `custom_config_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `custom_config_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `custom_config_template`
--

DROP TABLE IF EXISTS `custom_config_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `custom_config_template` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `uid` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '模板uid',
  `name` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '模板名称',
  `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '中间件类型',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '模板描述',
  `config` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '配置内容',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='自定义配置模板表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `custom_config_template`
--

LOCK TABLES `custom_config_template` WRITE;
/*!40000 ALTER TABLE `custom_config_template` DISABLE KEYS */;
/*!40000 ALTER TABLE `custom_config_template` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ding_robot_info`
--

DROP TABLE IF EXISTS `ding_robot_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ding_robot_info` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `webhook` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `secret_key` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '加签密钥',
  `enable_ding` varchar(16) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '是否启用该钉钉机器人 1 启用 0 否',
  `creat_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ding_robot_info`
--

LOCK TABLES `ding_robot_info` WRITE;
/*!40000 ALTER TABLE `ding_robot_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `ding_robot_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `image_repository`
--

DROP TABLE IF EXISTS `image_repository`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `image_repository` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cluster_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '集群',
  `protocol` varchar(16) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '协议',
  `address` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT 'harbor地址',
  `host_address` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT 'harbor主机地址',
  `port` int DEFAULT NULL COMMENT '端口',
  `project` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT 'harbor项目',
  `username` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '用户名',
  `password` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '密码',
  `description` varchar(512) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '描述',
  `is_default` int DEFAULT NULL COMMENT '是否默认',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='镜像仓库表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `image_repository`
--

LOCK TABLES `image_repository` WRITE;
/*!40000 ALTER TABLE `image_repository` DISABLE KEYS */;
/*!40000 ALTER TABLE `image_repository` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `k8s_default_cluster`
--

DROP TABLE IF EXISTS `k8s_default_cluster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `k8s_default_cluster` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `cluster_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '集群id',
  `url` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '路径',
  `token` text CHARACTER SET utf8 COLLATE utf8_bin COMMENT 'service account',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `k8s_default_cluster`
--

LOCK TABLES `k8s_default_cluster` WRITE;
/*!40000 ALTER TABLE `k8s_default_cluster` DISABLE KEYS */;
/*!40000 ALTER TABLE `k8s_default_cluster` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `kube_config`
--

DROP TABLE IF EXISTS `kube_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kube_config` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `cluster_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '集群id',
  `conf` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT 'admin.conf',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kube_config`
--

LOCK TABLES `kube_config` WRITE;
/*!40000 ALTER TABLE `kube_config` DISABLE KEYS */;
/*!40000 ALTER TABLE `kube_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mail_info`
--

DROP TABLE IF EXISTS `mail_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mail_info` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `mail_server` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '邮箱服务器',
  `port` varchar(16) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '端口',
  `username` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '用户',
  `password` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '密码',
  `mail_path` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '邮箱地址',
  `creat_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mail_info`
--

LOCK TABLES `mail_info` WRITE;
/*!40000 ALTER TABLE `mail_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `mail_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mail_to_user`
--

DROP TABLE IF EXISTS `mail_to_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mail_to_user` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `user_id` int DEFAULT NULL COMMENT '用户ID',
  `alert_rule_id` int DEFAULT NULL COMMENT '规则ID',
  `alert_setting_id` int DEFAULT NULL COMMENT '告警设置id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mail_to_user`
--

LOCK TABLES `mail_to_user` WRITE;
/*!40000 ALTER TABLE `mail_to_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `mail_to_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `middleware_backup_address`
--

DROP TABLE IF EXISTS `middleware_backup_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `middleware_backup_address` (
  `id` int NOT NULL AUTO_INCREMENT,
  `address_id` varchar(16) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '标识',
  `name` varchar(16) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '中文名称',
  `type` varchar(16) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '类型',
  `bucket_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT 'bucket名称',
  `access_key_id` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '用户ID',
  `secret_access_key` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '密码',
  `endpoint` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '地址',
  `ftp_host` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT 'FTP主机服务器',
  `ftp_user` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT 'FTP登录用户名',
  `ftp_password` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT 'FTP登录密码',
  `ftp_port` int DEFAULT NULL COMMENT 'FTP端口',
  `server_host` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '服务器地址',
  `server_user` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '服务器用户名',
  `server_password` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '服务器密码',
  `server_port` int DEFAULT NULL COMMENT '服务器端口',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `middleware_backup_address`
--

LOCK TABLES `middleware_backup_address` WRITE;
/*!40000 ALTER TABLE `middleware_backup_address` DISABLE KEYS */;
/*!40000 ALTER TABLE `middleware_backup_address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `middleware_cluster`
--

DROP TABLE IF EXISTS `middleware_cluster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `middleware_cluster` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cluster_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '集群ID',
  `middleware_cluster` text CHARACTER SET utf8 COLLATE utf8_bin COMMENT '集群对象',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `middleware_cluster`
--

LOCK TABLES `middleware_cluster` WRITE;
/*!40000 ALTER TABLE `middleware_cluster` DISABLE KEYS */;
/*!40000 ALTER TABLE `middleware_cluster` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `middleware_cr_type`
--

DROP TABLE IF EXISTS `middleware_cr_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `middleware_cr_type` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `chart_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'chart包名称',
  `cr_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'cr类型',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='中间件类型映照表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `middleware_cr_type`
--

LOCK TABLES `middleware_cr_type` WRITE;
/*!40000 ALTER TABLE `middleware_cr_type` DISABLE KEYS */;
/*!40000 ALTER TABLE `middleware_cr_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `middleware_info`
--

DROP TABLE IF EXISTS `middleware_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `middleware_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '中间件名称',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '描述',
  `type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '类型',
  `version` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '版本',
  `image` mediumblob COMMENT '图片',
  `image_path` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '图片地址',
  `chart_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'chart包名称',
  `chart_version` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'chart版本',
  `grafana_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'grafana的id',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `modifier` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `update_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `official` tinyint(1) DEFAULT NULL COMMENT '官方中间件',
  `chart` mediumblob COMMENT 'helm chart包',
  `operator_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'operator名称',
  `compatible_versions` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '升级所需最低版本',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='中间件表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `middleware_info`
--

LOCK TABLES `middleware_info` WRITE;
/*!40000 ALTER TABLE `middleware_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `middleware_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `middleware_param_top`
--

DROP TABLE IF EXISTS `middleware_param_top`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `middleware_param_top` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `cluster_id` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '集群id',
  `namespace` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '分区',
  `name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `param` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '参数名',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `middleware_param_top`
--

LOCK TABLES `middleware_param_top` WRITE;
/*!40000 ALTER TABLE `middleware_param_top` DISABLE KEYS */;
/*!40000 ALTER TABLE `middleware_param_top` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mysql_db`
--

DROP TABLE IF EXISTS `mysql_db`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mysql_db` (
  `id` int NOT NULL AUTO_INCREMENT,
  `mysql_qualified_name` varchar(512) NOT NULL COMMENT 'mysql服务限定名',
  `db` char(64) NOT NULL COMMENT '数据库名',
  `createtime` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `description` varchar(512) DEFAULT NULL COMMENT '备注',
  `charset` varchar(32) NOT NULL COMMENT '字符集',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='mysql数据库';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mysql_db`
--

LOCK TABLES `mysql_db` WRITE;
/*!40000 ALTER TABLE `mysql_db` DISABLE KEYS */;
/*!40000 ALTER TABLE `mysql_db` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mysql_db_priv`
--

DROP TABLE IF EXISTS `mysql_db_priv`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mysql_db_priv` (
  `id` int NOT NULL AUTO_INCREMENT,
  `mysql_qualified_name` varchar(512) NOT NULL COMMENT 'mysql服务限定名',
  `db` char(64) NOT NULL COMMENT '数据库名',
  `user` char(32) NOT NULL COMMENT '用户名',
  `authority` int NOT NULL COMMENT '权限：1：只读，2：读写，3：仅DDL，4：仅DML',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Mysql数据库授权';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mysql_db_priv`
--

LOCK TABLES `mysql_db_priv` WRITE;
/*!40000 ALTER TABLE `mysql_db_priv` DISABLE KEYS */;
/*!40000 ALTER TABLE `mysql_db_priv` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mysql_user`
--

DROP TABLE IF EXISTS `mysql_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mysql_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `mysql_qualified_name` varchar(512) NOT NULL COMMENT 'mysql服务限定名',
  `user` char(32) NOT NULL COMMENT '用户名',
  `password` varchar(255) NOT NULL COMMENT '密码',
  `createtime` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `description` varchar(512) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='mysql用户';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mysql_user`
--

LOCK TABLES `mysql_user` WRITE;
/*!40000 ALTER TABLE `mysql_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `mysql_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `operation_audit`
--

DROP TABLE IF EXISTS `operation_audit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `operation_audit` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `account` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '账户名称',
  `user_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '用户名称',
  `role_name` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '角色名称',
  `phone` char(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '手机号',
  `url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'url',
  `module_ch_desc` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '模块名称',
  `child_module_ch_desc` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '子模块名称',
  `action_ch_desc` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '操作名称',
  `method` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '方法',
  `request_method` char(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '请求方法类型',
  `request_params` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '请求参数',
  `response` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '响应内容',
  `remote_ip` char(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '请求ip',
  `status` char(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '状态码',
  `begin_time` datetime NOT NULL COMMENT '请求开始时间',
  `action_time` datetime NOT NULL COMMENT '请求响应时间',
  `execute_time` int NOT NULL COMMENT '执行时长(ms)',
  `cluster_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '集群id',
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '请求token',
  PRIMARY KEY (`id`),
  KEY `index_user_name` (`user_name`) USING BTREE,
  KEY `index_account` (`account`) USING BTREE,
  KEY `index_url` (`url`(32)) USING BTREE,
  KEY `index_remote_ip` (`remote_ip`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='操作审计';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `operation_audit`
--

LOCK TABLES `operation_audit` WRITE;
/*!40000 ALTER TABLE `operation_audit` DISABLE KEYS */;
/*!40000 ALTER TABLE `operation_audit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personal_config`
--

DROP TABLE IF EXISTS `personal_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `personal_config` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `background_image` mediumblob COMMENT '背景图',
  `background_image_path` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '背景图地址',
  `login_logo` mediumblob COMMENT '登录页logo',
  `login_logo_path` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '登录页logo地址',
  `home_logo` mediumblob COMMENT '主页logo',
  `home_logo_path` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '主页logo地址',
  `tab_logo` mediumblob COMMENT 'tab栏logo',
  `tab_logo_path` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT 'tab栏logo地址',
  `platform_name` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '平台名称',
  `slogan` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '标语',
  `copyright_notice` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '版权声明',
  `title` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '浏览器标题',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT NULL COMMENT '修改时间',
  `status` varchar(16) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '是否默认',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personal_config`
--

LOCK TABLES `personal_config` WRITE;
/*!40000 ALTER TABLE `personal_config` DISABLE KEYS */;
/*!40000 ALTER TABLE `personal_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project`
--

DROP TABLE IF EXISTS `project`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `project` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `project_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '项目id',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '项目名称',
  `alias_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '项目别名',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '项目描述',
  `user` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '用户',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project`
--

LOCK TABLES `project` WRITE;
/*!40000 ALTER TABLE `project` DISABLE KEYS */;
/*!40000 ALTER TABLE `project` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_namespace`
--

DROP TABLE IF EXISTS `project_namespace`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `project_namespace` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `project_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '项目id',
  `namespace` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '分区',
  `alias_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '分区别名',
  `cluster_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '集群id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_namespace`
--

LOCK TABLES `project_namespace` WRITE;
/*!40000 ALTER TABLE `project_namespace` DISABLE KEYS */;
/*!40000 ALTER TABLE `project_namespace` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `resource_menu`
--

DROP TABLE IF EXISTS `resource_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `resource_menu` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `alias_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '中文名称',
  `url` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '路径',
  `weight` int DEFAULT NULL COMMENT '权重(排序使用)',
  `icon_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT 'icon名称',
  `parent_id` int DEFAULT NULL COMMENT '父菜单id',
  `module` varchar(0) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '模块',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='菜单资源表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resource_menu`
--

LOCK TABLES `resource_menu` WRITE;
/*!40000 ALTER TABLE `resource_menu` DISABLE KEYS */;
INSERT INTO `resource_menu` VALUES (1,'dataOverview','数据总览','dataOverview',1,'icon-shujuzonglan',0,NULL);
INSERT INTO `resource_menu` VALUES (2,'middlewareRepository','中间件市场','middlewareRepository',2,'icon-cangku',0,NULL);
INSERT INTO `resource_menu` VALUES (3,'myProject','我的项目','myProject',3,'icon-wodexiangmu',0,NULL);
INSERT INTO `resource_menu` VALUES (4,'serviceList','服务列表','serviceList',4,'icon-fuwuliebiao',0,NULL);
INSERT INTO `resource_menu` VALUES (5,'serviceAvailable','服务暴露','serviceAvailable',5,'icon-fuwutiaokuan',0,NULL);
INSERT INTO `resource_menu` VALUES (6,'storageManagement','存储管理','storageManagement',6,'icon-cunchuguanli',0,NULL);
INSERT INTO `resource_menu` VALUES (7,'backupService','备份服务','backupService',7,'icon-beifenfuwu',0,NULL);
INSERT INTO `resource_menu` VALUES (8,'monitorAlarm','监控告警','monitorAlarm',8,'icon-gaojingshijian',0,NULL);
INSERT INTO `resource_menu` VALUES (9,'disasterBackup','灾备中心','disasterBackup',9,'icon-rongzaibeifen',0,NULL);
INSERT INTO `resource_menu` VALUES (10,'systemManagement','系统管理','systemManagement',10,'icon-shezhi01',0,NULL);
INSERT INTO `resource_menu` VALUES (11,'backupTask','备份任务','backupService/backupTask',71,'icon-fuwutiaokuan',7,NULL);
INSERT INTO `resource_menu` VALUES (12,'backupPosition','备份位置','backupService/backupPosition',72,'icon-fuwutiaokuan',7,NULL);
INSERT INTO `resource_menu` VALUES (13,'dataMonitor','数据监控','monitorAlarm/dataMonitor',81,NULL,8,NULL);
INSERT INTO `resource_menu` VALUES (14,'logDetail','日志详情','monitorAlarm/logDetail',82,NULL,8,NULL);
INSERT INTO `resource_menu` VALUES (15,'alarmCenter','服务告警','monitorAlarm/alarmCenter',83,NULL,8,NULL);
INSERT INTO `resource_menu` VALUES (16,'resourcePoolManagement','集群管理','systemManagement/resourcePoolManagement',101,NULL,10,NULL);
INSERT INTO `resource_menu` VALUES (17,'userManagement','用户管理','systemManagement/userManagement',102,NULL,10,NULL);
INSERT INTO `resource_menu` VALUES (18,'projectManagement','项目管理','systemManagement/projectManagement',103,NULL,10,NULL);
INSERT INTO `resource_menu` VALUES (19,'roleManagement','角色管理','systemManagement/roleManagement',104,NULL,10,NULL);
INSERT INTO `resource_menu` VALUES (20,'systemAlarm','系统告警','systemManagement/systemAlarm',105,NULL,10,NULL);
INSERT INTO `resource_menu` VALUES (21,'operationAudit','操作审计','systemManagement/operationAudit',106,NULL,10,NULL);
/*!40000 ALTER TABLE `resource_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `resource_menu_role`
--

DROP TABLE IF EXISTS `resource_menu_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `resource_menu_role` (
  `id` int NOT NULL AUTO_INCREMENT,
  `role_id` int DEFAULT NULL,
  `resource_menu_id` int DEFAULT NULL,
  `available` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='资源菜单角色关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resource_menu_role`
--

LOCK TABLES `resource_menu_role` WRITE;
/*!40000 ALTER TABLE `resource_menu_role` DISABLE KEYS */;
INSERT INTO `resource_menu_role` VALUES (1,1,1,1);
INSERT INTO `resource_menu_role` VALUES (2,1,2,1);
INSERT INTO `resource_menu_role` VALUES (3,1,3,1);
INSERT INTO `resource_menu_role` VALUES (4,1,4,1);
INSERT INTO `resource_menu_role` VALUES (5,1,5,1);
INSERT INTO `resource_menu_role` VALUES (6,1,6,1);
INSERT INTO `resource_menu_role` VALUES (7,1,7,1);
INSERT INTO `resource_menu_role` VALUES (8,1,8,1);
INSERT INTO `resource_menu_role` VALUES (9,1,9,1);
INSERT INTO `resource_menu_role` VALUES (10,1,10,1);
INSERT INTO `resource_menu_role` VALUES (11,1,11,1);
INSERT INTO `resource_menu_role` VALUES (12,1,12,1);
INSERT INTO `resource_menu_role` VALUES (13,1,13,1);
INSERT INTO `resource_menu_role` VALUES (14,1,14,1);
INSERT INTO `resource_menu_role` VALUES (15,1,15,1);
INSERT INTO `resource_menu_role` VALUES (16,1,16,1);
INSERT INTO `resource_menu_role` VALUES (17,1,17,1);
/*!40000 ALTER TABLE `resource_menu_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `description` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '描述',
  `parent` int DEFAULT NULL COMMENT '父角色id',
  `status` tinyint(1) DEFAULT NULL COMMENT '是否已被删除',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='角色表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role`
--

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES (1,'超级管理员','拥有所有最高权限',NULL,NULL,NULL);
INSERT INTO `role` VALUES (2,'项目管理员','拥有项目管理权限',NULL,NULL,NULL);
INSERT INTO `role` VALUES (3,'运维人员','拥有中间件运维权限',NULL,NULL,NULL);
INSERT INTO `role` VALUES (4,'普通用户','拥有平台查看权限',NULL,NULL,NULL);
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_authority`
--

DROP TABLE IF EXISTS `role_authority`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_authority` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `role_id` int DEFAULT NULL COMMENT '角色id',
  `type` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '中间件类型',
  `power` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '能力:查\\增\\删\\运维',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_authority`
--

LOCK TABLES `role_authority` WRITE;
/*!40000 ALTER TABLE `role_authority` DISABLE KEYS */;
INSERT INTO `role_authority` VALUES (1,1,'mysql','1111');
INSERT INTO `role_authority` VALUES (2,1,'redis','1111');
INSERT INTO `role_authority` VALUES (3,1,'elasticsearch','1111');
INSERT INTO `role_authority` VALUES (4,1,'rocketmq','1111');
INSERT INTO `role_authority` VALUES (5,1,'zookeeper','1111');
INSERT INTO `role_authority` VALUES (6,1,'kafka','1111');
INSERT INTO `role_authority` VALUES (7,2,'mysql','1111');
INSERT INTO `role_authority` VALUES (8,2,'redis','1111');
INSERT INTO `role_authority` VALUES (9,2,'elasticsearch','1111');
INSERT INTO `role_authority` VALUES (10,2,'rocketmq','1111');
INSERT INTO `role_authority` VALUES (11,2,'zookeeper','1111');
INSERT INTO `role_authority` VALUES (12,2,'kafka','1111');
INSERT INTO `role_authority` VALUES (13,3,'mysql','1111');
INSERT INTO `role_authority` VALUES (14,3,'redis','1111');
INSERT INTO `role_authority` VALUES (15,3,'elasticsearch','1111');
INSERT INTO `role_authority` VALUES (16,3,'rocketmq','1111');
INSERT INTO `role_authority` VALUES (17,3,'zookeeper','1111');
INSERT INTO `role_authority` VALUES (18,3,'kafka','1111');
INSERT INTO `role_authority` VALUES (19,4,'mysql','1000');
INSERT INTO `role_authority` VALUES (20,4,'redis','1000');
INSERT INTO `role_authority` VALUES (21,4,'elasticsearch','1000');
INSERT INTO `role_authority` VALUES (22,4,'rocketmq','1000');
INSERT INTO `role_authority` VALUES (23,4,'zookeeper','1000');
INSERT INTO `role_authority` VALUES (24,4,'kafka','1000');
/*!40000 ALTER TABLE `role_authority` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_user`
--

DROP TABLE IF EXISTS `role_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_user` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `project_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '项目id',
  `username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '用户名',
  `role_id` int DEFAULT NULL COMMENT '角色id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='用户角色关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_user`
--

LOCK TABLES `role_user` WRITE;
/*!40000 ALTER TABLE `role_user` DISABLE KEYS */;
INSERT INTO `role_user` VALUES (1,NULL,'admin',1);
/*!40000 ALTER TABLE `role_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `system_config`
--

DROP TABLE IF EXISTS `system_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `system_config` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `config_name` varchar(64) NOT NULL COMMENT '配置名',
  `config_value` varchar(2048) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `create_user` varchar(64) DEFAULT NULL COMMENT '创建人',
  `update_user` varchar(64) DEFAULT NULL COMMENT '修改人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `config_name` (`config_name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='ldap配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `system_config`
--

LOCK TABLES `system_config` WRITE;
/*!40000 ALTER TABLE `system_config` DISABLE KEYS */;
/*!40000 ALTER TABLE `system_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `username` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户名',
  `alias_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '用户别名',
  `password` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '密码',
  `email` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '手机',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `password_time` timestamp NULL DEFAULT NULL COMMENT '密码修改时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建者',
  PRIMARY KEY (`id`,`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='用户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'admin','超级管理员','6DA05F9A0ED31ABEEFD41C768B2E7233',NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-07-20 13:47:48
