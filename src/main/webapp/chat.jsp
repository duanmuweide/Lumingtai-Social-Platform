<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.qdu.entity.Users" %>
<%@ page import="cn.qdu.entity.Conversations" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
  Users currentUser = (Users) session.getAttribute("user");
  if (currentUser == null) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
  }

  List<Map<String, Object>> friendList = (List<Map<String, Object>>) request.getAttribute("friendList");
  List<Conversations> messages = (List<Conversations>) request.getAttribute("messages");
  int currentFriendId = request.getAttribute("currentFriendId") != null ?
          (Integer) request.getAttribute("currentFriendId") : 0;
  String currentFriendName = "";

  // 获取当前好友名称
  if (friendList != null) {
    for (Map<String, Object> friend : friendList) {
      if ((Integer)friend.get("friendId") == currentFriendId) {
        currentFriendName = (String)friend.get("friendName");
        break;
      }
    }
  }
%>
<html>
<head>
  <title>聊天室 - <%= currentUser.getUname() %></title>
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
      background-color: #2E2E2E; /* 改为深色背景 */
      height: 60px;
    }

    .logo {
      color: #1E9FFF;
      font-size: 24px;
      font-weight: bold;
      line-height: 60px;
      padding-left: 15px; /* 添加一些内边距 */
    }

    /* 导航菜单项样式调整 */
    .layui-nav {
      background-color: transparent !important; /* 使导航菜单背景透明 */
    }

    .layui-nav-item {
      color: #fff !important; /* 导航项文字颜色改为白色 */
    }

    .layui-nav-item:hover {
      background-color: rgba(255, 255, 255, 0.1) !important; /* 悬停效果 */
    }

    .layui-nav .layui-this {
      background-color: rgba(30, 159, 255, 0.5) !important; /* 当前选中项效果 */
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

    /* 好友列表样式 */
    .friend-list {
      width: 300px;
      background-color: var(--dark-bg);
      color: white;
      display: flex;
      flex-direction: column;
      border-right: 1px solid #3E3E3E;
    }
    .friend-header {
      padding: 15px;
      background-color: #1E1E1E;
      display: flex;
      align-items: center;
      justify-content: space-between;
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
    .friends-container {
      flex: 1;
      overflow-y: auto;
    }
    .friend-item {
      display: flex;
      align-items: center;
      padding: 12px 15px;
      cursor: pointer;
      border-bottom: 1px solid #3E3E3E;
      transition: background-color 0.2s;
    }
    .friend-item:hover {
      background-color: #3E3E3E;
    }
    .friend-item.active {
      background-color: var(--primary-color);
    }
    .friend-avatar {
      width: 45px;
      height: 45px;
      border-radius: 50%;
      margin-right: 12px;
      object-fit: cover;
    }
    .friend-info {
      flex: 1;
      min-width: 0;
    }
    .friend-name {
      font-weight: 500;
      margin-bottom: 3px;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }
    .friend-lastmsg {
      font-size: 12px;
      color: #AAA;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }
    .add-friend-btn {
      color: var(--primary-color);
      cursor: pointer;
      font-size: 14px;
    }
    .add-friend-btn:hover {
      text-decoration: underline;
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
    .no-friends {
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

    .delete-friend-btn {
      color: #FF5722;
      cursor: pointer;
      font-size: 14px;
      margin-left: 15px;
    }

    .delete-friend-btn:hover {
      text-decoration: underline;
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
          <li class="layui-nav-item layui-this"><a href="">好友</a></li>
          <li class="layui-nav-item"><a href="${pageContext.request.contextPath}/messages">消息</a></li>
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

<!-- 聊天主容器 -->
<div class="chat-container">
  <!-- 好友列表 -->
  <div class="friend-list">
    <div class="friend-header">
      <h2 style="margin: 0; font-size: 18px;">微信</h2>
      <div>
    <span class="add-friend-btn" id="addFriendBtn">
      <i class="fas fa-user-plus"></i> 添加好友
    </span>
        <span class="delete-friend-btn" id="deleteFriendBtn">
      <i class="fas fa-user-minus"></i> 删除好友
    </span>
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
        <div class="layui-input-block">
          <input type="text" placeholder="搜索" class="layui-input" style="background-color: #3E3E3E; border: none; color: white;">
        </div>
      </div>
    </div>

    <div class="friends-container" id="friendsContainer">
      <% if (friendList != null && !friendList.isEmpty()) { %>
      <% for (Map<String, Object> friend : friendList) { %>
      <div class="friend-item <%= friend.get("friendId").equals(currentFriendId) ? "active" : "" %>"
           data-friend-id="<%= friend.get("friendId") %>">
        <img src="<%= friend.get("avatar") %>" class="friend-avatar" alt="好友头像">
        <div class="friend-info">
          <div class="friend-name"><%= friend.get("friendName") %></div>
          <div class="friend-lastmsg"><%= friend.get("lastMessage") %></div>
        </div>
      </div>
      <% } %>
      <% } else { %>
      <div class="no-friends">
        <i class="fas fa-user-friends" style="font-size: 50px; margin-bottom: 15px;"></i>
        <div>暂无好友</div>
        <div style="margin-top: 10px; font-size: 13px;">快去添加好友开始聊天吧</div>
      </div>
      <% } %>
    </div>
  </div>

  <!-- 聊天区域 -->
  <div class="chat-area">
    <% if (currentFriendId > 0) { %>
    <div class="chat-header">
      <div class="chat-title"><%= currentFriendName %></div>
    </div>

    <div class="message-display" id="messageDisplay">
      <% if (messages != null && !messages.isEmpty()) { %>
      <div class="time-separator">今天</div>
      <% for (Conversations msg : messages) { %>
      <div class="message <%= msg.getCsenderid() == currentUser.getUid() ? "sent" : "received" %>">
        <% if (msg.getCsenderid() != currentUser.getUid()) { %>
        <img src="<%= getFriendAvatar(friendList, msg.getCsenderid()) %>"
             style="width: 35px; height: 35px; border-radius: 50%; margin-right: 10px; align-self: flex-start;">
        <% } %>
        <div class="message-bubble">
          <%= msg.getCmessage() %>
        </div>
        <div class="message-info">
          <%= msg.getCdate() %>
        </div>
      </div>
      <% } %>
      <% } else { %>
      <div class="no-messages">
        <i class="far fa-comment-dots" style="font-size: 50px; margin-bottom: 15px;"></i>
        <div>暂无聊天记录</div>
        <div style="margin-top: 10px; font-size: 13px;">发送消息开始与<%= currentFriendName %>聊天</div>
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
        <input type="hidden" id="currentFriendId" value="<%= currentFriendId %>">
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
        <i class="far fa-comments" style="font-size: 50px; margin-bottom: 15px;"></i>
        <div style="font-size: 18px; margin-bottom: 10px;">选择好友开始聊天</div>
        <div>从左侧好友列表中选择一位好友开始对话</div>
      </div>
    </div>
    <% } %>
  </div>
</div>

<!-- 添加好友的弹窗表单 -->
<div id="addFriendForm" style="display: none; padding: 20px;">
  <form class="layui-form" id="addFriendFormContent">
    <div class="layui-form-item">
      <label class="layui-form-label">好友ID</label>
      <div class="layui-input-block">
        <input type="text" name="friendId" required lay-verify="required|number" placeholder="请输入要添加的好友ID" autocomplete="off" class="layui-input">
      </div>
    </div>
    <div class="layui-form-item">
      <label class="layui-form-label">验证消息</label>
      <div class="layui-input-block">
        <textarea name="message" placeholder="请输入验证消息(可选)" class="layui-textarea"></textarea>
      </div>
    </div>
    <div class="layui-form-item">
      <div class="layui-input-block">
        <button class="layui-btn" lay-submit lay-filter="submitAddFriend">提交</button>
        <button type="reset" class="layui-btn layui-btn-primary">重置</button>
      </div>
    </div>
  </form>
</div>

<script src="${pageContext.request.contextPath}/layui/layui.js"></script>
<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
<script>
  // 使用jQuery的ready函数确保DOM加载完毕
  $(function() { // 等同于 $(document).ready(function() { ... });
    layui.use(['form', 'layer'], function() {
      var form = layui.form;
      var layer = layui.layer;
      var $ = layui.$; // 确保 $ 符号指向 jQuery

      // 当前选中的好友
      var currentFriendId = $('#currentFriendId').val();

      // 自动滚动到消息底部
      function scrollToBottom() {
        var messageDisplay = $('#messageDisplay')[0];
        if (messageDisplay) { // 确保元素存在
          messageDisplay.scrollTop = messageDisplay.scrollHeight;
        }
      }

      // 初始化滚动到底部
      scrollToBottom();

      refreshMessages();


      // 点击好友切换聊天
      $(document).on('click', '.friend-item', function() {
        var friendId = $(this).data('friend-id');
        if (friendId != currentFriendId) {
          window.location.href = '${pageContext.request.contextPath}/chat?friendId=' + friendId;
        }
      });

      // 删除好友按钮点击事件
      $('#deleteFriendBtn').on('click', function() {
        if (!currentFriendId || currentFriendId <= 0) {
          layer.msg('请先选择要删除的好友', {icon: 2});
          return;
        }

        // 获取当前好友名称
        var currentFriendName = '';
        $('.friend-item').each(function() {
          if ($(this).data('friend-id') == currentFriendId) {
            currentFriendName = $(this).find('.friend-name').text();
            return false; // 退出循环
          }
        });

        // 确认对话框
        layer.confirm('确定要删除好友 "' + currentFriendName + '" 吗？', {
          title: '删除好友',
          btn: ['确定', '取消'],
          icon: 3
        }, function(index) {
          layer.close(index);

          // 发送删除请求
          $.post('${pageContext.request.contextPath}/chat', {
            action: 'deleteFriend',
            friendId: currentFriendId
          }, function(res) {
            if (res.success) {
              layer.msg('好友已删除', {icon: 1});
              // 刷新页面
              window.location.href = '${pageContext.request.contextPath}/chat';
            } else {
              layer.msg(res.message || '删除好友失败', {icon: 2});
            }
          }, 'json');
        });
      });

      // 发送消息
      form.on('submit(sendMessage)', function(data) {
        var message = data.field.message.trim();
        if (message === '') {
          return false;
        }

        $.post('${pageContext.request.contextPath}/chat', {
          action: 'send',
          receiverId: currentFriendId,
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
        if (!currentFriendId || currentFriendId <= 0) return; // 确保有选中好友才刷新消息

        $.post('${pageContext.request.contextPath}/chat', {
          action: 'refresh',
          friendId: currentFriendId
        }, function(res) {
          if (res.success) {
            updateMessageDisplay(res.messages);
            scrollToBottom();
          }
        }, 'json');
      }

      // 更新消息显示
      function updateMessageDisplay(messages) {
        var messageDisplayElement = $('#messageDisplay');
        if (!messageDisplayElement.length) { // 如果消息显示区域不存在，则不执行
          return;
        }

        if (!messages || messages.length === 0) {
          messageDisplayElement.html('<div class="no-messages">' +
                  '<i class="far fa-comment-dots" style="font-size: 50px; margin-bottom: 15px;"></i>' +
                  '<div>暂无聊天记录</div>' +
                  '<div style="margin-top: 10px; font-size: 13px;">发送消息开始与好友聊天</div></div>');
          return;
        }

        var html = '<div class="time-separator">今天</div>';
        var currentUser = <%= currentUser.getUid() %>;

        messages.forEach(function(msg) {
          var isSent = msg.senderId == currentUser;
          html += '<div class="message ' + (isSent ? 'sent' : 'received') + '">';

          if (!isSent) {
            // 这里需要确保 getFriendAvatar 函数在 JS 中可用，或者从后端返回头像URL
            // 简化处理，如果后端没有返回头像，这里会使用默认头像
            html += '<img src="' + (msg.senderAvatar || 'default-avatar.jpg') + '" ' +
                    'style="width: 35px; height: 35px; border-radius: 50%; margin-right: 10px; align-self: flex-start;">';
          }

          html += '<div class="message-bubble">' + msg.message + '</div>' +
                  '<div class="message-info">' + msg.date + '</div>' +
                  '</div>';
        });

        messageDisplayElement.html(html);
      }

      // 获取好友头像（模拟函数，实际应从好友数据中获取）
      // 注意：这个JS函数在JSP的Java代码块中无法直接调用，
      // 如果需要JS获取头像，后端返回的messages数据中应该包含senderAvatar
      // 或者在JS中维护一个好友ID到头像URL的映射
      // 为了兼容性，我修改了 updateMessageDisplay 函数，假设 msg 对象中可能包含 senderAvatar
      // 如果没有，它会回退到 'default-avatar.jpg'
      // function getFriendAvatar(friendId) {
      //   return 'default-avatar.jpg'; // 这是一个JS函数，与JSP声明的Java方法不同
      // }


      // 点击添加好友按钮
      $('#addFriendBtn').on('click', function() {
        layer.open({
          type: 1,
          title: '添加好友',
          area: ['400px', '300px'],
          content: $('#addFriendForm') ,// 确保这个ID指向的是隐藏的表单div
          end: function() {
            // 当弹窗关闭时，将 #addFriendForm 移回 body 并隐藏
            $('#addFriendForm').css('display', 'none').appendTo('body');
          }
        });
      });

      // 提交添加好友表单
      form.on('submit(submitAddFriend)', function(data) {
        var friendId = data.field.friendId;
        var message = data.field.message || '';

        if (!friendId) {
          layer.msg('请输入好友ID', {icon: 2});
          return false;
        }

        $.post('${pageContext.request.contextPath}/chat', {
          action: 'addFriend',
          friendId: friendId,
          message: message
        }, function(res) {
          if (res.success) {
            layer.msg('好友请求已发送', {icon: 1});
            layer.closeAll(); // 关闭所有弹窗
            // 刷新好友列表，这里直接刷新整个页面是最简单的
            window.location.reload();
          } else {
            layer.msg(res.message || '添加好友失败', {icon: 2});
          }
        }, 'json');

        return false;
      });

      // 每3秒刷新一次消息
      // 调整为100毫秒，但请注意频繁刷新可能增加服务器压力
      // 建议在实际应用中使用WebSocket或长轮询
      setInterval(refreshMessages, 3000); // 建议改回3秒或更长，或者使用更高级的实时通信技术

      // 文本框高度自适应
      $('#messageInput').on('input', function() {
        this.style.height = 'auto';
        this.style.height = (this.scrollHeight) + 'px';
      });
    });
  });
</script>
</body>
</html>

<%!
  // JSP声明方法 - 根据好友ID获取头像
  // 这个方法是在服务器端JSP编译时执行的，用于生成HTML
  // 它不能在客户端JavaScript中直接调用
  private String getFriendAvatar(List<Map<String, Object>> friendList, int friendId) {
    if (friendList != null) {
      for (Map<String, Object> friend : friendList) {
        if (friend.get("friendId") instanceof Integer && (Integer)friend.get("friendId") == friendId) {
          return (String)friend.get("avatar");
        }
      }
    }
    return "default-avatar.jpg";
  }
%>