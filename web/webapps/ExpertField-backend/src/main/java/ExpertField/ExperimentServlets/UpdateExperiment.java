package ExpertField.ExperimentServlets;

import ExpertField.util.UpdateTool;

import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "UpdateExperiment", urlPatterns = {"Experiment/update"})
public class UpdateExperiment extends HttpServlet {

    private UpdateTool updateTool;

    public void init() throws ServletException {
        try {
            updateTool = new UpdateTool();
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            throw new ServletException("更新试验的Servlet 'UpdateExperiment'初始化失败");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int ID = Integer.parseInt(request.getParameter("ID"));
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String format = request.getParameter("format");
        try {
            updateTool.updateExperiment(ID, name, description, format);
            response.getWriter().print("ok");
        } catch (SQLException e) {
            //e.printStackTrace();
            System.out.println("一次失败的UpdateExperiment");
            response.getWriter().print("error");
        }
    }
}

