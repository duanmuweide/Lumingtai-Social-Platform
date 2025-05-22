package cn.qdu.entity;

import java.io.Serializable;

/**
 * @author Honey
 * Create on 2025-05-19 19:29:10
 */
public class Usergroups implements Serializable {

	private static final long serialVersionUID = 1590347354423L;

	private Integer gld;
	private String gname;
	private String gdate;
	private String gimage;
	private String gdescription;
	private Integer gnumber;

	public Integer getGld() {
		return gld;
	}

	public void setGld(Integer gld) {
		this.gld = gld;
	}

	public String getGname() {
		return gname;
	}

	public void setGname(String gname) {
		this.gname = gname;
	}

	public String getGdate() {
		return gdate;
	}

	public void setGdate(String gdate) {
		this.gdate = gdate;
	}

	public String getGimage() {
		return gimage;
	}

	public void setGimage(String gimage) {
		this.gimage = gimage;
	}

	public String getGdescription() {
		return gdescription;
	}

	public void setGdescription(String gdescription) {
		this.gdescription = gdescription;
	}

	public Integer getGnumber() {
		return gnumber;
	}

	public void setGnumber(Integer gnumber) {
		this.gnumber = gnumber;
	}

	public String toString() {
		StringBuilder str = new StringBuilder();
		str.append("Usergroups[");
		str.append("gld=").append(gld);
		str.append(",gname=").append(gname);
		str.append(",gdate=").append(gdate);
		str.append(",gimage=").append(gimage);
		str.append(",gdescription=").append(gdescription);
		str.append(",gnumber=").append(gnumber);
		str.append("]");
		return str.toString();
	}
}