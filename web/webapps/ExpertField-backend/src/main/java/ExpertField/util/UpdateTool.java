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
                    "UPDATE 试验田 SET 试验田名称=?, 试验田描述=? WHERE ID=?"
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
                    "UPDATE 试验 SET 试验名称=?, 试验描述=?, 试验数据格式=? WHERE ID=?"
            );
        updateExperimentStatement.setString(1, name);
        updateExperimentStatement.setString(2, description);
        updateExperimentStatement.setString(3, format);
        updateExperimentStatement.setInt(4, ID);
        updateExperimentStatement.execute();
    }

    private PreparedStatement deleteExpertFieldStatement;

    public void deleteExpertField(int ID) throws SQLException {
        if (deleteExpertFieldStatement == null)
            deleteExpertFieldStatement = dataConnection.sqlConnection.prepareStatement(
                    "DELETE FROM 试验_试验田 WHERE ID=?"
            );
        deleteExpertFieldStatement.setInt(1, ID);
        deleteExpertFieldStatement.execute();
    }
}
