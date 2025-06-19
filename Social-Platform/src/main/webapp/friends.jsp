<%--
  Created by IntelliJ IDEA.
  User: czm
  Date: 2025/6/16
  Time: 下午4:21
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
  <title>鹿鸣台 - 好友列表</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/layui/css/layui.css">
  <style>
    .main-content {
      padding: 15px;
      margin-top: 60px;
    }
    .friend-item {
      padding: 10px;
      border-bottom: 1px solid #f2f2f2;
      display: flex;
      align-items: center;
      justify-content: space-between;
      cursor: pointer;
      transition: background-color 0.2s;
    }
    .friend-item:hover {
      background-color: #f8f9fa;
    }
    .friend-item.active {
      background-color: #e9ecef;
    }
    .friend-avatar {
      width: 40px;
      height: 40px;
      border-radius: 50%;
      margin-right: 10px;
    }
    .chat-window {
      display: none;
      border: 1px solid #f2f2f2;
      padding: 10px;
      height: 400px;
      overflow-y: auto;
      background-color: #f8f9fa;
    }
    .chat-footer {
      display: flex;
      margin-top: 10px;
    }
    .chat-footer input {
      flex: 1;
      margin-right: 10px;
    }
    .message-item {
      margin-bottom: 15px;
      display: flex;
      align-items: flex-end;
    }
    .message-item.me {
      justify-content: flex-end;
    }
    .message-item.other {
      justify-content: flex-start;
    }
    .message-avatar {
      width: 30px;
      height: 30px;
      border-radius: 50%;
      margin: 0 8px;
    }
    .message-content {
      display: inline-block;
      padding: 8px 12px;
      border-radius: 20px;
      max-width: 70%;
      word-wrap: break-word;
    }
    .message-item.me .message-content {
      background-color: #007bff;
      color: white;
    }
    .message-item.other .message-content {
      background-color: white;
      border: 1px solid #e9ecef;
    }
    .message-time {
      font-size: 12px;
      color: #6c757d;
      margin-top: 3px;
      display: block;
    }
  </style>
</head>
<body class="layui-layout-body">
<div class="layui-layout layui-layout-admin">
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
            <li class="layui-nav-item layui-this"><a href="">好友</a></li>
            <li class="layui-nav-item"><a href="${pageContext.request.contextPath}/message_requests.jsp">消息</a></li>
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
      <div class="layui-col-md4">
        <div class="layui-card">
          <div class="layui-card-header">
            <i class="layui-icon layui-icon-group"></i> 好友列表
            <button class="layui-btn layui-btn-sm layui-btn-normal" id="addFriendBtn" style="float: right;">添加好友</button>
          </div>
          <div class="layui-card-body" id="friendList">
            <!-- 好友列表将通过JavaScript动态加载 -->
          </div>
        </div>
      </div>
      <div class="layui-col-md8">
        <div class="layui-card">
          <div class="layui-card-header" id="chatTitle">聊天窗口</div>
          <div class="layui-card-body chat-window" id="chatWindow">
            <!-- 聊天记录将通过JavaScript动态加载 -->
          </div>
          <div class="layui-card-footer chat-footer">
            <input type="text" id="messageInput" placeholder="输入消息..." class="layui-input" style="width: 80%">
            <button class="layui-btn" id="sendMessageBtn">发送</button>
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
    var currentFriendId = null;
    var currentFriendName = '';
    var chatInterval = null;
    var userId = ${currentUser.id != null ? currentUser.id : 0};

    console.log('当前用户ID:', userId); // 添加日志

    // 初始化页面
    function initPage() {
      loadFriends();
      bindEvents();
    }

    // 转义HTML字符
    function escapeHTML(str) {
      if (!str) return '';
      return str
              .replace(/&/g, '&amp;')
              .replace(/</g, '&lt;')
              .replace(/>/g, '&gt;')
              .replace(/"/g, '&quot;')
              .replace(/'/g, '&#039;');
    }

    // 加载好友列表
    function loadFriends() {
      console.log('加载好友列表...'); // 添加日志
      $.get('${pageContext.request.contextPath}/friends', function(res){
        console.log('好友列表响应:', res); // 添加日志
        if(res.success){
          renderFriendList(res.data);
        } else {
          layer.msg('加载好友列表失败', {icon: 2});
        }
      }).fail(function(){
        layer.msg('网络错误，请稍后重试', {icon: 2});
      });
    }

    // 渲染好友列表
    function renderFriendList(friends) {
      console.log('渲染好友列表，数据:', friends); // 添加日志
      var html = '';
      friends.forEach(function(friend){
        // 确保friend.name和friend.id存在
        var name = friend.name || '未知好友';
        var id = friend.id || 0;

        html += `
          <div class="friend-item" data-id="${id}" data-name="${name}">
            <img src="${friend.image || 'static/images/default-avatar.png'}" class="friend-avatar">
            <span>${name}</span>
          </div>
        `;
      });
      $('#friendList').html(html);
    }

    // 开始聊天
    function startChat(friendId) {
      console.log('开始聊天，friendId:', friendId); // 添加日志
      var $friendItem = $('.friend-item[data-id="' + friendId + '"]');

      if(!$friendItem.length) {
        console.error('未找到好友项，ID:', friendId);
        layer.msg('好友ID不存在', {icon: 2});
        return;
      }

      currentFriendId = friendId;
      currentFriendName = $friendItem.data('name');
      console.log('当前好友名称:', currentFriendName); // 添加日志

      $('#chatTitle').text('与 ' + currentFriendName + ' 的聊天');

      // 标记当前选中的好友
      $('.friend-item').removeClass('active');
      $friendItem.addClass('active');

      loadChat(friendId);
      $('#chatWindow').show();

      // 启动消息轮询
      startMessagePolling();
    }

    // 加载聊天记录
    function loadChat(friendId) {
      console.log('加载聊天记录，friendId:', friendId); // 添加日志
      $.get('${pageContext.request.contextPath}/chat?friendId=' + friendId, function(res){
        console.log('聊天记录响应:', res); // 添加日志
        if(res.success){
          renderChatMessages(res.data);
        } else {
          layer.msg(res.error || '加载聊天记录失败', {icon: 2});
        }
      }).fail(function(){
        console.error('加载聊天记录失败，网络错误'); // 添加日志
        // 静默处理网络错误
      });
    }

    // 渲染聊天消息
    function renderChatMessages(messages) {
      var html = '';
      messages.forEach(function(msg){
        var isMe = msg.senderId === userId;
        var avatar = isMe
                ? '${currentUser.uimage || "static/images/default-avatar.png"}'
                : (msg.image || 'static/images/default-avatar.png');
        var time = formatTime(msg.sendTime);
        var content = escapeHTML(msg.content);

        html += `
          <div class="message-item ${isMe ? 'me' : 'other'}">
            <img src="${avatar}" class="message-avatar">
            <div class="message-content">${content}</div>
            <div class="message-time">${time}</div>
          </div>
        `;
      });

      $('#chatWindow').html(html);
      scrollToBottom();
    }

    // 发送消息
    function sendMessage() {
      var message = $('#messageInput').val().trim();
      if(!message) {
        layer.msg('消息不能为空', {icon: 2});
        return;
      }

      console.log('发送消息，friendId:', currentFriendId, '内容:', message); // 添加日志

      $.post('${pageContext.request.contextPath}/sendMessage',
              {friendId: currentFriendId, content: message},
              function(res){
                console.log('发送消息响应:', res); // 添加日志
                if(res.success){
                  $('#messageInput').val('');
                  loadChat(currentFriendId); // 发送后刷新聊天记录
                } else {
                  layer.msg(res.error || '发送失败', {icon: 2});
                }
              }).fail(function(){
        layer.msg('网络错误，请稍后重试', {icon: 2});
      });
    }

    // 开始消息轮询
    function startMessagePolling() {
      if(chatInterval) clearInterval(chatInterval);

      chatInterval = setInterval(function(){
        if(currentFriendId) {
          console.log('轮询消息，friendId:', currentFriendId); // 添加日志
          loadChat(currentFriendId);
        }
      }, 3000); // 每3秒刷新一次
    }

    // 停止消息轮询
    function stopMessagePolling() {
      if(chatInterval) {
        clearInterval(chatInterval);
        chatInterval = null;
      }
    }

    // 绑定事件
    function bindEvents() {
      console.log('开始绑定事件');
      // 好友列表点击事件
      $('#friendList').on('click', '.friend-item', function(){
        var friendId = $(this).data('id');
        console.log('好友项被点击，friendId:', friendId); // 添加日志
        startChat(friendId);
      });

      // 发送消息按钮点击事件
      $('#sendMessageBtn').on('click', sendMessage);

      // 输入框按Enter发送消息
      $('#messageInput').on('keypress', function(e){
        if(e.which === 13) sendMessage();
      });

      // 添加好友按钮点击事件
      $('#addFriendBtn').on('click', function(){
        layer.prompt({title: '请输入好友ID'}, function(value, index){
          console.log('添加好友，ID:', value); // 添加日志
          $.post('${pageContext.request.contextPath}/addFriend', {friendId: value}, function(res){
            console.log('添加好友响应:', res); // 添加日志
            if(res.success){
              layer.msg('添加好友成功', {icon: 1});
              loadFriends(); // 重新加载好友列表
            } else {
              layer.msg(res.error || '添加好友失败', {icon: 2});
            }
          }).fail(function(){
            layer.msg('网络错误，请稍后重试', {icon: 2});
          });
          layer.close(index);
        });
      });

      // 页面卸载时停止轮询
      $(window).on('beforeunload', stopMessagePolling);
    }

    // 滚动到底部
    function scrollToBottom() {
      var chatWindow = $('#chatWindow');
      chatWindow.scrollTop(chatWindow[0].scrollHeight);
    }

    // 格式化时间
    function formatTime(timestamp) {
      if(!timestamp) return '';

      var date = new Date(timestamp);
      var h = date.getHours();
      var m = date.getMinutes();
      return (h < 10 ? '0' + h : h) + ':' + (m < 10 ? '0' + m : m);
    }

    // 初始化页面
    initPage();
  });
</script>
</body>
</html>