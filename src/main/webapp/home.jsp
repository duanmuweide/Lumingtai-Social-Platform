<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.qdu.entity.Users" %>
<%
    Users currentUser = (Users)session.getAttribute("user");
    if(currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String avatarPath;
    if (currentUser.getUimage() != null) {
        avatarPath = request.getContextPath() + "/" + currentUser.getUimage();
    } else {
        avatarPath = request.getContextPath() + "/static/images/default/default-wll.jpg";
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
        .image-square {
            width: 100px;
            height: 100px;
            overflow: hidden;
            border-radius: 4px;
            margin: 10px 0;
        }
        .image-square img {
            width: 100%;
            height: 100%;
            object-fit: cover;
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
                        <li class="layui-nav-item"><a href="">好友</a></li>
                        <li class="layui-nav-item"><a href="">群组</a></li>
                    </ul>
                </div>
                <div class="layui-col-md3">
                    <ul class="layui-nav" lay-filter="">
                        <li class="layui-nav-item">
                            <a href="javascript:;">
                                <img src="<%= avatarPath %>" class="layui-nav-img">${currentUser.uname}
                            </a>
                        </li>
                        <li class="layui-nav-item">
                            <a href="javascript:;">ID: ${currentUser.uid}</a>
                        </li>
                        <li class="layui-nav-item">
                            <a href="${pageContext.request.contextPath}/logout" class="layui-btn layui-btn-danger layui-btn-sm">
                                <i class="layui-icon layui-icon-logout"></i> 退出登录
                            </a>
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
                        <img src="<%= avatarPath %>" class="user-avatar">
                        <h3>${currentUser.uname}</h3>
                        <p class="layui-text">${currentUser.usign != null ? currentUser.usign : '这个人很懒，什么都没写~'}</p>
                        <div class="user-info">
                            <p><i class="layui-icon layui-icon-email"></i> ${currentUser.uemail != null ? currentUser.uemail : '未设置'}</p>
                            <p><i class="layui-icon layui-icon-user"></i> ${currentUser.ugender != null ? (currentUser.ugender ? '男' : '女') : '未设置'}</p>
                            <p><i class="layui-icon layui-icon-date"></i> ${currentUser.ubirthday != null ? currentUser.ubirthday : '未设置'}</p>
                            <p><i class="layui-icon layui-icon-star"></i> ${currentUser.uhobby != null ? currentUser.uhobby : '未设置'}</p>
                        </div>
                        <div style="margin-top: 15px;">
                            <a href="editProfile.jsp" class="layui-btn layui-btn-normal layui-btn-sm">
                                <i class="layui-icon layui-icon-edit"></i> 编辑资料
                            </a>
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
            $.ajax({
                url: '${pageContext.request.contextPath}/posts',
                type: 'GET',
                success: function(res) {
                    if(res.success && res.data && res.data.length > 0) {
                        var html = '';
                        res.data.forEach(function(post) {
                            var imageHtml = '';
                            if (post.image && post.image.trim() !== '') {
                                imageHtml = '<div class="image-square"><img src="${pageContext.request.contextPath}/' + post.image + '" alt="动态图片"></div>';
                            }
                            
                            var userImage = post.userImage || 'static/images/default/default-wll.jpg';
                            var userName = post.userName || '未知用户';
                            var content = post.content || '';
                            var time = post.time || '';
                            
                            html += `
                            <div class="post-item">
                                <div class="post-header">
                                    <img src="${pageContext.request.contextPath}/${userImage}" class="layui-nav-img">
                                    <span style="margin-left: 10px;">${userName}</span>
                                    <span class="layui-badge-rim" style="margin-left: 10px;">${time}</span>
                                </div>
                                <div class="post-content" style="margin: 15px 0; white-space: pre-wrap;">${content}</div>
                                ${imageHtml}
                                <div class="post-actions">
                                    <button class="layui-btn layui-btn-primary layui-btn-sm">
                                        <i class="layui-icon layui-icon-praise"></i> 点赞
                                    </button>
                                    <button class="layui-btn layui-btn-primary layui-btn-sm">
                                        <i class="layui-icon layui-icon-reply-fill"></i> 评论
                                    </button>
                                    <button class="layui-btn layui-btn-primary layui-btn-sm">
                                        <i class="layui-icon layui-icon-share"></i> 分享
                                    </button>
                                </div>
                            </div>
                            `;
                        });
                        $('#postList').html(html);
                    } else {
                        $('#postList').html('<div class="layui-card-body">暂无动态</div>');
                    }
                },
                error: function(xhr, status, error) {
                    console.error('加载动态失败:', error);
                    layer.msg('加载动态失败，请刷新页面重试', {icon: 2});
                }
            });
        }

        // 加载好友列表
        function loadFriends() {
            $.ajax({
                url: '${pageContext.request.contextPath}/friends',
                type: 'GET',
                success: function(res) {
                    if(res.success && res.data) {
                        var html = '';
                        res.data.forEach(function(friend) {
                            var friendImage = friend.image || 'static/images/default/default-wll.jpg';
                            html += `
                            <div class="friend-item">
                                <img src="${pageContext.request.contextPath}/${friendImage}" class="friend-avatar">
                                <span style="margin-left: 10px;">${friend.name || '未知用户'}</span>
                                <span class="layui-badge-dot ${friend.online ? 'layui-bg-green' : 'layui-bg-gray'}" style="margin-left: 5px;"></span>
                            </div>
                            `;
                        });
                        $('#friendList').html(html);
                    } else {
                        $('#friendList').html('<div class="layui-card-body">暂无好友</div>');
                    }
                },
                error: function(xhr, status, error) {
                    console.error('加载好友列表失败:', error);
                    $('#friendList').html('<div class="layui-card-body">加载好友列表失败</div>');
                }
            });
        }

        // 延迟加载非关键内容
        setTimeout(function() {
            loadPosts();
            loadFriends();
        }, 100);

        // 定时刷新，但降低频率
        setInterval(function(){
            loadPosts();
            loadFriends();
        }, 60000); // 每60秒刷新一次
    });
</script>
</body>
</html>