package cn.qdu.service;

import cn.qdu.dao.FriendrequestsDao;
import cn.qdu.dao.GrouprequestsDao;
import cn.qdu.dao.RelationshipDao;
import cn.qdu.dao.UserDao;
import cn.qdu.dao.Groupspeopledao;
import cn.qdu.dao.Usergroupsdao;
import cn.qdu.entity.FriendRequests;
import cn.qdu.entity.Grouprequests;
import cn.qdu.entity.Relationship;
import cn.qdu.entity.Users;
import cn.qdu.entity.Groupspeople;
import cn.qdu.entity.Usergroups;
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
    private GrouprequestsDao groupRequestsDao = new GrouprequestsDao();
    private ObjectMapper objectMapper = new ObjectMapper();
    private Groupspeopledao groupsPeopleDao = new Groupspeopledao();
    private Usergroupsdao userGroupsDao = new Usergroupsdao();
    private UserDao userDao = new UserDao();

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

            // 获取好友请求
            List<FriendRequests> friendRequests = null;
            try {
                friendRequests = friendDAO.selectByRecid(currentUser.getUid());
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }

            // 获取群组请求
            System.out.println("[DEBUG] 当前登录用户ID: " + currentUser.getUid());
            List<Grouprequests> groupRequests = groupRequestsDao.selectByGroupOwner(currentUser.getUid());
            System.out.println("[DEBUG] 查询到的群组请求数量: " + (groupRequests != null ? groupRequests.size() : "null"));

            // 输出好友请求
            if (friendRequests != null && !friendRequests.isEmpty()) {
                for (FriendRequests req : friendRequests) {
                    List<Users> users = userDao.selectById(req.getReqid());
                    if (users == null || users.isEmpty()) continue;

                    Users user = users.get(0);
                    out.println("<div class=\"request-item\" data-request-type=\"friend\" data-request-id=\"" + req.getReqid() + "\">");
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
            }

            // 输出群组请求
            if (groupRequests != null && !groupRequests.isEmpty()) {
                System.out.println("[DEBUG] 开始处理并输出群组请求...");
                for (Grouprequests req : groupRequests) {
                    System.out.println("[DEBUG] 正在处理请求ID: " + req.getId() + ", 申请人ID: " + req.getUserid() + ", 群组ID: " + req.getGroupid());
                    // 获取请求用户信息
                    List<Users> users = userDao.selectById(req.getUserid());
                    if (users == null || users.isEmpty()) {
                        System.out.println("[DEBUG] 找不到申请人信息，用户ID: " + req.getUserid() + "，跳过此请求。");
                        continue;
                    }

                    Users user = users.get(0);
                    System.out.println("[DEBUG] 成功获取申请人信息: " + user.getUname());

                    // 获取群组信息
                    Usergroups group = userGroupsDao.select(req.getGroupid());
                    if (group == null) {
                        System.out.println("[DEBUG] 找不到群组信息，群组ID: " + req.getGroupid() + "，跳过此请求。");
                        continue;
                    }
                    String groupName = group.getGname();
                    System.out.println("[DEBUG] 成功获取群组信息: " + groupName);

                    out.println("<div class=\"request-item\" data-request-type=\"group\" data-request-id=\"" + req.getId() + "\">");
                    out.println("  <img src=\"" + (user.getUimage() != null ? user.getUimage() : "default-avatar.jpg") + "\" ");
                    out.println("       class=\"request-avatar\" alt=\"用户头像\">");
                    out.println("  <div class=\"request-info\">");
                    out.println("    <div class=\"request-name\">" + user.getUname() + "</div>");
                    out.println("    <div class=\"request-id\">ID: " + user.getUid() + "</div>");
                    out.println("    <div class=\"request-message\">申请加入: " + groupName + "</div>");
                    out.println("    <div class=\"request-message\">验证消息: " + (req.getMessage() != null ? req.getMessage() : "无") + "</div>");
                    out.println("  </div>");
                    out.println("  <div class=\"request-actions\">");
                    out.println("    <button class=\"layui-btn layui-btn-sm layui-btn-normal accept-btn\">接受</button>");
                    out.println("    <button class=\"layui-btn layui-btn-sm layui-btn-danger reject-btn\">拒绝</button>");
                    out.println("  </div>");
                    out.println("</div>");
                }
                System.out.println("[DEBUG] 群组请求输出完毕。");
            }

            // 如果没有任何请求
            if ((friendRequests == null || friendRequests.isEmpty()) &&
                    (groupRequests == null || groupRequests.isEmpty())) {
                out.println("<div class=\"no-requests\">");
                out.println("  <i class=\"layui-icon layui-icon-face-smile\" style=\"font-size: 50px;\"></i>");
                out.println("  <div style=\"margin-top: 15px; font-size: 16px;\">暂无请求</div>");
                out.println("</div>");
            }

            out.close();
            return;
        }

        // 普通GET请求，渲染整个页面
        request.getRequestDispatcher("/message.jsp").forward(request, response);
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
                String requestType = request.getParameter("requestType");

                if ("friend".equals(requestType)) {
                    handleFriendRequest(request, currentUser, responseMap);
                } else if ("group".equals(requestType)) {
                    handleGroupRequest(request, currentUser, responseMap);
                }
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
                // 建立好友关系
                Relationship s1 = new Relationship();
                Relationship s2 = new Relationship();

                s1.setRuid(friendRequest.getReqid());
                s1.setRfiendid(friendRequest.getRecid());
                s2.setRuid(friendRequest.getRecid());
                s2.setRfiendid(friendRequest.getReqid());

                LocalDateTime currentDateTime = LocalDateTime.now();
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
                String dateString = currentDateTime.format(formatter);

                s1.setRtype(1);
                s1.setRdate(dateString);
                s2.setRtype(1);
                s2.setRdate(dateString);
                RelationshipDao rdao = new RelationshipDao();
                success = rdao.insert(s1) && rdao.insert(s2);

                success = friendDAO.acceptFriendRequest(requestId, currentUser.getUid());
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

    private void handleGroupRequest(HttpServletRequest request, Users currentUser, Map<String, Object> responseMap) {
        try {
            String type = request.getParameter("type");
            int requestId = Integer.parseInt(request.getParameter("requestId")); // 修复参数名

            // 获取群组请求
            Grouprequests groupRequest = groupRequestsDao.selectById(requestId);
            if (groupRequest == null) {
                responseMap.put("success", false);
                responseMap.put("message", "群组请求不存在");
                return;
            }

            // 添加调试日志
            System.out.println("处理群组请求: ID=" + requestId +
                    ", 群组ID=" + groupRequest.getGroupid() +
                    ", 申请人=" + groupRequest.getUserid());

            // 检查当前用户是否为群主
            Groupspeople owner = groupsPeopleDao.getGroupOwner(groupRequest.getGroupid());
            if (owner == null || !owner.getGpuid().equals(currentUser.getUid())) {
                // 添加详细日志
                System.out.println("权限验证失败: 当前用户=" + currentUser.getUid() +
                        ", 群主ID=" + (owner != null ? owner.getGpuid() : "null") +
                        ", 群组ID=" + groupRequest.getGroupid());
                responseMap.put("success", false);
                responseMap.put("message", "您不是群主，无权操作");
                return;
            }

            boolean success = false;

            if ("accept".equals(type)) {
                // 接受群组请求
                Groupspeople newMember = new Groupspeople();
                newMember.setGpid(groupRequest.getGroupid());
                newMember.setGpuid(groupRequest.getUserid());
                newMember.setGpname(null); // 初始群昵称为空
                newMember.setGpidentity(1); // 普通成员
                newMember.setGpdate(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd")));

                success = groupsPeopleDao.insert(newMember) > 0;

                if (success) {
                    // 更新群组人数
                    Usergroups group = userGroupsDao.select(groupRequest.getGroupid());
                    if (group != null) {
                        group.setGnumber(group.getGnumber() + 1);
                        userGroupsDao.update(group);
                    }
                }
            } else if ("reject".equals(type)) {
                // 拒绝群组请求，直接设置成功
                success = true;
            }

            // 无论接受还是拒绝，都删除请求
            success = groupRequestsDao.deleteRequest(requestId) && success;

            responseMap.put("success", success);
            responseMap.put("message", success ? "操作成功" : "操作失败");
        } catch (NumberFormatException e) {
            responseMap.put("success", false);
            responseMap.put("message", "请求ID格式不正确");
        }
    }
}