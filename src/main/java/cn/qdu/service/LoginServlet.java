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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            String loginInfo = request.getParameter("loginInfo");
            String password = request.getParameter("password");

            if (loginInfo == null || password == null || loginInfo.trim().isEmpty() || password.trim().isEmpty()) {
                out.print("{\"success\": false, \"error\": \"用户名和密码不能为空\"}");
                return;
            }

            // 调用 DAO 层验证登录

            List<Users> users = userDao.selectByName(loginInfo);


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
        } catch (Exception e) {
            out.print("{\"success\": false, \"error\": \"服务器内部错误\"}");
            e.printStackTrace();
        } finally {
            out.close();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.print("{\"success\": false, \"error\": \"登录请求必须使用POST方法\"}");
        out.close();
    }

}

