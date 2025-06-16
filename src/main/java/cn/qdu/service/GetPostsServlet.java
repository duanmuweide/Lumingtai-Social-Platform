package cn.qdu.service;

import cn.qdu.dao.PostDao;
import cn.qdu.dao.UserDao;
import cn.qdu.entity.Posts;
import cn.qdu.entity.Users;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/posts")
public class GetPostsServlet extends HttpServlet {
    private PostDao postDao = new PostDao();
    private UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            // 获取所有帖子
            List<Posts> posts = postDao.selectAll();
            
            StringBuilder json = new StringBuilder();
            json.append("{\"success\": true, \"data\": [");

            if (posts != null && !posts.isEmpty()) {
                // 预先获取所有相关用户信息
                Map<Integer, Users> userMap = new HashMap<>();
                for (Posts post : posts) {
                    if (!userMap.containsKey(post.getPuid())) {
                        List<Users> users = userDao.selectById(post.getPuid());
                        if (users != null && !users.isEmpty()) {
                            userMap.put(post.getPuid(), users.get(0));
                        }
                    }
                }

                for (int i = 0; i < posts.size(); i++) {
                    Posts post = posts.get(i);
                    if (i > 0) json.append(",");
                    
                    // 获取发帖用户信息
                    Users user = userMap.get(post.getPuid());
                    String userName = "未知用户";
                    String userImage = "static/images/default/default-wll.jpg";
                    
                    if (user != null) {
                        userName = user.getUname();
                        if (user.getUimage() != null && !user.getUimage().isEmpty()) {
                            userImage = user.getUimage();
                        }
                    }

                    // 处理内容
                    String content = post.getPmessage();
                    if (content == null) {
                        content = "";
                    } else {
                        // 转义特殊字符，但保留换行符
                        content = content.replace("\\", "\\\\")
                                .replace("\"", "\\\"")
                                .replace("\t", "\\t")
                                .replace("\r\n", "\n")  // 统一换行符
                                .replace("\r", "\n");   // 统一换行符
                        // 将换行符转换为HTML的<br>标签
                        content = content.replace("\n", "<br>");
                    }
                    
                    // 处理图片路径
                    String image = post.getPfile();
                    if (image == null || image.isEmpty()) {
                        image = "";
                    } else {
                        // 确保图片路径正确
                        if (!image.startsWith("static/")) {
                            image = "static/images/posts/" + image;
                        }
                    }

                    json.append("{")
                        .append("\"id\":").append(post.getPid()).append(",")
                        .append("\"content\":\"").append(content).append("\",")
                        .append("\"time\":\"").append(post.getPdate()).append("\",")
                        .append("\"image\":\"").append(image).append("\",")
                        .append("\"userName\":\"").append(userName).append("\",")
                        .append("\"userImage\":\"").append(userImage).append("\"")
                        .append("}");
                }
            }

            json.append("]}");
            out.print(json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"error\": \"获取动态列表失败: " + e.getMessage() + "\"}");
        } finally {
            out.close();
        }
    }
} 