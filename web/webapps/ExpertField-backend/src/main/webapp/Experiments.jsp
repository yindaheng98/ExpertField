<%--
  Created by IntelliJ IDEA.
  User: yinda
  Date: 2019/5/2
  Time: 21:48
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="ExpertField.util.QueryTool" %>
<%@ page import="java.sql.SQLException" %>
<%
    String data = "error";
    try {
        QueryTool queryTool = new QueryTool();
        data = queryTool.getExperiments().toString();
    } catch (SQLException | ClassNotFoundException ignored) {
    }
%>
<html>
<head>
    <title>试验田汇总</title>
    <script src="https://vuejs.org/js/vue.js"></script>
</head>
<body>
<form action="Experiment/new">
    <label>试验名称</label>
    <input type="text" placeholder="名称" name="name">
    <label>试验描述</label>
    <textarea placeholder="描述" name="description"></textarea>
    <input type="submit" value="新建">
</form>
<table id="fields">
    <tr>
        <th>试验名称</th>
        <th>创建时间</th>
        <th>试验描述</th>
    </tr>
    <tr v-for="field in fields" style="cursor: pointer" id="">
        <td>{{ field.试验名称 }}</td>
        <td>{{ field.创建时间 }}</td>
        <td>{{ field.试验描述 }}</td>
    </tr>
</table>

</body>
<script>
    let data =<%= data %>;
    let vdata = {
        el: "#fields",
        data: {
            fields: data
        },
        methods:{
            viewDetails:function (event) {

            }
        }
    };
    let vue = new Vue(vdata)
</script>
</html>
