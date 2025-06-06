package cn.qdu.dao;

import cn.qdu.entity.Relationship;
import org.teasoft.bee.osql.api.Suid;
import org.teasoft.honey.osql.shortcut.BF;

public class RelationshipDao {
    public void insert(Relationship relationship){
        Suid suid = BF.getSuid();
        suid.insert(relationship);
        System.out.println("插入成功!");
    }

    public void delete(Relationship relationship){
        Suid suid = BF.getSuid();
        int deletecount = suid.delete(relationship);
        if (deletecount > 0 ) System.out.println("删除成功!");
        else System.out.println("删除失败!");
    }

    public void update(Relationship relationship){
        Suid suid = BF.getSuid();
        int updatecount =  suid.update(relationship);
        if (updatecount > 0 ) System.out.println("更新成功!");
        else System.out.println("更新失败!");
    }


}
