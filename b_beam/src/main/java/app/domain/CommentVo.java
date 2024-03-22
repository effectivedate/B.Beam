package app.domain;

public class CommentVo extends MemberVo{
	private int cmno;
	private int mbno;
	private int bdno;
	private String cmcont;
	private String cmdate;
	private String cmdatem;
	private String cmdelyn;
	private int cmLikeCnt;
	
	public int getCmno() {
		return cmno;
	}
	public void setCmno(int cmno) {
		this.cmno = cmno;
	}
	public int getMbno() {
		return mbno;
	}
	public void setMbno(int mbno) {
		this.mbno = mbno;
	}
	public int getBdno() {
		return bdno;
	}
	public void setBdno(int bdno) {
		this.bdno = bdno;
	}
	public String getCmcont() {
		return cmcont;
	}
	public void setCmcont(String cmcont) {
		this.cmcont = cmcont;
	}
	public String getCmdate() {
		return cmdate;
	}
	public void setCmdate(String cmdate) {
		this.cmdate = cmdate;
	}
	public String getCmdatem() {
		return cmdatem;
	}
	public void setCmdatem(String cmdatem) {
		this.cmdatem = cmdatem;
	}
	public String getCmdelyn() {
		return cmdelyn;
	}
	public void setCmdelyn(String cmdelyn) {
		this.cmdelyn = cmdelyn;
	}
	public int getCmLikeCnt() {
		return cmLikeCnt;
	}
	public void setCmLikeCnt(int cmLikeCnt) {
		this.cmLikeCnt = cmLikeCnt;
	}

}
