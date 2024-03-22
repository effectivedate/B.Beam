package app.domain;

import java.util.ArrayList;

public class BoardVo extends MemberVo{
	private int bdno;
	private int mbno;
	private String bdcate;
	private String bdtitle;
	private String bdcont;
	private String bdtag;
	private String bdcontag;
	private String bddate;
	private String bddatem;
	private String bddelyn;
	private ArrayList<String> bdFilename;
	private int bdLikeCnt;
	private int bdCommentCnt;
	private String bdLikeYN = "N";
	
	public int getBdno() {
		return bdno;
	}
	public void setBdno(int bdno) {
		this.bdno = bdno;
	}
	public int getMbno() {
		return mbno;
	}
	public void setMbno(int mbno) {
		this.mbno = mbno;
	}
	public String getBdcate() {
		return bdcate;
	}
	public void setBdcate(String bdcate) {
		this.bdcate = bdcate;
	}
	public String getBdtitle() {
		return bdtitle;
	}
	public void setBdtitle(String bdtitle) {
		this.bdtitle = bdtitle;
	}
	public String getBdcont() {
		return bdcont;
	}
	public void setBdcont(String bdcont) {
		this.bdcont = bdcont;
	}
	public String getBdtag() {
		return bdtag;
	}
	public void setBdtag(String bdtag) {
		this.bdtag = bdtag;
	}
	public String getBdcontag() {
		return bdcontag;
	}
	public void setBdcontag(String bdcontag) {
		this.bdcontag = bdcontag;
	}
	public String getBddate() {
		return bddate;
	}
	public void setBddate(String bddate) {
		this.bddate = bddate;
	}
	public String getBddatem() {
		return bddatem;
	}
	public void setBddatem(String bddatem) {
		this.bddatem = bddatem;
	}
	public String getBddelyn() {
		return bddelyn;
	}
	public void setBddelyn(String bddelyn) {
		this.bddelyn = bddelyn;
	}
	public ArrayList<String> getBdFilename() {
		return bdFilename;
	}
	public void setBdFilename(ArrayList<String> bdFilename) {
		this.bdFilename = bdFilename;
	}
	public int getBdLikeCnt() {
		return bdLikeCnt;
	}
	public void setBdLikeCnt(int bdLikeCnt) {
		this.bdLikeCnt = bdLikeCnt;
	}
	public String getBdLikeYN() {
		return bdLikeYN;
	}
	public void setBdLikeYN(String bdLikeYN) {
		this.bdLikeYN = bdLikeYN;
	}
	public int getBdCommentCnt() {
		return bdCommentCnt;
	}
	public void setBdCommentCnt(int bdCommentCnt) {
		this.bdCommentCnt = bdCommentCnt;
	}

	
	
}
