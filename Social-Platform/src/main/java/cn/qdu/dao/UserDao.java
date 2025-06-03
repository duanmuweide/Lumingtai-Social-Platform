package cn.qdu.dao;

import cn.qdu.entity.Users;
import org.teasoft.bee.osql.api.Suid;
import org.teasoft.honey.osql.shortcut.BF;

import java.util.List;

public class UserDao {
    public void insert(Users user){
        Suid suid = BF.getSuid();
        suid.insert(user);
        System.out.println("插入成功!");
    }

    public void delete(Users user){
        Suid suid = BF.getSuid();
        int deletecount = suid.delete(user);
        if (deletecount > 0 ) System.out.println("删除成功!");
        else System.out.println("删除失败!");
    }

    public void update(Users user){
        Suid suid = BF.getSuid();
        System.out.println("执行更新");
        System.out.println(user.getUid());
        int updatecount = suid.update(user);
        System.out.println(updatecount);
        if (updatecount > 0 ) System.out.println("更新成功!");
        else System.out.println("更新失败!");
    }

    public List<Users> selectOne(String info){
        Suid suid = BF.getSuid();
        Users user = new Users(); user.setUname(info);
        List<Users> list = suid.select(user);
        if (list.size() > 0) {System.out.println("查询成功"); return list;}
        else {System.out.println("没有记录"); return null;}
    }



}
