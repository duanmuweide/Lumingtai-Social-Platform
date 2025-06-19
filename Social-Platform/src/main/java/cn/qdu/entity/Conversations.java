package cn.qdu.entity;

import java.io.Serializable;

/**
 * @author Honey
 * Create on 2025-06-19 16:20:29
 */
public class Conversations implements Serializable {

	private static final long serialVersionUID = 1594324435202L;

	private Integer cid;
	private Integer csenderid;
	private Integer creceiverid;
	private String cmessage;
	private String cdate;

	public Integer getCid() {
		return cid;
	}

	public void setCid(Integer cid) {
		this.cid = cid;
	}

	public Integer getCsenderid() {
		return csenderid;
	}

	public void setCsenderid(Integer csenderid) {
		this.csenderid = csenderid;
	}

	public Integer getCreceiverid() {
		return creceiverid;
	}

	public void setCreceiverid(Integer creceiverid) {
		this.creceiverid = creceiverid;
	}

	public String getCmessage() {
		return cmessage;
	}

	public void setCmessage(String cmessage) {
		this.cmessage = cmessage;
	}

	public String getCdate() {
		return cdate;
	}

	public void setCdate(String cdate) {
		this.cdate = cdate;
	}

	public String toString() {
		StringBuilder str = new StringBuilder();
		str.append("Conversations[");
		str.append("cid=").append(cid);
		str.append(",csenderid=").append(csenderid);
		str.append(",creceiverid=").append(creceiverid);
		str.append(",cmessage=").append(cmessage);
		str.append(",cdate=").append(cdate);
		str.append("]");
		return str.toString();
	}
}