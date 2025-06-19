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

@WebServlet("/sendMessage")
public class SendMessageServlet extends HttpServlet {
    private Conversationsdao messageDAO = new Conversationsdao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        if (session.getAttribute("user") == null) {
            JSONUtil.error(response, "未登录");
            return;
        }

        String friendIdStr = request.getParameter("friendId");
        String content = request.getParameter("content");

        System.out.println(friendIdStr);
        System.out.println(content);

        if (friendIdStr == null || friendIdStr.trim().isEmpty()) {
            JSONUtil.error(response, "好友ID不能为空");
            return;
        }

        if (content == null || content.trim().isEmpty()) {
            JSONUtil.error(response, "消息内容不能为空");
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
        Conversations con = new Conversations();
        con.setCsenderid(userId);
        con.setCreceiverid(friendId);
        con.setCmessage(content);
        boolean success = messageDAO.insert(con);
        if (success) {
            JSONUtil.success(response, "消息发送成功");
        } else {
            JSONUtil.error(response, "消息发送失败");
        }
    }
}
