package cn.qdu.dao;

import cn.qdu.entity.Users;
import org.teasoft.bee.osql.api.Suid;
import org.teasoft.honey.osql.shortcut.BF;

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
        int updatecount =  suid.update(user);
        if (updatecount > 0 ) System.out.println("更新成功!");
        else System.out.println("更新失败!");
    }



}
