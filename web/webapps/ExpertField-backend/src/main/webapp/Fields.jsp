<%--
  Created by IntelliJ IDEA.
  User: yinda
  Date: 2019/5/2
  Time: 19:16
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="ExpertField.util.QueryTool" %>
<%@ page import="java.sql.SQLException" %>
<%
    String data = "error";
    try {
        QueryTool queryTool = new QueryTool();
        data = queryTool.getFields().toString();
    } catch (SQLException | ClassNotFoundException ignored) {
    }
%>
<html>
<head>
    <title>试验田汇总</title>
    <script src="https://vuejs.org/js/vue.js"></script>
</head>
<body>
<form action="Field/new">
    <label>试验田名称</label>
    <input type="text" placeholder="名称" name="name">
    <label>试验田描述</label>
    <textarea placeholder="描述" name="description"></textarea>
    <input type="submit" value="新建">
</form>
<table id="fields">
    <tr>
        <th>试验田名称</th>
        <th>创建时间</th>
        <th>试验田描述</th>
        <th>相关试验</th>
        <th>二维码</th>
    </tr>
    <tr v-for="field in fields">
        <td>{{ field.试验田名称 }}</td>
        <td>{{ field.创建时间 }}</td>
        <td style="cursor:pointer">{{ field.试验田描述 }}</td>
        <td></td>
        <td><img src="img/erweima.svg" style="cursor:pointer" alt="点我看二维码"></td>
    </tr>
</table>

</body>
<script>
    let data =<%= data %>;
    let vdata = {
        el: "#fields",
        data: {
            fields: data
        }
    };
    let vue = new Vue(vdata)
</script>
</html>
