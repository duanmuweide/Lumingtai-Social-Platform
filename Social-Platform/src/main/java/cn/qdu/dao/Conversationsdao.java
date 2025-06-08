package cn.qdu.dao;


import cn.qdu.entity.Conversations;
import cn.qdu.entity.Groupsconversations;
import cn.qdu.entity.Usergroups;
import org.teasoft.bee.osql.Op;
import org.teasoft.bee.osql.api.Suid;
import org.teasoft.bee.osql.api.Condition;
import org.teasoft.honey.osql.shortcut.BF;

import java.util.List;

public class Conversationsdao {
    //消息的插入函数，成功返回1，否则返回0
    public int insert(Conversations conversations) {
        Suid suid = BF.getSuid();
        return suid.insert(conversations) > 0 ? 1 : 0;
    }

    //消息的删除函数，成功返回1，否则返回0
    public int delete(int id) {
        Suid suid = BF.getSuid();
        // 1. 先查询实体是否存在
        Conversations conversations = select(id);
        if (conversations == null) {
            return 0; // 不存在则直接返回失败
        }

        return suid.delete(conversations) > 0 ? 1 : 0;
    }

    //消息根据id查询，成功返回消息，否则返回null
    public Conversations select(int id) {
        Suid suid = BF.getSuid();
        Condition condition = BF.getCondition();
        condition.op("cid", Op.eq, id);

        List<Conversations> usergroupsList = suid.select(new Conversations(), condition);
        return usergroupsList.isEmpty() ? null : usergroupsList.get(0);
    }

    // 根据内容模糊查询，返回List（如果无结果返回null）
    public List<Conversations> selectcontent(String str) {
        Suid suid = BF.getSuid();
        Condition condition = BF.getCondition();

        // 使用 Op.like 进行模糊匹配（包含 str 即可）
        condition.op("cmessage", Op.like, "%" + str + "%");
        List<Conversations> result = suid.select(new Conversations(), condition);
        return result.isEmpty() ? null : result;
    }

    // 根据时间查询，返回List
    public List<Conversations> selectdate(String date) {
        Suid suid = BF.getSuid();
        Condition condition = BF.getCondition();

        condition.op("cdate", Op.eq,"date");

        List<Conversations> result = suid.select(new Conversations(), condition);
        return result.isEmpty() ? null : result;
    }
}
