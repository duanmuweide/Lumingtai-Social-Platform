package cn.qdu.dao;

import cn.qdu.entity.Comments;
import cn.qdu.util.connection;
import org.teasoft.bee.osql.api.Suid;
import org.teasoft.honey.osql.shortcut.BF;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CommentDao {
    
    /**
     * 插入评论
     */
    public void insert(Comments comment) throws SQLException {
        connection con = new connection();
        Connection connect = null;
        PreparedStatement ps = null;

        try {
            connect = con.getConnection();
            String sql = "INSERT INTO comments (cid, cuid, cfile, cmessage, cdate) VALUES (?, ?, ?, ?, ?)";

            ps = connect.prepareStatement(sql);
            ps.setInt(1, comment.getCid());
            ps.setInt(2, comment.getCuid());
            ps.setString(3, comment.getCfile());
            ps.setString(4, comment.getCmessage());
            ps.setString(5, comment.getCdate());

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                System.out.println("评论插入成功，影响行数: " + affectedRows);
            } else {
                System.out.println("没有评论记录被插入");
            }
        } finally {
            try {
                if (ps != null) ps.close();
                if (connect != null) connect.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 更新评论
     */
    public void update(Comments comment) throws SQLException {
        connection con = new connection();
        Connection connect = null;
        PreparedStatement ps = null;

        try {
            connect = con.getConnection();
            String sql = "UPDATE comments SET cfile = ?, cmessage = ?, cdate = ? WHERE cid = ? AND cuid = ?";

            ps = connect.prepareStatement(sql);
            ps.setString(1, comment.getCfile());
            ps.setString(2, comment.getCmessage());
            ps.setString(3, comment.getCdate());
            ps.setInt(4, comment.getCid());
            ps.setInt(5, comment.getCuid());

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                System.out.println("评论更新成功，影响行数: " + affectedRows);
            } else {
                System.out.println("没有评论记录被更新");
            }
        } finally {
            try {
                if (ps != null) ps.close();
                if (connect != null) connect.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 根据帖子ID查询所有评论
     */
    public List<Comments> selectByPostId(Integer postId) {
        Suid suid = BF.getSuid();
        Comments comment = new Comments();
        comment.setCid(postId);
        List<Comments> list = suid.select(comment);
        if (list.size() > 0) {
            System.out.println("查询评论成功，共 " + list.size() + " 条");
            return list;
        } else {
            System.out.println("没有找到评论记录");
            return new ArrayList<>();
        }
    }

    /**
     * 根据用户ID查询评论
     */
    public List<Comments> selectByUserId(Integer userId) {
        Suid suid = BF.getSuid();
        Comments comment = new Comments();
        comment.setCuid(userId);
        List<Comments> list = suid.select(comment);
        if (list.size() > 0) {
            System.out.println("查询用户评论成功");
            return list;
        } else {
            System.out.println("没有找到用户评论记录");
            return null;
        }
    }

    /**
     * 查询所有评论
     */
    public List<Comments> selectAll() {
        Suid suid = BF.getSuid();
        Comments comment = new Comments();
        List<Comments> list = suid.select(comment);
        if (list.size() > 0) {
            System.out.println("查询所有评论成功");
            return list;
        } else {
            System.out.println("没有找到评论记录");
            return null;
        }
    }

    /**
     * 获取帖子的点赞数
     */
    // public int getLikeCount(Integer postId) throws SQLException {
    //     // 已废弃，点赞数应从 likes 表获取
    //     return 0;
    // }

    /**
     * 获取帖子的评论数
     */
    public int getCommentCount(Integer postId) throws SQLException {
        connection con = new connection();
        Connection connect = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            connect = con.getConnection();
            String sql = "SELECT COUNT(*) FROM comments WHERE cid = ? AND cmessage IS NOT NULL AND cmessage != ''";
            ps = connect.prepareStatement(sql);
            ps.setInt(1, postId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (connect != null) connect.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return 0;
    }

    /**
     * 检查用户是否已点赞
     */
    // public boolean hasUserLiked(Integer postId, Integer userId) throws SQLException {
    //     // 已废弃，点赞状态应从 likes 表获取
    //     return false;
    // }

    /**
     * 删除用户的点赞记录
     */
    // public void deleteUserLike(Integer postId, Integer userId) throws SQLException {
    //     // 已废弃，点赞删除应从 likes 表操作
    // }

    /**
     * 根据帖子ID查询评论列表（包括用户信息）
     */
    public List<Comments> selectCommentsByPostId(Integer postId) throws SQLException {
        connection con = new connection();
        Connection connect = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Comments> comments = new ArrayList<>();

        try {
            connect = con.getConnection();
            String sql = "SELECT * FROM comments WHERE cid = ? AND cmessage IS NOT NULL AND cmessage != '' ORDER BY cdate DESC";
            ps = connect.prepareStatement(sql);
            ps.setInt(1, postId);
            rs = ps.executeQuery();
            while (rs.next()) {
                Comments comment = new Comments();
                comment.setCid(rs.getInt("cid"));
                comment.setCuid(rs.getInt("cuid"));
                comment.setCfile(rs.getString("cfile"));
                comment.setCmessage(rs.getString("cmessage"));
                comment.setCdate(rs.getString("cdate"));
                comments.add(comment);
            }
            System.out.println("查询评论列表成功，共 " + comments.size() + " 条");
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (connect != null) connect.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return comments;
    }
}
