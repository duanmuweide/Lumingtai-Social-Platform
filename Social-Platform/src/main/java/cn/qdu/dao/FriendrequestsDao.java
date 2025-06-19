package cn.qdu.dao;

import cn.qdu.entity.FriendRequests;
import cn.qdu.util.connection;
import org.teasoft.bee.osql.api.Suid;
import org.teasoft.honey.osql.shortcut.BF;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

public class FriendrequestsDao {
    public boolean insert(FriendRequests friendRequests){
        Suid suid = BF.getSuid();
        int cnt = suid.insert(friendRequests);
        System.out.println("插入成功!");
        if(cnt>0){ return true;}
        else return false;
    }
    public void delete(FriendRequests friendRequests){
        Suid suid = BF.getSuid();
        int deletecount = suid.delete(friendRequests);
        if (deletecount > 0 ) System.out.println("删除成功!");
        else System.out.println("删除失败!");
    }
    public void update(FriendRequests friendRequests) throws SQLException {
        connection con = new connection();
        Connection connect = con.getConnection();

        String sql = "UPDATE friend_requests SET reqid = ?, recid= ?, message = ?, " +
                "createtime = ? where id = ? ";

        PreparedStatement ps = connect.prepareStatement(sql);

        ps.setInt(1, friendRequests.getReqid());
        ps.setInt(2, friendRequests.getRecid());
        ps.setString(3, friendRequests.getMessage());
        ps.setString(4, friendRequests.getCreatetime());
        ps.setInt(5, friendRequests.getId());

        int affectedRows = ps.executeUpdate();

        if (affectedRows > 0) {
            System.out.println("更新成功，影响行数: " + affectedRows);
        } else {
            System.out.println("没有记录被更新");
        }

    }

    public List<FriendRequests> selectByRecid(int Recid) throws SQLException {
        Suid suid = BF.getSuid();
        FriendRequests friendRequests = new FriendRequests();
        friendRequests.setRecid(Recid);
        friendRequests.setStatus(false);
        List<FriendRequests> list = suid.select(friendRequests);
        if (list.size() > 0) {System.out.println("查询成功"); return list;}
        else {System.out.println("没有记录"); return null;}
    }

    public static FriendRequests selectBytwoid(int Reqid, int Recid) throws SQLException {
        Suid suid = BF.getSuid();
        FriendRequests friendRequests = new FriendRequests();

        friendRequests.setReqid(Reqid);
        friendRequests.setRecid(Recid);
        friendRequests.setStatus(false);

        List<FriendRequests> f =  suid.select(friendRequests);
        FriendRequests ff = f.get(0);
        if (ff != null) { return ff;}
        else {return null;}
    }

    public static FriendRequests selectBytwoidandstatus(int Reqid, int Recid) throws SQLException {
        Suid suid = BF.getSuid();
        FriendRequests friendRequests = new FriendRequests();

        friendRequests.setReqid(Reqid);
        friendRequests.setRecid(Recid);
        friendRequests.setStatus(true);

        List<FriendRequests> f =  suid.select(friendRequests);
        FriendRequests ff = f.get(0);
        if (ff != null) { return ff;}
        else {return null;}
    }

    public static boolean hasPendingRequest(int requesterId, int receiverId) {
        Suid suid = BF.getSuid();
        FriendRequests friendRequests = new FriendRequests();
        friendRequests.setReqid(requesterId);
        friendRequests.setRecid(receiverId);
        List<FriendRequests> list = suid.select(friendRequests);
        if (list.size() > 0) {return true;}
        else {return false;}
    }

    public static boolean createFriendRequest(int requesterId, int receiverId, String message) {
        Suid suid = BF.getSuid();
        FriendRequests friendRequests = new FriendRequests();

        friendRequests.setReqid(requesterId);
        friendRequests.setRecid(receiverId);
        friendRequests.setMessage(message);
        friendRequests.setStatus(false);
        LocalDateTime currentDateTime = LocalDateTime.now();
        // 创建DateTimeFormatter对象，并指定日期格式
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        // 将日期时间转换为字符串
        String dateString = currentDateTime.format(formatter);
        friendRequests.setCreatetime(dateString);

        int cnt = suid.insert(friendRequests);
        if (cnt > 0) {return true;}
        else {return false;}
    }


    public boolean rejectFriendRequest(int reqid, int recid) throws SQLException {
        Suid suid = BF.getSuid();
        FriendRequests friendRequests = new FriendRequests();
        friendRequests.setReqid(reqid);
        friendRequests.setRecid(recid);
        friendRequests.setStatus(false);
        int cnt = suid.delete(friendRequests);
        if (cnt > 0) {return true;}
        else {return false;}
    }

    public boolean acceptFriendRequest(int reqid, int recid) throws SQLException {
        Suid suid = BF.getSuid();
        FriendRequests friendRequests = new FriendRequests();
        friendRequests.setReqid(reqid);
        friendRequests.setRecid(recid);
        friendRequests.setStatus(false);
        int cnt = suid.delete(friendRequests);
        if (cnt > 0) {return true;}
        else {return false;}
    }

}
