package ExpertField.util;

import java.sql.PreparedStatement;
import java.sql.SQLException;

public class UpdateTool {
    private DataConnection dataConnection;

    public UpdateTool() throws SQLException, ClassNotFoundException {
        dataConnection = new DataConnection();
    }

    private PreparedStatement updateFieldStatement;

    public void updateField(int ID, String name, String description) throws SQLException {
        if (updateFieldStatement == null)
            updateFieldStatement = dataConnection.sqlConnection.prepareStatement(
                    "UPDATE 试验田 SET 试验田名称=IFNULL(?,试验田名称), 试验田描述=IFNULL(?,试验田描述) WHERE ID=?"
            );
        updateFieldStatement.setString(1, name);
        updateFieldStatement.setString(2, description);
        updateFieldStatement.setInt(3, ID);
        updateFieldStatement.execute();
    }

    private PreparedStatement updateExperimentStatement;

    public void updateExperiment(int ID, String name, String description, String format) throws SQLException {
        if (updateExperimentStatement == null)
            updateExperimentStatement = dataConnection.sqlConnection.prepareStatement(
                    "UPDATE 试验 SET 试验名称=IFNULL(?,试验名称), 试验描述=IFNULL(?,试验描述), 试验数据格式=IFNULL(?,试验数据格式) WHERE ID=?"
            );
        updateExperimentStatement.setString(1, name);
        updateExperimentStatement.setString(2, description);
        updateExperimentStatement.setString(3, format);
        updateExperimentStatement.setInt(4, ID);
        updateExperimentStatement.execute();
    }

    private PreparedStatement finishExperimentStatement;

    public void finishExperiment(int ID, int finish) throws SQLException {
        if (finishExperimentStatement == null)
            finishExperimentStatement = dataConnection.sqlConnection.prepareStatement(
                    "UPDATE 试验 SET 已结束=? WHERE ID=?"
            );
        finishExperimentStatement.setInt(1, finish);
        finishExperimentStatement.setInt(2, ID);
        finishExperimentStatement.execute();
    }

    private PreparedStatement deleteExpertFieldStatement;

    public void deleteExpertField(String ID, String experimentID, String fieldID) throws SQLException {
        if (deleteExpertFieldStatement == null)
            deleteExpertFieldStatement = dataConnection.sqlConnection.prepareStatement(
                    "DELETE FROM 试验_试验田 WHERE ID=IFNULL(?,ID) AND 试验ID=IFNULL(?,试验ID) AND 试验田ID=IFNULL(?,试验田ID)"
            );
        if (ID == null && (experimentID == null || fieldID == null))
            throw new SQLException("非法删除");
        deleteExpertFieldStatement.setString(1, ID);
        deleteExpertFieldStatement.setString(2, experimentID);
        deleteExpertFieldStatement.setString(3, fieldID);
        deleteExpertFieldStatement.execute();
    }

    private PreparedStatement updateDataStatement;

    public void updateData(int ID, String data) throws SQLException {
        if (updateDataStatement == null)
            updateDataStatement = dataConnection.sqlConnection.prepareStatement(
                    "UPDATE 试验数据 SET 数据=? WHERE ID=?"
            );
        updateDataStatement.setString(1, data);
        updateDataStatement.setInt(2, ID);
        updateDataStatement.execute();
    }

    private PreparedStatement deleteDataStatement;

    public void deleteData(int ID) throws SQLException {
        if (deleteDataStatement == null)
            deleteDataStatement = dataConnection.sqlConnection.prepareStatement(
                    "DELETE FROM 试验数据 WHERE ID=?"
            );
        deleteDataStatement.setInt(1, ID);
        deleteDataStatement.execute();

    }
}
