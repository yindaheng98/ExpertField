package ExpertField.Servlets.ExperimentServlets;

import ExpertField.util.UpdateTool;

import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "FinishExperiment", urlPatterns = {"Experiment/finish"})
public class FinishExperiment extends HttpServlet {

    private UpdateTool updateTool;

    public void init() throws ServletException {
        try {
            updateTool = new UpdateTool();
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            throw new ServletException("完成试验的Servlet 'FinishExperiment'初始化失败");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int ID = Integer.parseInt(request.getParameter("ID"));
        int finish=Integer.parseInt(request.getParameter("finish"));
        try {
            updateTool.finishExperiment(ID,finish);
            response.getWriter().print("ok");
        } catch (SQLException e) {
            //e.printStackTrace();
            System.out.println("一次失败的FinishExperiment");
            response.getWriter().print("error");
        }
    }
}

