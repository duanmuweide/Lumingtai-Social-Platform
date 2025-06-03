package cn.qdu.entity;

import java.io.Serializable;

/**
 * @author Honey
 * Create on 2025-06-02 19:19:54
 */
public class Groupspeople implements Serializable {

	private static final long serialVersionUID = 1594956413867L;

	private Integer gpid;
	private Integer gpuid;
	private String gpname;
	private String gpdate;
	private Integer gpidentity;

	public Integer getGpid() {
		return gpid;
	}

	public void setGpid(Integer gpid) {
		this.gpid = gpid;
	}

	public Integer getGpuid() {
		return gpuid;
	}

	public void setGpuid(Integer gpuid) {
		this.gpuid = gpuid;
	}

	public String getGpname() {
		return gpname;
	}

	public void setGpname(String gpname) {
		this.gpname = gpname;
	}

	public String getGpdate() {
		return gpdate;
	}

	public void setGpdate(String gpdate) {
		this.gpdate = gpdate;
	}

	public Integer getGpidentity() {
		return gpidentity;
	}

	public void setGpidentity(Integer gpidentity) {
		this.gpidentity = gpidentity;
	}

	public String toString() {
		StringBuilder str = new StringBuilder();
		str.append("Groupspeople[");
		str.append("gpid=").append(gpid);
		str.append(",gpuid=").append(gpuid);
		str.append(",gpname=").append(gpname);
		str.append(",gpdate=").append(gpdate);
		str.append(",gpidentity=").append(gpidentity);
		str.append("]");
		return str.toString();
	}
}