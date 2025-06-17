package cn.qdu.entity;

import java.io.Serializable;

/**
 * @author Honey
 * Create on 2025-06-02 19:19:54
 */
public class Users implements Serializable {

	private static final long serialVersionUID = 1598401129619L;


	private Integer uid;
	private String uname;
	private String upwd;
	private String uquestion;
	private String uanswer;
	private String ubirthday;
	private Boolean ugender;
	private String uhobby;
	private String usign;
	private String uphonenumber;
	private String uemail;
	private String uimage;

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

	public String getUbirthday() {
		return ubirthday;
	}

	public void setUbirthday(String ubirthday) {
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

	public String getUphonenumber() {
		return uphonenumber;
	}

	public void setUphonenumber(String uphonenumber) {
		this.uphonenumber = uphonenumber;
	}

	public String getUemail() {
		return uemail;
	}

	public void setUemail(String uemail) {
		this.uemail = uemail;
	}

	public String getUimage() {
		return uimage;
	}

	public void setUimage(String uimage) {
		this.uimage = uimage;
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
		str.append(",uphonenumber=").append(uphonenumber);
		str.append(",uemail=").append(uemail);
		str.append(",uimage=").append(uimage);
		str.append("]");
		return str.toString();
	}
}

