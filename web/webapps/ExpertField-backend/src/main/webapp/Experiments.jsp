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
    <style type="text/css">
        body, html {
            font-family: "microsoft yahei"
        }

        .main {
            width: 971px;
            zoom: 1;
            margin: 100px auto;
        }

        .main h2 {
            text-align: center;
            font-size: 28px;
            color: #666;
            text-align: center;
        }

        .page_btn {
            padding-top: 40px;
            text-align: center;
        }

        .page_btn a {
            cursor: pointer;
            padding: 10px 17px;
            border: solid 1px #dbdbdb;
            font-size: 14px;
        }

        .num {
            padding: 0 10px;
        }

        .page_btn a:hover, .page-item:hover {
            color: #fff;
            background: #e84c3d;
            border: 1px solid #e84c3d;
        }

        .page-item {
            padding: 10px 17px;
            text-decoration: none;
            background-color: #ffffff;
            border: 1px solid #dbdbdb;
            color: #666666;
            margin: 0 3px;
            font-size: 14px;
            cursor: pointer;
        }

        .page-item.current {
            color: #fff;
            background: #e84c3d;
            cursor: pointer;
            border: 1px solid #e84c3d;
        }

        table {
            border-spacing: 0;
            border-collapse: collapse;
        }

        .table-integral thead {
            background: #f7f7f7;
            height: 35px;
            text-align: center;
            line-height: 35px;
            font-size: 14px;
            color: #333;
        }

        .table-integral td {
            border: 1px solid #e5e5e5;
            border-collapse: collapse;
        }

        .table-integral tbody {
            height: 45px;
            line-height: 45px;
            font-size: 14px;
            color: #666;
            text-align: center;
            line-height: 45px;
        }

        .table-integral td {
            border: 1px solid #e5e5e5;
            border-collapse: collapse;
        }

        .text-green {
            color: #00a65a !important;
        }

        .text-red {
            color: #dd4b39 !important;
        }

        .table-integral td a, .table-integral td a:hover, .table-integral td a:active, .table-integral td a:visited, .table-integral td a:focus {
            color: #0099cc;
            cursor: pointer;
            text-decoration: none;
        }

        .tips_info {
            border-radius: 10px;
            background: rgba(0, 0, 0, 0.5);
            font-size: 18px;
            color: #fff;
            text-align: center;
            line-height: 60px;
            display: none;
            padding: 0 30px;
            z-index: 9999;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            margin: auto;
            max-width: 250px;
            height: 60px;
        }
    </style>
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
<script type="text/javascript">
    function Pagination($content, $wrap, options) {
        this.$wrap = $wrap;
        this.$content = $content;
        this.options = $.extend({}, Pagination.defaultOptions, options);
        this.init();
    }
    Pagination.defaultOptions = {
        size: 4
    };
    Pagination.prototype.init = function () {
        var totalItemNum = this.$content.children().length;
        var totalPageNum = this.totalPageNum = Math.ceil(totalItemNum / this.options.size);
        this.currentPage = 1;
        this.$wrap.empty();
        this.$content.children(':gt(' + (this.options.size - 1) + ')').hide();
        this.$wrap.append([
            '<span class="page_box">',
            '<a class="prev">上一页</a>',
            '<span class="num">',
            '</span>',
            '<a class="next">下一页</a>',
            '</span>'
        ].join(''));
        for (var i = 0; i < totalPageNum; i++) {
            var $btn = $('<span class="page-item">' + (i + 1) + '</span>');
            $btn.data('page', i + 1);
            this.$wrap.find('.num').append($btn);
        }
        this.$wrap.find('.num').children().eq(0).addClass('current');
        this.initEvents();
    };
    Pagination.prototype.initEvents = function () {
        var _this = this;
        var $prev = this.$wrap.find('.prev');
        var $next = this.$wrap.find('.next');
        var $num = this.$wrap.find('.num');

        $prev.on('click', function () {
            _this.prev();
        });
        $next.on('click', function () {
            _this.next();
        });
        $num.on('click', '.page-item', function () {
            var page = $(this).data('page');
            _this.goTo(page);
        });
    };
    Pagination.prototype.prev = function () {
        this.goTo(this.currentPage - 1);
    };
    Pagination.prototype.next = function () {
        this.goTo(this.currentPage + 1);
    };
    Pagination.prototype.goTo = function (num) {
        if (typeof num !== 'number') {
            throw new Error('e');
        }
        if(num > this.totalPageNum || num <= 0) {
            return false;
        }

        this.currentPage = num;

        this.$wrap.find('.num')
            .children().eq(this.currentPage - 1)
            .addClass('current').siblings('.current')
            .removeClass('current');

        var left = (this.currentPage - 1) * this.options.size;
        var right = left + this.options.size;

        var $shouldShow = this.$content.children().filter(function (index) {
            return left <= index && index < right;
        });
        this.$content.children().hide();
        $shouldShow.show();
    };

    var pagi = new Pagination($('#content_page'), $('#wrap'));


</script>
</html>
