package cn.qdu.entity;

import java.io.Serializable;

/**
 * @author Honey
 * Create on 2025-05-19 19:29:10
 */
public class Groupspeople implements Serializable {

	private static final long serialVersionUID = 1599324770404L;

	private Integer gpld;
	private Integer gpuid;
	private String gpname;
	private String gpdate;
	private Integer gpidentity;

	public Integer getGpld() {
		return gpld;
	}

	public void setGpld(Integer gpld) {
		this.gpld = gpld;
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
		str.append("gpld=").append(gpld);
		str.append(",gpuid=").append(gpuid);
		str.append(",gpname=").append(gpname);
		str.append(",gpdate=").append(gpdate);
		str.append(",gpidentity=").append(gpidentity);
		str.append("]");
		return str.toString();
	}
}