package cn.qdu.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class connection {
        String url = "jdbc:mysql://127.0.0.1:3306/social_platform?characterEncoding=UTF-8&useSSL=false&&serverTimezone=Asia/Shanghai";
        //String url = "jdbc:mysql://115.120.199.165:3306/social_platform?characterEncoding=UTF-8&useSSL=false&&serverTimezone=Asia/Shanghai";
        String username = "root";
        String password = "root00";
        Connection connection;

        public Connection getConnection() throws SQLException {
                if (connection == null || connection.isClosed()) {
                        try {
                                // 加载驱动（JDBC 4.0+ 可以自动加载，这行可以省略）
                                Class.forName("com.mysql.cj.jdbc.Driver"); // MySQL示例
                                // 对于其他数据库，更换驱动类名：
                                // Oracle: "oracle.jdbc.driver.OracleDriver"
                                // PostgreSQL: "org.postgresql.Driver"
                                // SQL Server: "com.microsoft.sqlserver.jdbc.SQLServerDriver"
                                connection = DriverManager.getConnection(url, username, password);
                        } catch (ClassNotFoundException e) {
                                throw new SQLException("数据库驱动未找到", e);
                        }
                }
                return connection;
        }
}
