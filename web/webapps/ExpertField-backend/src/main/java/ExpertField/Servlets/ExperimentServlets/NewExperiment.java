package ExpertField.Servlets.ExperimentServlets;

import ExpertField.util.CreateTool;

import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "NewExperiment", urlPatterns = {"Experiment/new"})
public class NewExperiment extends HttpServlet {

    private CreateTool createTool;

    public void init() throws ServletException {
        try {
            createTool = new CreateTool();
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            throw new ServletException("新建试验的Servlet 'NewExperiment'初始化失败");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String format = request.getParameter("format");
        try {
            int ID = createTool.createExperiment(name, description, format);
            response.getWriter().print("ok:" + ID);
        } catch (SQLException e) {
            //e.printStackTrace();
            System.out.println("一次失败的NewExperiment");
            response.getWriter().print("error");
        }
    }
}

