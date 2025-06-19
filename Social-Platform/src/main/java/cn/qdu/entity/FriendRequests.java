package cn.qdu.entity;

import java.io.Serializable;

/**
 * @author Honey
 * Create on 2025-06-19 16:20:29
 */
public class FriendRequests implements Serializable {

	private static final long serialVersionUID = 1597023450115L;

	private Integer id;
	private Integer reqid;
	private Integer recid;
	private String message;
	private String createtime;
	private Boolean status;

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Integer getReqid() {
		return reqid;
	}

	public void setReqid(Integer reqid) {
		this.reqid = reqid;
	}

	public Integer getRecid() {
		return recid;
	}

	public void setRecid(Integer recid) {
		this.recid = recid;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public String getCreatetime() {
		return createtime;
	}

	public void setCreatetime(String createtime) {
		this.createtime = createtime;
	}

	public Boolean getStatus() {
		return status;
	}

	public void setStatus(Boolean status) {
		this.status = status;
	}

	public String toString() {
		StringBuilder str = new StringBuilder();
		str.append("FriendRequests[");
		str.append("id=").append(id);
		str.append(",reqid=").append(reqid);
		str.append(",recid=").append(recid);
		str.append(",message=").append(message);
		str.append(",createtime=").append(createtime);
		str.append(",status=").append(status);
		str.append("]");
		return str.toString();
	}
}