package cn.qdu.dao;

import cn.qdu.entity.Posts;
import cn.qdu.util.connection;
import org.teasoft.bee.osql.api.Suid;
import org.teasoft.honey.osql.shortcut.BF;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

public class PostDao {
    public void insert(Posts post) {
        Suid suid = BF.getSuid();
        suid.insert(post);
        System.out.println("插入成功!");
    }

    public void delete(Posts post) {
        Suid suid = BF.getSuid();
        int deletecount = suid.delete(post);
        if (deletecount > 0) System.out.println("删除成功!");
        else System.out.println("删除失败!");
    }

    public void update(Posts post) throws SQLException {
        connection con = new connection();
        Connection connect = con.getConnection();

        String sql = "UPDATE relationship SET puid = ?,pmessage = ?, pdate= ?, pfile = ? WHERE pid = ?";

        PreparedStatement ps = connect.prepareStatement(sql);

        ps.setInt(1, post.getPuid());
        ps.setString(2, post.getPmessage());
        ps.setString(3, post.getPdate());
        ps.setString(4, post.getPfile());
        ps.setInt(5, post.getPid());

        int affectedRows = ps.executeUpdate();

        if (affectedRows > 0) {
            System.out.println("更新成功，影响行数: " + affectedRows);
        } else {
            System.out.println("没有记录被更新");
        }
    }

    public List<Posts> selectByPuid(Integer puid) {
        Suid suid = BF.getSuid();
        Posts posts = new Posts();
        posts.setPuid(puid);
        List<Posts> list = suid.select(posts);
        if (list.size() > 0) {
            System.out.println("查询成功");
            return list;
        } else {
            System.out.println("没有记录");
            return null;
        }
    }

    public List<Posts> selectByPessage(String pmessage) {
        Suid suid = BF.getSuid();
        Posts posts = new Posts();
        posts.setPmessage(pmessage);
        List<Posts> list = suid.select(posts);
        if (list.size() > 0) {
            System.out.println("查询成功");
            return list;
        } else {
            System.out.println("没有记录");
            return null;
        }
    }

    public List<Posts> selectByPdate(String pdate) {
        Suid suid = BF.getSuid();
        Posts posts = new Posts();
        posts.setPdate(pdate);
        List<Posts> list = suid.select(posts);
        if (list.size() > 0) {
            System.out.println("查询成功");
            return list;
        } else {
            System.out.println("没有记录");
            return null;
        }
    }

    public List<Posts> selectByPfile(String pfile) {
        Suid suid = BF.getSuid();
        Posts posts = new Posts();
        posts.setPfile(pfile);
        List<Posts> list = suid.select(posts);
        if (list.size() > 0) {
            System.out.println("查询成功");
            return list;
        } else {
            System.out.println("没有记录");
            return null;
        }
    }

    public List<Posts> selectByMany(Integer puid, String pmessage, String pdate, String pfile) {
        Suid suid = BF.getSuid();
        Posts posts = new Posts();
        posts.setPuid(puid);
        posts.setPmessage(pmessage);
        posts.setPdate(pdate);
        posts.setPfile(pfile);
        List<Posts> list = suid.select(posts);
        if (list.size() > 0) {
            System.out.println("查询成功");
            return list;
        } else {
            System.out.println("没有记录");
            return null;
        }
    }

}
