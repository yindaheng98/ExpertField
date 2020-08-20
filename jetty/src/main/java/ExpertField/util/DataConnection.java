package ExpertField.util;

import io.lettuce.core.RedisClient;
import io.lettuce.core.api.StatefulRedisConnection;
import io.lettuce.core.api.sync.RedisCommands;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * 连接数据库和redis用的类
 * SQL连不上会throw错误
 * redis连不上会把lettuce_avail置false
 */

public class DataConnection {
    private static final String REDIS_URL = "redis://redis:6379/";
    private static final String DB_URL = "jdbc:mysql://mysql:3306/ExperimentData?useUnicode=true&characterEncoding=utf8&useSSL=false";
    private static final String USER = "ExperimentData";
    private static final String PASS = "ExperimentData";

    public Connection sqlConnection;
    public RedisCommands<String, String> redisCommands;
    public boolean lettuce_avail;

    public DataConnection() throws SQLException, ClassNotFoundException {
        Class.forName("com.mysql.jdbc.Driver");
        sqlConnection = DriverManager.getConnection(DB_URL, USER, PASS);
        try {
            RedisClient redisClient = RedisClient.create(REDIS_URL);
            StatefulRedisConnection<String, String> connection = redisClient.connect();
            redisCommands = connection.sync();
            lettuce_avail = true;
        } catch (Exception ex) {
            lettuce_avail = false;
            System.out.println("Redis不可用");
            //ex.printStackTrace();
        }
    }
}
