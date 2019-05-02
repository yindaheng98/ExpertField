package ExpertField.Servlets.ExpertFieldServlets;

import ExpertField.util.CreateTool;

import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "NewExpertField", urlPatterns = {"ExpertField/new"})
public class NewExpertField extends HttpServlet {

    private CreateTool createTool;

    public void init() throws ServletException {
        try {
            createTool = new CreateTool();
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            throw new ServletException("新建试验-试验田关系的Servlet 'NewExpertField'初始化失败");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int experimentID = Integer.parseInt(request.getParameter("experimentID"));
        int fieldID = Integer.parseInt(request.getParameter("fieldID"));
        try {
            int ID = createTool.createExpertField(experimentID, fieldID);
            response.getWriter().print("ok:" + ID);
        } catch (SQLException e) {
            //e.printStackTrace();
            System.out.println("一次失败的NewExpertField");
            response.getWriter().print("error");
        }
    }
}

