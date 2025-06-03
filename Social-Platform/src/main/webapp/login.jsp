<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>登录</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/layui/css/layui.css">
    <style>
        body { background-color: #f2f2f2; }
        .form-container { width: 400px; margin: 50px auto; padding: 20px; background: #fff; border-radius: 5px; }
        .logo { text-align: center; margin-bottom: 20px; }
    </style>
</head>
<body>
<div class="form-container">
    <div class="logo">
        <h1 style="color: #1E9FFF;">社交平台</h1>
    </div>
    <h2 style="text-align: center; color: #1E9FFF;">用户登录</h2>
    <form class="layui-form" id="loginForm">
        <div class="layui-form-item">
            <label class="layui-form-label">用户名/手机/邮箱</label>
            <div class="layui-input-block">
                <input type="text" name="loginInfo" lay-verify="required" placeholder="请输入用户名、手机号或邮箱" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">密码</label>
            <div class="layui-input-block">
                <input type="password" name="password" lay-verify="required" placeholder="请输入密码" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-input-block">
                <button class="layui-btn layui-btn-fluid" lay-submit lay-filter="loginSubmit">登录</button>
            </div>
        </div>
        <div style="text-align: center;">
            <a href="register.jsp" class="layui-font-cyan">没有账号？立即注册</a>
        </div>
    </form>
</div>

<script src="${pageContext.request.contextPath}/layui/layui.js"></script>
<script>
    layui.use(['form', 'layer', 'jquery'], function() {
        var form = layui.form;
        var layer = layui.layer;
        var $ = layui.jquery;

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