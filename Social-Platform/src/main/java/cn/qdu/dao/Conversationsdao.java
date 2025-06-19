package cn.qdu.dao;


import cn.qdu.entity.Conversations;
import org.teasoft.bee.osql.Op;
import org.teasoft.bee.osql.OrderType;
import org.teasoft.bee.osql.api.Condition;
import org.teasoft.bee.osql.api.Suid;
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

    public void delete(Conversations conversations) {
        Suid suid = BF.getSuid();
        suid.delete(conversations);
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

    public List<Conversations> getConversations(int user1, int user2) {
        Suid suid = BF.getSuid();
        Condition condition = BF.getCondition();

        // 创建查询条件： (user1发给user2) 或 (user2发给user1)
        // 方法1：使用Op.or组合条件
        condition.op("csenderid", Op.eq, user1).op("creceiverid", Op.eq, user2);
        condition.or();
        condition.op("csenderid", Op.eq, user2).op("creceiverid", Op.eq, user1);

        // 方法2：如果方法1不行，可以尝试使用原生SQL条件
        // condition.op("(csenderid=? AND creceiverid=?) OR (csenderid=? AND creceiverid=?)",
        //     new Object[]{user1, user2, user2, user1});

        // 按日期排序
        condition.orderBy("cdate", OrderType.ASC);

        return suid.select(new Conversations(), condition);
    }

    public List<Conversations> selectBytwoid(int id1, int id2) {
        Suid suid = BF.getSuid();
        Conversations conversations = new Conversations();
        conversations.setCsenderid(id1);
        conversations.setCreceiverid(id2);
        List<Conversations> result = suid.select(conversations);
        return result.isEmpty() ? null : result;
    }

}