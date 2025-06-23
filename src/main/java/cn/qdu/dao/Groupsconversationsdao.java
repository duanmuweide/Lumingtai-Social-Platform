package cn.qdu.dao;
import cn.qdu.entity.Groupsconversations;
import org.teasoft.bee.osql.Op;
import org.teasoft.bee.osql.api.Suid;
import org.teasoft.bee.osql.api.Condition;
import org.teasoft.honey.osql.shortcut.BF;

import java.util.Collections;
import java.util.List;

public class Groupsconversationsdao {
    //群消息的插入函数，成功返回1，否则返回0
    public int insert(Groupsconversations groupsconversations) {
        Suid suid = BF.getSuid();
        return suid.insert(groupsconversations) > 0 ? 1 : 0;
    }

    //群某条消息的删除函数，成功返回1，否则返回0
    public int delete(int id) {
        Suid suid = BF.getSuid();
        // 1. 先查询实体是否存在
        Groupsconversations groupsconversations = select(id);
        if (groupsconversations == null) {
            return 0; // 不存在则直接返回失败
        }

        return suid.delete(groupsconversations) > 0 ? 1 : 0;
    }

    //群全部消息的删除，成功返回1，否则返回0
    public int deleteall(int gid) {
        Suid suid = BF.getSuid();
        Condition condition = BF.getCondition();
        condition.op("gcgid", Op.eq, gid);

        int deletedCount = suid.delete(new Groupsconversations(), condition);
        return deletedCount > 0 ? 1 : 0;
    }


    //群消息根据id查询，成功返回所查询用户，否则返回null
    public Groupsconversations select(int id) {
        Suid suid = BF.getSuid();
        Condition condition = BF.getCondition();
        condition.op("gcid", Op.eq, id);

        List<Groupsconversations> usergroupsList = suid.select(new Groupsconversations(), condition);
        return usergroupsList.isEmpty() ? null : usergroupsList.get(0);
    }

    // 根据内容模糊查询，返回List（如果无结果返回null）
    public List<Groupsconversations> selectcontent(String str) {
        Suid suid = BF.getSuid();
        Condition condition = BF.getCondition();

        // 使用 Op.like 进行模糊匹配（包含 str 即可）
        condition.op("gcmessage", Op.like, "%" + str + "%");

        List<Groupsconversations> result = suid.select(new Groupsconversations(), condition);
        return result.isEmpty() ? null : result;
    }

    // 根据时间查询，返回List
    public List<Groupsconversations> selectdate(String date) {
        Suid suid = BF.getSuid();
        Condition condition = BF.getCondition();

        condition.op("gcdate", Op.eq,date);

        List<Groupsconversations> result = suid.select(new Groupsconversations(), condition);
        return result.isEmpty() ? null : result;
    }

    //根据用户id查询
    public List<Groupsconversations> selectbyuid(int id) {
        Suid suid = BF.getSuid();
        Condition condition = BF.getCondition();
        condition.op("gcuid", Op.eq, id);

        List<Groupsconversations> usergroupsList = suid.select(new Groupsconversations(), condition);
        return usergroupsList.isEmpty() ? null : usergroupsList;
    }

    //根据组id查询
    public List<Groupsconversations> selectbygid(int id) {
        Suid suid = BF.getSuid();
        Condition condition = BF.getCondition();
        condition.op("gcgid", Op.eq, id);

        List<Groupsconversations> result = suid.select(new Groupsconversations(), condition);
        return result != null ? result : Collections.emptyList(); // 确保不返回null
    }


}