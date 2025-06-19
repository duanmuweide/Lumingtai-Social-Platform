package cn.qdu.service;

import cn.qdu.dao.Conversationsdao;
import cn.qdu.dao.RelationshipDao;
import cn.qdu.dao.UserDao;
import cn.qdu.entity.Conversations;
import cn.qdu.entity.Relationship;
import cn.qdu.entity.Users;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

@WebServlet("/chat")
public class ChatServlet extends HttpServlet {
    private UserDao userDao = new UserDao();
    private RelationshipDao relationshipDao = new RelationshipDao();
    private Conversationsdao conversationsDao = new Conversationsdao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Users currentUser = (Users) session.getAttribute("user");
        System.out.println("当前用户ID: " + currentUser.getUid());

        // 获取好友列表（包含好友详细信息）
        List<Map<String, Object>> friendList = getFriendList(currentUser.getUid());
        System.out.println("好友列表大小: " + friendList.size());

        // 设置默认选中的好友（第一个好友）
        int currentFriendId = 0;
        String friendIdParam = request.getParameter("friendId");
        if (friendIdParam != null && !friendIdParam.isEmpty()) {
            currentFriendId = Integer.parseInt(friendIdParam);
        } else if (!friendList.isEmpty()) {
            currentFriendId = (Integer) friendList.get(0).get("friendId");
        }

        // 获取聊天记录
        List<Conversations> messages = new ArrayList<>();
        if (currentFriendId > 0) {
            messages = conversationsDao.getConversations(currentUser.getUid(), currentFriendId);
        }

        request.setAttribute("currentUser", currentUser);
        request.setAttribute("friendList", friendList);
        request.setAttribute("messages", messages);
        request.setAttribute("currentFriendId", currentFriendId);

        request.getRequestDispatcher("/chat.jsp").forward(request, response);
        System.out.println("好友关系数量: " + relationshipDao.getFriends(currentUser.getUid()).size());
        System.out.println("最终好友列表大小: " + friendList.size());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                out.print("{\"success\": false, \"error\": \"未登录\"}");
                return;
            }

            Users currentUser = (Users) session.getAttribute("user");
            String action = request.getParameter("action");

            if ("send".equals(action)) {
                // 发送消息
                int receiverId = Integer.parseInt(request.getParameter("receiverId"));
                String message = request.getParameter("message");

                Conversations conversation = new Conversations();
                conversation.setCsenderid(currentUser.getUid());
                conversation.setCreceiverid(receiverId);
                conversation.setCmessage(message);
                conversation.setCdate(new Date().toString());

                int result = conversationsDao.insert(conversation);
                out.print("{\"success\": " + (result > 0) + "}");

            } else if ("refresh".equals(action)) {
                // 刷新消息
                int friendId = Integer.parseInt(request.getParameter("friendId"));
                List<Conversations> messages = conversationsDao.getConversations(currentUser.getUid(), friendId);

                // 构建JSON响应
                out.print(buildMessagesJson(messages));
            } else if ("friends".equals(action)) {
                // 获取好友列表
                List<Map<String, Object>> friendList = getFriendList(currentUser.getUid());
                out.print(buildFriendListJson(friendList));
            }
        } catch (Exception e) {
            out.print("{\"success\": false, \"error\": \"服务器内部错误: " + e.getMessage() + "\"}");
            e.printStackTrace();
        } finally {
            out.close();
        }
    }

    private List<Map<String, Object>> getFriendList(int userId) {
        List<Relationship> relationships = relationshipDao.getFriends(userId);
        List<Map<String, Object>> friendList = new ArrayList<>();

        for (Relationship rel : relationships) {
            Users friend =  userDao.selectById(rel.getRfiendid()).get(0);
            if (friend != null) {
                Map<String, Object> friendInfo = new HashMap<>();
                friendInfo.put("friendId", friend.getUid());
                friendInfo.put("friendName", friend.getUname());
                friendInfo.put("avatar", friend.getUimage() != null ? friend.getUimage() : "default-avatar.jpg");
                friendInfo.put("lastMessage", getLastMessage(userId, friend.getUid()));
                friendList.add(friendInfo);
            }
        }
        return friendList;
    }

    private String getLastMessage(int user1, int user2) {
        List<Conversations> messages = conversationsDao.getConversations(user1, user2);
        if (!messages.isEmpty()) {
            return messages.get(messages.size() - 1).getCmessage();
        }
        return "暂无消息";
    }

    private String buildMessagesJson(List<Conversations> messages) {
        StringBuilder json = new StringBuilder("{\"success\": true, \"messages\": [");
        for (Conversations msg : messages) {
            json.append("{\"senderId\":").append(msg.getCsenderid())
                    .append(",\"receiverId\":").append(msg.getCreceiverid())
                    .append(",\"message\":\"").append(escapeJson(msg.getCmessage()))
                    .append("\",\"date\":\"").append(msg.getCdate())
                    .append("\"},");
        }
        if (!messages.isEmpty()) {
            json.deleteCharAt(json.length() - 1);
        }
        json.append("]}");
        return json.toString();
    }

    private String buildFriendListJson(List<Map<String, Object>> friendList) {
        StringBuilder json = new StringBuilder("{\"success\": true, \"friends\": [");
        for (Map<String, Object> friend : friendList) {
            json.append("{\"friendId\":").append(friend.get("friendId"))
                    .append(",\"friendName\":\"").append(escapeJson((String)friend.get("friendName")))
                    .append("\",\"avatar\":\"").append(escapeJson((String)friend.get("avatar")))
                    .append("\",\"lastMessage\":\"").append(escapeJson((String)friend.get("lastMessage")))
                    .append("\"},");
        }
        if (!friendList.isEmpty()) {
            json.deleteCharAt(json.length() - 1);
        }
        json.append("]}");
        return json.toString();
    }

    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}