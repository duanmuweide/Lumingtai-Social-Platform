package cn.qdu.entity;

import java.io.Serializable;

/**
 * @author Honey
 * Create on 2025-06-19 16:20:29
 */
public class Comments implements Serializable {

	private static final long serialVersionUID = 1590971434702L;

	private Integer cid;
	private Integer cuid;
	private Boolean clike;
	private String cfile;
	private String cmessage;
	private String cdate;

	public Integer getCid() {
		return cid;
	}

	public void setCid(Integer cid) {
		this.cid = cid;
	}

	public Integer getCuid() {
		return cuid;
	}

	public void setCuid(Integer cuid) {
		this.cuid = cuid;
	}

	public Boolean getClike() {
		return clike;
	}

	public void setClike(Boolean clike) {
		this.clike = clike;
	}

	public String getCfile() {
		return cfile;
	}

	public void setCfile(String cfile) {
		this.cfile = cfile;
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
		str.append("Comments[");
		str.append("cid=").append(cid);
		str.append(",cuid=").append(cuid);
		str.append(",clike=").append(clike);
		str.append(",cfile=").append(cfile);
		str.append(",cmessage=").append(cmessage);
		str.append(",cdate=").append(cdate);
		str.append("]");
		return str.toString();
	}
}