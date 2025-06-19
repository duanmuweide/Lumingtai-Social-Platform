package cn.qdu.dao;

import cn.qdu.util.connection;
import java.sql.*;

public class LikeDao {
    public boolean hasUserLiked(int postId, int userId) throws SQLException {
        connection con = new connection();
        try (Connection connect = con.getConnection();
             PreparedStatement ps = connect.prepareStatement(
                 "SELECT COUNT(*) FROM likes WHERE cid = ? AND cuid = ?")) {
            ps.setInt(1, postId);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        }
        return false;
    }

    public void insertLike(int postId, int userId, String ldate) throws SQLException {
        connection con = new connection();
        try (Connection connect = con.getConnection();
             PreparedStatement ps = connect.prepareStatement(
                 "INSERT INTO likes (cid, cuid, ldate) VALUES (?, ?, ?)")) {
            ps.setInt(1, postId);
            ps.setInt(2, userId);
            ps.setString(3, ldate);
            ps.executeUpdate();
        }
    }

    public void deleteLike(int postId, int userId) throws SQLException {
        connection con = new connection();
        try (Connection connect = con.getConnection();
             PreparedStatement ps = connect.prepareStatement(
                 "DELETE FROM likes WHERE cid = ? AND cuid = ?")) {
            ps.setInt(1, postId);
            ps.setInt(2, userId);
            ps.executeUpdate();
        }
    }

    public int getLikeCount(int postId) throws SQLException {
        connection con = new connection();
        try (Connection connect = con.getConnection();
             PreparedStatement ps = connect.prepareStatement(
                 "SELECT COUNT(*) FROM likes WHERE cid = ?")) {
            ps.setInt(1, postId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }
} 