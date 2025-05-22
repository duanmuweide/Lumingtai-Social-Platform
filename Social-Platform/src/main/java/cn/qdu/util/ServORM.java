package cn.qdu.util;

import org.teasoft.honey.osql.autogen.GenBean;
import org.teasoft.honey.osql.autogen.GenConfig;

/**
 *
 * @author maste
 */
public class ServORM {

    public static void main(String[] args) {
        GenConfig genConfig = new GenConfig();
        genConfig.setGenSerializable(true);
        genConfig.setGenToString(true);
        // 生成代码的目录位置（相对）
        genConfig.setBaseDir("src/main/java/");
        // 生成代码所属的包名
        genConfig.setPackagePath("cn.qdu.entity");
        genConfig.setOverride(true);
        genConfig.setGenComment(true);
        genConfig.setCommentPlace(1);

        // genSomeBeanFile的参数：是数据库中的表名
        // ORM框架一般会自动读取默认位置的数据库配置文件
        new GenBean(genConfig).genSomeBeanFile("users");
        new GenBean(genConfig).genSomeBeanFile("comments");
        new GenBean(genConfig).genSomeBeanFile("conversations");
        new GenBean(genConfig).genSomeBeanFile("groupsconversations");
        new GenBean(genConfig).genSomeBeanFile("groupspeople");
        new GenBean(genConfig).genSomeBeanFile("posts");
        new GenBean(genConfig).genSomeBeanFile("relationship");
        new GenBean(genConfig).genSomeBeanFile("usergroups");

    }
}