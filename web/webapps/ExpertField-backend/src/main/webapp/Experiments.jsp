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
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>试验汇总</title>
    <script src="https://vuejs.org/js/vue.js"></script>
</head>
<body>
<form action="Experiment/new">
    <label>试验名称</label>
    <input type="text" placeholder="名称" name="name">
    <label>试验描述</label>
    <textarea placeholder="描述" name="description"></textarea>
    <label>试验数据格式</label>
    <input type="submit" value="新建">
</form>
<table id="fields">
    <tr>
        <th>试验名称</th>
        <th>创建时间</th>
        <th>试验描述</th>
        <th>查看</th>
    </tr>
    <tr v-for="(field,ID) in fields" style="cursor: pointer">
        <td>{{ field.试验名称 }}</td>
        <td>{{ field.创建时间 }}</td>
        <td>{{ field.试验描述 }}</td>
        <td><a :href="viewLink({ ID })"><img src="img/chakan.svg"></a></td>
    </tr>
</table>

</body>
<script>
    let data =<%= data %>;
    let vue = new Vue({
        el: "#fields",
        data: {
            fields: data
        },
        methods: {
            viewLink: function (ID) {
                return "Experiment.jsp?ID=" + ID.ID;
            }
        }
    });
</script>
</html>