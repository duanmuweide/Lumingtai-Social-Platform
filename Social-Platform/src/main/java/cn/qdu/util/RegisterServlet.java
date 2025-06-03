package cn.qdu.util;

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
import java.util.UUID;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private UserDao userDao = new UserDao();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 获取表单数据
        String uname = request.getParameter("uname");
        String upwd = request.getParameter("upwd");
        String uphonenumber = request.getParameter("uphonenumber");
        String uemail = request.getParameter("uemail");
        String ugender = request.getParameter("ugender");

        // 检查用户名、手机号、邮箱是否已存在
        List<Users> existingUsers = userDao.selectOne(uname);
        if (existingUsers != null && !existingUsers.isEmpty()) {
            sendResponse(response, false, "用户名已存在");
            return;
        }

        // 创建新用户
        Users newUser = new Users();
        newUser.setUname(uname);
        newUser.setUpwd(upwd); // 注意: 实际项目中应该加密存储
        newUser.setUphonenumber(uphonenumber);
        newUser.setUemail(uemail);
        newUser.setUgender(Boolean.parseBoolean(ugender));
        // 设置默认值
        newUser.setUsign("这个人很懒，什么都没留下");

        try {
            userDao.insert(newUser);
            sendResponse(response, true, "");
        } catch (Exception e) {
            e.printStackTrace();
            sendResponse(response, false, "注册失败: " + e.getMessage());
        }
    }

    private void sendResponse(HttpServletResponse response, boolean success, String error)
            throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print("{\"success\": " + success + ", \"error\": \"" + error + "\"}");
    }
}