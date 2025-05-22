package cn.qdu.entity;

import java.io.Serializable;

/**
 * @author Honey
 * Create on 2025-05-19 19:29:10
 */
public class Comments implements Serializable {

	private static final long serialVersionUID = 1591136780679L;

	private Integer cld;
	private Integer cuid;
	private Boolean clike;
	private String cfile;
	private String cmessage;
	private String cdate;

	public Integer getCld() {
		return cld;
	}

	public void setCld(Integer cld) {
		this.cld = cld;
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
		str.append("cld=").append(cld);
		str.append(",cuid=").append(cuid);
		str.append(",clike=").append(clike);
		str.append(",cfile=").append(cfile);
		str.append(",cmessage=").append(cmessage);
		str.append(",cdate=").append(cdate);
		str.append("]");
		return str.toString();
	}
}