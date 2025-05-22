package cn.qdu.entity;

import java.io.Serializable;

/**
 * @author Honey
 * Create on 2025-05-19 19:29:10
 */
public class Posts implements Serializable {

	private static final long serialVersionUID = 1595227845839L;

	private Integer pld;
	private Integer puid;
	private String pmessage;
	private String pdate;
	private String pfile;

	public Integer getPld() {
		return pld;
	}

	public void setPld(Integer pld) {
		this.pld = pld;
	}

	public Integer getPuid() {
		return puid;
	}

	public void setPuid(Integer puid) {
		this.puid = puid;
	}

	public String getPmessage() {
		return pmessage;
	}

	public void setPmessage(String pmessage) {
		this.pmessage = pmessage;
	}

	public String getPdate() {
		return pdate;
	}

	public void setPdate(String pdate) {
		this.pdate = pdate;
	}

	public String getPfile() {
		return pfile;
	}

	public void setPfile(String pfile) {
		this.pfile = pfile;
	}

	public String toString() {
		StringBuilder str = new StringBuilder();
		str.append("Posts[");
		str.append("pld=").append(pld);
		str.append(",puid=").append(puid);
		str.append(",pmessage=").append(pmessage);
		str.append(",pdate=").append(pdate);
		str.append(",pfile=").append(pfile);
		str.append("]");
		return str.toString();
	}
}