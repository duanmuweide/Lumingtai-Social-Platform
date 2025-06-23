package cn.qdu.service;

import cn.qdu.dao.*;
import cn.qdu.entity.Groupsconversations;
import cn.qdu.entity.Groupspeople;
import cn.qdu.entity.Usergroups;
import cn.qdu.entity.Users;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet("/groupChat")
@MultipartConfig(
        maxFileSize = 10485760,    // 10MB
        maxRequestSize = 20971520, // 20MB
        fileSizeThreshold = 0
)
public class GroupChatServlet extends HttpServlet {
    private UserDao userDao = new UserDao();
    private Groupspeopledao groupsPeopleDao = new Groupspeopledao();
    private Groupsconversationsdao groupConversationsDao = new Groupsconversationsdao();
    private Usergroupsdao userGroupsDao = new Usergroupsdao();
    private GrouprequestsDao groupRequestsDao = new GrouprequestsDao();

    // 允许的头像文件类型
    private static final String[] ALLOWED_IMAGE_TYPES = {"image/jpeg", "image/png", "image/gif"};

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Users currentUser = (Users) session.getAttribute("user");

        // 获取用户所在的群组列表
        List<Map<String, Object>> groupList = getGroupList(currentUser.getUid());

        // 设置默认选中的群组
        int currentGroupId = 0;
        String groupIdParam = request.getParameter("groupId");
        if (groupIdParam != null && !groupIdParam.isEmpty()) {
            currentGroupId = Integer.parseInt(groupIdParam);
        } else if (!groupList.isEmpty()) {
            currentGroupId = (Integer) groupList.get(0).get("groupId");
        }

        // 获取群聊消息
        List<Groupsconversations> messages = new ArrayList<>();
        if (currentGroupId > 0) {
            messages = groupConversationsDao.selectbygid(currentGroupId);
        }

        request.setAttribute("currentUser", currentUser);
        request.setAttribute("groupList", groupList);
        request.setAttribute("messages", messages);
        request.setAttribute("currentGroupId", currentGroupId);

        request.getRequestDispatcher("/groupChat.jsp").forward(request, response);
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
                // 发送群消息
                int groupId = Integer.parseInt(request.getParameter("groupId"));
                String message = request.getParameter("message");

                Groupsconversations conversation = new Groupsconversations();
                conversation.setGcgid(groupId);
                conversation.setGcuid(currentUser.getUid());
                conversation.setGcmessage(message);
                conversation.setGcdate(new Date().toString());

                int result = groupConversationsDao.insert(conversation);
                out.print("{\"success\": " + (result > 0) + "}");

            } else if ("refresh".equals(action)) {
                // 刷新群消息
                int groupId = Integer.parseInt(request.getParameter("groupId"));
                List<Groupsconversations> messages = groupConversationsDao.selectbygid(groupId);

                // 构建包含发送者名称和头像的JSON响应
                out.print(buildMessagesJsonWithNames(groupId, messages));
            } else if ("groups".equals(action)) {
                // 获取群组列表
                List<Map<String, Object>> groupList = getGroupList(currentUser.getUid());
                out.print(buildGroupListJson(groupList));
            } else if ("getMemberName".equals(action)) {
                // 获取成员显示名称
                int groupId = Integer.parseInt(request.getParameter("groupId"));
                int userId = Integer.parseInt(request.getParameter("userId"));

                String displayName = getMemberDisplayName(groupId, userId);
                out.print("{\"success\": true, \"displayName\": \"" + escapeJson(displayName) + "\"}");
            } else if ("getAvatar".equals(action)) {
                // 获取用户头像路径
                int userId = Integer.parseInt(request.getParameter("userId"));
                String avatarPath = getUserAvatarPath(userId);
                out.print("{\"success\": true, \"avatarPath\": \"" + escapeJson(avatarPath) + "\"}");
            } else if ("addGroupRequest".equals(action)) {
                // 处理添加群聊请求
                int groupId = Integer.parseInt(request.getParameter("groupId"));
                String message = request.getParameter("message");

                // 获取群组信息
                Usergroups group = userGroupsDao.select(groupId);
                if (group == null) {
                    out.print("{\"success\": false, \"error\": \"群组不存在\"}");
                    return;
                }

                // 获取群主ID
                Groupspeople owner = groupsPeopleDao.getGroupOwner(groupId);
                if (owner == null) {
                    out.print("{\"success\": false, \"error\": \"找不到群主\"}");
                    return;
                }

                // 检查是否已经在群中
                if (groupsPeopleDao.isMember(currentUser.getUid(), groupId)) {
                    out.print("{\"success\": false, \"error\": \"您已在群组中\"}");
                    return;
                }

                // 检查是否有待处理的请求
                if (groupRequestsDao.hasPendingRequest(currentUser.getUid(), groupId)) {
                    out.print("{\"success\": false, \"error\": \"您已发送过请求，请等待处理\"}");
                    return;
                }

                // 创建群组请求
                boolean success = groupRequestsDao.createGroupRequest(
                        currentUser.getUid(),
                        groupId,
                        message
                );

                if (success) {
                    out.print("{\"success\": true}");
                } else {
                    out.print("{\"success\": false, \"error\": \"请求发送失败\"}");
                }

            } else if ("deleteGroup".equals(action)) {
                // 处理删除群聊（退出群组）请求
                int groupId = Integer.parseInt(request.getParameter("groupId"));

                // 检查是否是群主（群主不能退出）
                Groupspeople member = groupsPeopleDao.select(groupId, currentUser.getUid());
                if (member != null && member.getGpidentity() == 3) {
                    out.print("{\"success\": false, \"error\": \"群主不能退出群组，请先转让群主\"}");
                    return;
                }

                // 删除群组成员关系
                int result = groupsPeopleDao.deletepeople(groupId, currentUser.getUid());
                if (result > 0) {
                    out.print("{\"success\": true}");
                } else {
                    out.print("{\"success\": false, \"error\": \"退出群组失败\"}");
                }
            } else if ("getGroupInfo".equals(action)) {
                // 获取群组详细信息和成员列表
                int groupId = Integer.parseInt(request.getParameter("groupId"));

                // 获取群组基本信息
                Usergroups group = userGroupsDao.select(groupId);
                if (group == null) {
                    out.print("{\"success\": false, \"error\": \"群组不存在\"}");
                    return;
                }

                // 获取群成员列表
                List<Groupspeople> members = groupsPeopleDao.selectall(groupId);
                List<Map<String, Object>> memberList = new ArrayList<>();

                if (members != null) {
                    for (Groupspeople member : members) {
                        Map<String, Object> memberInfo = new HashMap<>();
                        memberInfo.put("userId", member.getGpuid());
                        memberInfo.put("groupNickname", member.getGpname() != null ? member.getGpname() : "");
                        memberInfo.put("identity", member.getGpidentity());
                        memberInfo.put("joinDate", member.getGpdate() != null ? member.getGpdate() : "");

                        // 获取用户基本信息
                        List<Users> users = userDao.selectById(member.getGpuid());
                        if (users != null && !users.isEmpty()) {
                            Users user = users.get(0);
                            memberInfo.put("username", user.getUname() != null ? user.getUname() : "用户" + member.getGpuid());
                            memberInfo.put("avatar", user.getUimage() != null && !user.getUimage().trim().isEmpty() ?
                                    user.getUimage() : "pictures/default-avatar.jpg");
                        } else {
                            // 如果用户信息获取失败，设置默认值
                            memberInfo.put("username", "用户" + member.getGpuid());
                            memberInfo.put("avatar", "pictures/default-avatar.jpg");
                        }

                        memberList.add(memberInfo);
                    }
                }

                // 构建响应JSON
                StringBuilder json = new StringBuilder();
                json.append("{\"success\": true, \"groupInfo\": {");
                json.append("\"groupId\":").append(group.getGid()).append(",");
                json.append("\"groupName\":\"").append(escapeJson(group.getGname() != null ? group.getGname() : "")).append("\",");
                json.append("\"groupAvatar\":\"").append(escapeJson(group.getGimage() != null ? group.getGimage() : "pictures/default-group-avatar.jpg")).append("\",");
                json.append("\"groupDescription\":\"").append(escapeJson(group.getGdescription() != null ? group.getGdescription() : "")).append("\",");
                json.append("\"memberCount\":").append(group.getGnumber() != null ? group.getGnumber() : 0).append(",");
                json.append("\"createDate\":\"").append(group.getGdate() != null ? group.getGdate() : "").append("\"");
                json.append("}, \"members\": [");

                for (int i = 0; i < memberList.size(); i++) {
                    Map<String, Object> member = memberList.get(i);
                    json.append("{");
                    json.append("\"userId\":").append(member.get("userId")).append(",");
                    json.append("\"username\":\"").append(escapeJson((String)member.get("username"))).append("\",");
                    json.append("\"groupNickname\":\"").append(escapeJson((String)member.get("groupNickname"))).append("\",");
                    json.append("\"identity\":").append(member.get("identity")).append(",");
                    json.append("\"avatar\":\"").append(escapeJson((String)member.get("avatar"))).append("\",");
                    json.append("\"joinDate\":\"").append(member.get("joinDate")).append("\"");
                    json.append("}");
                    if (i < memberList.size() - 1) {
                        json.append(",");
                    }
                }

                json.append("]}");
                out.print(json.toString());
            } else if ("createGroup".equals(action)) {
                // 处理创建群聊请求
                String groupName = request.getParameter("groupName");
                String groupDescription = request.getParameter("groupDescription");

                if (groupName == null || groupName.trim().isEmpty()) {
                    out.print("{\"success\": false, \"error\": \"群名称不能为空\"}");
                    return;
                }

                // 处理群头像上传
                String imagePath = null;
                Part filePart = request.getPart("groupAvatar");
                if (filePart != null && filePart.getSize() > 0) {
                    // 验证文件类型
                    String contentType = filePart.getContentType();
                    boolean isAllowedType = false;
                    for (String type : ALLOWED_IMAGE_TYPES) {
                        if (type.equals(contentType)) {
                            isAllowedType = true;
                            break;
                        }
                    }
                    if (!isAllowedType) {
                        out.print("{\"success\": false, \"error\": \"只允许上传JPG、PNG或GIF格式的图片\"}");
                        return;
                    }

                    // 生成唯一文件名
                    String fileName = UUID.randomUUID().toString() + getFileExtension(filePart);
                    String uploadPath = getServletContext().getRealPath("/pictures");
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    filePart.write(uploadPath + File.separator + fileName);
                    imagePath = "pictures/" + fileName;
                } else {
                    // 使用默认群头像
                    imagePath = "pictures/default-group-avatar.jpg";
                }

                // 创建群组（初始人数为0）
                Usergroups newGroup = new Usergroups();
                newGroup.setGname(groupName);
                newGroup.setGimage(imagePath);
                newGroup.setGdescription(groupDescription);
                newGroup.setGnumber(0); // 初始为0人

                // 设置创建时间
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                String currentDate = sdf.format(new Date());
                newGroup.setGdate(currentDate);

                // 插入群组
                int groupId = userGroupsDao.insertReturnId(newGroup);
                if (groupId <= 0) {
                    out.print("{\"success\": false, \"error\": \"创建群组失败\"}");
                    return;
                }

                // 将创建者加入群组
                Groupspeople groupOwner = new Groupspeople();
                groupOwner.setGpid(groupId);
                groupOwner.setGpuid(currentUser.getUid());
                groupOwner.setGpidentity(3); // 群主
                groupOwner.setGpdate(currentDate);

                // 插入群成员（会自动更新人数）
                int result = groupsPeopleDao.insert(groupOwner);
                if (result <= 0) {
                    // 回滚群组创建
                    userGroupsDao.delete(groupId);
                    out.print("{\"success\": false, \"error\": \"添加群主失败\"}");
                    return;
                }

                out.print("{\"success\": true, \"groupId\": " + groupId + "}");
            }
        } catch (Exception e) {
            out.print("{\"success\": false, \"error\": \"服务器内部错误: " + e.getMessage() + "\"}");
            e.printStackTrace();
        } finally {
            out.close();
        }
    }

    // 获取文件扩展名
    private String getFileExtension(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                String fileName = token.substring(token.indexOf("=") + 2, token.length() - 1);
                return fileName.substring(fileName.lastIndexOf("."));
            }
        }
        return "";
    }

    private List<Map<String, Object>> getGroupList(int userId) {
        List<Groupspeople> groupMemberships = groupsPeopleDao.selectbyuid(userId);
        List<Map<String, Object>> groupList = new ArrayList<>();

        for (Groupspeople membership : groupMemberships) {
            Usergroups group = userGroupsDao.select(membership.getGpid());
            if (group != null) {
                Map<String, Object> groupInfo = new HashMap<>();
                groupInfo.put("groupId", group.getGid());
                groupInfo.put("groupName", group.getGname());
                groupInfo.put("avatar", group.getGimage() != null ? group.getGimage() : "pictures/default-group-avatar.jpg");
                groupInfo.put("lastMessage", getLastGroupMessage(group.getGid()));
                groupInfo.put("memberCount", group.getGnumber());
                groupList.add(groupInfo);
            }
        }
        return groupList;
    }

    private String getLastGroupMessage(int groupId) {
        List<Groupsconversations> messages = groupConversationsDao.selectbygid(groupId);
        if (messages != null && !messages.isEmpty()) {
            return messages.get(messages.size() - 1).getGcmessage();
        }
        return "暂无消息";
    }

    private String buildMessagesJsonWithNames(int groupId, List<Groupsconversations> messages) {
        StringBuilder json = new StringBuilder("{\"success\": true, \"messages\": [");
        for (Groupsconversations msg : messages) {
            json.append("{\"senderId\":").append(msg.getGcuid())
                    .append(",\"senderName\":\"").append(escapeJson(getMemberDisplayName(groupId, msg.getGcuid())))
                    .append("\",\"senderAvatar\":\"").append(escapeJson(getUserAvatarPath(msg.getGcuid())))
                    .append("\",\"groupId\":").append(msg.getGcgid())
                    .append(",\"message\":\"").append(escapeJson(msg.getGcmessage()))
                    .append("\",\"date\":\"").append(msg.getGcdate())
                    .append("\"},");
        }
        if (!messages.isEmpty()) {
            json.deleteCharAt(json.length() - 1);
        }
        json.append("]}");
        return json.toString();
    }

    private String buildGroupListJson(List<Map<String, Object>> groupList) {
        StringBuilder json = new StringBuilder("{\"success\": true, \"groups\": [");
        for (Map<String, Object> group : groupList) {
            json.append("{\"groupId\":").append(group.get("groupId"))
                    .append(",\"groupName\":\"").append(escapeJson((String)group.get("groupName")))
                    .append("\",\"avatar\":\"").append(escapeJson((String)group.get("avatar")))
                    .append("\",\"lastMessage\":\"").append(escapeJson((String)group.get("lastMessage")))
                    .append("\",\"memberCount\":").append(group.get("memberCount"))
                    .append("},");
        }
        if (!groupList.isEmpty()) {
            json.deleteCharAt(json.length() - 1);
        }
        json.append("]}");
        return json.toString();
    }

    private String getMemberDisplayName(int groupId, int userId) {
        Groupspeople member = groupsPeopleDao.select(groupId, userId);

        if (member != null && member.getGpname() != null && !member.getGpname().trim().isEmpty()) {
            return member.getGpname();
        }

        List<Users> users = userDao.selectById(userId);
        if (users != null && !users.isEmpty()) {
            return users.get(0).getUname();
        }

        return "用户" + userId;
    }

    private String getUserAvatarPath(int userId) {
        List<Users> users = userDao.selectById(userId);
        if (users != null && !users.isEmpty()) {
            String avatar = users.get(0).getUimage();
            return (avatar != null && !avatar.trim().isEmpty()) ?
                    avatar : "pictures/default-avatar.jpg";
        }
        return "pictures/default-avatar.jpg";
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