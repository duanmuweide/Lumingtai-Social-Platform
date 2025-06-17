package cn.qdu.dao;

import cn.qdu.entity.Comments;
import cn.qdu.util.connection;
import org.teasoft.bee.osql.api.Suid;
import org.teasoft.honey.osql.shortcut.BF;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

public class CommentDao {
    public void insert(Comments com) {
        Suid suid = BF.getSuid();
        suid.insert(com);
        System.out.println("插入成功!");
    }

    public void delete(Comments com) {
        Suid suid = BF.getSuid();
        int deletecount = suid.delete(com);
        if (deletecount > 0) System.out.println("删除成功!");
        else System.out.println("删除失败!");
    }

    public void update(Comments com) throws SQLException {
        connection con = new connection();
        Connection connect = con.getConnection();

        String sql = "UPDATE relationship SET cuid = ?,clike = ?, cfile= ?, cmessage = ?,cdate = ? WHERE cid = ?";

        PreparedStatement ps = connect.prepareStatement(sql);

        ps.setInt(1, com.getCuid());
        ps.setBoolean(2, com.getClike());
        ps.setString(3, com.getCfile());
        ps.setString(4, com.getCmessage());
        ps.setString(5, com.getCdate());

        int affectedRows = ps.executeUpdate();

        if (affectedRows > 0) {
            System.out.println("更新成功，影响行数: " + affectedRows);
        } else {
            System.out.println("没有记录被更新");
        }
    }

    public List<Comments> selectByCuid(Integer cuid) {
        Suid suid = BF.getSuid();
        Comments com = new Comments();
        com.setCuid(cuid);
        List<Comments> list = suid.select(com);
        if (list.size() > 0) {
            System.out.println("查询成功");
            return list;
        } else {
            System.out.println("没有记录");
            return null;
        }
    }

    public List<Comments> selectByClike(Boolean clike) {
        Suid suid = BF.getSuid();
        Comments com = new Comments();
        com.setClike(clike);
        List<Comments> list = suid.select(com);
        if (list.size() > 0) {
            System.out.println("查询成功");
            return list;
        } else {
            System.out.println("没有记录");
            return null;
        }
    }

    public List<Comments> selectByCmessage(String cmessage) {
        Suid suid = BF.getSuid();
        Comments com = new Comments();
        com.setCmessage(cmessage);
        List<Comments> list = suid.select(com);
        if (list.size() > 0) {
            System.out.println("查询成功");
            return list;
        } else {
            System.out.println("没有记录");
            return null;
        }
    }

    public List<Comments> selectByCdate(String cdate) {
        Suid suid = BF.getSuid();
        Comments com = new Comments();
        com.setCdate(cdate);
        List<Comments> list = suid.select(com);
        if (list.size() > 0) {
            System.out.println("查询成功");
            return list;
        } else {
            System.out.println("没有记录");
            return null;
        }
    }

    public List<Comments> selectByMany(Integer cuid, Boolean clike, String cfile, String cmessage, String cdate) {
        Suid suid = BF.getSuid();
        Comments com = new Comments();
        com.setCuid(cuid);
        com.setClike(clike);
        com.setCfile(cfile);
        com.setCmessage(cmessage);
        com.setCdate(cdate);
        List<Comments> list = suid.select(com);
        if (list.size() > 0) {
            System.out.println("查询成功");
            return list;
        } else {
            System.out.println("没有记录");
            return null;
        }
    }
}
