package ExpertField.Servlets.ExpertFieldServlets;

import ExpertField.util.UpdateTool;

import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "DeleteExpertField", urlPatterns = {"ExpertField/del"})
public class DeleteExpertField extends HttpServlet {

    private UpdateTool updateTool;

    public void init() throws ServletException {
        try {
            updateTool = new UpdateTool();
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            throw new ServletException("删除试验-试验田关系的Servlet 'DeleteExpertField'初始化失败");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String ID = request.getParameter("ID");
        String experimentID = request.getParameter("experimentID");
        String fieldID = request.getParameter("fieldID");
        try {
            updateTool.deleteExpertField(ID, experimentID, fieldID);
            response.getWriter().print("ok");
        } catch (SQLException e) {
            //e.printStackTrace();
            System.out.println("一次失败的DeleteExpertField");
            response.getWriter().print("error");
        }
    }
}

