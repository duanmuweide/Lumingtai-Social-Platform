package cn.qdu.service;

import cn.qdu.dao.Conversationsdao;
import cn.qdu.dao.FriendrequestsDao;
import cn.qdu.dao.RelationshipDao;
import cn.qdu.dao.UserDao;
import cn.qdu.entity.Conversations;
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

        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // 使用Map代替JSONObject
        Map<String, Object> jsonMap = new HashMap<>();
        PrintWriter out = response.getWriter();
        ObjectMapper mapper = new ObjectMapper();

        try {
            String action = request.getParameter("action");

            if ("addFriend".equals(action)) {
                handleAddFriend(request, currentUser, jsonMap);
            } else if ("send".equals(action)) {
                // 发送消息
                int receiverId = Integer.parseInt(request.getParameter("receiverId"));
                String message = request.getParameter("message");

                Conversations conversation = new Conversations();
                conversation.setCsenderid(currentUser.getUid());
                conversation.setCreceiverid(receiverId);
                conversation.setCmessage(message);
                conversation.setCdate(new Date().toString());

                int result = conversationsDao.insert(conversation);
                jsonMap.put("success", result > 0);

            } else if ("refresh".equals(action)) {
                // 刷新消息
                int friendId = Integer.parseInt(request.getParameter("friendId"));
                List<Conversations> messages = conversationsDao.getConversations(currentUser.getUid(), friendId);

                // 转换为前端需要的格式
                List<Map<String, Object>> messageList = new ArrayList<>();
                for (Conversations msg : messages) {
                    Map<String, Object> messageMap = new HashMap<>();
                    messageMap.put("senderId", msg.getCsenderid());
                    messageMap.put("receiverId", msg.getCreceiverid());
                    messageMap.put("message", msg.getCmessage());
                    messageMap.put("date", msg.getCdate()); // 确保这是字符串格式
                    messageList.add(messageMap);
                }

                jsonMap.put("success", true);
                jsonMap.put("messages", messageList); // 使用转换后的列表


            } else if ("friends".equals(action)) {
                // 获取好友列表
                List<Map<String, Object>> friendList = getFriendList(currentUser.getUid());
                jsonMap.put("success", true);
                jsonMap.put("friends", friendList);

            }else if("deleteFriend".equals(action)){
                int friendId = Integer.parseInt(request.getParameter("friendId"));
                // 删除两个关系以及他们的所有消息以及他们的请求验证
                RelationshipDao relationshipDao = new RelationshipDao();
                Relationship relationship = new Relationship();

                relationship.setRuid(currentUser.getUid());
                relationship.setRfiendid(friendId);
                relationshipDao.delete(relationship);
                relationship.setRuid(friendId);
                relationship.setRfiendid(currentUser.getUid());
                relationshipDao.delete(relationship);

                // 删除消息
                Conversationsdao conversationsDao = new Conversationsdao();
                Conversations conversation = new Conversations();

                List<Conversations> con = conversationsDao.selectBytwoid(currentUser.getUid(), friendId);
                if(con.size()>0){
                    for(Conversations c : con){
                        conversationsDao.delete(c);
                    }
                }

                List<Conversations> con2 = conversationsDao.selectBytwoid(friendId, currentUser.getUid());
                if(con2.size()>0){
                    for(Conversations c : con2){
                        conversationsDao.delete(c);
                    }
                }

                // 删除请求表
                FriendrequestsDao friendrequestsDao = new FriendrequestsDao();
                FriendRequests f = FriendrequestsDao.selectBytwoidandstatus(currentUser.getUid(), friendId);
                if(f != null){
                    friendrequestsDao.delete(f);
                }else {
                    f = FriendrequestsDao.selectBytwoidandstatus(friendId, currentUser.getUid());
                    friendrequestsDao.delete(f);
                }


                jsonMap.put("success", true);

            }

            // 将Map转换为JSON字符串
            String json = mapper.writeValueAsString(jsonMap);
            out.print(json);
        } catch (Exception e) {
            // 错误处理
            jsonMap.put("success", false);
            jsonMap.put("message", "服务器错误: " + e.getMessage());
            out.print(mapper.writeValueAsString(jsonMap));
            e.printStackTrace();
        } finally {
            out.flush();
            out.close();
        }
    }

    private void handleAddFriend(HttpServletRequest request, Users currentUser, Map<String, Object> jsonMap) {
        try {
            int friendId = Integer.parseInt(request.getParameter("friendId"));
            String message = request.getParameter("message");

            // 1. 检查好友ID是否存在
            Users friend = userDao.selectById(friendId).get(0);
            if (friend == null) {
                jsonMap.put("success", false);
                jsonMap.put("message", "用户不存在");
                return;
            }

            // 2. 检查是否是自己
            if (friendId == currentUser.getUid()) {
                jsonMap.put("success", false);
                jsonMap.put("message", "不能添加自己为好友");
                return;
            }

            // 3. 检查是否已经是好友
            if (isFriend(currentUser.getUid(), friendId)) {
                jsonMap.put("success", false);
                jsonMap.put("message", "你们已经是好友了");
                return;
            }

            // 4. 检查是否已有待处理的好友请求
            if (hasPendingRequest(currentUser.getUid(), friendId)) {
                jsonMap.put("success", false);
                jsonMap.put("message", "已发送过好友请求，请等待对方处理");
                return;
            }

            // 5. 创建好友请求记录
            boolean success = createFriendRequest(currentUser.getUid(), friendId, message);

            if (success) {
                jsonMap.put("success", true);
                jsonMap.put("message", "好友请求已发送");
            } else {
                jsonMap.put("success", false);
                jsonMap.put("message", "发送好友请求失败，请重试");
            }
        } catch (NumberFormatException e) {
            jsonMap.put("success", false);
            jsonMap.put("message", "好友ID格式不正确");
        }
    }

    private boolean isFriend(int userId1, int userId2) {
        List<Relationship> relationships = relationshipDao.getFriends(userId1);
        for (Relationship rel : relationships) {
            if (rel.getRfiendid() == userId2) {
                return true;
            }
        }
        return false;
    }

    private boolean hasPendingRequest(int requesterId, int receiverId) {
        // 这里需要实现检查是否有待处理的好友请求的逻辑
        // 假设我们有一个方法来检查
        return FriendrequestsDao.hasPendingRequest(requesterId, receiverId);
    }

    private boolean createFriendRequest(int requesterId, int receiverId, String message) {
        // 这里需要实现创建好友请求的逻辑
        // 假设我们有一个方法来创建好友请求
        return FriendrequestsDao.createFriendRequest(requesterId, receiverId, message);
    }

    private List<Map<String, Object>> getFriendList(int userId) {
        List<Relationship> relationships = relationshipDao.getFriends(userId);
        List<Map<String, Object>> friendList = new ArrayList<>();

        for (Relationship rel : relationships) {
            Users friend = userDao.selectById(rel.getRfiendid()).get(0);
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
}