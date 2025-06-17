package cn.qdu.service;

import cn.qdu.dao.UserDao;
import cn.qdu.entity.Users;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
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
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            // 输入验证
            if (username == null || password == null || username.trim().isEmpty() || password.trim().isEmpty()) {
                out.print("{\"success\": false, \"error\": \"用户名和密码不能为空\"}");
                return;
            }

            // 用户名长度和格式验证
            if (username.length() < 3 || username.length() > 20) {
                out.print("{\"success\": false, \"error\": \"用户名长度必须在3-20个字符之间\"}");
                return;
            }

            // 防止SQL注入：移除特殊字符
            username = username.replaceAll("[^a-zA-Z0-9_\\u4e00-\\u9fa5]", "");

            // 调用 DAO 层验证登录
            List<Users> users = userDao.selectByName(username);

            if (users != null && !users.isEmpty()) {
                Users user = users.get(0);
                if (password.equals(user.getUpwd())) {  // 直接比较密码
                    // 创建新的会话
                    HttpSession oldSession = request.getSession(false);
                    if (oldSession != null) {
                        oldSession.invalidate();
                    }
                    HttpSession newSession = request.getSession(true);
                    newSession.setMaxInactiveInterval(30 * 60);
                    newSession.setAttribute("user", user);

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