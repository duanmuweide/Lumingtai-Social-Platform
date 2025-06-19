package cn.qdu.servlet;

import cn.qdu.dao.RelationshipDao;
import cn.qdu.entity.Relationship;
import cn.qdu.util.JSONUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
// 根据ID查询这个人的所有好友
@WebServlet("/friends")
public class FriendsServlet extends HttpServlet {
    private RelationshipDao friendDAO = new RelationshipDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            // 若session找不到就返回到页面
            return;
        }

        int userId = ((cn.qdu.entity.Users) session.getAttribute("user")).getUid();
        List<Relationship> friends = friendDAO.selectByRuid(userId);

        JSONUtil.success(response, friends);
    }
}