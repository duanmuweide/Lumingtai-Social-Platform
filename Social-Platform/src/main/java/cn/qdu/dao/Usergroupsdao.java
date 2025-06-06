package cn.qdu.dao;


import cn.qdu.entity.Usergroups;
import cn.qdu.util.DBUtil;
import org.teasoft.bee.osql.Op;
import org.teasoft.bee.osql.api.Condition;
import org.teasoft.bee.osql.api.Suid;
import org.teasoft.honey.osql.shortcut.BF;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

public class Usergroupsdao {
    //用户组的插入函数，成功返回1，否则返回0
    public int insert(Usergroups usergroup) {
        Suid suid = BF.getSuid();
        return suid.insert(usergroup) > 0 ? 1 : 0;
    }

    public int update(Usergroups usergroup) {
        if (usergroup.getGid() == null) {
            return 0; // 主键为空，直接返回失败
        }

        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            // 1. 获取数据库连接 (假设你有一个获取连接的工具类)
            conn = DBUtil.getConnection();

            // 2. 准备SQL语句
            String sql = "UPDATE usergroups SET group_name = ?, description = ?, create_time = ? WHERE gid = ?";

            // 3. 创建PreparedStatement并设置参数
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, usergroup.getGname());
            pstmt.setString(2, usergroup.getGdescription());
            pstmt.setTimestamp(3, new java.sql.Timestamp(usergroup.getGdate()));
            pstmt.setInt(4, usergroup.getGid());

            // 4. 执行更新
            int affectedRows = pstmt.executeUpdate();

            // 5. 返回结果
            return affectedRows > 0 ? 1 : 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        } finally {
            // 6. 关闭资源
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
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

        return suid.delete(usergroup) > 0 ? 1 : 0;
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