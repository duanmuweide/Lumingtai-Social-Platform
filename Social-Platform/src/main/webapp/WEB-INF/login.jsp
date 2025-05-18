<%--
  Created by IntelliJ IDEA.
  User: hp
  Date: 2025/5/17
  Time: 14:55
  To change this template use File | Settings | File Templates.
--%>
<%-- 结构类似 register.jsp，仅修改表单和提交逻辑 --%>
<form class="layui-form" id="loginForm">
    <div class="layui-form-item">
        <label class="layui-form-label">用户名</label>
        <div class="layui-input-block">
            <input type="text" name="username" lay-verify="required" class="layui-input">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">密码</label>
        <div class="layui-input-block">
            <input type="password" name="password" lay-verify="required" class="layui-input">
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn layui-btn-fluid" lay-submit lay-filter="loginSubmit">登录</button>
        </div>
    </div>
</form>

<script>
    form.on('submit(loginSubmit)', function(data) {
        $.post('${pageContext.request.contextPath}/login', data.field, function(res) {
            if (res.success) {
                window.location.href = 'home.jsp'; // 跳转到主页
            } else {
                layer.msg(res.error || '登录失败', {icon: 2});
            }
        }, 'json');
        return false;
    });
</script>
