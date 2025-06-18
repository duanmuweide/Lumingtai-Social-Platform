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
    <title>社交平台 - 主页</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/layui/css/layui.css">
    <style>
        .header {
            border-bottom: 1px solid #f2f2f2;
            background-color: #fff;
        }
        .logo {
            color: #1E9FFF;
            font-size: 24px;
            font-weight: bold;
            line-height: 60px;
        }
        .main-content {
            padding: 15px;
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
        }
        .post-box {
            margin-bottom: 15px;
        }
        .friend-item {
            padding: 10px;
            border-bottom: 1px solid #f2f2f2;
        }
        .friend-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            margin-right: 10px;
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
                    <div class="logo">社交平台</div>
                </div>
                <div class="layui-col-md6">
                    <ul class="layui-nav" lay-filter="">
                        <li class="layui-nav-item layui-this"><a href="">首页</a></li>
                        <li class="layui-nav-item"><a href="${pageContext.request.contextPath}/chat">好友</a></li>
                        <li class="layui-nav-item"><a href="">消息</a></li>
                        <li class="layui-nav-item"><a href="">群组</a></li>
                    </ul>
                </div>
                <div class="layui-col-md3">
                    <ul class="layui-nav" lay-filter="">
                        <li class="layui-nav-item">
                            <a href="javascript:;"><img src="${currentUser.ulimage != null ? currentUser.ulimage : 'https://unsplash.it/100/100?random'}" class="layui-nav-img">${currentUser.uname}</a>
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
                        <img src="${currentUser.ulimage != null ? currentUser.ulimage : 'https://unsplash.it/100/100?random'}" class="user-avatar">
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
                            <textarea placeholder="分享新鲜事..." class="layui-textarea"></textarea>
                            <div style="margin-top: 10px;">
                                <button class="layui-btn layui-btn-primary"><i class="layui-icon layui-icon-picture"></i> 图片</button>
                                <button class="layui-btn" style="float: right;">发布</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 动态列表 -->
                <div class="layui-card" style="margin-top: 15px;">
                    <div class="layui-card-header">
                        <i class="layui-icon layui-icon-notice"></i> 最新动态
                    </div>
                    <div class="layui-card-body">
                        <div class="layui-collapse" lay-accordion>
                            <div class="layui-colla-item">
                                <div class="layui-colla-content layui-show">
                                    <div class="layui-card">
                                        <div class="layui-card-header">
                                            <img src="https://unsplash.it/40/40?random" class="layui-nav-img">
                                            张三
                                            <span class="layui-badge-rim">2分钟前</span>
                                        </div>
                                        <div class="layui-card-body">
                                            今天天气真不错！
                                            <div class="layui-btn-group" style="margin-top: 10px;">
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
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 右侧好友列表 -->
            <div class="layui-col-md3">
                <div class="layui-card">
                    <div class="layui-card-header">
                        <i class="layui-icon layui-icon-group"></i> 好友列表
                    </div>
                    <div class="layui-card-body">
                        <div class="friend-item">
                            <img src="https://unsplash.it/40/40?random" class="friend-avatar layui-circle">
                            <span>李四</span>
                            <span class="layui-badge-dot layui-bg-green" style="margin-left: 5px;"></span>
                        </div>
                        <div class="friend-item">
                            <img src="https://unsplash.it/40/40?random" class="friend-avatar layui-circle">
                            <span>王五</span>
                            <span class="layui-badge-dot layui-bg-gray" style="margin-left: 5px;"></span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/layui/layui.js"></script>
<script>
layui.use(['element', 'layer', 'form'], function(){
    var element = layui.element;
    var layer = layui.layer;
    var form = layui.form;

    // 显示欢迎消息
    layer.msg('欢迎回来！', {icon: 1});

    // 初始化导航栏
    element.render('nav');

    // 发布动态
    document.querySelector('.post-box .layui-btn').onclick = function(){
        var content = document.querySelector('.post-box textarea').value;
        if(!content.trim()) {
            layer.msg('请输入内容', {icon: 2});
            return;
        }
        // TODO: 发送到服务器
        layer.msg('发布成功', {icon: 1});
        document.querySelector('.post-box textarea').value = '';
    };
});
</script>
</body>
</html>