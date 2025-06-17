package cn.qdu.service;

import cn.qdu.dao.Conversationsdao;
import cn.qdu.entity.Conversations;
import cn.qdu.util.JSONUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/chat")
public class ChatServlet extends HttpServlet {
    private Conversationsdao messageDAO = new Conversationsdao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            JSONUtil.error(response, "未登录");
            return;
        }

        String friendIdStr = request.getParameter("friendId");
        System.out.println(friendIdStr);

        if (friendIdStr == null || friendIdStr.trim().isEmpty()) {
            JSONUtil.error(response, "好友ID不能为空");
            return;
        }

        int userId = ((cn.qdu.entity.Users) session.getAttribute("user")).getUid();
        int friendId;

        try {
            friendId = Integer.parseInt(friendIdStr);
        } catch (NumberFormatException e) {
            JSONUtil.error(response, "好友ID格式错误");
            return;
        }

        List<Conversations> messages = messageDAO.selectbyfromandto(userId, friendId);

        JSONUtil.success(response, messages);
    }
}