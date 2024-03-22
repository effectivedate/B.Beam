package app.domain;

import java.sql.Array;
import java.util.ArrayList;

public class ReviewVo {
	private int rvno;
	private int mbno;
	private String mbname;
	private String contentid;
	private String rvcont;
	private String rvpic;
	private String rvrate;
	private String rvdate;
	private int rvLikeCnt;
	private ArrayList<String> rvglname;
	private String rvLikeYN;

	


	public String getMbname() {
		return mbname;
	}
	public void setMbname(String mbname) {
		this.mbname = mbname;
	}
	public int getRvno() {
		return rvno;
	}
	public void setRvno(int rvno) {
		this.rvno = rvno;
	}
	public int getMbno() {
		return mbno;
	}
	public void setMbno(int mbno) {
		this.mbno = mbno;
	}
	public String getContentid() {
		return contentid;
	}
	public void setContentid(String contentid) {
		this.contentid = contentid;
	}
	public String getRvcont() {
		return rvcont;
	}
	public void setRvcont(String rvcont) {
		this.rvcont = rvcont;
	}
	public String getRvpic() {
		return rvpic;
	}
	public void setRvpic(String rvpic) {
		this.rvpic = rvpic;
	}
	public String getRvrate() {
		return rvrate;
	}
	public void setRvrate(String rvrate) {
		this.rvrate = rvrate;
	}
	public String getRvdate() {
		return rvdate;
	}
	public void setRvdate(String rvdate) {
		this.rvdate = rvdate;
	}
	public int getRvLikeCnt() {
		return rvLikeCnt;
	}
	public void setRvLikeCnt(int rvLikeCnt) {
		this.rvLikeCnt = rvLikeCnt;
	}
	public ArrayList<String> getRvglname() {
		return rvglname;
	}
	public void setRvglname(ArrayList<String> rvglname) {
		this.rvglname = rvglname;
	}
	public String getRvLikeYN() {
		return rvLikeYN;
	}
	public void setRvLikeYN(String rvLikeYN) {
		this.rvLikeYN = rvLikeYN;
	}



}