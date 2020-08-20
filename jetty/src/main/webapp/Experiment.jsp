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
    <link rel="stylesheet" href="css/main.css"/>
    <link rel="stylesheet" href="css/ListPage.css">
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
    <style type='text/css'>
        .icon {
            width: 20px;
            height: 20px;
            cursor: pointer;
        }

        .删除数据格式字段 {
            display: none;
        }
        .操作试验田{
            display: none;
        }
        .ui-btn{
            display: inline;
        }
    </style>
</head>
<body>
<div id="main" align="center">
    <h1 align="center" style="font-size:30px; text-align:center; font-weight:bold;">{{ 试验名称 }}
        <img v-if="已结束" src="img/yiwancheng.svg" alt="已结束" style="width: 50px">
        <img v-else src="img/jinxingzhong.svg" alt="进行中" style="width: 50px">
    </h1>
    <div align="center">
        <p align="center" style="font-size:20px; text-align:center; font-weight:bold;">【创建时间】</p>
        {{ 创建时间 }}
    </div>
    <div align="center">
        <div>
            <h1 align="center" style="font-size:20px; text-align:center; font-weight:bold;">
                【试验描述】
                <img src="img/edit.svg" class="icon" alt="编辑试验描述" :onclick="show_edit_description({ 试验描述 })">
            </h1>
            <p>{{ 试验描述 }}</p>
        </div>
    </div>
    <br>

    <div align="center">
        <h1 align="center" style="font-size:20px; text-align:center; font-weight:bold;">
            【试验数据格式】
            <span onclick="show_edit_format()" id="编辑试验数据格式" style="text-align: center;height: 50px">
                <img src="img/edit.svg" class="icon" alt="编辑试验数据格式">
            </span>
            <span onclick="hide_edit_format()" id="取消编辑试验数据格式" style="display: none">
                <img src="img/cancel.svg" class="icon" alt="取消编辑">
            </span>
        </h1>
    </div>
    <br>

    <table class="table-integral" id="fields">
        <thead>
        <tr>
            <td style="width:250px;height: 100px">字段名</td>
            <td style="width:250px;height: 100px">数据类型</td>
            <td class="删除数据格式字段">操作</td>
        </tr>
        </thead>

        <tbody>
        <tr id="新增数据格式字段" style="display: none">
            <td style="height: 50px">
                <input type="text" placeholder="新增字段名" id="新增数据格式字段名">
            </td>
            <td style="height: 50px">
                <select id="新增数据格式字段数据类型">
                    <option value="int">int</option>
                    <option value="float">float</option>
                    <option value="string">string</option>
                </select>
            </td>
            <td onclick="newFormat(<%= ID %>)">
                <img src="img/xinzeng.svg" class="删除数据格式字段 icon" alt="新增">
            </td>
        </tr>
        <tr v-for="(数据类型,字段名) in 试验数据格式">
            <td>{{ 字段名 }}</td>
            <td>{{ 数据类型 }}</td>
            <td>
                <img src="img/shanchu.svg" alt="删除" class="删除数据格式字段 icon"
                     :onclick="delete_format(字段名)">
            </td>
        </tr>
        </tbody>
    </table>
    <br>
    <br>

    <h1 align="center" style="font-size:20px; text-align:center; font-weight:bold;">【各试验田数据汇总】
        <span id="编辑试验田"
              onclick="show_edit_field()">
                <img src="img/edit.svg" class="icon" alt="编辑试验田">
        </span>
        <span id="取消编辑试验田" style="display: none"
              onclick="show_edit_field()">
                <img src="img/cancel.svg" class="icon" alt="取消编辑试验田">
        </span>
    </h1>
    <br>

    <div id="新增试验田" align="center" class="操作试验田">
        <select id="选择新增试验田">
            <option v-for="(试验田,试验田ID) in 所有试验田" :value="试验田ID">{{ 试验田.试验田名称 }}</option>
        </select>
        <button class="ui-btn" onclick="add_field(<%= ID %>)">添加试验田</button>
    </div>

    <div id="info_modal" class="tips_info"></div>
    <div id="wrap" class="page_btn clear"></div>
    <br>
    <table class="table-integral">
        <tbody id="content_page">
        <tr v-for="(试验田详情,试验田ID) in 试验田">
            <td>
                <h1 align="center" style="font-size:20px; text-align:center; font-weight:bold;">
                    【试验田-{{ 试验田ID }}:{{ 试验田详情.试验田名称 }}】
                    <img src="img/shanchu.svg" alt="删除试验田" :onclick="delete_field({ 试验田ID })" class="操作试验田 icon">
                </h1>
                <table class="table-integral">
                    <thead>
                    <tr>
                        <td style="width:250px;">录入时间</td>
                        <td style="width:250px;">数据</td>
                        <td style="width:150px;" class="操作试验田">操作</td>
                        <td style="width:450px;">语音</td>
                    </tr>
                    </thead>
                    <tbody>
                    <tr v-for="(试验数据,试验数据ID) in 试验田详情.试验田数据">
                        <td>{{ 试验数据.录入时间 }}</td>
                        <td>
                            <div class="查看数据">
                                <table>
                                    <tbody>
                                    <tr v-for="(值,字段名) in 试验数据.数据">
                                        <td style="width: 125px">{{ 字段名 }}</td>
                                        <td style="width: 125px">{{ 值 }}</td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div class="修改数据" style="display: none;">
                                <table>
                                    <tbody>
                                    <tr v-for="(数据类型,字段名) in 试验数据格式">
                                        <td style="width: 125px">{{ 字段名 }}</td>
                                        <td style="width: 125px">
                                            <input type="text" style="width: 125px"
                                                   :value="试验数据.数据[字段名]" :name="字段名">
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                        </td>
                        <td class="操作试验田">
                            <img src="img/edit.svg" class="icon" alt="修改数据"
                                 onclick="
                                 $(this).hide();
                                 $(this).next().show();
                                 $(this).next().next().show();
                                 $(this).parent().prev().children('.查看数据').hide();
                                 $(this).parent().prev().children('.修改数据').show();">
                            <img src="img/cancel.svg" class="icon" style="display: none" alt="取消修改数据"
                                 onclick="
                                 $(this).hide();
                                 $(this).next().hide();
                                 $(this).prev().show();
                                 $(this).parent().prev().children('.查看数据').show();
                                 $(this).parent().prev().children('.修改数据').hide();">
                            <button style="display: none" class="ui-btn"
                                    :onclick="edit_metadata({ 试验数据ID },{ 试验田ID })">ok
                            </button>
                            <br>
                            <img src="img/shanchu.svg" class="icon" alt="点击删除"
                                 :onclick="delete_data({ 试验数据ID },{试验田ID})">
                        </td>
                        <td>
                            <div v-for="(语音链接) in 试验数据.语音">
                                <audio :src="getAudioLink(语音链接)" preload="metadata"></audio>
                            </div>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </td>
        </tr>
        </tbody>
    </table>
</div>

<div class="ui-dialog ui-dialog-operate" id="试验描述编辑div">
    <div class="ui-dialog-cnt" align="center" style="width: 500px;height: 250px">
        <div class="ui-form ui-border-t">
            <h1 align="center">编辑实验描述</h1>
            <br>
            <div style="padding: 0;width: 300px;height: 150px" class="ui-form-item ui-border-b" align="center">
                <textarea style="padding: 0;width: 300px;height: 150px" placeholder="试验描述"
                          id="试验描述编辑textarea"></textarea>
            </div>
            <div class="ui-btn-wrap" align="center">
                <button style="width: 150px" class="ui-btn-lg ui-btn-primary" onclick="editDescription(<%= ID %>)">
                    确定
                </button>
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
            },
            getAudioLink:function (oriLink) {
                if(oriLink.split('/')[0].indexOf('http')!==-1)
                    return oriLink;
                return document.URL.split('/').slice(0,3).join('/')+'/api/'+oriLink
            }
        }
    });
</script>
<script src="js/EditExperiment.js"></script>
<script src="js/FieldList.js"></script>
</html>
