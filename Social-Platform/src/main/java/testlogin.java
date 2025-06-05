import cn.qdu.dao.UserDao;
import cn.qdu.entity.Users;

import java.sql.SQLException;
import java.util.List;

public class testlogin {
    public static void main(String[] args) throws SQLException {

//        String url = "jdbc:mysql://127.0.0.1:3306/social_platform?characterEncoding=UTF-8&useSSL=false&&serverTimezone=Asia/Shanghai";
//        String username = "root";
//        String password = "Czm982376";
//        String sql = "UPDATE users SET uname = ? WHERE uid = ?";
//        Connection conn = DriverManager.getConnection(url, username,password);
//        PreparedStatement pstmt = conn.prepareStatement(sql);
//
//        pstmt.setString(1, "admin");
//        pstmt.setInt(2, 3);
//
//        int affectedRows = pstmt.executeUpdate();
//
//        if (affectedRows > 0) {
//            System.out.println("更新成功，影响行数: " + affectedRows);
//        } else {
//            System.out.println("没有记录被更新");
//        }
        Users user = new Users();
//        user.setUid(3);
//        user.setUname("qyf");
//        user.setUpwd("222222");
//        user.setUbirthday("2005-1-1");
//        user.setUanswer("hhh");
        UserDao userDao = new UserDao();
//        userDao.update(user);
//        System.out.println(user.getUid());
        List<Users> list = userDao.selectByMany("admin", "111111", "2005-1-1");
        System.out.println(list.size());
        for (int i = 0; i < list.size(); i++) {
            System.out.println(list.get(i));
        }
    }
}
