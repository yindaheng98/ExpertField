<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="ExpertField.util.QueryTool" %>
<%@ page import="java.sql.SQLException" %>
<%
    String data = "error";
    int ID = 0;
    try {
        QueryTool queryTool = new QueryTool();
        ID = Integer.parseInt(request.getParameter("ID"));
        data = queryTool.getExperimentDetails(ID).toString();
    } catch (SQLException | ClassNotFoundException ignored) {
    }
%>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>试验详情</title>
    <script src="https://vuejs.org/js/vue.js"></script>
    <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
    <link rel="stylesheet" href="http://i.gtimg.cn/vipstyle/frozenui/2.0.0/css/frozen.css">
</head>
<body>
<div id="main">
    <div>{{ 试验名称 }}</div>
    <div>{{ 创建时间 }}</div>
    <div v-if="已结束"><img src="img/yiwancheng.svg" alt="已结束"></div>
    <div v-else><img src="img/jinxingzhong.svg" alt="进行中"></div>
    <div>
        <div>试验描述</div>
        {{ 试验描述 }}
        <span :onclick="show_edit_description({ 试验描述 })">
            <img src="img/edit.svg" alt="编辑试验描述">
        </span>
    </div>
    <div>
        <div>试验数据格式</div>
        <table>
            <tr><th>字段名</th><th>数据类型</th></tr>
            <tr v-for="(数据类型,字段名) in 试验数据格式"><td>{{ 字段名 }}</td><td>{{数据类型}}</td></tr>
        </table>
    </div>
    <div v-for="(试验田详情,试验田ID) in 试验田">
        <div>试验田-{{ 试验田ID }}:{{ 试验田详情.试验田名称 }}</div>
        <table>
            <tr v-for="(试验数据,试验数据ID) in 试验田详情.试验田数据">
                <td>试验数据-{{ 试验数据ID }}:{{ 试验数据 }}</td>
            </tr>
        </table>
    </div>
</div>

<div class="ui-dialog ui-dialog-operate" id="试验描述编辑div">
    <div class="ui-dialog-cnt">
        <div class="ui-form ui-border-t">
            <div class="ui-form-item ui-border-b">
                <textarea placeholder="试验描述" id="试验描述编辑textarea"></textarea>
            </div>
            <div class="ui-btn-wrap">
                <button class="ui-btn-lg ui-btn-primary" onclick="editDescription(<%= ID %>)">确定</button>
            </div>
        </div>
        <i class="ui-dialog-close" data-role="button"
           onclick="document.getElementById('试验描述编辑div').classList.remove('show')"></i>
    </div>
</div>

<div class="ui-dialog ui-dialog-operate" id="试验数据格式编辑div">
    <div class="ui-dialog-cnt">
        <div class="ui-form ui-border-t">
            <div class="ui-form-item ui-border-b">
                <textarea placeholder="试验描述" id="试验数据格式编辑textarea"></textarea>
            </div>
            <div class="ui-btn-wrap">
                <button class="ui-btn-lg ui-btn-primary" onclick="edit_description(<%= ID %>)">确定</button>
            </div>
        </div>
        <i class="ui-dialog-close" data-role="button"
           onclick="document.getElementById('试验描述编辑div').classList.remove('show')"></i>
    </div>
</div>

<div class="ui-loading-block" id="加载中">
    <div class="ui-loading-cnt">
        <i class="ui-loading-bright"></i>
        <p>正在加载中...</p>
    </div>
</div>

</body>
<script>
    let data_set =<%= data %>;
    let vue = new Vue({
        el: "#main",
        data: data_set,
        methods: {
            show_edit_description: function (description) {
                let fstr = "$('#试验描述编辑textarea').val('" + description.试验描述 + "');";
                fstr += "document.getElementById('试验描述编辑div').classList.add('show');";
                return fstr;
            },
            show_edit_format: function (description) {
                let fstr = "document.getElementById('试验数据格式编辑textarea').innerHTML='" + description.试验描述 + "';";
                fstr += "document.getElementById('试验数据格式编辑div').classList.add('show');";
                return fstr;
            }
        }
    });
</script>
<script src="js/Experiment/edit_info.js"></script>
</html>
