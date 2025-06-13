package cn.qdu.service;

import cn.qdu.dao.UserDao;
import cn.qdu.entity.Users;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.UUID;
import java.util.regex.Pattern;

@WebServlet("/register")
@MultipartConfig(
        maxFileSize = 10485760,    // 10MB
        maxRequestSize = 20971520, // 20MB
        fileSizeThreshold = 0
)
public class RegisterServlet extends HttpServlet {
    private UserDao userDao = new UserDao();
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@(.+)$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^1[3-9]\\d{9}$");
    private static final String[] ALLOWED_IMAGE_TYPES = {"image/jpeg", "image/png", "image/gif"};

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        try {
            // 获取表单数据
            String uname = request.getParameter("uname");
            String upwd = request.getParameter("upwd");
            String uphonenumber = request.getParameter("uphonenumber");
            String uemail = request.getParameter("uemail");
            String ugender = request.getParameter("ugender");

            // 基本验证
            if (uname == null || upwd == null || uname.trim().isEmpty() || upwd.trim().isEmpty()) {
                sendResponse(response, false, "用户名和密码不能为空");
                return;
            }

            // 用户名长度和格式验证
            if (uname.length() < 3 || uname.length() > 20) {
                sendResponse(response, false, "用户名长度必须在3-20个字符之间");
                return;
            }

            // 密码长度验证
            if (upwd.length() > 20) {
                sendResponse(response, false, "密码长度不能超过20个字符");
                return;
            }

            // 邮箱格式验证
            if (uemail != null && !uemail.isEmpty() && !EMAIL_PATTERN.matcher(uemail).matches()) {
                sendResponse(response, false, "邮箱格式不正确");
                return;
            }

            // 手机号格式验证
            if (uphonenumber != null && !uphonenumber.isEmpty() && !PHONE_PATTERN.matcher(uphonenumber).matches()) {
                sendResponse(response, false, "手机号格式不正确");
                return;
            }

            // 检查用户名、手机号、邮箱是否已存在
            List<Users> existingUsers = userDao.selectByName(uname);
            if (existingUsers != null && !existingUsers.isEmpty()) {
                sendResponse(response, false, "用户名已存在");
                return;
            }

            // 处理头像上传
            String imagePath = null;
            Part filePart = request.getPart("ulmage");
            if (filePart != null && filePart.getSize() > 0) {
                // 验证文件类型
                String contentType = filePart.getContentType();
                boolean isAllowedType = false;
                for (String type : ALLOWED_IMAGE_TYPES) {
                    if (type.equals(contentType)) {
                        isAllowedType = true;
                        break;
                    }
                }
                if (!isAllowedType) {
                    sendResponse(response, false, "只允许上传JPG、PNG或GIF格式的图片");
                    return;
                }

                String fileName = UUID.randomUUID().toString() + getFileExtension(filePart);
                String uploadPath = getServletContext().getRealPath("/uploads");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdir();
                }
                filePart.write(uploadPath + File.separator + fileName);
                imagePath = "uploads/" + fileName;
            }

            // 创建新用户
            Users newUser = new Users();
            newUser.setUname(uname);
            newUser.setUpwd(upwd);
            newUser.setUphonenumber(uphonenumber);
            newUser.setUemail(uemail);
            newUser.setUgender("true".equals(ugender));
            newUser.setUsign("这个人很懒，什么都没留下");
            if (imagePath != null) {
                newUser.setUimage(imagePath);
            }

            userDao.insert(newUser);
            sendResponse(response, true, "");
        } catch (Exception e) {
            e.printStackTrace();
            sendResponse(response, false, "注册失败: " + e.getMessage());
        }
    }

    private String getFileExtension(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                String fileName = token.substring(token.indexOf("=") + 2, token.length() - 1);
                return fileName.substring(fileName.lastIndexOf("."));
            }
        }
        return "";
    }

    private void sendResponse(HttpServletResponse response, boolean success, String error)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.print("{\"success\": " + success + ", \"error\": \"" + error + "\"}");
        out.flush();
    }
}