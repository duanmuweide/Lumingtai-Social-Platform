package cn.qdu.dao;

import cn.qdu.entity.Posts;
import org.teasoft.bee.osql.api.Suid;
import org.teasoft.honey.osql.shortcut.BF;

public class PostDao {
    public void insert(Posts post){
        Suid suid = BF.getSuid();
        suid.insert(post);
        System.out.println("插入成功!");
    }

    public void delete(Posts post){
        Suid suid = BF.getSuid();
        int deletecount = suid.delete(post);
        if (deletecount > 0 ) System.out.println("删除成功!");
        else System.out.println("删除失败!");
    }

    public void update(Posts post){
        Suid suid = BF.getSuid();
        int updatecount =  suid.update(post);
        if (updatecount > 0 ) System.out.println("更新成功!");
        else System.out.println("更新失败!");
    }

}
