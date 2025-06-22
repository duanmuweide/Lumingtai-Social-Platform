<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.qdu.entity.Users" %>
<%
    Users currentUser = (Users)session.getAttribute("user");
    if(currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    pageContext.setAttribute("currentUser", currentUser);

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
        }
        /* 导航菜单项样式调整 */
        .layui-nav {
            background-color: transparent !important; /* 使导航菜单背景透明 */
        }
        .layui-nav-item a {
            color: #fff !important; /* 导航项文字颜色改为白色 */
        }
        .layui-nav-item:hover {
            background-color: rgba(255, 255, 255, 0.1) !important; /* 悬停效果 */
        }
        .layui-nav .layui-this a {
             color: #fff !important;
        }
        .layui-nav .layui-this {
            background-color: rgba(30, 159, 255, 0.5) !important; /* 当前选中项效果 */
        }
        /* 修复下拉菜单字体颜色问题 */
        .layui-nav .layui-nav-child dd a {
            color: #333 !important; /* 设置下拉菜单字体为深色 */
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
                        <li class="layui-nav-item layui-this"><a href="${pageContext.request.contextPath}/home.jsp">首页</a></li>
                        <li class="layui-nav-item"><a href="${pageContext.request.contextPath}/chat">好友</a></li>
                        <li class="layui-nav-item"><a href="${pageContext.request.contextPath}/messages">消息</a></li>
                        <li class="layui-nav-item"><a href="${pageContext.request.contextPath}/groupChat">群组</a></li>

                    </ul>
                </div>
                <div class="layui-col-md3">
                    <ul class="layui-nav" lay-filter="">
                        <li class="layui-nav-item">
                            <a href="javascript:;">
                                <img src="<%= avatarPath %>" class="layui-nav-img">${currentUser.uname}
                            </a>
                            <dl class="layui-nav-child">
                                <dd><a href="editProfile.jsp">编辑资料</a></dd>
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
            <div class="layui-col-md9">
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
                    var imageHtml = post.image ? '<img src="' + post.image + '" class="post-image">' : '';
                    html += '<div class="post-item" data-post-id="' + post.id + '">' +
                        '<div class="post-header">' +
                        '<img src="' + (post.userImage || 'static/images/default-avatar.png') + '" class="layui-nav-img">' +
                        '<span style="margin-left: 10px;">' + (post.userName || '未知用户') + '</span>' +
                        '<span class="layui-badge-rim" style="margin-left: 10px;">' + (post.time || '') + '</span>' +
                        '</div>' +
                        '<div class="post-content" style="margin: 15px 0; white-space: pre-wrap;">' + (post.content || '') + '</div>' +
                        imageHtml +
                        '<div class="post-actions">' +
                        '<button class="layui-btn ' + (post.userLiked ? 'layui-btn-danger' : 'layui-btn-primary') + ' layui-btn-sm like-btn" data-post-id="' + post.id + '">' +
                        '<i class="layui-icon layui-icon-praise"></i> 点赞 <span class="like-count">' + (post.likeCount || 0) + '</span>' +
                        '</button>' +
                        '<button class="layui-btn layui-btn-primary layui-btn-sm comment-btn" data-post-id="' + post.id + '">' +
                        '<i class="layui-icon layui-icon-reply-fill"></i> 评论 <span class="comment-count">' + (post.commentCount || 0) + '</span>' +
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
                        '<div class="comment-list"></div>' +
                        '</div>' +
                        '</div>';
                });
                $('#postList').html(html);
                bindPostEvents();
            } else {
                $('#postList').html('<div class="layui-card-body">暂无动态</div>');
            }
        });
    }

    function bindPostEvents() {
        // 点赞事件
        $('.like-btn').off('click').on('click', function() {
            var postId = $(this).data('post-id');
            var $btn = $(this);
            var $likeCount = $btn.find('.like-count');
            $.ajax({
                url: '${pageContext.request.contextPath}/like',
                type: 'POST',
                data: {
                    postId: postId
                },
                success: function(res) {
                    if(res.success) {
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
                        loadComments(postId, $postItem);
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

    function loadComments(postId, $postItem) {
        var $commentList = $postItem.find('.comment-list');
        $.ajax({
            url: '${pageContext.request.contextPath}/comment',
            type: 'GET',
            data: {
                postId: postId
            },
            success: function(res) {
                if(res.success && res.data && res.data.length > 0) {
                    var html = '';
                    res.data.forEach(function(comment) {
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
                    var $commentCount = $postItem.find('.comment-count');
                    $commentCount.text(res.data.length);
                } else {
                    $commentList.html('<div style="text-align: center; color: #999; padding: 20px;">暂无评论</div>');
                    var $commentCount = $postItem.find('.comment-count');
                    $commentCount.text('0');
                }
            },
            error: function(xhr, status, error) {
                $commentList.html('<div style="text-align: center; color: #999; padding: 20px;">加载评论失败</div>');
            }
        });
    }

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
                }
            }
        });
    }

    // 延迟加载非关键内容
    setTimeout(function() {
        loadPosts();
    }, 100);

    // 定时刷新，但降低频率
    setInterval(function(){
        loadPosts();
    }, 60000); // 每60秒刷新一次
});

</script>
</body>
</html>