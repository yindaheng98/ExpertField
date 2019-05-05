import org.junit.Test;

import org.junit.FixMethodOrder;
import org.junit.runners.MethodSorters;

import ExpertField.util.CreateTool;
import ExpertField.util.UpdateTool;
import ExpertField.util.QueryTool;

import java.sql.SQLException;

@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class TestDataTool {
    private CreateTool createTool = null;
    private UpdateTool updateTool = null;
    private QueryTool queryTool = null;

    @Test
    public void test01_InitTools() {
        try {
            createTool = new CreateTool();
            updateTool = new UpdateTool();
            queryTool = new QueryTool();
            System.out.println("DataTool初始化测试成功");
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println("DataTool初始化测试失败");
            e.printStackTrace();
        }
    }

    private int experimentID = -1;
    private int fieldID = -1;
    private int expertFieldID=-1;

    @Test
    public void test02_CreateTool() {
        try {
            test01_InitTools();
            fieldID = createTool.createField("JUNITCreateTool测试创建的试验田", "JUNIT测试创建的试验田描述");
            experimentID = createTool.createExperiment("JUNITCreateTool测试创建的试验", "JUNIT测试创建的试验描述",
                    "{\"天气\": [\"阴\", \"晴\", \"雨\", \"雪\"], \"湿度\": \"double\", \"谁写的\": \"string\", \"日照情况\": \"int\"}");
            expertFieldID=createTool.createExpertField(experimentID,fieldID);
            System.out.println("experimentID="+experimentID+",fieldID="+fieldID+",expertFieldID="+expertFieldID);
            System.out.println("CreateTool测试成功");
        } catch (SQLException e) {
            System.out.println("CreateTool测试失败");
            e.printStackTrace();
        }
    }

    @Test
    public void test03_UpdateTool(){

        try {
            test01_InitTools();
            fieldID = createTool.createField("JUNITUpdateTool测试创建的试验田", "JUNIT测试创建的试验田描述");
            experimentID = createTool.createExperiment("JUNITUpdateTool测试创建的试验", "JUNIT测试创建的试验描述",
                    "{\"天气\": [\"阴\", \"晴\", \"雨\", \"雪\"], \"湿度\": \"double\", \"谁写的\": \"string\", \"日照情况\": \"int\"}");
            expertFieldID=createTool.createExpertField(experimentID,fieldID);
            updateTool.updateField(fieldID,"JUNITUpdateTool测试修改的试验田","JUNIT测试修改的试验田描述");
            updateTool.updateExperiment(experimentID,"JUNITUpdateTool测试修改的试验","JUNIT测试修改的试验描述",
                    "{\"改了吗\": [\"改了\", \"并没有\"], \"可选的变量类型\": [\"int\", \"long\", \"float\", \"double\", \"枚举列表\"]}");
            updateTool.deleteExpertField(expertFieldID);
            System.out.println("experimentID="+experimentID+",fieldID="+fieldID+",expertFieldID="+expertFieldID);
            System.out.println("UpdateTool测试成功");
        } catch (SQLException e) {
            System.out.println("UpdateTool测试失败");
            e.printStackTrace();
        }
    }

    @Test
    public void test04_QueryTool(){
        try {
            test01_InitTools();
            fieldID = createTool.createField("JUNITQueryTool测试创建的试验田", "JUNIT测试创建的试验田描述");
            expertFieldID=createTool.createExpertField(1,fieldID);
            System.out.println(queryTool.getExperiments().toString());
            System.out.println(queryTool.getFields().toString());
            System.out.println(queryTool.getExperimentDetails(1));
            System.out.println("QueryTool测试成功");
        } catch (SQLException e) {
            System.out.println("QueryTool测试失败");
            e.printStackTrace();
        }
    }
}
