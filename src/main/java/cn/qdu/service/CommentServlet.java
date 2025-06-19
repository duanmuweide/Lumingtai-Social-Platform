package cn.qdu.service;

import cn.qdu.dao.CommentDao;
import cn.qdu.dao.UserDao;
import cn.qdu.dao.PostDao;
import cn.qdu.entity.Comments;
import cn.qdu.entity.Users;
import cn.qdu.entity.Posts;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.sql.SQLException;

@WebServlet("/comment")
public class CommentServlet extends HttpServlet {
    private CommentDao commentDao = new CommentDao();
    private UserDao userDao = new UserDao();
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

            String action = request.getParameter("action");
            
            if ("add".equals(action)) {
                // 添加评论
                addComment(request, response, currentUser);
            } else if ("like".equals(action)) {
                // 点赞/取消点赞
                toggleLike(request, response, currentUser);
            } else {
                out.print("{\"success\": false, \"error\": \"无效的操作\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"error\": \"操作失败: " + e.getMessage() + "\"}");
        } finally {
            out.close();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            String postId = request.getParameter("postId");
            if (postId != null) {
                // 获取帖子的评论列表
                getCommentsByPostId(Integer.parseInt(postId), response);
            } else {
                out.print("{\"success\": false, \"error\": \"缺少帖子ID参数\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"error\": \"获取评论失败: " + e.getMessage() + "\"}");
        } finally {
            out.close();
        }
    }

    /**
     * 检查帖子是否存在
     */
    private boolean isPostExists(int postId) {
        try {
            Posts post = new Posts();
            post.setPid(postId);
            List<Posts> posts = postDao.selectByPid(postId);
            return posts != null && !posts.isEmpty();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 添加评论
     */
    private void addComment(HttpServletRequest request, HttpServletResponse response, Users currentUser) 
            throws Exception {
        PrintWriter out = response.getWriter();
        
        String postId = request.getParameter("postId");
        String message = request.getParameter("message");
        
        System.out.println("=== 添加评论调试信息 ===");
        System.out.println("postId: " + postId);
        System.out.println("message: " + message);
        System.out.println("currentUser: " + (currentUser != null ? currentUser.getUid() : "null"));
        
        if (postId == null || message == null || message.trim().isEmpty()) {
            out.print("{\"success\": false, \"error\": \"评论内容不能为空\"}");
            return;
        }

        int pid = Integer.parseInt(postId);
        
        // 检查帖子是否存在
        if (!isPostExists(pid)) {
            System.out.println("帖子不存在: " + pid);
            out.print("{\"success\": false, \"error\": \"帖子不存在\"}");
            return;
        }

        int uid = currentUser.getUid();

        try {
            System.out.println("创建新评论记录...");
            // 创建新评论对象
            Comments comment = new Comments();
            comment.setCid(pid);
            comment.setCuid(uid);
            comment.setCmessage(message.trim());
            comment.setClike(false); // 评论时默认不点赞
            comment.setCfile(null); // 确保cfile字段不为null
            
            // 设置时间
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            comment.setCdate(sdf.format(new Date()));

            // 保存到数据库
            commentDao.insert(comment);
            System.out.println("评论插入完成");
            
            out.print("{\"success\": true, \"message\": \"评论发布成功\"}");
        } catch (SQLException e) {
            System.out.println("=== 添加评论SQL错误 ===");
            System.out.println("错误信息: " + e.getMessage());
            System.out.println("SQL状态: " + e.getSQLState());
            System.out.println("错误代码: " + e.getErrorCode());
            e.printStackTrace();
            out.print("{\"success\": false, \"error\": \"数据库操作失败: " + e.getMessage() + "\"}");
        } catch (Exception e) {
            System.out.println("=== 添加评论其他错误 ===");
            System.out.println("错误信息: " + e.getMessage());
            e.printStackTrace();
            out.print("{\"success\": false, \"error\": \"操作失败: " + e.getMessage() + "\"}");
        }
    }

    /**
     * 点赞/取消点赞
     */
    private void toggleLike(HttpServletRequest request, HttpServletResponse response, Users currentUser) 
            throws Exception {
        PrintWriter out = response.getWriter();
        
        String postId = request.getParameter("postId");
        
        System.out.println("=== 点赞操作调试信息 ===");
        System.out.println("postId: " + postId);
        System.out.println("currentUser: " + (currentUser != null ? currentUser.getUid() : "null"));
        
        if (postId == null) {
            out.print("{\"success\": false, \"error\": \"缺少帖子ID参数\"}");
            return;
        }

        int pid = Integer.parseInt(postId);
        
        // 检查帖子是否存在
        if (!isPostExists(pid)) {
            System.out.println("帖子不存在: " + pid);
            out.print("{\"success\": false, \"error\": \"帖子不存在\"}");
            return;
        }

        int uid = currentUser.getUid();

        try {
            System.out.println("检查用户点赞状态...");
            // 检查是否已经点赞
            boolean hasLiked = commentDao.hasUserLiked(pid, uid);
            System.out.println("用户是否已点赞: " + hasLiked);
            
            if (hasLiked) {
                System.out.println("用户已点赞，执行取消点赞...");
                // 用户已点赞，需要取消点赞
                // 直接删除该用户的点赞记录
                commentDao.deleteUserLike(pid, uid);
                System.out.println("点赞记录已删除");
            } else {
                System.out.println("用户未点赞，执行点赞...");
                // 用户未点赞，需要添加点赞记录
                Comments likeComment = new Comments();
                likeComment.setCid(pid);
                likeComment.setCuid(uid);
                likeComment.setClike(true);
                likeComment.setCmessage(""); // 点赞记录使用空字符串而不是null
                likeComment.setCfile(null);
                
                // 设置时间
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                likeComment.setCdate(sdf.format(new Date()));

                // 插入点赞记录
                commentDao.insert(likeComment);
                System.out.println("点赞记录已创建");
            }

            System.out.println("获取最新点赞数...");
            // 获取最新的点赞数
            int likeCount = commentDao.getLikeCount(pid);
            System.out.println("最新点赞数: " + likeCount);
            
            out.print("{\"success\": true, \"liked\": " + !hasLiked + ", \"likeCount\": " + likeCount + "}");
        } catch (SQLException e) {
            System.out.println("=== 点赞操作SQL错误 ===");
            System.out.println("错误信息: " + e.getMessage());
            System.out.println("SQL状态: " + e.getSQLState());
            System.out.println("错误代码: " + e.getErrorCode());
            e.printStackTrace();
            out.print("{\"success\": false, \"error\": \"数据库操作失败: " + e.getMessage() + "\"}");
        } catch (Exception e) {
            System.out.println("=== 点赞操作其他错误 ===");
            System.out.println("错误信息: " + e.getMessage());
            e.printStackTrace();
            out.print("{\"success\": false, \"error\": \"操作失败: " + e.getMessage() + "\"}");
        }
    }

    /**
     * 获取帖子的评论列表
     */
    private void getCommentsByPostId(int postId, HttpServletResponse response) throws Exception {
        PrintWriter out = response.getWriter();
        
        // 检查帖子是否存在
        if (!isPostExists(postId)) {
            out.print("{\"success\": false, \"error\": \"帖子不存在\"}");
            return;
        }
        
        List<Comments> comments = commentDao.selectCommentsByPostId(postId);
        
        StringBuilder json = new StringBuilder();
        json.append("{\"success\": true, \"data\": [");

        if (comments != null && !comments.isEmpty()) {
            int commentIndex = 0;
            for (Comments comment : comments) {
                // 只显示真正的评论，过滤掉点赞记录和空评论
                if (comment.getClike() || (comment.getCmessage() == null || comment.getCmessage().trim().isEmpty())) {
                    continue;
                }
                
                if (commentIndex > 0) json.append(",");
                
                // 获取评论用户信息
                List<Users> users = userDao.selectById(comment.getCuid());
                String userName = "未知用户";
                String userImage = "static/images/default/default-wll.jpg";
                
                if (users != null && !users.isEmpty()) {
                    Users user = users.get(0);
                    userName = user.getUname();
                    if (user.getUimage() != null && !user.getUimage().isEmpty()) {
                        userImage = user.getUimage();
                    }
                }

                // 处理评论内容
                String message = comment.getCmessage();
                if (message == null) {
                    message = "";
                } else {
                    // 转义特殊字符
                    message = message.replace("\\", "\\\\")
                            .replace("\"", "\\\"")
                            .replace("\t", "\\t")
                            .replace("\r\n", "\n")
                            .replace("\r", "\n");
                    // 将换行符转换为HTML的<br>标签
                    message = message.replace("\n", "<br>");
                }

                json.append("{")
                    .append("\"cid\":").append(comment.getCid()).append(",")
                    .append("\"cuid\":").append(comment.getCuid()).append(",")
                    .append("\"clike\":").append(comment.getClike()).append(",")
                    .append("\"cfile\":\"").append(comment.getCfile() != null ? comment.getCfile() : "").append("\",")
                    .append("\"cmessage\":\"").append(message).append("\",")
                    .append("\"cdate\":\"").append(comment.getCdate()).append("\",")
                    .append("\"userName\":\"").append(userName).append("\",")
                    .append("\"userImage\":\"").append(userImage).append("\"")
                    .append("}");
                
                commentIndex++;
            }
        }

        json.append("]}");
        out.print(json.toString());
    }
} 