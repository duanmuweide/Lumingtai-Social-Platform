<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>鹿鸣台 - 注册</title>
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
            height: 600px;
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
        }
        .logo { 
            text-align: center; 
            margin-bottom: 15px;
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
            height: 600px;
            background-size: cover;
            background-position: center;
        }
        .login-link {
            margin-top: 20px;
            text-align: center;
        }
        .login-link a {
            color: #1E9FFF;
            text-decoration: none;
            font-size: 15px;
        }
        .login-link a:hover {
            text-decoration: underline;
        }
        .layui-btn {
            font-size: 16px;
            height: 35px;
            line-height: 35px;
        }
        .layui-form-item {
            margin-bottom: 12px;
        }
        .avatar-container {
            text-align: center;
            margin-bottom: 15px;
        }
        .avatar-preview {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            margin: 0 auto 8px;
            background: #f0f0f0;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            cursor: pointer;
            transition: all 0.3s;
        }
        .avatar-preview:hover {
            background: #e0e0e0;
        }
        .avatar-preview img {
            max-width: 100%;
            max-height: 100%;
            display: none;
        }
        .avatar-preview i {
            font-size: 32px;
            color: #999;
        }
        .avatar-text {
            color: #666;
            font-size: 13px;
            margin-top: 3px;
        }
        .file-input {
            display: none;
        }
    </style>
</head>
<body>
<div class="main-container">
    <div class="carousel-container">
        <div class="layui-carousel" id="register-carousel">
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
        <form class="layui-form" id="registerForm" enctype="multipart/form-data">
            <div class="avatar-container">
                <div class="avatar-preview" id="avatarPreview">
                    <i class="layui-icon layui-icon-user"></i>
                    <img id="previewImage" src="#" alt="头像预览">
                </div>
                <div class="avatar-text">点击上传头像</div>
                <input type="file" name="ulmage" id="avatarInput" class="file-input" accept="image/*">
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">用户名</label>
                <div class="layui-input-block">
                    <input type="text" name="uname" lay-verify="required" placeholder="请输入用户名" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">密码</label>
                <div class="layui-input-block">
                    <input type="password" name="upwd" lay-verify="required|pass" placeholder="请输入密码" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">手机号</label>
                <div class="layui-input-block">
                    <input type="text" name="uphonenumber" lay-verify="required|phone" placeholder="请输入手机号" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">邮箱</label>
                <div class="layui-input-block">
                    <input type="text" name="uemail" lay-verify="required|email" placeholder="请输入邮箱" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">性别</label>
                <div class="layui-input-block">
                    <input type="radio" name="ugender" value="true" title="男" checked>
                    <input type="radio" name="ugender" value="false" title="女">
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-input-block" style="margin-left: 0;">
                    <button class="layui-btn layui-btn-fluid" lay-submit lay-filter="registerSubmit">注册</button>
                </div>
            </div>
            <div class="login-link">
                <a href="login.jsp">已有账号？去登录</a>
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
            elem: '#register-carousel',
            width: '500px',
            height: '600px',
            interval: 3000,
            arrow: 'none',
            anim: 'fade'
        });

        // 头像上传预览
        $('#avatarPreview').on('click', function() {
            $('#avatarInput').click();
        });

        $('#avatarInput').on('change', function(e) {
            var file = e.target.files[0];
            if (file) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    $('#previewImage').attr('src', e.target.result).show();
                    $('.avatar-preview i').hide();
                }
                reader.readAsDataURL(file);
            }
        });

        // 自定义验证规则
        form.verify({
            pass: [/^[\S]{6,12}$/, '密码必须6到12位，且不能出现空格']
        });

        // Ajax 提交注册表单
        form.on('submit(registerSubmit)', function(data) {
            var formData = new FormData($('#registerForm')[0]);

            $.ajax({
                url: '${pageContext.request.contextPath}/register',
                type: 'POST',
                data: formData,
                processData: false,
                contentType: false,
                success: function(res) {
                    if (res.success) {
                        layer.msg('注册成功', {icon: 1}, function() {
                            window.location.href = 'login.jsp';
                        });
                    } else {
                        layer.msg(res.error || '注册失败', {icon: 2});
                    }
                },
                dataType: 'json'
            });
            return false;
        });
    });
</script>
</body>
</html>