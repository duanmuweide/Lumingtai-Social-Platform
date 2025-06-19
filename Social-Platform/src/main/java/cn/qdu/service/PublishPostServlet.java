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
                    String fileName = UUID.randomUUID().toString() + getFileExtension(filePart);
                    String uploadPath = getServletContext().getRealPath("/static/images/posts");
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    
                    // 添加调试信息
                    System.out.println("上传路径: " + uploadPath);
                    System.out.println("文件名: " + fileName);
                    System.out.println("完整路径: " + uploadPath + File.separator + fileName);
                    System.out.println("目录是否存在: " + uploadDir.exists());
                    System.out.println("目录是否可写: " + uploadDir.canWrite());
                    
                    filePart.write(uploadPath + File.separator + fileName);
                    imagePath = "static/images/posts/" + fileName;
                    
                    // 验证文件是否成功保存
                    File savedFile = new File(uploadPath + File.separator + fileName);
                    System.out.println("文件是否保存成功: " + savedFile.exists());
                    System.out.println("文件大小: " + savedFile.length());
                }
            } catch (Exception e) {
                System.out.println("处理图片上传时出错: " + e.getMessage());
                e.printStackTrace();
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