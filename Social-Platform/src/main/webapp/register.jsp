<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>注册</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/layui/css/layui.css">
    <style>
        body { background-color: #f2f2f2; }
        .form-container { width: 450px; margin: 30px auto; padding: 20px; background: #fff; border-radius: 5px; }
        .logo { text-align: center; margin-bottom: 20px; }
    </style>
</head>
<body>
<div class="form-container">
    <div class="logo">
        <h1 style="color: #1E9FFF;">社交平台</h1>
    </div>
    <h2 style="text-align: center; color: #1E9FFF;">用户注册</h2>
    <form class="layui-form" id="registerForm" enctype="multipart/form-data">
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
            <label class="layui-form-label">头像</label>
            <div class="layui-input-block">
                <input type="file" name="ulmage" class="layui-input">
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