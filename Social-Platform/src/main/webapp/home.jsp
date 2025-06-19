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
        .comment-section {
            background: #fafafa;
            border-radius: 4px;
            padding: 15px;
        }
        .comment-item {
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
            margin-bottom: 10px;
        }
        .comment-item:last-child {
            border-bottom: none;
            margin-bottom: 0;
        }
        .like-btn.layui-btn-danger {
            background-color: #FF5722;
            border-color: #FF5722;
        }
        .comment-textarea {
            resize: none;
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
<<<<<<< HEAD:Social-Platform/src/main/webapp/home.jsp
                        <li class="layui-nav-item"><a href="${pageContext.request.contextPath}/friends.jsp">好友</a></li>
                        <li class="layui-nav-item">
                            <a href="javascript:;">消息<span class="layui-badge notification-badge">5</span></a>
                            <dl class="layui-nav-child">
                                <dd><a href="javascript:;">评论 <span class="layui-badge">3</span></a></dd>
                                <dd><a href="javascript:;">私信 <span class="layui-badge">2</span></a></dd>
                            </dl>
                        </li>
=======
                        <li class="layui-nav-item"><a href="">好友</a></li>
>>>>>>> 0e49da2bd1bb6c818f5f17aa8ae3f52b5ec7955c:src/main/webapp/home.jsp
                        <li class="layui-nav-item"><a href="">群组</a></li>
                        <li class="layui-nav-item"><a href="messages.jsp">消息</a></li>
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
<<<<<<< HEAD:Social-Platform/src/main/webapp/home.jsp
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
=======
            $.ajax({
                url: '${pageContext.request.contextPath}/posts',
                type: 'GET',
                success: function(res) {
                    console.log('收到响应:', res); // 调试信息
                    if(res.success && res.data && res.data.length > 0) {
                        console.log('找到 ' + res.data.length + ' 条动态'); // 调试信息
                        var html = '';
                        res.data.forEach(function(post, index) {
                            console.log('处理第 ' + (index + 1) + ' 条动态:', post); // 调试信息
                            var imageHtml = '';
                            if (post.image && post.image.trim() !== '') {
                                imageHtml = '<div class="image-square"><img src="${pageContext.request.contextPath}/' + post.image + '" alt="动态图片"></div>';
                            }
                            
                            var userImage = post.userImage || 'static/images/default/default-wll.jpg';
                            var userName = post.userName || '未知用户';
                            var content = post.content || '';
                            var time = post.time || '';
                            var likeCount = post.likeCount || 0;
                            var commentCount = post.commentCount || 0;
                            var userLiked = post.userLiked || false;
                            
                            console.log('用户图片:', userImage); // 调试信息
                            console.log('用户名:', userName); // 调试信息
                            console.log('内容:', content); // 调试信息
                            console.log('时间:', time); // 调试信息
                            console.log('点赞数:', likeCount); // 调试信息
                            console.log('评论数:', commentCount); // 调试信息
                            console.log('用户已点赞:', userLiked); // 调试信息
                            
                            // 根据用户点赞状态设置按钮样式
                            var likeBtnClass = userLiked ? 'layui-btn-danger' : 'layui-btn-primary';
                            
                            html += '<div class="post-item" data-post-id="' + post.id + '">' +
                                '<div class="post-header">' +
                                '<img src="${pageContext.request.contextPath}/' + userImage + '" class="layui-nav-img">' +
                                '<span style="margin-left: 10px;">' + userName + '</span>' +
                                '<span class="layui-badge-rim" style="margin-left: 10px;">' + time + '</span>' +
                                '</div>' +
                                '<div class="post-content" style="margin: 15px 0; white-space: pre-wrap;">' + content + '</div>' +
                                imageHtml +
                                '<div class="post-actions">' +
                                '<button class="layui-btn ' + likeBtnClass + ' layui-btn-sm like-btn" data-post-id="' + post.id + '">' +
                                '<i class="layui-icon layui-icon-praise"></i> 点赞 <span class="like-count">' + likeCount + '</span>' +
                                '</button>' +
                                '<button class="layui-btn layui-btn-primary layui-btn-sm comment-btn" data-post-id="' + post.id + '">' +
                                '<i class="layui-icon layui-icon-reply-fill"></i> 评论 <span class="comment-count">' + commentCount + '</span>' +
                                '</button>' +
                                '<button class="layui-btn layui-btn-primary layui-btn-sm">' +
                                '<i class="layui-icon layui-icon-share"></i> 分享' +
                                '</button>' +
                                '</div>' +
                                '<div class="comment-section" style="display: none; margin-top: 15px; border-top: 1px solid #f2f2f2; padding-top: 15px;">' +
                                '<div class="comment-input" style="margin-bottom: 15px;">' +
                                '<textarea class="layui-textarea comment-textarea" placeholder="写下你的评论..." style="height: 60px;"></textarea>' +
                                '<button class="layui-btn layui-btn-sm submit-comment" style="margin-top: 5px;">发表评论</button>' +
                                '</div>' +
                                '<div class="comment-list">' +
                                '<!-- 评论列表将在这里动态加载 -->' +
                                '</div>' +
                                '</div>' +
                                '</div>';
                        });
                        $('#postList').html(html);
                        
                        // 绑定事件
                        bindPostEvents();
                    } else {
                        console.log('没有找到动态数据或数据为空'); // 调试信息
                        $('#postList').html('<div class="layui-card-body">暂无动态</div>');
                    }
                },
                error: function(xhr, status, error) {
                    console.error('加载动态失败:', error);
                    console.error('状态:', status);
                    console.error('响应文本:', xhr.responseText);
                    layer.msg('加载动态失败，请刷新页面重试', {icon: 2});
                }
            });
        }

        // 绑定帖子相关事件
        function bindPostEvents() {
            // 检查用户点赞状态
            checkUserLikeStatus();
            
            // 点赞事件
            $('.like-btn').off('click').on('click', function() {
                var postId = $(this).data('post-id');
                var $btn = $(this);
                var $likeCount = $btn.find('.like-count');
                
                $.ajax({
                    url: '${pageContext.request.contextPath}/comment',
                    type: 'POST',
                    data: {
                        action: 'like',
                        postId: postId
                    },
                    success: function(res) {
                        if(res.success) {
                            // 从服务器获取最新的点赞数
                            $likeCount.text(res.likeCount);
                            if(res.liked) {
                                $btn.addClass('layui-btn-danger').removeClass('layui-btn-primary');
                                layer.msg('点赞成功', {icon: 1});
                            } else {
                                $btn.addClass('layui-btn-primary').removeClass('layui-btn-danger');
                                layer.msg('取消点赞', {icon: 1});
                            }
                        } else {
                            layer.msg(res.error || '操作失败', {icon: 2});
                        }
                    },
                    error: function() {
                        layer.msg('网络错误，请重试', {icon: 2});
                    }
                });
            });

            // 评论按钮事件
            $('.comment-btn').off('click').on('click', function() {
                var postId = $(this).data('post-id');
                var $postItem = $('.post-item[data-post-id="' + postId + '"]');
                var $commentSection = $postItem.find('.comment-section');
                
                if($commentSection.is(':visible')) {
                    $commentSection.hide();
                } else {
                    $commentSection.show();
                    loadComments(postId, $postItem);
                }
            });

            // 提交评论事件
            $('.submit-comment').off('click').on('click', function() {
                var $btn = $(this);
                var $postItem = $btn.closest('.post-item');
                var postId = $postItem.data('post-id');
                var $textarea = $postItem.find('.comment-textarea');
                var message = $textarea.val().trim();
                
                if(!message) {
                    layer.msg('请输入评论内容', {icon: 2});
                    return;
                }
                
                $.ajax({
                    url: '${pageContext.request.contextPath}/comment',
                    type: 'POST',
                    data: {
                        action: 'add',
                        postId: postId,
                        message: message
                    },
                    success: function(res) {
                        if(res.success) {
                            $textarea.val('');
                            layer.msg('评论发布成功', {icon: 1});
                            // 重新加载评论列表和更新评论数
                            loadComments(postId, $postItem);
                            // 更新按钮上的评论数
                            updateCommentCount(postId, $postItem);
                        } else {
                            layer.msg(res.error || '评论发布失败', {icon: 2});
                        }
                    },
                    error: function() {
                        layer.msg('网络错误，请重试', {icon: 2});
                    }
                });
            });
        }

        // 检查用户点赞状态
        function checkUserLikeStatus() {
            $('.post-item').each(function() {
                var postId = $(this).data('post-id');
                var $likeBtn = $(this).find('.like-btn');
                
                // 这里可以添加一个API调用来检查用户是否已点赞
                // 暂时使用默认状态，实际项目中可以添加相应的API
            });
        }

        // 加载评论列表
        function loadComments(postId, $postItem) {
            var $commentList = $postItem.find('.comment-list');
            console.log('开始加载评论，帖子ID: ' + postId); // 调试信息
            
            $.ajax({
                url: '${pageContext.request.contextPath}/comment',
                type: 'GET',
                data: {
                    postId: postId
                },
                success: function(res) {
                    console.log('收到评论响应:', res); // 调试信息
                    if(res.success && res.data && res.data.length > 0) {
                        console.log('找到 ' + res.data.length + ' 条评论'); // 调试信息
                        var html = '';
                        res.data.forEach(function(comment, index) {
                            console.log('处理第 ' + (index + 1) + ' 条评论:', comment); // 调试信息
                            var userImage = comment.userImage || 'static/images/default/default-wll.jpg';
                            html += '<div class="comment-item" style="margin-bottom: 10px; padding: 10px; background: #f8f8f8; border-radius: 4px;">' +
                                '<div style="display: flex; align-items: center; margin-bottom: 5px;">' +
                                '<img src="${pageContext.request.contextPath}/' + userImage + '" style="width: 30px; height: 30px; border-radius: 50%; margin-right: 8px;">' +
                                '<span style="font-weight: bold;">' + comment.userName + '</span>' +
                                '<span style="margin-left: 10px; color: #999; font-size: 12px;">' + comment.cdate + '</span>' +
                                '</div>' +
                                '<div style="margin-left: 38px;">' + comment.cmessage + '</div>' +
                                '</div>';
                        });
                        $commentList.html(html);
                        
                        // 更新评论数显示
                        var $commentCount = $postItem.find('.comment-count');
                        $commentCount.text(res.data.length);
                        console.log('评论列表更新完成，评论数: ' + res.data.length); // 调试信息
                    } else {
                        console.log('没有找到评论数据'); // 调试信息
                        $commentList.html('<div style="text-align: center; color: #999; padding: 20px;">暂无评论</div>');
                        // 更新评论数为0
                        var $commentCount = $postItem.find('.comment-count');
                        $commentCount.text('0');
                    }
                },
                error: function(xhr, status, error) {
                    console.error('加载评论失败:', error); // 调试信息
                    console.error('状态:', status);
                    console.error('响应:', xhr.responseText);
                    $commentList.html('<div style="text-align: center; color: #999; padding: 20px;">加载评论失败</div>');
                }
            });
        }

        // 更新评论数量
        function updateCommentCount(postId, $postItem) {
            $.ajax({
                url: '${pageContext.request.contextPath}/comment',
                type: 'GET',
                data: {
                    postId: postId
                },
                success: function(res) {
                    if(res.success) {
                        var commentCount = res.data ? res.data.length : 0;
                        var $commentCount = $postItem.find('.comment-count');
                        $commentCount.text(commentCount);
                        console.log('更新评论数: ' + commentCount); // 调试信息
                    }
                },
                error: function() {
                    console.log('更新评论数失败');
>>>>>>> 0e49da2bd1bb6c818f5f17aa8ae3f52b5ec7955c:src/main/webapp/home.jsp
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
                            html += '<div class="friend-item">' +
                                '<img src="${pageContext.request.contextPath}/' + friendImage + '" class="friend-avatar">' +
                                '<span style="margin-left: 10px;">' + (friend.name || '未知用户') + '</span>' +
                                '<span class="layui-badge-dot ' + (friend.online ? 'layui-bg-green' : 'layui-bg-gray') + '" style="margin-left: 5px;"></span>' +
                                '</div>';
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