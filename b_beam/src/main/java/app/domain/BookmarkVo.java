package app.domain;

public class BookmarkVo {
	private String contentid;
	private int mbno;
	private boolean bmdelyn;
	private String bmdate;
	private String bmdatem;
	public String getContentid() {
		return contentid;
	}
	public void setContentid(String contentid) {
		this.contentid = contentid;
	}
	public int getMbno() {
		return mbno;
	}
	public void setMbno(int mbno) {
		this.mbno = mbno;
	}
	public boolean isBmdelyn() {
		return bmdelyn;
	}
	public void setBmdelyn(boolean bmdelyn) {
		this.bmdelyn = bmdelyn;
	}
	public String getBmdate() {
		return bmdate;
	}
	public void setBmdate(String bmdate) {
		this.bmdate = bmdate;
	}
	public String getBmdatem() {
		return bmdatem;
	}
	public void setBmdatem(String bmdatem) {
		this.bmdatem = bmdatem;
	}

}
