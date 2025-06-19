package cn.qdu.service;

import cn.qdu.dao.FriendrequestsDao;
import cn.qdu.dao.RelationshipDao;
import cn.qdu.dao.UserDao;
import cn.qdu.entity.FriendRequests;
import cn.qdu.entity.Relationship;
import cn.qdu.entity.Users;
import com.fasterxml.jackson.databind.ObjectMapper;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/messages")
public class MessagesServlet extends HttpServlet {
    private FriendrequestsDao friendDAO = new FriendrequestsDao();
    private ObjectMapper objectMapper = new ObjectMapper();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("refreshRequests".equals(action)) {
            // 处理AJAX刷新请求
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();

            List<FriendRequests> friendRequests = null;
            try {
                friendRequests = friendDAO.selectByRecid(currentUser.getUid());
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }

            if (friendRequests != null && !friendRequests.isEmpty()) {
                for (FriendRequests req : friendRequests) {

                    UserDao userDao = new UserDao();
                    List<Users> users = userDao.selectById(req.getReqid());
                    Users user = users.get(0);

                    out.println("<div class=\"request-item\" data-request-id=\"" + req.getReqid() + "\">");
                    out.println("  <img src=\"" + (user.getUimage() != null ? user.getUimage() : "default-avatar.jpg") + "\" ");
                    out.println("       class=\"request-avatar\" alt=\"用户头像\">");
                    out.println("  <div class=\"request-info\">");
                    out.println("    <div class=\"request-name\">" + user.getUname() + "</div>");
                    out.println("    <div class=\"request-id\">ID: " + user.getUid() + "</div>");
                    out.println("    <div class=\"request-message\">验证消息: " + (req.getMessage() != null ? req.getMessage() : "无") + "</div>");
                    out.println("  </div>");
                    out.println("  <div class=\"request-actions\">");
                    out.println("    <button class=\"layui-btn layui-btn-sm layui-btn-normal accept-btn\">接受</button>");
                    out.println("    <button class=\"layui-btn layui-btn-sm layui-btn-danger reject-btn\">拒绝</button>");
                    out.println("  </div>");
                    out.println("</div>");
                }
            } else {
                out.println("<div class=\"no-requests\">");
                out.println("  <i class=\"layui-icon layui-icon-face-smile\" style=\"font-size: 50px;\"></i>");
                out.println("  <div style=\"margin-top: 15px; font-size: 16px;\">暂无好友请求</div>");
                out.println("</div>");
            }
            out.close();
            return;
        }

        // 普通GET请求，渲染整个页面
        List<FriendRequests> friendRequests = null;
        try {
            friendRequests = friendDAO.selectByRecid(currentUser.getUid());
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        request.setAttribute("friendRequests", friendRequests);
        request.getRequestDispatcher("/messages.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // 使用Map构建响应数据
        Map<String, Object> responseMap = new HashMap<>();
        PrintWriter out = response.getWriter();

        try {
            String action = request.getParameter("action");

            if ("handleRequest".equals(action)) {
                handleFriendRequest(request, currentUser, responseMap);
            }

            // 将Map转换为JSON字符串
            String jsonResponse = objectMapper.writeValueAsString(responseMap);
            out.print(jsonResponse);
        } catch (Exception e) {
            // 错误处理
            responseMap.put("success", false);
            responseMap.put("message", "服务器错误: " + e.getMessage());
            out.print(objectMapper.writeValueAsString(responseMap));
            e.printStackTrace();
        } finally {
            out.flush();
            out.close();
        }
    }

    private void handleFriendRequest(HttpServletRequest request, Users currentUser, Map<String, Object> responseMap) {
        try {
            int requestId = Integer.parseInt(request.getParameter("requestId"));
            String type = request.getParameter("type");

            FriendRequests friendRequest = friendDAO.selectBytwoid(requestId, currentUser.getUid());
            System.out.println(friendRequest);

            if (friendRequest == null || friendRequest.getRecid() != currentUser.getUid()) {
                responseMap.put("success", false);
                responseMap.put("message", "请求不存在或无权操作");
                return;
            }

            boolean success = false;

            if ("accept".equals(type)) {
                // 接受好友请求
                success = friendDAO.acceptFriendRequest(requestId, currentUser.getUid());

                if (success) {
                    // 建立好友关系
                    Relationship s1 = new Relationship();
                    Relationship s2 = new Relationship();

                    s1.setRuid(friendRequest.getReqid());
                    s1.setRfiendid(friendRequest.getRecid());
                    s2.setRuid(friendRequest.getRecid());
                    s2.setRfiendid(friendRequest.getReqid());

                    LocalDateTime currentDateTime = LocalDateTime.now();
                    // 创建DateTimeFormatter对象，并指定日期格式
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
                    // 将日期时间转换为字符串
                    String dateString = currentDateTime.format(formatter);

                    s1.setRtype(1);
                    s1.setRdate(dateString);
                    s2.setRtype(1);
                    s2.setRdate(dateString);
                    RelationshipDao rdao = new RelationshipDao();
                    success = rdao.insert(s1) && rdao.insert(s2);

                }
            } else if ("reject".equals(type)) {
                // 拒绝好友请求
                success = friendDAO.rejectFriendRequest(requestId, currentUser.getUid());
            }

            responseMap.put("success", success);
            responseMap.put("message", success ? "操作成功" : "操作失败");
        } catch (NumberFormatException e) {
            responseMap.put("success", false);
            responseMap.put("message", "请求ID格式不正确");
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}