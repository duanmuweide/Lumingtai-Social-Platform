package cn.qdu.entity;

import java.io.Serializable;

/**
 * @author Honey
 * Create on 2025-05-16 13:47:41
 */
public class Conversations implements Serializable {

	private static final long serialVersionUID = 1598903305955L;

	private Integer cid;
	private Integer senderid;
	private Integer receiverid;
	private String information;
	private String date;

	public Integer getCid() {
		return cid;
	}

	public void setCid(Integer cid) {
		this.cid = cid;
	}

	public Integer getSenderid() {
		return senderid;
	}

	public void setSenderid(Integer senderid) {
		this.senderid = senderid;
	}

	public Integer getReceiverid() {
		return receiverid;
	}

	public void setReceiverid(Integer receiverid) {
		this.receiverid = receiverid;
	}

	public String getInformation() {
		return information;
	}

	public void setInformation(String information) {
		this.information = information;
	}

	public String getDate() {
		return date;
	}

	public void setDate(String date) {
		this.date = date;
	}

	public String toString() {
		StringBuilder str = new StringBuilder();
		str.append("Conversations[");
		str.append("cid=").append(cid);
		str.append(",senderid=").append(senderid);
		str.append(",receiverid=").append(receiverid);
		str.append(",information=").append(information);
		str.append(",date=").append(date);
		str.append("]");
		return str.toString();
	}
}