//package cn.qdu.service;
//
//import cn.qdu.entity.User;
//
//import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.HttpServlet;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//import java.io.IOException;
//import java.io.PrintWriter;
//
//@WebServlet("/login")
//public class LoginServlet extends HttpServlet {
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        String username = request.getParameter("username");
//        String password = request.getParameter("password");
//
//        // 调用 Service 层验证登录
//        User user = UserService.login(username, password);
//
//        response.setContentType("application/json");
//        PrintWriter out = response.getWriter();
//        if (user != null) {
//            request.getSession().setAttribute("user", user); // 保存用户到 Session
//            out.print("{\"success\": true}");
//        } else {
//            out.print("{\"success\": false, \"error\": \"用户名或密码错误\"}");
//        }
//    }
//}