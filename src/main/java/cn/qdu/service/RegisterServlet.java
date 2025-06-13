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

@WebServlet("/register")
@MultipartConfig(
    maxFileSize = 10485760,    // 10MB
    maxRequestSize = 20971520, // 20MB
    fileSizeThreshold = 0
)
public class RegisterServlet extends HttpServlet {
    private UserDao userDao = new UserDao();

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

            // 检查用户名、手机号、邮箱是否已存在
            List<Users> existingUsers = userDao.selectOne(uname);
            if (existingUsers != null && !existingUsers.isEmpty()) {
                sendResponse(response, false, "用户名已存在");
                return;
            }

            // 处理头像上传
            String imagePath = null;
            Part filePart = request.getPart("ulmage");
            if (filePart != null && filePart.getSize() > 0) {
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
            newUser.setUpwd(upwd); // 注意: 实际项目中应该加密存储
            newUser.setUphonenumber(uphonenumber);
            newUser.setUemail(uemail);
            newUser.setUgender("true".equals(ugender)); // 更安全的布尔值转换
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