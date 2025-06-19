<%--
  Created by IntelliJ IDEA.
  User: yinxi
  Date: 2025/6/17
  Time: 下午8:30
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.qdu.entity.Users" %>
<%
    Users currentUser = (Users)session.getAttribute("user");
    if(currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>鹿鸣台 - 消息中心</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/layui/css/layui.css">
    <style>
        .main-content {
            padding: 15px;
            margin-top: 60px;
        }
        .request-item {
            padding: 12px 15px;
            border-bottom: 1px solid #f2f2f2;
            display: flex;
            align-items: center;
            justify-content: space-between;
            transition: background-color 0.2s;
        }
        .request-item:hover {
            background-color: #f8f9fa;
        }
        .request-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            margin-right: 10px;
        }
        .request-info {
            flex: 1;
        }
        .request-name {
            font-weight: bold;
            display: block;
            margin-bottom: 3px;
        }
        .request-id {
            font-size: 14px;
            color: #6c757d;
        }
        .action-buttons {
            display: flex;
            gap: 8px;
        }
        .layui-card {
            margin-bottom: 15px;
        }
        .no-request {
            padding: 30px 0;
            text-align: center;
            color: #999;
            font-size: 16px;
        }
        .no-request i {
            display: block;
            font-size: 40px;
            margin-bottom: 10px;
            color: #ddd;
        }
    </style>
</head>
<body class="layui-layout-body">
<div class="layui-layout layui-layout-admin">
    <!-- 顶部导航栏 - 与好友页面一致 -->
    <div class="layui-header header">
        <div class="layui-container">
            <div class="layui-row">
                <div class="layui-col-md3">
                    <div class="logo">鹿鸣台</div>
                </div>
                <div class="layui-col-md6">
                    <ul class="layui-nav" lay-filter="">
                        <li class="layui-nav-item"><a href="${pageContext.request.contextPath}/home.jsp">首页</a></li>
                        <li class="layui-nav-item"><a href="${pageContext.request.contextPath}/friends.jsp">好友</a></li>
                        <li class="layui-nav-item layui-this"><a href="">消息</a></li>
                        <li class="layui-nav-item"><a href="">群组</a></li>
                    </ul>
                </div>
                <div class="layui-col-md3">
                    <ul class="layui-nav" lay-filter="">
                        <li class="layui-nav-item">
                            <a href="javascript:;">
                                <img src="${currentUser.uimage != null ? currentUser.uimage : 'static/images/default-avatar.png'}" class="layui-nav-img">${currentUser.uname}
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

    <!-- 主要内容区域 -->
    <div class="layui-container main-content">
        <div class="layui-row layui-col-space15">
            <div class="layui-col-md12">
                <div class="layui-card">
                    <div class="layui-card-header">
                        <i class="layui-icon layui-icon-chat"></i> 好友请求
                        <span class="layui-badge" id="requestCount">0</span>
                    </div>
                    <div class="layui-card-body" id="requestList">
                        <!-- 好友请求将通过JavaScript动态加载 -->
                        <div class="no-request" id="noRequests">
                            <i class="layui-icon layui-icon-note"></i>
                            暂无好友请求
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/layui/layui.js"></script>
<script>
    layui.use(['jquery', 'layer'], function(){
        var $ = layui.jquery;
        var layer = layui.layer;
        var userId = ${currentUser.id != null ? currentUser.id : 0};
        var requestPollingInterval = null;

        console.log('当前用户ID:', userId); // 添加日志

        // 初始化页面
        function initPage() {
            loadFriendRequests();
            bindEvents();
            startRequestPolling();
        }

        // 加载好友请求
        function loadFriendRequests() {
            console.log('加载好友请求...'); // 添加日志
            $.get('${pageContext.request.contextPath}/friendRequests', function(res){
                console.log('好友请求响应:', res); // 添加日志
                if(res.success){
                    renderRequestList(res.data);
                    updateRequestCount(res.data.length);
                } else {
                    layer.msg(res.error || '加载好友请求失败', {icon: 2});
                }
            }).fail(function(){
                layer.msg('网络错误，请稍后重试', {icon: 2});
            });
        }

        // 渲染好友请求列表
        function renderRequestList(requests) {
            console.log('渲染好友请求列表，数据:', requests); // 添加日志
            var requestList = $('#requestList');
            var noRequests = $('#noRequests');

            if(requests.length > 0) {
                var html = '';
                requests.forEach(function(request){
                    // 确保request中有必要的字段
                    var senderName = request.senderName || '未知用户';
                    var senderId = request.senderId || 0;

                    html += `
            <div class="request-item" data-sender-id="${senderId}">
              <img src="${request.senderImage || 'static/images/default-avatar.png'}" class="request-avatar">
              <div class="request-info">
                <div class="request-name">${senderName}</div>
                <div class="request-id">用户ID: ${senderId}</div>
              </div>
              <div class="action-buttons">
                <button class="layui-btn layui-btn-xs layui-btn-normal agree-btn" data-sender-id="${senderId}">同意</button>
                <button class="layui-btn layui-btn-xs layui-btn-danger reject-btn" data-sender-id="${senderId}">拒绝</button>
              </div>
            </div>
          `;
                });
                requestList.html(html);
                noRequests.hide();
            } else {
                requestList.html('');
                noRequests.show();
            }
        }

        // 更新请求计数
        function updateRequestCount(count) {
            $('#requestCount').text(count);
            // 如果有新请求，添加闪烁效果
            if(count > 0) {
                $('#requestCount').addClass('layui-badge-dot');
                setTimeout(function(){
                    $('#requestCount').removeClass('layui-badge-dot');
                }, 1000);
            } else {
                $('#requestCount').removeClass('layui-badge-dot');
            }
        }

        // 同意好友请求
        function agreeRequest(senderId) {
            console.log('同意好友请求，senderId:', senderId); // 添加日志
            layer.confirm('确定要同意 ' + getSenderNameByElement(senderId) + ' 的好友请求吗？', {
                icon: 3,
                title: '确认添加好友'
            }, function(index){
                $.post('${pageContext.request.contextPath}/agreeFriendRequest',
                    {senderId: senderId},
                    function(res){
                        console.log('同意好友请求响应:', res); // 添加日志
                        if(res.success){
                            layer.msg('已同意好友请求', {icon: 1});
                            loadFriendRequests(); // 重新加载请求列表
                            // 刷新好友列表
                            if(window.opener && window.opener.loadFriends) {
                                window.opener.loadFriends();
                            }
                        } else {
                            layer.msg(res.error || '同意好友请求失败', {icon: 2});
                        }
                    }).fail(function(){
                    layer.msg('网络错误，请稍后重试', {icon: 2});
                });
                layer.close(index);
            });
        }

        // 拒绝好友请求
        function rejectRequest(senderId) {
            console.log('拒绝好友请求，senderId:', senderId); // 添加日志
            layer.confirm('确定要拒绝 ' + getSenderNameByElement(senderId) + ' 的好友请求吗？', {
                icon: 3,
                title: '确认拒绝'
            }, function(index){
                $.post('${pageContext.request.contextPath}/rejectFriendRequest',
                    {senderId: senderId},
                    function(res){
                        console.log('拒绝好友请求响应:', res); // 添加日志
                        if(res.success){
                            layer.msg('已拒绝好友请求', {icon: 1});
                            loadFriendRequests(); // 重新加载请求列表
                        } else {
                            layer.msg(res.error || '拒绝好友请求失败', {icon: 2});
                        }
                    }).fail(function(){
                    layer.msg('网络错误，请稍后重试', {icon: 2});
                });
                layer.close(index);
            });
        }

        // 通过senderId获取发送者名称
        function getSenderNameByElement(senderId) {
            var $requestItem = $('.request-item[data-sender-id="' + senderId + '"]');
            return $requestItem.find('.request-name').text() || '用户';
        }

        // 开始请求轮询
        function startRequestPolling() {
            if(requestPollingInterval) clearInterval(requestPollingInterval);

            requestPollingInterval = setInterval(function(){
                loadFriendRequests(); // 定期刷新请求列表
            }, 5000); // 每5秒刷新一次
        }

        // 停止请求轮询
        function stopRequestPolling() {
            if(requestPollingInterval) {
                clearInterval(requestPollingInterval);
                requestPollingInterval = null;
            }
        }

        // 绑定事件
        function bindEvents() {
            console.log('开始绑定事件');
            // 同意按钮点击事件
            $('#requestList').on('click', '.agree-btn', function(){
                var senderId = $(this).data('sender-id');
                console.log('同意按钮被点击，senderId:', senderId); // 添加日志
                agreeRequest(senderId);
            });

            // 拒绝按钮点击事件
            $('#requestList').on('click', '.reject-btn', function(){
                var senderId = $(this).data('sender-id');
                console.log('拒绝按钮被点击，senderId:', senderId); // 添加日志
                rejectRequest(senderId);
            });

            // 页面卸载时停止轮询
            $(window).on('beforeunload', stopRequestPolling);
        }

        // 初始化页面
        initPage();
    });
</script>
</body>
</html>