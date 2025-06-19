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
import java.sql.SQLException;
import java.util.UUID;

@WebServlet("/updateProfile")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1MB
    maxFileSize = 1024 * 1024 * 5,   // 5MB
    maxRequestSize = 1024 * 1024 * 10 // 10MB
)
public class UpdateProfileServlet extends HttpServlet {
    private UserDao userDao = new UserDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            // 获取当前用户
            Users currentUser = (Users) request.getSession().getAttribute("user");
            if (currentUser == null) {
                out.print("{\"success\": false, \"error\": \"请先登录\"}");
                return;
            }

            // 获取表单数据
            String uname = request.getParameter("uname");
            String usign = request.getParameter("usign");
            String uphonenumber = request.getParameter("uphonenumber");
            String uemail = request.getParameter("uemail");
            String ugender = request.getParameter("ugender");
            String ubirthday = request.getParameter("ubirthday");
            String uhobby = request.getParameter("uhobby");

            // 验证用户名不能为空
            if (uname == null || uname.trim().isEmpty()) {
                out.print("{\"success\": false, \"error\": \"用户名不能为空\"}");
                return;
            }

            // 处理头像上传
            String imagePath = null;
            try {
                Part filePart = request.getPart("uimage");
                if (filePart != null && filePart.getSize() > 0) {
                    // 获取项目根目录
                    String projectRoot = request.getServletContext().getRealPath("/");
                    // 设置上传目录
                    String uploadDir = projectRoot + "static/images/avatars";
                    // 确保目录存在
                    File uploadDirFile = new File(uploadDir);
                    if (!uploadDirFile.exists()) {
                        uploadDirFile.mkdirs();
                    }

                    // 生成唯一文件名
                    String fileName = UUID.randomUUID().toString() + getFileExtension(filePart);
                    String filePath = uploadDir + File.separator + fileName;
                    
                    // 保存文件
                    filePart.write(filePath);
                    
                    // 设置图片路径（相对于webapp目录）
                    imagePath = "static/images/avatars/" + fileName;
                }
            } catch (Exception e) {
                System.out.println("处理头像上传时出错: " + e.getMessage());
                // 头像上传失败不影响其他信息更新
            }

            // 更新用户信息
            currentUser.setUname(uname.trim());
            currentUser.setUsign(usign);
            currentUser.setUphonenumber(uphonenumber);
            currentUser.setUemail(uemail);
            currentUser.setUgender(Boolean.parseBoolean(ugender));
            currentUser.setUbirthday(ubirthday);
            currentUser.setUhobby(uhobby);
            if (imagePath != null) {
                currentUser.setUimage(imagePath);
            }

            try {
                // 保存到数据库
                userDao.update(currentUser);
                
                // 更新session中的用户信息
                request.getSession().setAttribute("user", currentUser);
                
                out.print("{\"success\": true}");
            } catch (SQLException e) {
                e.printStackTrace();
                out.print("{\"success\": false, \"error\": \"数据库更新失败: " + e.getMessage() + "\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"error\": \"更新失败: " + e.getMessage() + "\"}");
        } finally {
            out.close();
        }
    }

    private String getFileExtension(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                String fileName = s.substring(s.indexOf("=") + 2, s.length() - 1);
                return fileName.substring(fileName.lastIndexOf("."));
            }
        }
        return "";
    }
} 