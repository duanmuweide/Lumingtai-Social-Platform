package cn.qdu.entity;

import java.io.Serializable;

/**
 * @author Honey
 * Create on 2025-06-19 16:20:29
 */
public class Groupsconversations implements Serializable {

	private static final long serialVersionUID = 1590805416916L;

	private Integer gcid;
	private Integer gcgid;
	private Integer gcuid;
	private String gcmessage;
	private String gcdate;

	public Integer getGcid() {
		return gcid;
	}

	public void setGcid(Integer gcid) {
		this.gcid = gcid;
	}

	public Integer getGcgid() {
		return gcgid;
	}

	public void setGcgid(Integer gcgid) {
		this.gcgid = gcgid;
	}

	public Integer getGcuid() {
		return gcuid;
	}

	public void setGcuid(Integer gcuid) {
		this.gcuid = gcuid;
	}

	public String getGcmessage() {
		return gcmessage;
	}

	public void setGcmessage(String gcmessage) {
		this.gcmessage = gcmessage;
	}

	public String getGcdate() {
		return gcdate;
	}

	public void setGcdate(String gcdate) {
		this.gcdate = gcdate;
	}

	public String toString() {
		StringBuilder str = new StringBuilder();
		str.append("Groupsconversations[");
		str.append("gcid=").append(gcid);
		str.append(",gcgid=").append(gcgid);
		str.append(",gcuid=").append(gcuid);
		str.append(",gcmessage=").append(gcmessage);
		str.append(",gcdate=").append(gcdate);
		str.append("]");
		return str.toString();
	}
}