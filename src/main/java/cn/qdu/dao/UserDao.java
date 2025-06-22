package cn.qdu.dao;

import cn.qdu.entity.Users;
import cn.qdu.util.connection;
import org.teasoft.bee.osql.api.Suid;
import org.teasoft.honey.osql.shortcut.BF;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

public class UserDao {
    public boolean insert(Users user){
        Suid suid = BF.getSuid();
        int cnt = suid.insert(user);
        System.out.println("插入成功!");
        if(cnt>0){ return true;}
        else return false;
    }

    public void delete(Users user){
        Suid suid = BF.getSuid();
        int deletecount = suid.delete(user);
        if (deletecount > 0 ) System.out.println("删除成功!");
        else System.out.println("删除失败!");
    }

    public void update(Users user) throws SQLException {
        connection con = new connection();
        Connection connect = con.getConnection();

        String sql = "UPDATE users SET uname = ?,upwd = ?, uquestion= ?, uanswer = ?, " +
                "ubirthday= ? , ugender = ?, uhobby = ? , usign = ?, uphonenumber = ?, " +
                "uemail = ? , uimage=? WHERE uid = ?";

        PreparedStatement ps = connect.prepareStatement(sql);

        ps.setString(1, user.getUname());
        ps.setString(2, user.getUpwd());
        ps.setString(3, user.getUquestion());
        ps.setString(4, user.getUanswer());
        ps.setString(5, user.getUbirthday());
        ps.setBoolean(6,user.getUgender());
        ps.setString(7, user.getUhobby());
        ps.setString(8, user.getUsign());
        ps.setString(9,user.getUphonenumber());
        ps.setString(10,user.getUemail());
        ps.setString(11,user.getUimage());
        ps.setInt(12, user.getUid());

        int affectedRows = ps.executeUpdate();
//
        if (affectedRows > 0) {
            System.out.println("更新成功，影响行数: " + affectedRows);
        } else {
            System.out.println("没有记录被更新");
        }

    }

    public List<Users> selectByName(String name){
        Suid suid = BF.getSuid();
        Users user = new Users(); user.setUname(name);
        List<Users> list = suid.select(user);
        if (list.size() > 0) {System.out.println("查询成功"); return list;}
        else {System.out.println("没有记录"); return null;}
    }


    public List<Users> selectById(Integer id){
        Suid suid = BF.getSuid();
        Users user = new Users(); user.setUid(id);
        List<Users> list = suid.select(user);
        if (list.size() > 0) {System.out.println("查询成功"); return list;}
        else {System.out.println("没有记录"); return null;}
    }

    public List<Users> selectByBirth(String birthday){
        Suid suid = BF.getSuid();
        Users user = new Users(); user.setUbirthday(birthday);
        List<Users> list = suid.select(user);
        if (list.size() > 0) {System.out.println("查询成功"); return list;}
        else {System.out.println("没有记录"); return null;}
    }

    public List<Users> selectByMany(String name, String pwd, String birthday){
        Suid suid = BF.getSuid();
        Users user = new Users();
        user.setUname(name);
        user.setUpwd(pwd);
        user.setUbirthday(birthday);
        List<Users> list = suid.select(user);
        if (list.size() > 0) {System.out.println("查询成功"); return list;}
        else {System.out.println("没有记录"); return null;}
    }
}
