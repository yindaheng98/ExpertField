package ExpertField.FieldServlets;

import ExpertField.util.CreateTool;

import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "NewField", urlPatterns = {"Field/new"})
public class NewField extends HttpServlet {

    private CreateTool createTool;

    public void init() throws ServletException {
        try {
            createTool = new CreateTool();
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            throw new ServletException("新建试验田的Servlet 'NewField'初始化失败");
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
        try {
            int ID = createTool.createField(name, description);
            response.getWriter().print("ok:" + ID);
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().print("error");
        }
    }
}

