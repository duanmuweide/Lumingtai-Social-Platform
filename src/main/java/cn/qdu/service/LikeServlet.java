package cn.qdu.service;

import cn.qdu.dao.LikeDao;
import cn.qdu.entity.Users;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/like")
public class LikeServlet extends HttpServlet {
    private LikeDao likeDao = new LikeDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            Users currentUser = (Users) request.getSession().getAttribute("user");
            if (currentUser == null) {
                out.print("{\"success\": false, \"error\": \"请先登录\"}");
                return;
            }
            int postId = Integer.parseInt(request.getParameter("postId"));
            int userId = currentUser.getUid();

            boolean liked = likeDao.hasUserLiked(postId, userId);
            if (liked) {
                likeDao.deleteLike(postId, userId);
            } else {
                String ldate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
                likeDao.insertLike(postId, userId, ldate);
            }
            int likeCount = likeDao.getLikeCount(postId);
            out.print("{\"success\": true, \"liked\": " + !liked + ", \"likeCount\": " + likeCount + "}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"error\": \"服务器错误\"}");
        } finally {
            out.close();
        }
    }
} 