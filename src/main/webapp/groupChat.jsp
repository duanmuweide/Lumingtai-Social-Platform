<%--
  Created by IntelliJ IDEA.
  User: 24437
  Date: 2025/6/18
  Time: 下午2:47
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.qdu.entity.Users" %>
<%@ page import="cn.qdu.entity.Groupsconversations" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="cn.qdu.dao.UserDao" %>
<%@ page import="cn.qdu.dao.Groupspeopledao" %>
<%@ page import="cn.qdu.entity.Groupspeople" %>
<%
    Users currentUser = (Users) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Map<String, Object>> groupList = (List<Map<String, Object>>) request.getAttribute("groupList");
    List<Groupsconversations> messages = (List<Groupsconversations>) request.getAttribute("messages");
    int currentGroupId = request.getAttribute("currentGroupId") != null ?
            (Integer) request.getAttribute("currentGroupId") : 0;
    String currentGroupName = "";

    // 获取当前群组名称
    if (groupList != null) {
        for (Map<String, Object> group : groupList) {
            if ((Integer)group.get("groupId") == currentGroupId) {
                currentGroupName = (String)group.get("groupName");
                break;
            }
        }
    }
%>
<html>
<head>
    <title>群聊 - <%= currentUser.getUname() %></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/layui/css/layui.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        :root {
            --primary-color: #1E9FFF;
            --dark-bg: #2E2E2E;
            --light-bg: #F5F5F5;
            --message-bg: #FFFFFF;
            --my-message-bg: #DCF8C6;
        }
        body {
            margin: 0;
            padding: 0;
            font-family: 'Helvetica Neue', Arial, sans-serif;
            background-color: #F2F2F2;
        }

        /* 导航栏样式 */
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

        /* 导航菜单项样式调整 */
        .layui-nav {
            background-color: transparent !important;
        }

        .layui-nav-item {
            color: #fff !important;
        }

        .layui-nav-item:hover {
            background-color: rgba(255, 255, 255, 0.1) !important;
        }

        .layui-nav .layui-this {
            background-color: rgba(30, 159, 255, 0.5) !important;
        }

        /* 聊天容器 */
        .chat-container {
            display: flex;
            height: calc(100vh - 60px);
            max-width: 1200px;
            margin: 0 auto;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            padding-top: 60px;
        }

        /* 群组列表样式 */
        .group-list {
            width: 300px;
            background-color: var(--dark-bg);
            color: white;
            display: flex;
            flex-direction: column;
            border-right: 1px solid #3E3E3E;
        }
        .group-header {
            padding: 15px;
            background-color: #1E1E1E;
            display: flex;
            align-items: center;
            border-bottom: 1px solid #3E3E3E;
        }
        .user-info {
            display: flex;
            align-items: center;
            padding: 10px 15px;
            background-color: #252525;
            border-bottom: 1px solid #3E3E3E;
        }
        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            margin-right: 10px;
            object-fit: cover;
        }
        .search-box {
            padding: 10px 15px;
            background-color: #252525;
        }
        .groups-container {
            flex: 1;
            overflow-y: auto;
        }
        .group-item {
            display: flex;
            align-items: center;
            padding: 12px 15px;
            cursor: pointer;
            border-bottom: 1px solid #3E3E3E;
            transition: background-color 0.2s;
        }
        .group-item:hover {
            background-color: #3E3E3E;
        }
        .group-item.active {
            background-color: var(--primary-color);
        }
        .group-avatar {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            margin-right: 12px;
            object-fit: cover;
        }
        .group-info {
            flex: 1;
            min-width: 0;
        }
        .group-name {
            font-weight: 500;
            margin-bottom: 3px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .group-lastmsg {
            font-size: 12px;
            color: #AAA;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .group-members {
            font-size: 11px;
            color: #AAA;
        }

        /* 聊天区域样式 */
        .chat-area {
            flex: 1;
            display: flex;
            flex-direction: column;
            background-color: #F5F5F5;
        }
        .chat-header {
            padding: 15px;
            background-color: white;
            border-bottom: 1px solid #E5E5E5;
            display: flex;
            align-items: center;
        }
        .chat-title {
            font-weight: 500;
            font-size: 18px;
        }
        .message-display {
            flex: 1;
            padding: 20px;
            overflow-y: auto;
            background-color: #E5E5E5;
            background-image: url('https://web.wechat.com/bg.jpg');
            background-size: cover;
            background-attachment: fixed;
        }
        .message {
            margin-bottom: 15px;
            display: flex;
            flex-direction: column;
            max-width: 70%;
        }
        .message.sent {
            align-items: flex-end;
            margin-left: auto;
        }
        .message.received {
            align-items: flex-start;
            margin-right: auto;
        }
        .message-bubble {
            padding: 10px 15px;
            border-radius: 18px;
            position: relative;
            word-wrap: break-word;
        }
        .message.sent .message-bubble {
            background-color: var(--my-message-bg);
            border-top-right-radius: 0;
        }
        .message.received .message-bubble {
            background-color: var(--message-bg);
            border-top-left-radius: 0;
        }
        .message-info {
            font-size: 12px;
            color: #999;
            margin: 5px 10px;
        }
        .message-sender {
            font-weight: bold;
            margin-bottom: 3px;
            color: #666;
        }
        .message-input {
            padding: 15px;
            background-color: white;
            border-top: 1px solid #E5E5E5;
        }
        .typing-area {
            display: flex;
            align-items: center;
        }
        .message-toolbar {
            display: flex;
            padding: 5px 0;
        }
        .tool-button {
            margin-right: 10px;
            color: #7D7D7D;
            cursor: pointer;
            font-size: 20px;
        }
        .no-groups {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100%;
            color: #AAA;
            padding: 20px;
            text-align: center;
        }
        .no-messages {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100%;
            color: #999;
        }
        .time-separator {
            text-align: center;
            margin: 20px 0;
            color: #999;
            font-size: 12px;
        }

        /* 新增按钮样式 */
        .group-actions {
            display: flex;
            margin-left: auto;
        }
        .action-button {
            background: none;
            border: none;
            color: #1E9FFF;
            cursor: pointer;
            font-size: 14px;
            padding: 5px 10px;
            margin-left: 10px;
            border-radius: 3px;
            transition: background-color 0.3s;
        }
        .action-button:hover {
            background-color: rgba(30, 159, 255, 0.1);
        }

        /* 头像预览样式 */
        .avatar-preview {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            margin: 0 auto 15px;
            background: #f0f0f0;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            cursor: pointer;
        }
        .avatar-preview img {
            max-width: 100%;
            max-height: 100%;
            display: none;
        }
        .avatar-preview i {
            font-size: 24px;
            color: #999;
        }
        .avatar-text {
            text-align: center;
            color: #666;
            font-size: 13px;
            margin-bottom: 15px;
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
                    <li class="layui-nav-item"><a href="${pageContext.request.contextPath}/messages">消息</a></li>
                    <li class="layui-nav-item layui-this"><a href="${pageContext.request.contextPath}/groupChat">群组</a></li>
                </ul>
            </div>
            <div class="layui-col-md3">
                <ul class="layui-nav" lay-filter="">
                    <li class="layui-nav-item">
                        <a href="javascript:;">
                            <img src="${pageContext.request.contextPath}/<%= currentUser.getUimage() != null ? currentUser.getUimage() : "pictures/default-avatar.jpg" %>"
                                 class="layui-nav-img">
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

<!-- 聊天主容器 -->
<div class="chat-container">
    <!-- 群组列表 -->
    <div class="group-list">
        <div class="group-header">
            <h2 style="margin: 0; font-size: 18px;">我的群组</h2>
            <div class="group-actions">
                <button class="action-button" id="btnCreateGroup">
                    <i class="fas fa-plus-circle"></i> 创建群聊
                </button>
                <button class="action-button" id="btnAddGroup">
                    <i class="fas fa-plus"></i> 添加群聊
                </button>
                <button class="action-button" id="btnDeleteGroup">
                    <i class="fas fa-trash-alt"></i> 删除群聊
                </button>
            </div>
        </div>

        <div class="user-info">
            <img src="<%= currentUser.getUimage() != null ? currentUser.getUimage() : "default-avatar.jpg" %>"
                 class="user-avatar" alt="用户头像">
            <div>
                <div style="font-weight: 500;"><%= currentUser.getUname() %></div>
                <div style="font-size: 12px; color: #AAA;">在线</div>
            </div>
        </div>

        <div class="search-box">
            <div class="layui-form">
            </div>
        </div>

        <div class="groups-container" id="groupsContainer">
            <% if (groupList != null && !groupList.isEmpty()) { %>
            <% for (Map<String, Object> group : groupList) { %>
            <div class="group-item <%= group.get("groupId").equals(currentGroupId) ? "active" : "" %>"
                 data-group-id="<%= group.get("groupId") %>">
                <img src="<%= group.get("avatar") %>" class="group-avatar" alt="群组头像">
                <div class="group-info">
                    <div class="group-name"><%= group.get("groupName") %></div>
                    <div class="group-lastmsg"><%= group.get("lastMessage") %></div>
                    <div class="group-members"><%= group.get("memberCount") %>人</div>
                </div>
            </div>
            <% } %>
            <% } else { %>
            <div class="no-groups">
                <i class="fas fa-users" style="font-size: 50px; margin-bottom: 15px;"></i>
                <div>暂无群组</div>
                <div style="margin-top: 10px; font-size: 13px;">创建或加入群组开始聊天</div>
            </div>
            <% } %>
        </div>
    </div>

    <!-- 聊天区域 -->
    <div class="chat-area">
        <% if (currentGroupId > 0) { %>
        <div class="chat-header">
            <div class="chat-title"><%= currentGroupName %></div>
            <div style="margin-left: auto;">
                <button class="layui-btn layui-btn-primary layui-btn-sm" id="btnGroupInfo">
                    <i class="fas fa-info-circle"></i> 群简介
                </button>
            </div>
        </div>

        <div class="message-display" id="messageDisplay">
            <% if (messages != null && !messages.isEmpty()) { %>
            <div class="time-separator">今天</div>
            <% for (Groupsconversations msg : messages) { %>
            <div class="message <%= msg.getGcuid() == currentUser.getUid() ? "sent" : "received" %>">
                <% if (msg.getGcuid() != currentUser.getUid()) { %>
                <img src="<%= getMemberAvatar(msg.getGcuid()) %>"
                     style="width: 35px; height: 35px; border-radius: 50%; margin-right: 10px; align-self: flex-start;">
                <% } %>
                <div class="message-bubble">
                    <% if (msg.getGcuid() != currentUser.getUid()) { %>
                    <div class="message-sender"><%= getMemberDisplayName(msg.getGcgid(), msg.getGcuid()) %></div>
                    <% } %>
                    <%= msg.getGcmessage() %>
                </div>
                <div class="message-info">
                    <%= msg.getGcdate() %>
                </div>
            </div>
            <% } %>
            <% } else { %>
            <div class="no-messages">
                <i class="far fa-comment-dots" style="font-size: 50px; margin-bottom: 15px;"></i>
                <div>暂无聊天记录</div>
                <div style="margin-top: 10px; font-size: 13px;">发送消息开始与群成员聊天</div>
            </div>
            <% } %>
        </div>

        <div class="message-input">
            <div class="message-toolbar">
                <div class="tool-button"><i class="far fa-smile"></i></div>
                <div class="tool-button"><i class="fas fa-paperclip"></i></div>
                <div class="tool-button"><i class="fas fa-image"></i></div>
            </div>
            <form class="layui-form" id="messageForm">
                <input type="hidden" id="currentGroupId" value="<%= currentGroupId %>">
                <div class="typing-area">
                    <div class="layui-input-block" style="flex: 1; margin-right: 10px;">
                                <textarea name="message" lay-verify="required" placeholder="输入消息..."
                                          class="layui-textarea" style="resize: none; min-height: 40px;" id="messageInput"></textarea>
                    </div>
                    <button class="layui-btn layui-btn-normal" lay-submit lay-filter="sendMessage">发送</button>
                </div>
            </form>
        </div>
        <% } else { %>
        <div style="display: flex; justify-content: center; align-items: center; height: 100%; background-color: white;">
            <div style="text-align: center; color: #999;">
                <i class="fas fa-users" style="font-size: 50px; margin-bottom: 15px;"></i>
                <div style="font-size: 18px; margin-bottom: 10px;">选择群组开始聊天</div>
                <div>从左侧群组列表中选择一个群组开始对话</div>
            </div>
        </div>
        <% } %>
    </div>
</div>

<script src="${pageContext.request.contextPath}/layui/layui.js"></script>
<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
<script>
    layui.use(['form', 'layer', 'upload'], function() {
        var form = layui.form;
        var layer = layui.layer;
        var $ = layui.$;
        var upload = layui.upload;

        // 当前选中的群组
        var currentGroupId = $('#currentGroupId').val();

        // 自动滚动到消息底部
        function scrollToBottom() {
            var messageDisplay = $('#messageDisplay')[0];
            messageDisplay.scrollTop = messageDisplay.scrollHeight;
        }

        // 初始化滚动到底部
        scrollToBottom();

        // 点击群组切换聊天
        $(document).on('click', '.group-item', function() {
            var groupId = $(this).data('group-id');
            if (groupId != currentGroupId) {
                window.location.href = '${pageContext.request.contextPath}/groupChat?groupId=' + groupId;
            }
        });

        // 发送消息
        form.on('submit(sendMessage)', function(data) {
            var message = data.field.message.trim();
            if (message === '') {
                return false;
            }

            $.post('${pageContext.request.contextPath}/groupChat', {
                action: 'send',
                groupId: currentGroupId,
                message: message
            }, function(res) {
                if (res.success) {
                    $('#messageInput').val('');
                    refreshMessages();
                } else {
                    layer.msg('发送失败', {icon: 2});
                }
            }, 'json');

            return false;
        });

        // 刷新消息
        function refreshMessages() {
            if (!currentGroupId) return;

            $.post('${pageContext.request.contextPath}/groupChat', {
                action: 'refresh',
                groupId: currentGroupId
            }, function(res) {
                if (res.success) {
                    updateMessageDisplay(res.messages);
                    scrollToBottom();
                }
            }, 'json');
        }

        // 更新消息显示
        function updateMessageDisplay(messages) {
            if (!messages || messages.length === 0) {
                $('#messageDisplay').html('<div class="no-messages">' +
                    '<i class="far fa-comment-dots" style="font-size: 50px; margin-bottom: 15px;"></i>' +
                    '<div>暂无聊天记录</div>' +
                    '<div style="margin-top: 10px; font-size: 13px;">发送消息开始与群成员聊天</div></div>');
                return;
            }

            var html = '<div class="time-separator">今天</div>';
            var currentUserId = parseInt('<%= currentUser.getUid() %>');

            messages.forEach(function(msg) {
                var isSent = msg.senderId == currentUserId;
                html += '<div class="message ' + (isSent ? 'sent' : 'received') + '">';

                if (!isSent) {
                    html += '<img src="' + getMemberAvatar(msg.senderId) + '" ' +
                        'style="width: 35px; height: 35px; border-radius: 50%; margin-right: 10px; align-self: flex-start;">';
                }

                html += '<div class="message-bubble">';

                if (!isSent) {
                    html += '<div class="message-sender">' + msg.senderName + '</div>';
                }

                html += msg.message + '</div>' +
                    '<div class="message-info">' + msg.date + '</div>' +
                    '</div>';
            });

            $('#messageDisplay').html(html);
        }

        // 获取成员头像
        function getMemberAvatar(userId) {
            // 先检查是否有缓存
            if (window.avatarCache && window.avatarCache[userId]) {
                return window.avatarCache[userId];
            }

            // 默认返回一个占位头像，避免请求未完成时显示空白
            var defaultAvatar = 'pictures/default-avatar.jpg';

            // 发起异步请求获取真实头像
            $.ajax({
                url: '${pageContext.request.contextPath}/groupChat',
                type: 'POST',
                data: {
                    action: 'getAvatar',
                    userId: userId
                },
                async: false, // 同步请求确保立即返回结果（可根据需求调整）
                success: function(res) {
                    if (res.success && res.avatarPath) {
                        // 缓存结果
                        if (!window.avatarCache) window.avatarCache = {};
                        window.avatarCache[userId] = res.avatarPath;
                        defaultAvatar = res.avatarPath;
                    }
                },
                error: function() {
                    console.error('Failed to fetch avatar for user:', userId);
                }
            });

            return defaultAvatar;
        }

        // 创建群聊按钮点击事件
        $('#btnCreateGroup').click(function() {
            // 创建群聊表单HTML
            var formHtml = `
                <div style="padding: 20px;">
                    <div class="avatar-container">
                        <div class="avatar-preview" id="groupAvatarPreview">
                            <i class="fas fa-camera"></i>
                            <img id="previewGroupAvatar" src="#" alt="群头像预览">
                        </div>
                        <div class="avatar-text">点击上传群头像</div>
                        <input type="file" name="groupAvatar" id="groupAvatarInput" style="display: none;">
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">群名称</label>
                        <div class="layui-input-block">
                            <input type="text" id="groupName" placeholder="请输入群名称" class="layui-input" required>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">群描述</label>
                        <div class="layui-input-block">
                            <textarea id="groupDescription" placeholder="请输入群描述（可选）" class="layui-textarea"></textarea>
                        </div>
                    </div>
                </div>
            `;

            // 打开创建群聊的弹出层
            var index = layer.open({
                type: 1,
                title: '创建群聊',
                content: formHtml,
                area: ['500px', '450px'],
                btn: ['创建', '取消'],
                success: function(layero, index) {
                    // 头像预览功能
                    $('#groupAvatarPreview').click(function() {
                        $('#groupAvatarInput').click();
                    });

                    $('#groupAvatarInput').on('change', function(e) {
                        var file = e.target.files[0];
                        if (file) {
                            var reader = new FileReader();
                            reader.onload = function(e) {
                                $('#previewGroupAvatar').attr('src', e.target.result).show();
                                $('#groupAvatarPreview i').hide();
                            }
                            reader.readAsDataURL(file);
                        }
                    });
                },
                yes: function(index, layero) {
                    var groupName = $('#groupName').val().trim();
                    var groupDescription = $('#groupDescription').val().trim();
                    var avatarFile = $('#groupAvatarInput')[0].files[0];

                    if (!groupName) {
                        layer.msg('请输入群名称', {icon: 2});
                        return;
                    }

                    // 创建FormData对象
                    var formData = new FormData();
                    formData.append('action', 'createGroup');
                    formData.append('groupName', groupName);
                    formData.append('groupDescription', groupDescription);

                    if (avatarFile) {
                        formData.append('groupAvatar', avatarFile);
                    }

                    // 显示加载层
                    var loadIndex = layer.load(1, {
                        shade: [0.1, '#fff']
                    });

                    // 发送创建群聊请求
                    $.ajax({
                        url: '${pageContext.request.contextPath}/groupChat',
                        type: 'POST',
                        data: formData,
                        processData: false,
                        contentType: false,
                        success: function(res) {
                            layer.close(loadIndex);
                            if (res.success) {
                                layer.msg('群聊创建成功', {icon: 1}, function() {
                                    layer.close(index);
                                    // 刷新页面
                                    window.location.reload();
                                });
                            } else {
                                layer.msg(res.error || '创建群聊失败', {icon: 2});
                            }
                        },
                        error: function() {
                            layer.close(loadIndex);
                            layer.msg('请求失败，请稍后重试', {icon: 2});
                        },
                        dataType: 'json'
                    });
                }
            });
        });

        // 添加群聊按钮点击事件
        $('#btnAddGroup').click(function() {
            layer.open({
                type: 1,
                title: '加入群组',
                content: `
                    <div style="padding: 20px;">
                        <div class="layui-form-item">
                            <label class="layui-form-label">群组ID</label>
                            <div class="layui-input-block">
                                <input type="number" id="joinGroupId" placeholder="请输入群组ID" class="layui-input" required>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">验证信息</label>
                            <div class="layui-input-block">
                                <textarea id="joinGroupMessage" placeholder="请输入验证信息（可选）" class="layui-textarea"></textarea>
                            </div>
                        </div>
                    </div>
                `,
                btn: ['发送申请', '取消'],
                area: ['500px', '300px'],
                yes: function(index, layero) {
                    var groupId = $('#joinGroupId').val();
                    var message = $('#joinGroupMessage').val();

                    if (!groupId) {
                        layer.msg('请输入群组ID', {icon: 2});
                        return;
                    }

                    $.post('${pageContext.request.contextPath}/groupChat', {
                        action: 'addGroupRequest',
                        groupId: groupId,
                        message: message
                    }, function(res) {
                        if (res.success) {
                            layer.msg('请求已发送', {icon: 1});
                            layer.close(index);
                        } else {
                            layer.msg(res.error || '请求发送失败', {icon: 2});
                        }
                    }, 'json');
                }
            });
        });

        // 删除群聊按钮点击事件
        $('#btnDeleteGroup').click(function() {
            if (!currentGroupId) {
                layer.msg('请先选择一个群组', {icon: 0});
                return;
            }

            layer.confirm('确定要退出该群组吗？', {
                icon: 3,
                title: '提示'
            }, function(index) {
                $.post('${pageContext.request.contextPath}/groupChat', {
                    action: 'deleteGroup',
                    groupId: currentGroupId
                }, function(res) {
                    if (res.success) {
                        layer.msg('已退出群组', {icon: 1});
                        // 刷新页面
                        setTimeout(function() {
                            window.location.reload();
                        }, 1000);
                    } else {
                        layer.msg(res.error || '退出群组失败', {icon: 2});
                    }
                }, 'json');
                layer.close(index);
            });
        });

        // 群简介按钮点击事件
        $('#btnGroupInfo').click(function() {
            if (!currentGroupId) {
                layer.msg('请先选择一个群组', {icon: 0});
                return;
            }

            // 显示加载层
            var loadIndex = layer.load(1, {
                shade: [0.1, '#fff']
            });

            $.post('${pageContext.request.contextPath}/groupChat', {
                action: 'getGroupInfo',
                groupId: currentGroupId
            }, function(res) {
                layer.close(loadIndex);

                if (res.success) {
                    showGroupInfoModal(res.groupInfo, res.members);
                } else {
                    layer.msg(res.error || '获取群组信息失败', {icon: 2});
                }
            }, 'json');
        });

        // 显示群组信息弹窗
        function showGroupInfoModal(groupInfo, members) {
            // 按身份分组：群主(3)、管理员(2)、成员(1)
            var owners = members.filter(function(m) { return m.identity == 3; });
            var admins = members.filter(function(m) { return m.identity == 2; });
            var normalMembers = members.filter(function(m) { return m.identity == 1; });

            // 获取上下文路径
            var contextPath = '${pageContext.request.contextPath}';

            // 构建群主部分
            var ownersHtml = '';
            if (owners.length > 0) {
                ownersHtml += '<div style="margin-bottom: 15px;">';
                ownersHtml += '<h5 style="color: #FF6B6B; margin-bottom: 8px;">群主 (' + owners.length + '人)</h5>';
                owners.forEach(function(member) {
                    ownersHtml += '<div style="display: flex; align-items: center; padding: 8px 0; border-bottom: 1px solid #f0f0f0;">';
                    ownersHtml += '<img src="' + contextPath + '/' + member.avatar + '" ';
                    ownersHtml += 'style="width: 40px; height: 40px; border-radius: 50%; margin-right: 10px; object-fit: cover;">';
                    ownersHtml += '<div>';
                    ownersHtml += '<div style="font-weight: 500;">' + (member.groupNickname || member.username) + '</div>';
                    ownersHtml += '<div style="font-size: 12px; color: #999;">' + member.username + '</div>';
                    ownersHtml += '</div>';
                    ownersHtml += '</div>';
                });
                ownersHtml += '</div>';
            }

            // 构建管理员部分
            var adminsHtml = '';
            if (admins.length > 0) {
                adminsHtml += '<div style="margin-bottom: 15px;">';
                adminsHtml += '<h5 style="color: #4ECDC4; margin-bottom: 8px;">管理员 (' + admins.length + '人)</h5>';
                admins.forEach(function(member) {
                    adminsHtml += '<div style="display: flex; align-items: center; padding: 8px 0; border-bottom: 1px solid #f0f0f0;">';
                    adminsHtml += '<img src="' + contextPath + '/' + member.avatar + '" ';
                    adminsHtml += 'style="width: 40px; height: 40px; border-radius: 50%; margin-right: 10px; object-fit: cover;">';
                    adminsHtml += '<div>';
                    adminsHtml += '<div style="font-weight: 500;">' + (member.groupNickname || member.username) + '</div>';
                    adminsHtml += '<div style="font-size: 12px; color: #999;">' + member.username + '</div>';
                    adminsHtml += '</div>';
                    adminsHtml += '</div>';
                });
                adminsHtml += '</div>';
            }

            // 构建普通成员部分
            var normalMembersHtml = '';
            if (normalMembers.length > 0) {
                normalMembersHtml += '<div style="margin-bottom: 15px;">';
                normalMembersHtml += '<h5 style="color: #666; margin-bottom: 8px;">群成员 (' + normalMembers.length + '人)</h5>';
                normalMembers.forEach(function(member) {
                    normalMembersHtml += '<div style="display: flex; align-items: center; padding: 8px 0; border-bottom: 1px solid #f0f0f0;">';
                    normalMembersHtml += '<img src="' + contextPath + '/' + member.avatar + '" ';
                    normalMembersHtml += 'style="width: 40px; height: 40px; border-radius: 50%; margin-right: 10px; object-fit: cover;">';
                    normalMembersHtml += '<div>';
                    normalMembersHtml += '<div style="font-weight: 500;">' + (member.groupNickname || member.username) + '</div>';
                    normalMembersHtml += '<div style="font-size: 12px; color: #999;">' + member.username + '</div>';
                    normalMembersHtml += '</div>';
                    normalMembersHtml += '</div>';
                });
                normalMembersHtml += '</div>';
            }

            var content = '<div style="padding: 20px;">' +
                '<div style="text-align: center; margin-bottom: 20px;">' +
                '<img src="' + contextPath + '/' + groupInfo.groupAvatar + '" ' +
                'style="width: 80px; height: 80px; border-radius: 50%; object-fit: cover;">' +
                '<h3 style="margin: 10px 0 5px 0;">' + groupInfo.groupName + '</h3>' +
                '<p style="color: #999; margin: 0;">群号：' + groupInfo.groupId + '</p>' +
                '</div>' +
                '<div style="margin-bottom: 20px;">' +
                '<h4 style="margin-bottom: 10px;">群简介</h4>' +
                '<p style="color: #666; line-height: 1.5;">' + (groupInfo.groupDescription || '暂无群简介') + '</p>' +
                '</div>' +
                '<div style="margin-bottom: 20px;">' +
                '<p style="color: #999; margin-bottom: 10px;">' +
                '创建时间：' + groupInfo.createDate + ' | 成员数：' + groupInfo.memberCount + '人' +
                '</p>' +
                '</div>' +
                '<div>' +
                '<h4 style="margin-bottom: 15px;">群成员 (' + members.length + '人)</h4>' +
                ownersHtml +
                adminsHtml +
                normalMembersHtml +
                '</div>' +
                '</div>';

            layer.open({
                type: 1,
                title: '群组信息',
                content: content,
                area: ['600px', '500px'],
                btn: ['关闭'],
                yes: function(index) {
                    layer.close(index);
                }
            });
        }

        // 立即执行第一次刷新
        if (currentGroupId) {
            refreshMessages();
        }

        // 设置3秒间隔的常规刷新
        setInterval(function() {
            if (currentGroupId) {
                refreshMessages();
            }
        }, 3000);

        // 文本框高度自适应
        $('#messageInput').on('input', function() {
            this.style.height = 'auto';
            this.style.height = (this.scrollHeight) + 'px';
        });
    });
</script>
</body>
</html>

<%!
    // JSP声明方法 - 根据用户ID获取头像
    private String getMemberAvatar(int userId) {
        try {
            UserDao userDao = new UserDao();
            List<Users> users = userDao.selectById(userId);
            if (users != null && !users.isEmpty()) {
                Users user = users.get(0);
                // 如果用户有头像则返回头像路径，否则返回默认头像
                return user.getUimage() != null && !user.getUimage().isEmpty() ?
                        user.getUimage() : "pictures/default-avatar.jpg";
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "pictures/default-avatar.jpg";
    }

    // JSP声明方法 - 获取成员显示名称（优先使用群昵称gpname，如果没有则使用用户名uname）
    private String getMemberDisplayName(int groupId, int userId) {
        try {
            // 获取群成员信息
            Groupspeopledao groupsPeopleDao = new Groupspeopledao();
            Groupspeople member = groupsPeopleDao.select(groupId, userId);

            if (member != null && member.getGpname() != null && !member.getGpname().trim().isEmpty()) {
                return member.getGpname(); // 返回群昵称
            }

            // 如果没有群昵称，获取用户信息
            UserDao userDao = new UserDao();
            List<Users> users = userDao.selectById(userId);
            if (users != null && !users.isEmpty()) {
                return users.get(0).getUname(); // 返回用户名
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "用户" + userId; // 默认返回
    }
%>