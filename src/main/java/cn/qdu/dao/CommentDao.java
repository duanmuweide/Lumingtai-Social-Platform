package cn.qdu.dao;

import cn.qdu.entity.Comments;
import org.teasoft.bee.osql.api.Suid;
import org.teasoft.honey.osql.shortcut.BF;

public class CommentDao {
    public void insert(Comments com){
        Suid suid = BF.getSuid();
        suid.insert(com);
        System.out.println("插入成功!");
    }

    public void delete(Comments com){
        Suid suid = BF.getSuid();
        int deletecount = suid.delete(com);
        if (deletecount > 0 ) System.out.println("删除成功!");
        else System.out.println("删除失败!");
    }

    public void update(Comments com){
        Suid suid = BF.getSuid();
        int updatecount =  suid.update(com);
        if (updatecount > 0 ) System.out.println("更新成功!");
        else System.out.println("更新失败!");
    }
}
