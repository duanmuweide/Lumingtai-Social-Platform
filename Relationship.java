package cn.qdu.entity;

import java.io.Serializable;

/**
 * @author Honey
 * Create on 2025-05-16 13:48:03
 */
public class Relationship implements Serializable {

	private static final long serialVersionUID = 1590448936332L;

	private Integer uid;
	private Integer friendid;
	private Integer rela;

	public Integer getUid() {
		return uid;
	}

	public void setUid(Integer uid) {
		this.uid = uid;
	}

	public Integer getFriendid() {
		return friendid;
	}

	public void setFriendid(Integer friendid) {
		this.friendid = friendid;
	}

	public Integer getRela() {
		return rela;
	}

	public void setRela(Integer rela) {
		this.rela = rela;
	}

	public String toString() {
		StringBuilder str = new StringBuilder();
		str.append("Relationship[");
		str.append("uid=").append(uid);
		str.append(",friendid=").append(friendid);
		str.append(",rela=").append(rela);
		str.append("]");
		return str.toString();
	}
}