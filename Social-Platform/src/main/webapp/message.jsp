<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.qdu.entity.Users" %>
<%@ page import="cn.qdu.entity.FriendRequests" %>
<%@ page import="java.util.List" %>
<%@ page import="cn.qdu.entity.FriendRequests" %>
<%@ page import="cn.qdu.dao.UserDao" %>
<%
    Users currentUser = (Users) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<FriendRequests> friendRequests = (List<FriendRequests>) request.getAttribute("friendRequests");
%>
<html>
<head>
    <title>好友请求 - <%= currentUser.getUname() %></title>
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
    </style>
</head>
<body>
<!-- 顶部导航栏 -->
<div class="layui-header header">
    <div class="layui-container">
        <div class="layui-row">
            <div class="layui-col-md3">
                <div class="logo">社交平台</div>
            </div>
            <div class="layui-col-md6">
                <ul class="layui-nav" lay-filter="">
                    <li class="layui-nav-item"><a href="${pageContext.request.contextPath}/home.jsp">首页</a></li>
                    <li class="layui-nav-item"><a href="${pageContext.request.contextPath}/chat">好友</a></li>
                    <li class="layui-nav-item layui-this"><a href="">消息</a></li>
                    <li class="layui-nav-item"><a href="">群组</a></li>
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
    <h2 class="request-title">好友请求</h2>

    <button class="layui-btn layui-btn-normal refresh-btn" id="refreshBtn">
        <i class="layui-icon layui-icon-refresh"></i> 刷新
    </button>

    <div class="request-list" id="requestList">
        <% if (friendRequests != null && !friendRequests.isEmpty()) { %>
        <% for (FriendRequests requests : friendRequests) { %>
        <div class="request-item" data-request-id="<%= requests.getReqid() %>">
            <% UserDao userDao = new UserDao();
                List<Users> users = userDao.selectById(requests.getReqid());
                Users user = users.get(0);
            %>
            <img src="<%= user.getUimage() != null ? user.getUimage() : "default-avatar.jpg" %>"
                 class="request-avatar" alt="用户头像">
            <div class="request-info">
                <div class="request-name"><%= user.getUname() %></div>
                <div class="request-id">ID: <%= user.getUid() %></div>
                <div class="request-message">验证消息: <%= requests.getMessage() != null ? requests.getMessage() : "无" %></div>
            </div>
            <div class="request-actions">
                <button class="layui-btn layui-btn-sm layui-btn-normal accept-btn" data-id="<%= user.getUid() %>">接受</button>
                <button class="layui-btn layui-btn-sm layui-btn-danger reject-btn" data-id="<%= user.getUid() %>">拒绝</button>
            </div>
        </div>
        <% } %>
        <% } else { %>
        <div class="no-requests">
            <i class="layui-icon layui-icon-face-smile" style="font-size: 50px;"></i>
            <div style="margin-top: 15px; font-size: 16px;">暂无好友请求</div>
        </div>
        <% } %>
    </div>
</div>

<script src="${pageContext.request.contextPath}/layui/layui.js"></script>
<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
<script>
    layui.use(['layer', 'form'], function() {
        var layer = layui.layer;
        var $ = layui.$;

        // 刷新好友请求列表
        function refreshRequests() {
            $.get('${pageContext.request.contextPath}/messages', {
                action: 'refreshRequests'
            }, function(data) {
                $('#requestList').html(data);
            });
        }

        // 点击刷新按钮
        $('#refreshBtn').on('click', function() {
            refreshRequests();
        });

        // 接受好友请求
        $(document).on('click', '.accept-btn', function() {
            var requestId = $(this).closest('.request-item').data('request-id');
            handleRequest(requestId, 'accept');
        });

        // 拒绝好友请求
        $(document).on('click', '.reject-btn', function() {
            var requestId = $(this).closest('.request-item').data('request-id');
            handleRequest(requestId, 'reject');
        });

        // 处理好友请求
        function handleRequest(requestId, action) {
            $.post('${pageContext.request.contextPath}/messages', {
                action: 'handleRequest',
                requestId: requestId,
                type: action
            }, function(res) {
                if (res.success) {
                    layer.msg(action === 'accept' ? '已接受好友请求' : '已拒绝好友请求', {icon: 1});
                    refreshRequests();
                } else {
                    layer.msg(res.message || '操作失败', {icon: 2});
                }
            }, 'json');
        }

        // 初始加载后5秒自动刷新一次
        setTimeout(refreshRequests, 5000);
    });
</script>
</body>
</html>