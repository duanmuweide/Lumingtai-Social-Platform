<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.qdu.entity.Users" %>
<%
    Users currentUser = (Users)session.getAttribute("user");
    if(currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String avatarPath;
    if (currentUser.getUimage() != null && !currentUser.getUimage().isEmpty()) {
        avatarPath = request.getContextPath() + "/" + currentUser.getUimage();
    } else {
        avatarPath = request.getContextPath() + "/static/images/default/default-wll.jpg";
    }
    
    // 调试信息
    System.out.println("=== 当前用户信息 ===");
    System.out.println("用户ID: " + currentUser.getUid());
    System.out.println("用户名: " + currentUser.getUname());
    System.out.println("个性签名: " + currentUser.getUsign());
    System.out.println("手机号: " + currentUser.getUphonenumber());
    System.out.println("邮箱: " + currentUser.getUemail());
    System.out.println("性别: " + currentUser.getUgender());
    System.out.println("生日: " + currentUser.getUbirthday());
    System.out.println("兴趣爱好: " + currentUser.getUhobby());
    System.out.println("头像: " + currentUser.getUimage());
%>
<!DOCTYPE html>
<html>
<head>
    <title>鹿鸣台 - 编辑资料</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/layui/css/layui.css">
    <style>
        body { 
            background-color: #f2f2f2; 
            margin: 0;
            padding: 20px;
        }
        .main-container {
            max-width: 800px;
            margin: 0 auto;
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }
        .avatar-container {
            text-align: center;
            margin-bottom: 20px;
        }
        .avatar-preview {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            margin: 0 auto 10px;
            overflow: hidden;
            position: relative;
            cursor: pointer;
            border: 2px solid #ddd;
        }
        .avatar-preview:hover {
            border-color: #1E9FFF;
        }
        .avatar-preview img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .avatar-text {
            color: #666;
            font-size: 14px;
            margin-top: 5px;
        }
        .layui-form-label {
            width: 100px;
        }
        .layui-input-block {
            margin-left: 130px;
        }
        .layui-form-item {
            margin-bottom: 25px;
        }
        .back-link {
            margin-top: 20px;
            text-align: center;
        }
        .back-link a {
            color: #1E9FFF;
            text-decoration: none;
        }
        .back-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="main-container">
    <div class="avatar-container">
        <div class="avatar-preview" id="avatarPreview">
            <img src="<%= avatarPath %>" alt="头像预览" id="previewImage">
        </div>
        <div class="avatar-text">点击上传新头像</div>
        <input type="file" name="uimage" id="avatarInput" style="display: none;" accept="image/*">
    </div>

    <form class="layui-form" id="editProfileForm" enctype="multipart/form-data">
        <div class="layui-form-item">
            <label class="layui-form-label">用户名</label>
            <div class="layui-input-block">
                <input type="text" name="uname" value="<%= currentUser.getUname() != null ? currentUser.getUname() : "" %>" placeholder="请输入用户名" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">个性签名</label>
            <div class="layui-input-block">
                <input type="text" name="usign" value="<%= currentUser.getUsign() != null ? currentUser.getUsign() : "" %>" placeholder="请输入个性签名" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">手机号</label>
            <div class="layui-input-block">
                <input type="text" name="uphonenumber" value="<%= currentUser.getUphonenumber() != null ? currentUser.getUphonenumber() : "" %>" lay-verify="phone" placeholder="请输入手机号" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">邮箱</label>
            <div class="layui-input-block">
                <input type="text" name="uemail" value="<%= currentUser.getUemail() != null ? currentUser.getUemail() : "" %>" lay-verify="email" placeholder="请输入邮箱" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">性别</label>
            <div class="layui-input-block">
                <input type="radio" name="ugender" value="true" title="男" <%= currentUser.getUgender() != null && currentUser.getUgender() ? "checked" : "" %>>
                <input type="radio" name="ugender" value="false" title="女" <%= currentUser.getUgender() != null && !currentUser.getUgender() ? "checked" : "" %>>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">生日</label>
            <div class="layui-input-block">
                <input type="text" name="ubirthday" value="<%= currentUser.getUbirthday() != null ? currentUser.getUbirthday() : "" %>" id="birthday" placeholder="请选择生日" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">兴趣爱好</label>
            <div class="layui-input-block">
                <input type="text" name="uhobby" value="<%= currentUser.getUhobby() != null ? currentUser.getUhobby() : "" %>" placeholder="请输入兴趣爱好" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-input-block" style="margin-left: 0;">
                <button class="layui-btn layui-btn-fluid" lay-submit lay-filter="editProfileSubmit">保存修改</button>
            </div>
        </div>
    </form>

    <div class="back-link">
        <a href="home.jsp">返回主页</a>
    </div>
</div>

<script src="${pageContext.request.contextPath}/layui/layui.js"></script>
<script>
    layui.use(['form', 'layer', 'laydate'], function() {
        var form = layui.form;
        var layer = layui.layer;
        var laydate = layui.laydate;
        var $ = layui.jquery;

        // 初始化日期选择器
        laydate.render({
            elem: '#birthday'
        });

        // 头像上传预览
        $('#avatarPreview').on('click', function() {
            $('#avatarInput').click();
        });

        $('#avatarInput').on('change', function(e) {
            var file = e.target.files[0];
            if(file) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    $('#previewImage').attr('src', e.target.result);
                }
                reader.readAsDataURL(file);
            }
        });

        // 表单提交
        form.on('submit(editProfileSubmit)', function(data) {
            var formData = new FormData();
            // 添加表单数据
            for(var key in data.field) {
                formData.append(key, data.field[key]);
            }
            // 添加头像文件
            var avatarFile = $('#avatarInput')[0].files[0];
            if(avatarFile) {
                formData.append('uimage', avatarFile);
            }

            $.ajax({
                url: '${pageContext.request.contextPath}/updateProfile',
                type: 'POST',
                data: formData,
                processData: false,
                contentType: false,
                success: function(res) {
                    if(res.success) {
                        layer.msg('修改成功', {icon: 1}, function() {
                            window.location.href = 'home.jsp';
                        });
                    } else {
                        layer.msg(res.error || '修改失败', {icon: 2});
                    }
                },
                error: function() {
                    layer.msg('网络错误，请重试', {icon: 2});
                }
            });
            return false;
        });
    });
</script>
</body>
</html> 