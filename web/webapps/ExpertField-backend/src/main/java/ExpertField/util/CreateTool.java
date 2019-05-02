package ExpertField.util;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class CreateTool {
    private DataConnection dataConnection;

    public CreateTool() throws SQLException, ClassNotFoundException {
        dataConnection = new DataConnection();
    }

    private int executeGeneratedKeys(PreparedStatement preparedStatement) throws SQLException {
        preparedStatement.execute();
        ResultSet rs = preparedStatement.getGeneratedKeys();
        if (!rs.next())//如果查不到主键就报错返回
            throw new SQLException("获取主键失败");
        return rs.getInt(1);
    }

    private PreparedStatement createFieldStatement = null;

    public int createField(String name, String description) throws SQLException {
        if (createFieldStatement == null)
            createFieldStatement = dataConnection.sqlConnection.prepareStatement(
                    "INSERT INTO 试验田(创建时间, 试验田名称, 试验田描述)VALUES(now(),?,?)",
                    Statement.RETURN_GENERATED_KEYS//返回刚插完的数据的主键
            );
        createFieldStatement.setString(1, name);
        createFieldStatement.setString(2, description);
        return executeGeneratedKeys(createFieldStatement);
    }

    private PreparedStatement createExperimentStatement = null;

    public int createExperiment(String name, String description, String format) throws SQLException {
        if (createExperimentStatement == null)
            createExperimentStatement = dataConnection.sqlConnection.prepareStatement(
                    "INSERT INTO 试验(创建时间, 试验名称, 试验描述, 试验数据格式, 已结束)VALUES(now(),?,?,?,0)",
                    Statement.RETURN_GENERATED_KEYS//返回刚插完的数据的主键
            );
        createExperimentStatement.setString(1, name);
        createExperimentStatement.setString(2, description);
        createExperimentStatement.setString(3, format);
        return executeGeneratedKeys(createExperimentStatement);
    }

    private PreparedStatement createExpertFieldStatement;

    public int createExpertField(int experimentID, int fieldID) throws SQLException {
        if (createExpertFieldStatement == null)
            createExpertFieldStatement = dataConnection.sqlConnection.prepareStatement(
                    "INSERT INTO 试验_试验田(试验ID, 试验田ID)VALUES(?,?)",
                    Statement.RETURN_GENERATED_KEYS//返回刚插完的数据的主键
            );
        createExpertFieldStatement.setInt(1, experimentID);
        createExpertFieldStatement.setInt(2, fieldID);
        return executeGeneratedKeys(createExpertFieldStatement);
    }
}
