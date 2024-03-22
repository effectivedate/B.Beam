package app.domain;

import java.util.List;

public class BdgalleryVo extends BoardVo {
	private int bdno;
	private int bdglno;
	private String bdglname;
	private String bdgldelyn;
	private List<String> bdglnameList;
	
	public List<String> getBdglnameList() {
		return bdglnameList;
	}
	public void setBdglnameList(List<String> bdglnameList) {
		this.bdglnameList = bdglnameList;
	}
	public int getBdno() {
		return bdno;
	}
	public void setBdno(int bdno) {
		this.bdno = bdno;
	}
	public int getBdglno() {
		return bdglno;
	}
	public void setBdglno(int bdglno) {
		this.bdglno = bdglno;
	}
	public String getBdglname() {
		return bdglname;
	}
	public void setBdglname(String bdglname) {
		this.bdglname = bdglname;
	}
	public String getBdgldelyn() {
		return bdgldelyn;
	}
	public void setBdgldelyn(String bdgldelyn) {
		this.bdgldelyn = bdgldelyn;
	}
	
}
