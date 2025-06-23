package cn.qdu.dao;


import cn.qdu.entity.Usergroups;
import org.teasoft.bee.osql.Op;
import org.teasoft.bee.osql.api.Suid;
import org.teasoft.bee.osql.api.Condition;
import org.teasoft.honey.osql.shortcut.BF;

import java.sql.*;
import java.util.List;

public class Usergroupsdao {
    //用户组的插入函数，成功返回1，否则返回0
    public int insert(Usergroups usergroup) {
        Suid suid = BF.getSuid();
        return suid.insert(usergroup) > 0 ? 1 : 0;
    }

    public int insertReturnId(Usergroups usergroup) {
        String url = "jdbc:mysql://127.0.0.1:3306/social_platform?characterEncoding=UTF-8&useSSL=false&serverTimezone=Asia/Shanghai";
        String username = "root";
        String password = "root";

        // 使用 RETURN_GENERATED_KEYS 选项获取自增ID
        String sql = "INSERT INTO usergroups (gname, gimage, gdescription, gnumber, gdate) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DriverManager.getConnection(url, username, password);
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, usergroup.getGname());
            pstmt.setString(2, usergroup.getGimage());
            pstmt.setString(3, usergroup.getGdescription());
            pstmt.setInt(4, usergroup.getGnumber());
            pstmt.setString(5, usergroup.getGdate());

            int affectedRows = pstmt.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1); // 返回生成的自增ID
                    }
                }
            }
            return 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public int update(Usergroups usergroup) {
        String url = "jdbc:mysql://127.0.0.1:3306/social_platform?characterEncoding=UTF-8&useSSL=false&serverTimezone=Asia/Shanghai";
        String username = "root";
        String password = "root";

        String sql = "UPDATE usergroups SET gnumber = ? WHERE gid = ?";

        try (Connection conn = DriverManager.getConnection(url, username, password);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, usergroup.getGnumber());
            pstmt.setInt(2, usergroup.getGid());

            return pstmt.executeUpdate() > 0 ? 1 : 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }


    //用户组的删除函数，成功返回1，否则返回0
    public int delete(int id) {
        Suid suid = BF.getSuid();
        // 1. 先查询实体是否存在
        Usergroups usergroup = select(id);
        if (usergroup == null) {
            return 0; // 不存在则直接返回失败
        }

        if(suid.delete(usergroup) > 0){
            //删除用户群会群成员和消息都应该删除
            Groupspeopledao groupspeopledao = new Groupspeopledao();
            groupspeopledao.deletegroup(id);

            Groupsconversationsdao conversationsdao = new Groupsconversationsdao();
            groupspeopledao.deletegroup(id);
            return 1;
        }else{
            return 0;
        }
    }

    //用户组的查询函数，成功返回所查询用户，否则返回null
    public Usergroups select(int id) {
        Suid suid = BF.getSuid();
        Condition condition = BF.getCondition();
        condition.op("gid", Op.eq, id);

        List<Usergroups> usergroupsList = suid.select(new Usergroups(), condition);
        return usergroupsList.isEmpty() ? null : usergroupsList.get(0);
    }
}