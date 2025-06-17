<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>鹿鸣台 - 登录</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/layui/css/layui.css">
    <style>
        body { 
            background-color: #f2f2f2; 
            margin: 0;
            padding: 0;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .main-container {
            display: flex;
            width: 900px;
            height: 500px;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .carousel-container {
            width: 500px;
            height: 100%;
            background: #1E9FFF;
        }
        .form-container { 
            width: 400px;
            padding: 30px 40px;
            box-sizing: border-box;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        .logo { 
            text-align: center; 
            margin-bottom: 40px; 
        }
        .logo h1 {
            color: #1E9FFF;
            font-size: 32px;
            margin: 0;
            letter-spacing: 2px;
        }
        .logo p {
            color: #666;
            margin-top: 10px;
            font-size: 16px;
            letter-spacing: 1px;
        }
        .layui-form-label {
            width: 80px;
            font-size: 16px;
        }
        .layui-input-block {
            margin-left: 110px;
        }
        .layui-input {
            font-size: 15px;
        }
        .carousel-item {
            height: 500px;
            background-size: cover;
            background-position: center;
        }
        .register-link {
            margin-top: 30px;
            text-align: center;
        }
        .register-link a {
            color: #1E9FFF;
            text-decoration: none;
            font-size: 15px;
        }
        .register-link a:hover {
            text-decoration: underline;
        }
        .layui-btn {
            font-size: 16px;
            height: 45px;
            line-height: 45px;
            margin-top: 20px;
        }
        .form-container .layui-form {
            margin-top: 20px;
        }
        .layui-form-item {
            margin-bottom: 25px;
        }
    </style>
</head>
<body>
<div class="main-container">
    <div class="carousel-container">
        <div class="layui-carousel" id="login-carousel">
            <div carousel-item>
                <div class="carousel-item" style="background-image: url(static/images/register&login/bg1.jpg)"></div>
                <div class="carousel-item" style="background-image: url(static/images/register&login/bg2.jpg)"></div>
                <div class="carousel-item" style="background-image: url(static/images/register&login/bg3.jpg)"></div>
            </div>
        </div>
    </div>
    <div class="form-container">
        <div class="logo">
            <h1>鹿鸣台</h1>
            <p>相期邈邈，鹿鸣呦呦</p>
        </div>
        <form class="layui-form" id="loginForm">
            <div class="layui-form-item">
                <label class="layui-form-label">用户名</label>
                <div class="layui-input-block">
                    <input type="text" name="username" lay-verify="required" placeholder="请输入用户名" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">密码</label>
                <div class="layui-input-block">
                    <input type="password" name="password" lay-verify="required" placeholder="请输入密码" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-input-block" style="margin-left: 0;">
                    <button class="layui-btn layui-btn-fluid" lay-submit lay-filter="loginSubmit">登录</button>
                </div>
            </div>
            <div class="register-link">
                <a href="register.jsp">没有账号？立即注册</a>
            </div>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/layui/layui.js"></script>
<script>
    layui.use(['form', 'layer', 'jquery', 'carousel'], function() {
        var form = layui.form;
        var layer = layui.layer;
        var $ = layui.jquery;
        var carousel = layui.carousel;
        
        // 初始化轮播图
        carousel.render({
            elem: '#login-carousel',
            width: '500px',
            height: '500px',
            interval: 3000,
            arrow: 'none',
            anim: 'fade'
        });

        // Ajax 提交登录表单
        form.on('submit(loginSubmit)', function(data) {
            $.post('${pageContext.request.contextPath}/login', data.field, function(res) {
                if (res.success) {
                    layer.msg('登录成功', {icon: 1}, function() {
                        window.location.href = 'home.jsp'; // 跳转到主页
                    });
                } else {
                    layer.msg(res.error || '登录失败', {icon: 2});
                }
            }, 'json');
            return false; // 阻止表单默认提交
        });
    });
</script>
</body>
</html>