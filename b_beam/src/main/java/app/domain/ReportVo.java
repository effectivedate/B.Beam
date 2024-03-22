package app.domain;

public class ReportVo extends BoardVo {
	private int rpno;
	private int mbno;
	private int mbno2;
	private int rvno;
	private int bdno;
	private int cmno;
	private String rpcate;
	private String rpdelyn;
	private int bdno_count;
	private int rvno_count;
	private int cmno_count;
	
	private ReviewVo reviewVo;
	private CommentVo commnetVo;
	private PenaltyVo penaltyVo;
	
	public int getBdno_count() {
		return bdno_count;
	}
	public void setBdno_count(int bdno_count) {
		this.bdno_count = bdno_count;
	}
	public int getRvno_count() {
		return rvno_count;
	}
	public void setRvno_count(int rvno_count) {
		this.rvno_count = rvno_count;
	}
	public int getCmno_count() {
		return cmno_count;
	}
	public void setCmno_count(int cmno_count) {
		this.cmno_count = cmno_count;
	}
	
	public int getRpno() {
		return rpno;
	}
	public ReviewVo getReviewVo() {
		return reviewVo;
	}
	public void setReviewVo(ReviewVo reviewVo) {
		this.reviewVo = reviewVo;
	}
	public CommentVo getCommnetVo() {
		return commnetVo;
	}
	public void setCommnetVo(CommentVo commnetVo) {
		this.commnetVo = commnetVo;
	}
	public void setRpno(int rpno) {
		this.rpno = rpno;
	}
	public int getMbno() {
		return mbno;
	}
	public void setMbno(int mbno) {
		this.mbno = mbno;
	}
	public int getMbno2() {
		return mbno2;
	}
	public void setMbno2(int mbno2) {
		this.mbno2 = mbno2;
	}
	public int getRvno() {
		return rvno;
	}
	public void setRvno(int rvno) {
		this.rvno = rvno;
	}
	public int getBdno() {
		return bdno;
	}
	public void setBdno(int bdno) {
		this.bdno = bdno;
	}
	public int getCmno() {
		return cmno;
	}
	public void setCmno(int cmno) {
		this.cmno = cmno;
	}
	public String getRpcate() {
		return rpcate;
	}
	public void setRpcate(String rpcate) {
		this.rpcate = rpcate;
	}
	public String getRpdelyn() {
		return rpdelyn;
	}
	public void setRpdelyn(String rpdelyn) {
		this.rpdelyn = rpdelyn;
	}
	public PenaltyVo getPenaltyVo() {
		return penaltyVo;
	}
	public void setPenaltyVo(PenaltyVo penaltyVo) {
		this.penaltyVo = penaltyVo;
	}

}
