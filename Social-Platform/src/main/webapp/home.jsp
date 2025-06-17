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
    <title>鹿鸣台 - 主页</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/layui/css/layui.css">
    <style>
        .header {
            border-bottom: 1px solid #f2f2f2;
            background-color: #fff;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1000;
        }
        .logo {
            color: #1E9FFF;
            font-size: 24px;
            font-weight: bold;
            line-height: 60px;
        }
        .main-content {
            padding: 15px;
            margin-top: 60px;
        }
        .user-card {
            text-align: center;
            padding: 20px;
        }
        .user-avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            margin-bottom: 10px;
            object-fit: cover;
        }
        .post-box {
            margin-bottom: 15px;
        }
        .friend-item {
            padding: 10px;
            border-bottom: 1px solid #f2f2f2;
            display: flex;
            align-items: center;
        }
        .friend-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            margin-right: 10px;
            object-fit: cover;
        }
        .post-item {
            margin-bottom: 20px;
            padding: 15px;
            background: #fff;
            border-radius: 4px;
            box-shadow: 0 1px 2px 0 rgba(0,0,0,.05);
        }
        .post-header {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
        }
        .post-content {
            margin: 10px 0;
            line-height: 1.6;
        }
        .post-actions {
            margin-top: 10px;
            padding-top: 10px;
            border-top: 1px solid #f2f2f2;
        }
        .post-image {
            max-width: 100%;
            border-radius: 4px;
            margin: 10px 0;
        }
        .notification-badge {
            position: absolute;
            top: -5px;
            right: -5px;
            background: #FF5722;
            color: #fff;
            border-radius: 50%;
            padding: 2px 6px;
            font-size: 12px;
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
                        <li class="layui-nav-item layui-this"><a href="">首页</a></li>
                        <li class="layui-nav-item"><a href="${pageContext.request.contextPath}/friends.jsp">好友</a></li>
                        <li class="layui-nav-item">
                            <a href="javascript:;">消息<span class="layui-badge notification-badge">5</span></a>
                            <dl class="layui-nav-child">
                                <dd><a href="javascript:;">评论 <span class="layui-badge">3</span></a></dd>
                                <dd><a href="javascript:;">私信 <span class="layui-badge">2</span></a></dd>
                            </dl>
                        </li>
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
            <!-- 左侧个人信息 -->
            <div class="layui-col-md3">
                <div class="layui-card">
                    <div class="layui-card-body user-card">
                        <img src="${currentUser.uimage != null ? currentUser.uimage : 'static/images/default-avatar.png'}" class="user-avatar">
                        <h3>${currentUser.uname}</h3>
                        <p class="layui-text">${currentUser.usign}</p>
                        <div class="layui-btn-group">
                            <button class="layui-btn layui-btn-primary">关注 <span class="layui-badge layui-bg-gray">58</span></button>
                            <button class="layui-btn layui-btn-primary">粉丝 <span class="layui-badge layui-bg-gray">128</span></button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 中间动态发布区 -->
            <div class="layui-col-md6">
                <div class="layui-card">
                    <div class="layui-card-body">
                        <div class="post-box">
                            <textarea id="postContent" placeholder="分享新鲜事..." class="layui-textarea"></textarea>
                            <div style="margin-top: 10px;">
                                <button class="layui-btn layui-btn-primary" id="uploadImage">
                                    <i class="layui-icon layui-icon-picture"></i> 图片
                                </button>
                                <input type="file" id="imageInput" style="display: none;" accept="image/*">
                                <button class="layui-btn" id="publishPost" style="float: right;">发布</button>
                            </div>
                            <div id="imagePreview" style="margin-top: 10px; display: none;">
                                <img src="" alt="预览图" style="max-width: 200px; max-height: 200px;">
                                <button type="button" class="layui-btn layui-btn-danger layui-btn-xs" id="removeImage">
                                    <i class="layui-icon layui-icon-close"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 动态列表 -->
                <div class="layui-card" style="margin-top: 15px;">
                    <div class="layui-card-header">
                        <i class="layui-icon layui-icon-notice"></i> 最新动态
                    </div>
                    <div class="layui-card-body" id="postList">
                        <!-- 动态内容将通过JavaScript动态加载 -->
                    </div>
                </div>
            </div>

            <!-- 右侧好友列表 -->
            <div class="layui-col-md3">
                <div class="layui-card">
                    <div class="layui-card-header">
                        <i class="layui-icon layui-icon-group"></i> 好友列表
                    </div>
                    <div class="layui-card-body" id="friendList">
                        <!-- 好友列表将通过JavaScript动态加载 -->
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/layui/layui.js"></script>
<script>
    layui.use(['element', 'layer', 'form', 'upload'], function(){
        var element = layui.element;
        var layer = layui.layer;
        var form = layui.form;
        var upload = layui.upload;
        var $ = layui.jquery;

        // 显示欢迎消息
        layer.msg('欢迎回来！', {icon: 1});

        // 初始化导航栏
        element.render('nav');

        // 图片上传预览
        $('#uploadImage').on('click', function(){
            $('#imageInput').click();
        });

        $('#imageInput').on('change', function(e){
            var file = e.target.files[0];
            if(file){
                var reader = new FileReader();
                reader.onload = function(e){
                    $('#imagePreview img').attr('src', e.target.result);
                    $('#imagePreview').show();
                }
                reader.readAsDataURL(file);
            }
        });

        $('#removeImage').on('click', function(){
            $('#imageInput').val('');
            $('#imagePreview').hide();
        });

        // 发布动态
        $('#publishPost').on('click', function(){
            var content = $('#postContent').val();
            var imageFile = $('#imageInput')[0].files[0];

            if(!content.trim() && !imageFile) {
                layer.msg('请输入内容或上传图片', {icon: 2});
                return;
            }

            var formData = new FormData();
            formData.append('content', content);
            if(imageFile) {
                formData.append('image', imageFile);
            }

            $.ajax({
                url: '${pageContext.request.contextPath}/post',
                type: 'POST',
                data: formData,
                processData: false,
                contentType: false,
                success: function(res){
                    if(res.success){
                        layer.msg('发布成功', {icon: 1});
                        $('#postContent').val('');
                        $('#imageInput').val('');
                        $('#imagePreview').hide();
                        loadPosts(); // 重新加载动态列表
                    } else {
                        layer.msg(res.error || '发布失败', {icon: 2});
                    }
                }
            });
        });

        // 加载动态列表
        function loadPosts() {
            $.get('${pageContext.request.contextPath}/posts', function(res){
                if(res.success){
                    var html = '';
                    res.data.forEach(function(post){
                        var imageHtml = post.image ? '&lt;img src="' + post.image + '" class="post-image"&gt;' : '';
                        html += `
                &lt;div class="post-item"&gt;
                    &lt;div class="post-header"&gt;
                        &lt;img src="${post.userImage || 'static/images/default-avatar.png'}" class="layui-nav-img"&gt;
                        &lt;span&gt;${post.userName}&lt;/span&gt;
                        &lt;span class="layui-badge-rim"&gt;${post.time}&lt;/span&gt;
                    &lt;/div&gt;
                    &lt;div class="post-content"&gt;${post.content}&lt;/div&gt;
                    ${imageHtml}
                    &lt;div class="post-actions"&gt;
                        &lt;button class="layui-btn layui-btn-primary layui-btn-sm"&gt;
                            &lt;i class="layui-icon layui-icon-praise"&gt;&lt;/i&gt; 点赞
                        &lt;/button&gt;
                        &lt;button class="layui-btn layui-btn-primary layui-btn-sm"&gt;
                            &lt;i class="layui-icon layui-icon-reply-fill"&gt;&lt;/i&gt; 评论
                        &lt;/button&gt;
                        &lt;button class="layui-btn layui-btn-primary layui-btn-sm"&gt;
                            &lt;i class="layui-icon layui-icon-share"&gt;&lt;/i&gt; 分享
                        &lt;/button&gt;
                    &lt;/div&gt;
                &lt;/div&gt;
                `;
                    });
                    $('#postList').html(html);
                }
            });
        }

        // 加载好友列表
        function loadFriends() {
            $.get('${pageContext.request.contextPath}/friends', function(res){
                if(res.success){
                    var html = '';
                    res.data.forEach(function(friend){
                        html += `
                        <div class="friend-item">
                            <img src="${friend.image || 'static/images/default-avatar.png'}" class="friend-avatar">
                            <span>${friend.name}</span>
                            <span class="layui-badge-dot ${friend.online ? 'layui-bg-green' : 'layui-bg-gray'}" style="margin-left: 5px;"></span>
                        </div>
                    `;
                    });
                    $('#friendList').html(html);
                }
            });
        }

        // 初始加载
        loadPosts();
        loadFriends();

        // 定时刷新
        setInterval(function(){
            loadPosts();
            loadFriends();
        }, 30000); // 每30秒刷新一次
    });
</script>
</body>
</html>