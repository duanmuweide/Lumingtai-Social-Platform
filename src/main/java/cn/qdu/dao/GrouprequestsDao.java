package cn.qdu.dao;

import cn.qdu.entity.Grouprequests;
import cn.qdu.entity.Groupspeople;
import org.teasoft.bee.osql.Op;
import org.teasoft.bee.osql.api.Condition;
import org.teasoft.bee.osql.api.Suid;
import org.teasoft.honey.osql.shortcut.BF;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class GrouprequestsDao {
    private Suid suid = BF.getSuid();

    public boolean insert(Grouprequests request) {
        return suid.insert(request) > 0;
    }

    public Grouprequests selectById(int id) {
        Grouprequests request = new Grouprequests();
        request.setId(id);
        List<Grouprequests> requests = suid.select(request);
        return requests != null && !requests.isEmpty() ? requests.get(0) : null;
    }

    public boolean acceptRequest(int id) {
        return deleteRequest(id);
    }

    public boolean rejectRequest(int id) {
        return deleteRequest(id);
    }

    public boolean deleteRequest(int id) {
        Grouprequests request = new Grouprequests();
        request.setId(id);
        return suid.delete(request) > 0;
    }

    public List<Grouprequests> selectByGroupOwner(int ownerId) {
        // Step 1: Find all group IDs for which the user is an owner.
        Condition ownerCondition = BF.getCondition();
        ownerCondition.op("gpuid", Op.eq, ownerId);
        ownerCondition.op("gpidentity", Op.eq, 3); // 3 represents the owner

        List<Groupspeople> ownedGroups = suid.select(new Groupspeople(), ownerCondition);

        // Step 2: If the user owns no groups, they can't have any requests.
        if (ownedGroups == null || ownedGroups.isEmpty()) {
            return new ArrayList<>(); // Return empty list
        }

        // Step 3: Extract the group IDs into a list of Integers.
        List<Integer> groupIds = ownedGroups.stream()
                .map(Groupspeople::getGpid)
                .collect(Collectors.toList());

        // Step 4: Find all pending requests for those group IDs.
        Condition requestCondition = BF.getCondition();
        requestCondition.op("groupid", Op.in, groupIds); // Use the list of IDs
        requestCondition.op("status", Op.eq, false); // Pending requests

        return suid.select(new Grouprequests(), requestCondition);
    }

    public static boolean createGroupRequest(int userId, int groupId, String message) {
        Grouprequests request = new Grouprequests();
        request.setUserid(userId);
        request.setGroupid(groupId);
        request.setMessage(message);
        request.setStatus(false); // 未处理

        // 设置创建时间
        LocalDateTime currentDateTime = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        String dateString = currentDateTime.format(formatter);
        request.setCreatetime(dateString);

        return new GrouprequestsDao().insert(request);
    }

    public static boolean hasPendingRequest(int userId, int groupId) {
        Suid suid = BF.getSuid();
        Grouprequests request = new Grouprequests();
        request.setUserid(userId);
        request.setGroupid(groupId);
        request.setStatus(false); // 未处理的请求

        // 使用 select 方法查询请求列表
        List<Grouprequests> requests = suid.select(request);

        // 如果列表不为空，表示存在待处理请求
        return requests != null && !requests.isEmpty();
    }

    // 新增方法：获取用户的群组请求
    public List<Grouprequests> getRequestsByUser(int userId) {
        Condition condition = BF.getCondition();
        condition.op("userid", Op.eq, userId);
        return suid.select(new Grouprequests(), condition);
    }
}