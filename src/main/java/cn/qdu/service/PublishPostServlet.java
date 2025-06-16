package cn.qdu.service;

import cn.qdu.dao.PostDao;
import cn.qdu.entity.Posts;
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
import java.util.UUID;

@WebServlet("/post")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 10 * 1024 * 1024,  // 10 MB
    maxRequestSize = 20 * 1024 * 1024 // 20 MB
)
public class PublishPostServlet extends HttpServlet {
    private PostDao postDao = new PostDao();

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

            // 获取帖子内容
            String content = request.getParameter("content");
            if (content == null) content = "";

            // 处理图片上传
            String imagePath = null;
            try {
                Part filePart = request.getPart("image");
                if (filePart != null && filePart.getSize() > 0) {
                    // 获取项目根目录
                    String projectRoot = request.getServletContext().getRealPath("/");
                    // 设置上传目录
                    String uploadDir = projectRoot + "static/images/posts";
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
                    imagePath = "static/images/posts/" + fileName;
                    
                    System.out.println("图片已保存到: " + filePath);
                }
            } catch (Exception e) {
                System.out.println("处理图片上传时出错: " + e.getMessage());
                // 图片上传失败不影响帖子发布
            }

            // 创建帖子对象
            Posts post = new Posts();
            post.setPuid(currentUser.getUid());
            post.setPmessage(content);
            post.setPfile(imagePath);
            // 格式化时间为 yyyy-MM-dd HH:mm:ss
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            post.setPdate(sdf.format(new java.util.Date()));

            // 保存到数据库
            postDao.insert(post);
            out.print("{\"success\": true}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"error\": \"发布失败: " + e.getMessage() + "\"}");
        } finally {
            out.close();
        }
    }

    private String getFileExtension(Part part) {
        String submittedFileName = part.getSubmittedFileName();
        return submittedFileName.substring(submittedFileName.lastIndexOf("."));
    }
} 