package cn.qdu.entity;

import java.io.Serializable;
import java.sql.Date;

/**
 * @author Honey
 * Create on 2025-05-16 15:57:47
 */
public class Users implements Serializable {

	private static final long serialVersionUID = 1592950104834L;

	private Integer uid;//用户id 主键 自动增长
	private String uname;//用户名
	private String upwd;//用户密码
	private String uquestion;//密码查询问题
	private String uanswer;//密码查询答案
	private Date ubirthday;//用户生日
	private Boolean ugender;//用户性别
	private String uhobby;//用户爱好
	private String usign;//用户签名

	public Integer getUid() {
		return uid;
	}

	public void setUid(Integer uid) {
		this.uid = uid;
	}

	public String getUname() {
		return uname;
	}

	public void setUname(String uname) {
		this.uname = uname;
	}

	public String getUpwd() {
		return upwd;
	}

	public void setUpwd(String upwd) {
		this.upwd = upwd;
	}

	public String getUquestion() {
		return uquestion;
	}

	public void setUquestion(String uquestion) {
		this.uquestion = uquestion;
	}

	public String getUanswer() {
		return uanswer;
	}

	public void setUanswer(String uanswer) {
		this.uanswer = uanswer;
	}

	public Date getUbirthday() {
		return ubirthday;
	}

	public void setUbirthday(Date ubirthday) {
		this.ubirthday = ubirthday;
	}

	public Boolean getUgender() {
		return ugender;
	}

	public void setUgender(Boolean ugender) {
		this.ugender = ugender;
	}

	public String getUhobby() {
		return uhobby;
	}

	public void setUhobby(String uhobby) {
		this.uhobby = uhobby;
	}

	public String getUsign() {
		return usign;
	}

	public void setUsign(String usign) {
		this.usign = usign;
	}

	public String toString() {
		StringBuilder str = new StringBuilder();
		str.append("Users[");
		str.append("uid=").append(uid);
		str.append(",uname=").append(uname);
		str.append(",upwd=").append(upwd);
		str.append(",uquestion=").append(uquestion);
		str.append(",uanswer=").append(uanswer);
		str.append(",ubirthday=").append(ubirthday);
		str.append(",ugender=").append(ugender);
		str.append(",uhobby=").append(uhobby);
		str.append(",usign=").append(usign);
		str.append("]");
		return str.toString();
	}
}