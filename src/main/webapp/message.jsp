<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.qdu.entity.Users" %>
<%
    Users currentUser = (Users) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<html>
<head>
    <title>消息中心 - <%= currentUser.getUname() %></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/layui/css/layui.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Helvetica Neue', Arial, sans-serif;
            background-color: #F2F2F2;
        }

        .header {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1000;
            border-bottom: 1px solid #f2f2f2;
            background-color: #2E2E2E;
            height: 60px;
        }

        .logo {
            color: #1E9FFF;
            font-size: 24px;
            font-weight: bold;
            line-height: 60px;
            padding-left: 15px;
        }

        .container {
            max-width: 1000px;
            margin: 80px auto 20px;
            padding: 20px;
            background-color: white;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            border-radius: 5px;
        }

        .request-title {
            font-size: 20px;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }

        .request-list {
            margin-top: 20px;
        }

        .request-item {
            display: flex;
            align-items: center;
            padding: 15px;
            border-bottom: 1px solid #eee;
            transition: background-color 0.2s;
        }

        .request-item:hover {
            background-color: #f9f9f9;
        }

        .request-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            margin-right: 15px;
            object-fit: cover;
        }

        .request-info {
            flex: 1;
        }

        .request-name {
            font-weight: bold;
            margin-bottom: 5px;
        }

        .request-id {
            font-size: 12px;
            color: #999;
            margin-bottom: 5px;
        }

        .request-message {
            font-size: 14px;
            color: #666;
            margin-top: 5px;
        }

        .request-group {
            font-size: 14px;
            color: #1E9FFF;
            margin-top: 3px;
        }

        .request-actions {
            display: flex;
            gap: 10px;
        }

        .no-requests {
            text-align: center;
            padding: 40px 0;
            color: #999;
        }

        .refresh-btn {
            margin-bottom: 20px;
        }

        .request-tabs {
            display: flex;
            margin-bottom: 15px;
            border-bottom: 1px solid #eee;
        }

        .request-tab {
            padding: 8px 15px;
            cursor: pointer;
            border-bottom: 2px solid transparent;
        }

        .request-tab.active {
            border-bottom-color: #1E9FFF;
            color: #1E9FFF;
            font-weight: bold;
        }
    </style>
</head>
<body>
<!-- 顶部导航栏 -->
<div class="layui-header header">
    <div class="layui-container">
        <div class="layui-row">
            <div class="layui-col-md3">
                <div class="logo">鹿鸣台</div>
            </div>
            <div class="layui-col-md6">
                <ul class="layui-nav" lay-filter="">
                    <li class="layui-nav-item"><a href="${pageContext.request.contextPath}/home.jsp">首页</a></li>
                    <li class="layui-nav-item"><a href="${pageContext.request.contextPath}/chat">好友</a></li>
                    <li class="layui-nav-item layui-this"><a href="">消息</a></li>
                    <li class="layui-nav-item"><a href="${pageContext.request.contextPath}/groupChat">群组</a></li>
                </ul>
            </div>
            <div class="layui-col-md3">
                <ul class="layui-nav" lay-filter="">
                    <li class="layui-nav-item">
                        <a href="javascript:;">
                            <img src="<%= currentUser.getUimage() != null ? currentUser.getUimage() : "default-avatar.jpg" %>" class="layui-nav-img">
                            <%= currentUser.getUname() %>
                        </a>
                        <dl class="layui-nav-child">
                            <dd><a href="javascript:;">个人主页</a></dd>
                            <dd><a href="javascript:;">账号设置</a></dd>
                            <dd><a href="${pageContext.request.contextPath}/logout">退出登录</a></dd>
                        </dl>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</div>

<!-- 主内容区 -->
<div class="container">
    <h2 class="request-title">消息中心</h2>

    <!-- 请求类型标签页 -->
    <div class="request-tabs">
        <div class="request-tab active" data-type="all">全部请求</div>
        <div class="request-tab" data-type="friend">好友请求</div>
        <div class="request-tab" data-type="group">群组请求</div>
    </div>

    <button class="layui-btn layui-btn-normal refresh-btn" id="refreshBtn">
        <i class="layui-icon layui-icon-refresh"></i> 刷新
    </button>

    <div class="request-list" id="requestList">
        <!-- 请求列表将通过AJAX动态加载 -->
        <div class="no-requests">
            <i class="layui-icon layui-icon-face-smile" style="font-size: 50px;"></i>
            <div style="margin-top: 15px; font-size: 16px;">加载中...</div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/layui/layui.js"></script>
<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
<script>
    layui.use(['layer', 'form'], function() {
        var layer = layui.layer;
        var $ = layui.$;

        // 当前选中的请求类型
        var currentRequestType = 'all';

        // 刷新请求列表
        function refreshRequests() {
            $.get('${pageContext.request.contextPath}/messages', {
                action: 'refreshRequests'
            }, function(data) {
                $('#requestList').html(data);

                // 根据当前选中的类型过滤请求
                filterRequests(currentRequestType);
            });
        }

        // 过滤请求类型
        function filterRequests(type) {
            currentRequestType = type;

            // 更新标签页状态
            $('.request-tab').removeClass('active');
            $(`.request-tab[data-type="${type}"]`).addClass('active');

            // 过滤请求项
            $('.request-item').each(function() {
                var itemType = $(this).data('request-type');
                $(this).toggle(
                    type === 'all' || itemType === type
                );
            });

            // 检查是否没有请求
            var visibleItems = $('.request-item:visible').length;
            if (visibleItems === 0 && $('.no-requests').length === 0) {
                $('#requestList').append('<div class="no-requests">' +
                    '<i class="layui-icon layui-icon-face-smile" style="font-size: 50px;"></i>' +
                    '<div style="margin-top: 15px; font-size: 16px;">暂无请求</div></div>');
            } else if (visibleItems > 0) {
                $('.no-requests').remove();
            }
        }

        // 点击刷新按钮
        $('#refreshBtn').on('click', function() {
            refreshRequests();
        });

        // 点击标签页
        $('.request-tabs').on('click', '.request-tab', function() {
            var type = $(this).data('type');
            filterRequests(type);
        });

        // 处理接受/拒绝按钮点击
        $(document).on('click', '.accept-btn, .reject-btn', function() {
            var requestItem = $(this).closest('.request-item');
            var requestId = requestItem.data('request-id');
            var requestType = requestItem.data('request-type');
            var actionType = $(this).hasClass('accept-btn') ? 'accept' : 'reject';

            $.post('${pageContext.request.contextPath}/messages', {
                action: 'handleRequest',
                requestType: requestType,
                requestId: requestId,
                type: actionType
            }, function(res) {
                if (res.success) {
                    layer.msg(res.message, {icon: 1});
                    // 移除请求项
                    requestItem.remove();

                    // 检查是否没有请求了
                    if ($('.request-item').length === 0) {
                        $('#requestList').html('<div class="no-requests">' +
                            '<i class="layui-icon layui-icon-face-smile" style="font-size: 50px;"></i>' +
                            '<div style="margin-top: 15px; font-size: 16px;">暂无请求</div></div>');
                    } else {
                        // 重新过滤
                        filterRequests(currentRequestType);
                    }
                } else {
                    layer.msg(res.message || '操作失败', {icon: 2});
                }
            }, 'json');
        });

        // 初始加载
        refreshRequests();

        // 每30秒自动刷新一次
        setInterval(refreshRequests, 30000);
    });
</script>
</body>
</html>
