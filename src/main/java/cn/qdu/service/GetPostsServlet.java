package cn.qdu.service;

import cn.qdu.dao.PostDao;
import cn.qdu.dao.UserDao;
import cn.qdu.dao.CommentDao;
import cn.qdu.dao.LikeDao;
import cn.qdu.entity.Posts;
import cn.qdu.entity.Users;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/posts")
public class GetPostsServlet extends HttpServlet {
    private PostDao postDao = new PostDao();
    private UserDao userDao = new UserDao();
    private CommentDao commentDao = new CommentDao();
    private LikeDao likeDao = new LikeDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            // 获取所有帖子
            List<Posts> posts = postDao.selectAll();
            System.out.println("查询到的帖子数量: " + (posts != null ? posts.size() : 0));
            
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
                        // 确保图片路径正确，避免重复添加前缀
                        if (!image.startsWith("static/images/posts/") && !image.startsWith("static/")) {
                            image = "static/images/posts/" + image;
                        }
                    }

                    // 获取点赞数和评论数
                    int likeCount = 0;
                    int commentCount = 0;
                    boolean userLiked = false;
                    try {
                        likeCount = likeDao.getLikeCount(post.getPid());
                        commentCount = commentDao.getCommentCount(post.getPid());
                        // 检查当前用户是否已点赞
                        Users currentUser = (Users) request.getSession().getAttribute("user");
                        if (currentUser != null) {
                            userLiked = likeDao.hasUserLiked(post.getPid(), currentUser.getUid());
                        }
                    } catch (SQLException e) {
                        System.out.println("获取统计信息数据库错误: " + e.getMessage());
                        e.printStackTrace();
                    } catch (Exception e) {
                        System.out.println("获取统计信息失败: " + e.getMessage());
                        e.printStackTrace();
                    }

                    // 调试信息
                    System.out.println("处理帖子 " + (i + 1) + ":");
                    System.out.println("  ID: " + post.getPid());
                    System.out.println("  用户ID: " + post.getPuid());
                    System.out.println("  原始内容: " + post.getPmessage());
                    System.out.println("  处理后内容: " + content);
                    System.out.println("  时间: " + post.getPdate());
                    System.out.println("  图片: " + image);
                    System.out.println("  用户名: " + userName);
                    System.out.println("  用户图片: " + userImage);
                    System.out.println("  点赞数: " + likeCount);
                    System.out.println("  评论数: " + commentCount);
                    System.out.println("  用户已点赞: " + userLiked);

                    json.append("{")
                        .append("\"id\":").append(post.getPid()).append(",")
                        .append("\"content\":\"").append(content).append("\",")
                        .append("\"time\":\"").append(post.getPdate()).append("\",")
                        .append("\"image\":\"").append(image).append("\",")
                        .append("\"userName\":\"").append(userName).append("\",")
                        .append("\"userImage\":\"").append(userImage).append("\",")
                        .append("\"likeCount\":").append(likeCount).append(",")
                        .append("\"commentCount\":").append(commentCount).append(",")
                        .append("\"userLiked\":").append(userLiked)
                        .append("}");
                }
            }

            json.append("]}");
            String finalJson = json.toString();
            System.out.println("最终JSON响应: " + finalJson);
            out.print(finalJson);
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"error\": \"获取动态列表失败: " + e.getMessage() + "\"}");
        } finally {
            out.close();
        }
    }
} 