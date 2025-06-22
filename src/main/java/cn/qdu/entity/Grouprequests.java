package cn.qdu.entity;

import java.io.Serializable;

public class Grouprequests implements Serializable {
    private static final long serialVersionUID = 1L;

    private Integer id;
    private Integer userid;
    private Integer groupid;
    private String message;
    private String createtime;
    private Boolean status;

    // Getters and Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public Integer getUserid() { return userid; }
    public void setUserid(Integer userid) { this.userid = userid; }
    public Integer getGroupid() { return groupid; }
    public void setGroupid(Integer groupid) { this.groupid = groupid; }
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    public String getCreatetime() { return createtime; }
    public void setCreatetime(String createtime) { this.createtime = createtime; }
    public Boolean getStatus() { return status; }
    public void setStatus(Boolean status) { this.status = status; }

    @Override
    public String toString() {
        return "Grouprequests{" +
                "id=" + id +
                ", userid=" + userid +
                ", groupid=" + groupid +
                ", message='" + message + '\'' +
                ", createtime='" + createtime + '\'' +
                ", status=" + status +
                '}';
    }
}