<%--
  Created by IntelliJ IDEA.
  User: yinda
  Date: 2019/5/2
  Time: 21:49
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="ExpertField.util.QueryTool" %>
<%@ page import="java.sql.SQLException" %>
<%
    String data = "error";
    try {
        QueryTool queryTool = new QueryTool();
        int ID=Integer.parseInt(request.getParameter("ID"));
        data = queryTool.getExperimentDetails(ID).toString();
    } catch (SQLException | ClassNotFoundException ignored) {
    }
%>
<html>
<head>
    <title>试验田汇总</title>
    <script src="https://vuejs.org/js/vue.js"></script>
</head>
<body>

</body>
</html>
