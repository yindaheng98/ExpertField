<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="ExpertField.util.QueryTool" %>
<%@ page import="java.sql.SQLException" %>
<%
    String data = "sth went wrong";
    String fields = "sth went wrong";
    int ID = 0;
    try {
        QueryTool queryTool = new QueryTool();
        ID = Integer.parseInt(request.getParameter("ID"));
        data = queryTool.getExperimentDetails(ID).toString();
        fields = queryTool.getFields().toString();
    } catch (SQLException | ClassNotFoundException e) {
        data = e.getMessage();
    }
%>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>试验详情</title>
    <script src="js/lib/vue.js"></script>
    <script src="js/lib/jquery-3.3.1.min.js"></script>
    <script src="js/lib/audiojs/audio.min.js"></script>
    <link rel="stylesheet" href="http://i.gtimg.cn/vipstyle/frozenui/2.0.0/css/frozen.css">
    <script src="js/lib/audiojs/audio.min.js"></script>
    <script>
        audiojs.events.ready(function () {
            audiojs.createAll();
        });
    </script>
</head>
<body>
<div id="main">
    <h1 align="center" style="font-size:30px; text-align:center; font-weight:bold;">{{ 试验名称 }}</h1>
    <div align="center">
        <span v-if="已结束"><img src="img/yiwancheng.svg" alt="已结束" style="width:200px; height:100px"></span>
        <span v-else><img src="img/jinxingzhong.svg" alt="进行中" style="width:200px;height: 100px"></span>
    </div>
    <div align="center">
        <div><p style="font-size:20px;height:auto">【创建时间】</p></div>
        <div>{{ 创建时间 }}</div>
    </div>
    <div align="center">
        <div>
            <h1 style="font-size:20px;width:300px; height:auto">【试验描述】</h1>
        </div>
        <div align="center">
            <table>
                <tr>
                    <th width="300px" align="center">试验描述</th>
                    <th width="100px" align="center">修改试验描述</th>
                </tr>
                <tr>
                    <td width="300px">{{ 试验描述 }}</td>
                    <td width="100px" align="center"><span :onclick="show_edit_description({ 试验描述 })">
            			<img src="img/edit.svg" width="50px" height="50px" align="center" alt="编辑试验描述">
        				</span></td>
                </tr>
            </table>
        </div>
    </div>
    <div>
        <div align="center">
            <h1 style="font-size:20px;width:300px; height:auto"> 【试验数据格式】</h1>
        </div>
        <span onclick="show_edit_format()" id="编辑试验数据格式">
            <img src="img/edit.svg" alt="编辑试验数据格式">
        </span>
        <span onclick="hide_edit_format()" id="取消编辑试验数据格式" style="display: none;">
            <img src="img/cancel.svg" alt="取消编辑">
        </span>
        <table>
            <tr>
                <th>字段名</th>
                <th>数据类型</th>
                <th></th>
            </tr>
            <tr v-for="(数据类型,字段名) in 试验数据格式">
                <td>{{ 字段名 }}</td>
                <td>{{ 数据类型 }}</td>
                <td :onclick="delete_format(字段名)">
                    <img src="img/shanchu.svg" alt="删除" class="删除数据格式字段" style="display: none;">
                </td>
            </tr>
            <tr id="新增数据格式字段" style="display: none;">
                <td><input type="text" placeholder="新增字段名" id="新增数据格式字段名"></td>
                <td>
                    <select id="新增数据格式字段数据类型">
                        <option value="int">int</option>
                        <option value="float">float</option>
                        <option value="string">string</option>
                    </select>
                </td>
                <td onclick="newFormat(<%= ID %>)">
                    <img src="img/xinzeng.svg" alt="新增">
                </td>
            </tr>
        </table>
    </div>

    <h1>各试验田数据汇总</h1>
    <span id="编辑试验田"
          onclick="$('#编辑试验田').hide();$('#取消编辑试验田').show();$('#新增试验田').slideDown('fast');$('.删除试验田').show();">
            <img src="img/edit.svg" alt="编辑试验田">
        </span>
    <span id="取消编辑试验田" style="display: none;"
          onclick="$('#编辑试验田').show();$('#取消编辑试验田').hide();$('#新增试验田').slideUp('fast');$('.删除试验田').hide();">
            <img src="img/cancel.svg" alt="取消编辑试验田">
        </span>
    <div id="新增试验田" style="display: none">
        <select id="选择新增试验田">
            <option v-for="(试验田,试验田ID) in 所有试验田" :value="试验田ID">{{ 试验田.试验田名称 }}</option>
        </select>
        <button onclick="add_field(<%=ID%>)">添加试验田</button>
    </div>
    <div v-for="(试验田详情,试验田ID) in 试验田">
        <h1>
            试验田-{{ 试验田ID }}:{{ 试验田详情.试验田名称 }}
            <img src="img/shanchu.svg" alt="删除试验田" :onclick="delete_field({ 试验田ID })" class="删除试验田"
                 style="display: none">
        </h1>
        <table>
            <tr>
                <th>录入时间</th>
                <th>数据</th>
                <th>语音</th>
                <th class="删除试验田数据" style="display: none">删除</th>
            </tr>
            <tr v-for="(试验数据,试验数据ID) in 试验田详情.试验田数据">
                <td>{{ 试验数据.录入时间 }}</td>
                <td>
                    <div>
                        <table class="查看数据">
                            <tbody>
                            <tr v-for="(值,字段名) in 试验数据.数据">
                                <td>{{ 字段名 }}</td>
                                <td>{{ 值 }}</td>
                            </tr>
                            </tbody>
                        </table>
                        <img src="img/edit.svg" alt="修改数据"
                             onclick="$(this).parent().hide();$(this).parent().next().show();">
                    </div>
                    <div style="display: none;">
                        <table class="修改数据">
                            <tbody>
                            <tr v-for="(数据类型,字段名) in 试验数据格式">
                                <td>{{ 字段名 }}</td>
                                <td><input type="text" :value="试验数据.数据[字段名]" :name="字段名"></td>
                            </tr>
                            </tbody>
                        </table>
                        <img src="img/cancel.svg" alt="取消修改数据"
                             onclick="$(this).parent().hide();$(this).parent().prev().show();">
                        <button :onclick="edit_metadata({ 试验数据ID },{ 试验田ID })">ok</button>
                    </div>
                </td>
                <td>
                    <div v-for="(语音链接) in 试验数据.语音">
                        <audio :src="语音链接" preload="metadata"></audio>
                    </div>
                </td>
                <td class="删除试验田数据" style="display: none">
                    <img src="img/shanchu.svg" alt="点击删除" :onclick="delete_data({ 试验数据ID },{试验田ID})">
                </td>
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

<div class="ui-loading-block" id="加载中">
    <div class="ui-loading-cnt">
        <i class="ui-loading-bright"></i>
        <p>正在加载中...</p>
    </div>
</div>

</body>
<script>
    let data_set =<%= data %>;
    data_set.所有试验田 =<%=fields%>;
    let vue = new Vue({
        el: "#main",
        data: data_set,
        methods: {
            show_edit_description: function (description) {
                let fstr = "$('#试验描述编辑textarea').val('" + description.试验描述 + "');";
                fstr += "document.getElementById('试验描述编辑div').classList.add('show');";
                return fstr;
            },
            delete_format: function (name) {
                return "deleteFormat(<%= ID %>,'" + name + "')";
            },
            delete_data: function (dataID, fieldID) {
                return "deleteData(" + dataID.试验数据ID + ',' + fieldID.试验田ID + ")";
            },
            delete_field: function (fieldID) {
                return "delete_field(<%=ID%>,'" + fieldID.试验田ID + "')";
            },
            edit_metadata: function (dataID, fieldID) {
                return "edit_metadata(" + dataID.试验数据ID + ",this," + fieldID.试验田ID + ")"
            }
        }
    });
</script>
<script src="js/EditExperiment.js"></script>
</html>
