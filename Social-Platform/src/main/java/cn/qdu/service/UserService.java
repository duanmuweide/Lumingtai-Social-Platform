//package cn.qdu.service;
//
//import cn.qdu.dao.UserDao;
//import cn.qdu.entity.User;
//
//public class UserService {
//    public static boolean register(String username, String password) {
//        // 检查用户名是否已存在
//        if (UserDao.findByUsername(username) {
//            return false;
//        }
//        // 密码加密（实际项目用 BCrypt）
//        String encryptedPwd = MD5Util.encrypt(password);
//        return UserDao.save(username, encryptedPwd);
//    }
//
//    public static User login(String username, String password) {
//        User user = UserDao.findUser(username);
//        if (user != null && user.getPassword().equals(MD5Util.encrypt(password))) {
//            return user;
//        }
//        return null;
//    }
//}