<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>注册</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/layui/css/layui.css">
    <style>
        body { background-color: #f2f2f2; }
        .form-container { width: 400px; margin: 50px auto; padding: 20px; background: #fff; border-radius: 5px; }
    </style>
</head>
<body>
<div class="form-container">
    <h2 style="text-align: center; color: #1E9FFF;">用户注册</h2>
    <form class="layui-form" id="registerForm">
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
            <div class="layui-input-block">
                <button class="layui-btn layui-btn-fluid" lay-submit lay-filter="registerSubmit">注册</button>
            </div>
        </div>
        <div style="text-align: center;">
            <a href="login.jsp" class="layui-font-cyan">已有账号？去登录</a>
        </div>
    </form>
</div>

<script src="${pageContext.request.contextPath}/layui/layui.js"></script>
<script>
    layui.use(['form', 'layer', 'jquery'], function() {
        var form = layui.form;
        var layer = layui.layer;
        var $ = layui.jquery;

        // Ajax 提交注册表单
        form.on('submit(registerSubmit)', function(data) {
            $.post('${pageContext.request.contextPath}/register', data.field, function(res) {
                if (res.success) {
                    layer.msg('注册成功', {icon: 1}, function() {
                        window.location.href = 'login.jsp';
                    });
                } else {
                    layer.msg(res.error || '注册失败', {icon: 2});
                }
            }, 'json');
            return false; // 阻止表单默认提交
        });
    });
</script>
</body>
</html>