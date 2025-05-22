package cn.qdu.util;

public class UserDao {
    // 模拟数据库
    private static Map<String, User> fakeDB = new HashMap<>();

    public static boolean findByUsername(String username) {
        return fakeDB.containsKey(username);
    }

    public static boolean save(String username, String password) {
        fakeDB.put(username, new User(username, password));
        return true;
    }

    public static User findUser(String username) {
        return fakeDB.get(username);
    }
}