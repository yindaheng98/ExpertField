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
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>试验田汇总</title>
    <link rel="stylesheet" href="css/main.css"/>
    <link rel="stylesheet" href="css/ListPage.css">
    <script src="js/lib/vue.js"></script>
    <script src="js/lib/jquery-3.3.1.min.js"></script>
    <script src="js/lib/jQueryRotate.js"></script>
    <link rel="stylesheet" href="http://i.gtimg.cn/vipstyle/frozenui/2.0.0/css/frozen.css">
    <script src="js/lib/qrcode.js"></script>
    <script src="js/lib/qrcode_SJIS.js"></script>
    <script src="js/lib/canvg.js"></script>
</head>
<body>

<h1 style="font-size:30px; text-align:center; font-weight:bold;">
    新建试验田<br>
    <img src="img/xinjian.svg" alt="新建" width="30px" height="auto"
         id="打开新建表单" style="cursor: pointer">
</h1>
<div class="content" id="新建表单" style="display: none">
    <br/><br/>
    <div class="register-box">
        <div class="wrap">
            <div class="register-box-con2">
                <div class="register-box-con2-box clearfix mar-bottom20">
                    <label class="register-box-con2-box-left">试验田名称</label>
                    <div class="register-box-con2-box-right">
                        <input type="text" class="login-box-cen-form-input w358" id="新试验田名称"
                               placeholder="请填写试验田名称"/>
                    </div>
                </div>

                <div class="register-box-con2-box clearfix mar-bottom20">
                    <label class="register-box-con2-box-left">试验田描述</label>
                    <div class="register-box-con2-box-right">
                                    <textarea class="login-box-cen-form-textarea w358 h88" id="新试验田描述"
                                              placeholder="请填写试验田描述"></textarea>
                    </div>
                </div>

                <div class="register-box-con2-box clearfix mar-bottom20 mar-top50">
                    <label class="register-box-con2-box-left"></label>
                    <div class="register-box-con2-box-right">
                        <button class="login-box-cen-form-button w380" onclick="newField()">新建</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="main">
    <h1 style="font-size:30px; text-align:center; font-weight:bold;">全部试验田</h1>
    <table class="table-integral" id="fields">
        <thead>
        <tr>
            <td style="width:250px;">试验田名称</td>
            <td style="width:250px;">创建时间</td>
            <td style="width:450px;">试验田描述</td>
            <td style="width:150px;">编辑</td>
            <td style="width:150px;">二维码</td>
        </tr>
        </thead>

        <tbody id="content_page">
        <tr v-for="(field,ID) in fields">
            <td>{{ field.试验田名称 }}</td>
            <td>{{ field.创建时间 }}</td>
            <td>{{ field.试验田描述 }}</td>
            <td style="cursor:pointer" :onclick="show_edit({ ID },{ field })">
                <img src="img/edit.svg" width="30px" height="auto" alt="编辑试验田">
            </td>
            <td style="cursor:pointer" :onclick="create_qrcode({ ID },{ field })">
                <img src="img/erweima.svg" width="30px" height="auto" alt="查看二维码">
            </td>
        </tr>
        </tbody>
    </table>
    <div id="wrap" class="page_btn clear"></div>
</div>
<div id="info_modal" class="tips_info"></div>

<div class="ui-dialog ui-dialog-operate" id="QR码窗口">
    <div class="ui-dialog-cnt">
        <div class="ui-dialog-hd" id="QR码标题"></div>
        <div class="ui-dialog-hd">
            <div class="ui-img" id="QR码img">
                <span>加载失败</span>
            </div>
        </div>
        <div class="ui-dialog-ft">
            <button class="ui-btn-lg" onclick="save_qrcode()">立即保存</button>
        </div>
        <i class="ui-dialog-close" data-role="button"
           onclick="document.getElementById('QR码窗口').classList.remove('show')"></i>
    </div>
</div>

<div class="ui-dialog ui-dialog-operate" id="编辑试验田描述div">
    <div class="ui-dialog-cnt">
        <div class="ui-list-info ui-border-t">
            <h1 align="center">{{ name }}</h1>
            <p>编辑试验田描述：</p>
        </div>
        <div class="ui-form ui-border-b">

            <div class="ui-form-item ui-border-b" align="center">
                <textarea class="" placeholder="试验田描述" id="编辑试验田描述textarea" style="padding:0"></textarea>
            </div>
            <div class="ui-btn-wrap">
                <button class="ui-btn-lg ui-btn-primary" :onclick="edit_description({ ID })">确定</button>
            </div>

        </div>
        <i class="ui-dialog-close" data-role="button"
           onclick="document.getElementById('编辑试验田描述div').classList.remove('show')">
        </i>
    </div>
</div>

<div class="ui-loading-block" id="加载中">
    <div class="ui-loading-cnt">
        <i class="ui-loading-bright"></i>
        <p>正在加载中...</p>
    </div>
</div>

</body>
<script src="js/Fields.js"></script>
<script>
    let data_set =<%= data %>;
    let vue = new Vue({
        el: "#fields",
        data: {
            fields: data_set
        },
        methods: {
            create_qrcode: function (ID, field) {//默认模式生成字符，最高容错率
                field = field.field;
                let text = JSON.stringify({ID: ID.ID, 试验田名称: field.试验田名称, 创建时间: field.创建时间});
                return "create_qrcode('" + text + "')"
            },
            show_edit: function (ID, field) {
                field = field.field;
                let fstr = "$('#编辑试验田描述textarea').val('" + field.试验田描述 + "');";
                fstr += "document.getElementById('编辑试验田描述div').classList.add('show');";
                fstr += "selected.ID=" + ID.ID + ";";
                fstr += "selected.name='" + field.试验田名称 + "';";
                return fstr;
            }
        }
    });

    let selected = {ID: 0, name: ''};
    let vue2 = new Vue({
        el: '#编辑试验田描述div',
        data: selected,
        methods: {
            edit_description: function (ID) {
                return "edit_description(" + ID.ID + ")"
            }
        }
    });

</script>
<script src="js/MultiTable.js"></script>
</html>
