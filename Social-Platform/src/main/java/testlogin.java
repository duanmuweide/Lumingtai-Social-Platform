mport cn.qdu.dao.RelationshipDao;
import cn.qdu.entity.Relationship;

public class testlogin {
    public static void main(String[] args) {
        RelationshipDao dao = new RelationshipDao();
        Relationship relationship = new Relationship();
        relationship.setRuid(4); relationship.setRfiendid(3);
        relationship.setRdate("1");
        dao.insert(relationship);
        relationship.setRuid(3); relationship.setRfiendid(4);
        dao.insert(relationship);
    }
}