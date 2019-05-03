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
    <script src="https://vuejs.org/js/vue.js"></script>
    <link rel="stylesheet" href="http://i.gtimg.cn/vipstyle/frozenui/2.0.0/css/frozen.css">
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
        <th>编辑</th>
        <th>二维码</th>
    </tr>
    <tr v-for="(field,ID) in fields">
        <td>{{ field.试验田名称 }}</td>
        <td>{{ field.创建时间 }}</td>
        <td>{{ field.试验田描述 }}</td>
        <td style="cursor:pointer" :onclick="show_edit({ ID },{ field })">
            <img src="img/edit.svg" alt="编辑试验田">
        </td>
        <td style="cursor:pointer" :onclick="create_qrcode({ ID },{ field })">
            <img src="img/erweima.svg" alt="查看二维码">
        </td>
    </tr>
</table>

<div class="ui-dialog ui-dialog-operate" id="qrcanvas">
    <div class="ui-dialog-cnt">
        <div class="ui-dialog-hd">
            <div class="ui-img" id="qr">
                <span>加载失败</span>
            </div>
        </div>
        <div class="ui-dialog-bd" id="qrcontents"></div>
        <div class="ui-dialog-ft">
            <button class="ui-btn-lg" onclick="save_qrcode()">立即保存</button>
        </div>
        <i class="ui-dialog-close" data-role="button"
           onclick="document.getElementById('qrcanvas').classList.remove('show')"></i>
    </div>
</div>

<div class="ui-dialog ui-dialog-operate" id="edit-field">
    <div class="ui-dialog-cnt">
        <div class="ui-form ui-border-t">
            <form action="">
                <div class="ui-form-item ui-border-b">
                    <textarea placeholder="试验田描述" id="edit-description"></textarea>
                </div>
                <div class="ui-btn-wrap">
                    <button class="ui-btn-lg ui-btn-primary">确定</button>
                </div>
            </form>
        </div>
        <i class="ui-dialog-close" data-role="button"
           onclick="document.getElementById('edit-field').classList.remove('show')"></i>
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
            create_qrcode: function (ID,field) {//默认模式生成字符，最高容错率
                field = field.field;
                let text = JSON.stringify({ID: ID.ID, 试验田名称: field.试验田名称, 创建时间: field.创建时间});
                return "create_qrcode('" + text + "')"
            },
            show_edit: function (ID,field) {
                field = field.field;
                return "show_edit(" + ID.ID+','+field.试验田描述 + ")";
            }
        }
    });

    function create_qrcode(text) {
        qrcode.stringToBytes = qrcode.stringToBytesFuncs['default'];
        var qr = qrcode("0", 'H');//"0"表示自动判断要生成的QRCode的大小
        qr.addData(text, 'Byte');
        qr.make();
        document.getElementById('qrcanvas').classList.add("show");
        document.getElementById('qr').innerHTML = qr.createSvgTag();
        document.getElementById('qrcontents').innerText = text;
    }

    function save_qrcode() {

    }

    function show_edit(field) {
        document.getElementById('edit-description').innerHTML = field.试验田描述;
        document.getElementById('edit-field').classList.add('show');
    }
</script>
</html>
