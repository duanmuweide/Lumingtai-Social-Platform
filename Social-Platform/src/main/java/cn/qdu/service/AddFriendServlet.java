package cn.qdu.service;

import cn.qdu.dao.RelationshipDao;
import cn.qdu.entity.Relationship;
import cn.qdu.entity.Users;
import cn.qdu.util.JSONUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/addFriend")
public class AddFriendServlet extends HttpServlet {


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        if (session.getAttribute("user") == null) {
            JSONUtil.error(response, "未登录");
            return;
        }

        String friendIdStr = request.getParameter("friendId");
        if (friendIdStr == null || friendIdStr.trim().isEmpty()) {
            JSONUtil.error(response, "好友ID不能为空");
            return;
        }

        int userId = ((Users) session.getAttribute("user")).getUid();
        int friendId;

        friendId = Integer.parseInt(friendIdStr);


        // 不能添加自己为好友
        if (userId == friendId) {
            JSONUtil.error(response, "不能添加自己为好友");
            return;
        }

        RelationshipDao relationshipDAO = new RelationshipDao();
        Relationship relationship = new Relationship();
        relationship.setRuid(userId); relationship.setRfiendid(friendId);


        List<Relationship> list = relationshipDAO.selectByManytwoid(userId, friendId);
        if(list.size() > 0) {
            JSONUtil.error(response, "好友已存在");
            return;
        }

        list.clear();
        RelationshipDao frienddao = new RelationshipDao();

        Relationship f = new Relationship();
        f.setRid(null);  // 关键！
        f.setRuid(userId); f.setRfiendid(friendId); f.setRdate("1");


        boolean success = frienddao.insert(f);

        Relationship f2 = new Relationship();
        f2.setRid(null);
        f2.setRuid(friendId); f2.setRfiendid(userId); f2.setRdate("1");

        frienddao.insert(f2);
        if (success) {
            // 同时添加反向好友关系
            JSONUtil.success(response, "添加好友成功");
        } else {
            JSONUtil.error(response, "添加好友失败");
        }
    }
}