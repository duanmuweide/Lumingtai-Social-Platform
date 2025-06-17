package cn.qdu.dao;

import cn.qdu.entity.Groupspeople;
import cn.qdu.entity.Usergroups;
import org.teasoft.bee.osql.Op;
import org.teasoft.bee.osql.api.Condition;
import org.teasoft.bee.osql.api.Suid;
import org.teasoft.honey.osql.shortcut.BF;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

public class Groupspeopledao {
    //群成员的插入函数，成功返回1，否则返回0
    public int insert(Groupspeople groupspeople) {
        Suid suid = BF.getSuid();
        if(suid.insert(groupspeople)>0){
            //插入群成员后群的人数要加一
            Usergroupsdao usergroupsdao = new Usergroupsdao();
            Usergroups usergroups=usergroupsdao.select(groupspeople.getGpid());
            usergroups.setGnumber(usergroups.getGnumber()+1);
            usergroupsdao.update(usergroups);
            return 1;
        }else{
            return 0;
        }
    }

    //更新群成员的群昵称和群身份，成功返回1，否则返回0
    public int update(Groupspeople groupspeople) {
        String url = "jdbc:mysql://127.0.0.1:3306/social_platform?characterEncoding=UTF-8&useSSL=false&serverTimezone=Asia/Shanghai";
        String username = "root";
        String password = "root";

        String sql = "UPDATE groupspeople SET gpname = ?, gpidentity = ? WHERE gpid = ? AND gpuid = ?";

        try (Connection conn = DriverManager.getConnection(url, username, password);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            // 设置所有可更新的参数
            pstmt.setString(1, groupspeople.getGpname());
            pstmt.setInt(2, groupspeople.getGpidentity());
            pstmt.setInt(3,groupspeople.getGpid());
            pstmt.setInt(4, groupspeople.getGpuid());


            int affectedRows = pstmt.executeUpdate();

            // 成功返回1，失败返回0
            return affectedRows > 0 ? 1 : 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return 0; // 发生异常返回0表示失败
        }
    }


    // 群某个成员的删除函数，成功返回1，否则返回0
    public int deletepeople(int gid, int uid) {
        Suid suid = BF.getSuid();

        // 1. 先根据复合主键(gid, uid)查询实体是否存在
        Groupspeople groupspeople = select(gid,uid);
        if (groupspeople == null) {
            return 0; // 不存在则直接返回失败
        }

        // 2. 直接删除实体对象
        if(suid.delete(groupspeople)>0){
            //删除群成员后群的人数要减一
            Usergroupsdao usergroupsdao = new Usergroupsdao();
            Usergroups usergroups=usergroupsdao.select(groupspeople.getGpid());
            usergroups.setGnumber(usergroups.getGnumber()-1);
            usergroupsdao.update(usergroups);
            return 1;
        }else{
            return 0;
        }
    }

    //群的删除
    public int deletegroup(int gpid) {
        Suid suid = BF.getSuid();
        Condition condition = BF.getCondition();
        condition.op("gpid", Op.eq, gpid);

        int deletedCount = suid.delete(new Groupspeople(), condition);
        return deletedCount > 0 ? 1 : 0;
    }


    //群所有成员的查询函数，成功返回这个群的所有用户，否则返回null
    public List<Groupspeople> selectall(int gid) {
        Suid suid = BF.getSuid();
        Condition condition = BF.getCondition();
        condition.op("gpid", Op.eq, gid);

        // 查询所有符合条件的记录
        List<Groupspeople> result = suid.select(new Groupspeople(), condition);
        return result.isEmpty() ? null : result;
    }

    //群某个成员查询函数
    public Groupspeople select(int gid, int uid) {
        Suid suid = BF.getSuid();
        Condition condition = BF.getCondition();
        condition.op("gpid", Op.eq, gid)
                .op("gpuid", Op.eq, uid);

        // 查询唯一记录
        List<Groupspeople> result = suid.select(new Groupspeople(), condition);
        return result != null && !result.isEmpty() ? result.get(0) : null;
    }


}
