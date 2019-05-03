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
    <script src="js/lib/vue.js"></script>
    <script src="js/lib/jquery-3.3.1.min.js"></script>
</head>
<body>
<form>
    <label>试验名称</label>
    <input type="text" placeholder="试验名称" id="新试验名称">
    <label>试验描述</label>
    <textarea placeholder="试验描述" id="新试验描述"></textarea>
    <button onclick="newExperiment()">新建</button>
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

<div class="ui-loading-block" id="加载中">
    <div class="ui-loading-cnt">
        <i class="ui-loading-bright"></i>
        <p>正在加载中...</p>
    </div>
</div>

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

    function newExperiment() {
        let name = document.getElementById('新试验名称').value;
        if (!name) return;
        let description = $('#新试验描述').val();
        document.getElementById('加载中').classList.add('show');
        $.post("Experiment/new", {
            name: name,
            description: description,
            format: '{}'
        }, function (data, textStatus, jqXHR) {
            document.getElementById('加载中').classList.remove('show');
            if (data.indexOf('ok')!==-1){
                alert("新建成功");
                window.location.replace('Experiment.jsp?ID='+data.split(':')[1])
            }
            else
                alert("新建失败");
        });
    }
</script>
</html>
