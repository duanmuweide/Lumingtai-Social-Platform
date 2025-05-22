package cn.qdu.entity;

import java.io.Serializable;

/**
 * @author Honey
 * Create on 2025-05-19 19:29:10
 */
public class Relationship implements Serializable {

	private static final long serialVersionUID = 1594574786689L;

	private Integer rid;
	private Integer ruid;
	private Integer rfiendid;
	private Integer rtype;
	private String rdate;

	public Integer getRid() {
		return rid;
	}

	public void setRid(Integer rid) {
		this.rid = rid;
	}

	public Integer getRuid() {
		return ruid;
	}

	public void setRuid(Integer ruid) {
		this.ruid = ruid;
	}

	public Integer getRfiendid() {
		return rfiendid;
	}

	public void setRfiendid(Integer rfiendid) {
		this.rfiendid = rfiendid;
	}

	public Integer getRtype() {
		return rtype;
	}

	public void setRtype(Integer rtype) {
		this.rtype = rtype;
	}

	public String getRdate() {
		return rdate;
	}

	public void setRdate(String rdate) {
		this.rdate = rdate;
	}

	public String toString() {
		StringBuilder str = new StringBuilder();
		str.append("Relationship[");
		str.append("rid=").append(rid);
		str.append(",ruid=").append(ruid);
		str.append(",rfiendid=").append(rfiendid);
		str.append(",rtype=").append(rtype);
		str.append(",rdate=").append(rdate);
		str.append("]");
		return str.toString();
	}
}