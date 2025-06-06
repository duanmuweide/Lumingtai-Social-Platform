package cn.qdu.dao;

import cn.qdu.entity.Groupspeople;
import org.teasoft.bee.osql.Op;
import org.teasoft.bee.osql.api.Condition;
import org.teasoft.bee.osql.api.Suid;
import org.teasoft.honey.osql.shortcut.BF;

import java.util.List;

public class Groupspeopledao {
    //群成员的插入函数，成功返回1，否则返回0
    public int insert(Groupspeople groupspeople) {
        Suid suid = BF.getSuid();
        return suid.insert(groupspeople) > 0 ? 1 : 0;
    }

    // 群某个成员的删除函数，成功返回1，否则返回0
    public int deletepeople(int gid, int uid) {
        Suid suid = BF.getSuid();

        // 1. 先根据复合主键(gid, uid)查询实体是否存在
        Groupspeople groupspeople = select(gid,uid);
        if (groupspeople == null) {
            return 0; // 不存在则直接返回失败
        }

        // 2. 直接删除实体对象
        return suid.delete(groupspeople) > 0 ? 1 : 0;
    }

    //群的删除
    public int deletegroup(int gpid) {
        Suid suid = BF.getSuid();
        Condition condition = BF.getCondition();
        condition.op("gpid", Op.eq, gpid);

        int deletedCount = suid.delete(new Groupspeople(), condition);
        return deletedCount > 0 ? 1 : 0;
    }


    //群所有成员的查询函数，成功返回这个群的所有用户，否则返回null
    public List<Groupspeople> selectall(int gid) {
        Suid suid = BF.getSuid();
        Condition condition = BF.getCondition();
        condition.op("gpid", Op.eq, gid);

        // 查询所有符合条件的记录
        List<Groupspeople> result = suid.select(new Groupspeople(), condition);
        return result.isEmpty() ? null : result;
    }

    //群某个成员查询函数
    public Groupspeople select(int gid, int uid) {
        Suid suid = BF.getSuid();
        Condition condition = BF.getCondition();
        condition.op("gpid", Op.eq, gid)
                .op("gpuid", Op.eq, uid);

        // 查询唯一记录
        List<Groupspeople> result = suid.select(new Groupspeople(), condition);
        return result != null && !result.isEmpty() ? result.get(0) : null;
    }


}
