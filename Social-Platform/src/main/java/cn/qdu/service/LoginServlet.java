package cn.qdu.service;

import cn.qdu.dao.UserDao;
import cn.qdu.entity.Users;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UserDao userDao = new UserDao();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String loginInfo = request.getParameter("loginInfo");
        String password = request.getParameter("password");

        // 调用 DAO 层验证登录
        List<Users> users = userDao.selectOne(loginInfo);

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        if (users != null && !users.isEmpty()) {
            Users user = users.get(0);
            // 简单密码验证 (实际项目中应该使用加密验证)
            if (user.getUpwd().equals(password)) {
                request.getSession().setAttribute("user", user);
                out.print("{\"success\": true}");
            } else {
                out.print("{\"success\": false, \"error\": \"密码错误\"}");
            }
        } else {
            out.print("{\"success\": false, \"error\": \"用户不存在\"}");
        }
    }
}