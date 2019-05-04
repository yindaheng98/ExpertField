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
    <link rel="stylesheet" href="http://i.gtimg.cn/vipstyle/frozenui/2.0.0/css/frozen.css">
    <link rel="stylesheet" href="css/main.css"/>
    <link rel="stylesheet" href="css/ListPage.css">
</head>
<body>

<h3 style="font-size:20px; text-align:center; font-weight:bold;">新建试验</h3>
<br/><br/>
<div class="content">
    <div class="register-box">
        <div class="wrap">
            <div class="register-box-con2">
                <div class="register-box-con2-box clearfix mar-bottom20">
                    <label class="register-box-con2-box-left">试验名称</label>
                    <div class="register-box-con2-box-right">
                        <input type="text" class="login-box-cen-form-input w358" id="新试验名称" placeholder="请填写试验名称"/>
                    </div>
                </div>
                <div class="register-box-con2-box clearfix mar-bottom20">
                    <label class="register-box-con2-box-left">试验描述</label>
                    <div class="register-box-con2-box-right">
                        <textarea class="login-box-cen-form-textarea w358 h88" id="新试验描述"
                                  placeholder="请填写试验描述"></textarea>
                    </div>
                </div>
                <div class="register-box-con2-box clearfix mar-bottom20 mar-top50">
                    <label class="register-box-con2-box-left"></label>
                    <div class="register-box-con2-box-right">
                        <button onclick="newExperiment()" class="login-box-cen-form-button w380">新建</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<br/><br/>

<div class="main">
    <h2>全部试验</h2>
    <table class="table-integral" id="fields">
        <thead>
        <tr>
            <td style="width:250px;">试验名称</td>
            <td style="width:250px;">创建时间</td>
            <td style="width:450px;">试验描述</td>
            <td style="width:150px;">查看</td>
        </tr>
        </thead>
        <tbody id="content_page">
        <tr v-for="(field,ID) in fields">
            <td>{{ field.试验名称 }}</td>
            <td>{{ field.创建时间 }}</td>
            <td>{{ field.试验描述 }}</td>
            <td><a :href="viewLink({ ID })"><img src="img/chakan.svg" alt="点击查看"></a></td>
        </tr>
        </tbody>
    </table>
    <div id="wrap" class="page_btn clear"></div>
</div>
<div id="info_modal" class="tips_info"></div>


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
            if (data.indexOf('ok') !== -1) {
                alert("新建成功");
                window.location.replace('Experiment.jsp?ID=' + data.split(':')[1])
            } else
                alert("新建失败");
        });
    }
</script>
<script src="js/MultiTable.js"></script>
</html>
