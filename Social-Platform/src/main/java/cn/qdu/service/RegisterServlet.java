//package cn.qdu.service;
//
//import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.HttpServlet;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//import java.io.IOException;
//import java.io.PrintWriter;
//
//@WebServlet("/register")
//public class RegisterServlet extends HttpServlet {
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        String username = request.getParameter("username");
//        String password = request.getParameter("password");
//
//        // 调用 Service 层注册
//        boolean isSuccess = UserService.register(username, password);
//
//        // 返回 JSON 响应
//        response.setContentType("application/json");
//        PrintWriter out = response.getWriter();
//        out.print("{\"success\": " + isSuccess + ", \"error\": \"" + (isSuccess ? "" : "用户名已存在") + "\"}");
//    }
//}