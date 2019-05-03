package ExpertField.util;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class QueryTool {
    private DataConnection dataConnection;

    public QueryTool() throws SQLException, ClassNotFoundException {
        dataConnection = new DataConnection();
    }

    /**
     * 从一个next过的ResultSet里面构造出试验信息
     *
     * @param rs 试验信息的ResultSet
     * @return 试验信息JSONObject
     * @throws SQLException ResultSet的get报错
     */
    private JSONObject getExperimentInfo(ResultSet rs) throws SQLException {
        JSONObject info = new JSONObject();
        info.element("创建时间", rs.getString("创建时间"));
        info.element("试验名称", rs.getString("试验名称"));
        info.element("试验数据格式", JSONObject.fromObject(rs.getString("试验数据格式")));
        info.element("试验描述", rs.getString("试验描述"));
        info.element("已结束", rs.getBoolean("已结束"));
        return info;
    }


    private PreparedStatement fieldInfoStatement = null;

    private JSONObject getFieldInfo(int ID) throws SQLException {
        if (fieldInfoStatement == null)
            fieldInfoStatement = dataConnection.sqlConnection.prepareStatement(
                    "SELECT 创建时间, 试验田名称, 试验田描述 FROM 试验田 WHERE ID=? LIMIT 1"
            );
        fieldInfoStatement.setInt(1, ID);
        ResultSet rs = fieldInfoStatement.executeQuery();
        JSONObject fieldInfo = new JSONObject();
        if (rs.next()) {
            fieldInfo.element("创建时间", rs.getString("创建时间"));
            fieldInfo.element("试验田名称", rs.getString("试验田名称"));
            fieldInfo.element("试验田描述", rs.getString("试验田描述"));
        }
        return fieldInfo;
    }

    /**
     * 获取某个试验的详细情况getExperimentDetails要用的两个PreparedStatement
     */
    private PreparedStatement experimentInfoStatement = null;
    private PreparedStatement experimentDataStatement = null;

    /**
     * 获取某个试验的详细情况
     *
     * @param ID 试验ID
     * @return 试验详细情况，JSON
     * @throws SQLException PreparedStatement失败和查询失败
     */
    public JSONObject getExperimentDetails(int ID) throws SQLException {
        if (experimentInfoStatement == null)
            experimentInfoStatement = dataConnection.sqlConnection.prepareStatement(
                    "SELECT 创建时间, 试验名称, 试验数据格式, 试验描述, 已结束 FROM 试验 WHERE ID=? LIMIT 1"
            );
        experimentInfoStatement.setInt(1, ID);
        ResultSet experimentInfo = experimentInfoStatement.executeQuery();//先获取试验名称和描述

        if (!experimentInfo.next())
            return new JSONObject();//啥都没有直接返回空

        JSONObject details = getExperimentInfo(experimentInfo);

        if (experimentDataStatement == null)
            experimentDataStatement = dataConnection.sqlConnection.prepareStatement(
                    "SELECT 试验数据.ID,试验田ID,录入时间,数据,语音 FROM (SELECT ID,试验田ID FROM 试验_试验田 WHERE 试验ID=?) AS T INNER JOIN 试验数据 ON T.ID=试验数据.试验_试验田ID GROUP BY 试验田ID ORDER BY 录入时间 DESC"
            );
        experimentDataStatement.setInt(1, ID);
        ResultSet experimentData = experimentDataStatement.executeQuery();//再获取试验数据
        JSONObject fields = new JSONObject();
        if (experimentData.next()) {
            JSONObject fieldData = new JSONObject();//按试验田对试验数据进行分类
            int lastFieldID = experimentData.getInt("试验田ID");//第一个
            do {//循环开始
                int fieldID = experimentData.getInt("试验田ID");
                if (fieldID != lastFieldID) {//如果是不一样的试验田，说明已经有一个试验田数据收完了
                    JSONObject fieldInfo = getFieldInfo(lastFieldID);//这时就汇总试验田信息
                    fieldInfo.element("试验田数据", fieldData);//和试验田数据
                    fields.element("" + lastFieldID, fieldInfo);//放入总数据集中
                    fieldData = new JSONObject();//然后收集下一个田的数据
                    lastFieldID = fieldID;
                }
                JSONObject d = new JSONObject();
                d.element("录入时间", experimentData.getString("录入时间"));
                d.element("数据", JSONObject.fromObject(experimentData.getString("数据")));
                d.element("语音", JSONArray.fromObject(experimentData.getString("语音")));
                fieldData.element(experimentData.getString("ID"), d);
            } while (experimentData.next());
            JSONObject fieldInfo = getFieldInfo(lastFieldID);//这时就汇总试验田信息
            fieldInfo.element("试验田数据", fieldData);//和试验田数据
            fields.element("" + lastFieldID, fieldInfo);//放入总数据集中
        }
        details.element("试验田",fields);
        return details;
    }


    /**
     * 获取所有试验的简略信息getExperiments要用的PreparedStatement
     */
    private PreparedStatement experimentsStatement = null;

    /**
     * 获取所有试验的简略信息
     *
     * @return 所有试验的简略信息JSONArray
     * @throws SQLException PreparedStatement出错
     */
    public JSONObject getExperiments() throws SQLException {
        if (experimentsStatement == null)
            experimentsStatement = dataConnection.sqlConnection.prepareStatement(
                    "SELECT ID, 创建时间, 试验名称, 试验数据格式, 试验描述, 已结束 FROM 试验 ORDER BY 创建时间 DESC"
            );
        ResultSet experiment = experimentsStatement.executeQuery();
        JSONObject experiments = new JSONObject();
        while (experiment.next())
            experiments.element(experiment.getString("ID"), getExperimentInfo(experiment));
        return experiments;
    }


    /**
     * 获取所有试验田的简略信息getFields要用的PreparedStatement
     */
    private PreparedStatement fieldsStatement = null;

    /**
     * 获取所有试验田的简略信息
     *
     * @return 所有试验田的简略信息JSONArray
     * @throws SQLException PreparedStatement出错
     */
    public JSONObject getFields() throws SQLException {
        if (fieldsStatement == null)
            fieldsStatement = dataConnection.sqlConnection.prepareStatement(
                    "SELECT ID, 创建时间, 试验田名称, 试验田描述 FROM 试验田 ORDER BY 创建时间 DESC"
            );
        ResultSet field = fieldsStatement.executeQuery();
        JSONObject fields = new JSONObject();
        while (field.next()) {
            JSONObject data = new JSONObject();
            data.element("创建时间", field.getString("创建时间"));
            data.element("试验田名称", field.getString("试验田名称"));
            data.element("试验田描述", field.getString("试验田描述"));
            fields.element(field.getString("ID"), data);
        }
        return fields;
    }
}
