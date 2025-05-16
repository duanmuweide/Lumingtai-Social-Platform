import cn.qdu.entity.Users;
import org.teasoft.bee.osql.api.Suid;
import org.teasoft.honey.osql.shortcut.BF;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;


@WebServlet("/login")
public class login extends HttpServlet {
    public void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        request.setCharacterEncoding("utf-8");
        response.setContentType("text/html;charset=utf-8");
        PrintWriter out = response.getWriter();
        String username = request.getParameter("username");
        out.println("<html>");
        out.println("<head>");
        out.println("<h1>" + username + "</h1>");
        Suid suid = BF.getSuid();
        Users user = new Users();
        user.setUname("czm");
        user.setUpwd("123456");

        Date sqlDate = new Date(new java.util.Date().getTime());
        user.setUbirthday(sqlDate);
        suid.insert(user);
    }
    public void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        doGet(request, response);
    }
}
