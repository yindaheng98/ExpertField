package ExpertField.FieldServlets;

import ExpertField.util.UpdateTool;

import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "UpdateField", urlPatterns = {"Field/update"})
public class UpdateField extends HttpServlet {

    private UpdateTool updateTool;

    public void init() throws ServletException {
        try {
            updateTool = new UpdateTool();
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            throw new ServletException("更新试验田的Servlet 'UpdateField'初始化失败");
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
        try {
            updateTool.updateField(ID, name, description);
            response.getWriter().print("ok");
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().print("error");
        }
    }
}

