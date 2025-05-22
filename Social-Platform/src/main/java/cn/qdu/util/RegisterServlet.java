package cn.qdu.util;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // 调用 Service 层注册
        boolean isSuccess = UserService.register(username, password);

        // 返回 JSON 响应
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print("{\"success\": " + isSuccess + ", \"error\": \"" + (isSuccess ? "" : "用户名已存在") + "\"}");
    }
}