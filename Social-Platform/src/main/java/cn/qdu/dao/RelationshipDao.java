package cn.qdu.dao;

import cn.qdu.entity.Relationship;
import cn.qdu.util.connection;
import org.teasoft.bee.osql.Op;
import org.teasoft.bee.osql.api.Condition;
import org.teasoft.bee.osql.api.Suid;
import org.teasoft.honey.osql.shortcut.BF;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

public class RelationshipDao {
    public boolean insert(Relationship relationship){
        Suid suid = BF.getSuid();
        int cnt = suid.insert(relationship);
        System.out.println("插入成功!");
        return cnt > 0;
    }

    public void delete(Relationship relationship){
        Suid suid = BF.getSuid();
        int deletecount = suid.delete(relationship);
        if (deletecount > 0 ) System.out.println("删除成功!");
        else System.out.println("删除失败!");
    }

    public void update(Relationship relationship) throws SQLException {
        connection con = new connection();
        Connection connect = con.getConnection();

        String sql = "UPDATE relationship SET ruid = ?,rfiendid = ?, rtype= ?, rdate = ? WHERE rid = ?";

        PreparedStatement ps = connect.prepareStatement(sql);

        ps.setInt(1,relationship.getRuid());
        ps.setInt(2,relationship.getRfiendid());
        ps.setInt(3,relationship.getRtype());
        ps.setString(4, relationship.getRdate());
        ps.setInt(5,relationship.getRid());

        int affectedRows = ps.executeUpdate();

        if (affectedRows > 0) {
            System.out.println("更新成功，影响行数: " + affectedRows);
        } else {
            System.out.println("没有记录被更新");
        }
    }

    public List<Relationship> selectByRuid(Integer ruid){
        Suid suid = BF.getSuid();
        Relationship rel = new Relationship(); rel.setRuid(ruid);
        List<Relationship> list = suid.select(rel);
        if (list.size() > 0) {System.out.println("查询成功"); return list;}
        else {System.out.println("没有记录"); return null;}
    }

    public List<Relationship> selectByRfriendid(Integer rfiendid){
        Suid suid = BF.getSuid();
        Relationship rel = new Relationship(); rel.setRfiendid(rfiendid);
        List<Relationship> list = suid.select(rel);
        if (list.size() > 0) {System.out.println("查询成功"); return list;}
        else {System.out.println("没有记录"); return null;}
    }

    public List<Relationship> selectByRtype(Integer rtype){
        Suid suid = BF.getSuid();
        Relationship rel = new Relationship(); rel.setRtype(rtype);
        List<Relationship> list = suid.select(rel);
        if (list.size() > 0) {System.out.println("查询成功"); return list;}
        else {System.out.println("没有记录"); return null;}
    }

    public List<Relationship> selectByRdate(String rdate){
        Suid suid = BF.getSuid();
        Relationship rel = new Relationship(); rel.setRdate(rdate);
        List<Relationship> list = suid.select(rel);
        if (list.size() > 0) {System.out.println("查询成功"); return list;}
        else {System.out.println("没有记录"); return null;}
    }

    public List<Relationship> selectByMany(Integer ruid,Integer rfiendid,Integer rtype,String rdate){
        Suid suid = BF.getSuid();
        Relationship rel = new Relationship();
        rel.setRdate(rdate);
        rel.setRuid(ruid);
        rel.setRfiendid(rfiendid);
        rel.setRtype(rtype);
        List<Relationship> list = suid.select(rel);
        if (list.size() > 0) {System.out.println("查询成功"); return list;}
        else {System.out.println("没有记录"); return null;}
    }


    // 在RelationshipDao类中添加更完整的查询方法
    public List<Relationship> getFriends(int userId) {
        Suid suid = BF.getSuid();
        Condition condition = BF.getCondition();

        // 查询当前用户的好友关系（rtype=1表示好友关系）
        condition.op("ruid", Op.eq, userId)
                .op("rtype", Op.eq, 1);

        return suid.select(new Relationship(), condition);
    }

    // 同时保留原有的select方法
    public List<Relationship> select(Relationship relationship) {
        Suid suid = BF.getSuid();
        return suid.select(relationship);

    public List<Relationship> selectByManytwoid(Integer uid, Integer friendid){
        Suid suid = BF.getSuid();
        Relationship rel = new Relationship();
        rel.setRuid(uid);
        rel.setRfiendid(friendid);
        List<Relationship> list = suid.select(rel);
        return list;

    }

}
