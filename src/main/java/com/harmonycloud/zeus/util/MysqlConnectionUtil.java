package com.harmonycloud.zeus.util;

import com.harmonycloud.caas.common.model.MysqlAccessInfo;
import com.harmonycloud.caas.common.model.MysqlDbDTO;
import com.harmonycloud.caas.common.model.MysqlUserDTO;

import java.sql.Connection;
import java.sql.DriverManager;

/**
 * @author liyinlong
 * @since 2022/3/25 3:09 下午
 */
public class MysqlConnectionUtil {

    private static final String DBDRIVER = "com.mysql.cj.jdbc.Driver";//mysql数据库驱动类

    /**
     * 获取mysql限定名
     *
     * @param dbDTO
     * @return
     */
    public static String getMysqlQualifiedName(MysqlDbDTO dbDTO) {
        return String.format("%s_%s_%s", dbDTO.getClusterId(), dbDTO.getNamespace(), dbDTO.getMiddlewareName());
    }

    /**
     * 获取mysql限定名
     *
     * @param userDTO
     * @return
     */
    public static String getMysqlQualifiedName(MysqlUserDTO userDTO) {
        return String.format("%s_%s_%s", userDTO.getClusterId(), userDTO.getNamespace(), userDTO.getMiddlewareName());
    }

//    public static Connection getDBConnection(MysqlDbDTO dbDTO) {
//        String clusterId = dbDTO.getClusterId();
//        String namespace = dbDTO.getNamespace();
//        String middlewareName = dbDTO.getMiddlewareName();
//        String type = dbDTO.getType();
//        // 获取mysql service信息
//        String host = "10.10.101.140";
//        int port = 31227;
//        String user = "root";
//        String password = "XtcTHMZ6QW";
//        // 获取一个mysql连接
//        return MysqlConnectionUtil.getDbConn(host, port, user, password);
//    }

//    public static Connection getDBConnection(MysqlUserDTO userDTO) {
//        String clusterId = userDTO.getClusterId();
//        String namespace = userDTO.getNamespace();
//        String middlewareName = userDTO.getMiddlewareName();
//        String type = userDTO.getType();
//        // 获取mysql service信息
//        String host = "10.10.101.140";
//        int port = 31227;
//        String user = "root";
//        String password = "XtcTHMZ6QW";
//        // 获取一个mysql连接
//        return MysqlConnectionUtil.getDbConn(host, port, user, password);
//    }

    public static Connection getDBConnection(MysqlAccessInfo mysqlAccessInfo) {
        String host = mysqlAccessInfo.getHost();
        int port = Integer.parseInt(mysqlAccessInfo.getPort());
        String user = mysqlAccessInfo.getUsername();
        String password = mysqlAccessInfo.getPassword();
        // 获取一个mysql连接
        return MysqlConnectionUtil.getDbConn(host, port, user, password);
    }

    public static boolean passwordCheck(MysqlUserDTO userDTO, String user, String password) {
        // 获取mysql service信息
        String host = "10.10.101.140";
        int port = 31227;
        try {
            Class.forName(DBDRIVER);
            String dbUrl = "jdbc:mysql://" + host + ":" + port + "/?characterEncoding=UTF-8";
            DriverManager.getConnection(dbUrl, user, password);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 获取一个数据库连接
     *
     * @param host     主机地址
     * @param port     端口号
     * @param user     用户名
     * @param password 密码
     * @return
     */
    public static Connection getDbConn(String host, int port, String user, String password) {
        try {
            Class.forName(DBDRIVER);
            String dbUrl = "jdbc:mysql://" + host + ":" + port + "/?characterEncoding=UTF-8";
            return DriverManager.getConnection(dbUrl, user, password);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 连接测试
     *
     * @param host     主机地址
     * @param port     端口号
     * @param user     用户名
     * @param password 密码
     * @return
     */
    public static boolean linkTest(String host, int port, String user, String password) {
        Connection dbConn = getDbConn(host, port, user, password);
        if (dbConn != null) {
            return true;
        }
        return false;
    }

}
