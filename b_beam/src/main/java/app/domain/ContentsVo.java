package app.domain;

public class ContentsVo {
	private String contentid;
	private String title;
	private String contenttypeid;
	private String mapx;
	private String mapy;
	private String firstimage;
	private String firstimage2;
	private String cat1;
	private String cat2;
	private String cat3;
	private String contentdate;
	private String contentdatem;
	private String detailCommon1;
	private String detailImage1;
	private String menuImage1;
	private String detailIntro1;
	private String contentDelyn;
	private int contentsView;
	private int contentLikeCnt;
	private int contentReviewCnt;
	private int contentRating;
	private String contentLikeYN;
	
	public int getContentRating() {
		return contentRating;
	}
	public void setContentRating(int contentRating) {
		this.contentRating = contentRating;
	}
	public int getContentsView() {
		return contentsView;
	}
	public void setContentsView(int contentsView) {
		this.contentsView = contentsView;
	}
	public String getDetailCommon1() {
		return detailCommon1;
	}
	public void setDetailCommon1(String detailCommon1) {
		this.detailCommon1 = detailCommon1.replaceAll("(\r\n|\r|\n|\n\r)", "");
	}
	public String getDetailImage1() {
		return detailImage1;
	}
	public void setDetailImage1(String detailImage1) {
		this.detailImage1 = detailImage1;
	}
	public String getMenuImage1() {
		return menuImage1;
	}
	public void setMenuImage1(String menuImage1) {
		this.menuImage1 = menuImage1;
	}
	public String getDetailIntro1() {
		return detailIntro1;
	}
	public void setDetailIntro1(String detailIntro1) {
		this.detailIntro1 = detailIntro1.replaceAll("(\r\n|\r|\n|\n\r)", "");
	}
	public int getContentLikeCnt() {
		return contentLikeCnt;
	}
	public void setContentLikeCnt(int contentLikeCnt) {
		this.contentLikeCnt = contentLikeCnt;
	}
	public String getContentLikeYN() {
		return contentLikeYN;
	}
	public void setContentLikeYN(String contentLikeYN) {
		this.contentLikeYN = contentLikeYN;
	}
	public String getFirstimage2() {
		return firstimage2;
	}
	public void setFirstimage2(String firstimage2) {
		this.firstimage2 = firstimage2;
	}
	public String getCat1() {
		return cat1;
	}
	public void setCat1(String cat1) {
		this.cat1 = cat1;
	}
	public String getCat2() {
		return cat2;
	}
	public void setCat2(String cat2) {
		this.cat2 = cat2;
	}
	public String getCat3() {
		return cat3;
	}
	public void setCat3(String cat3) {
		this.cat3 = cat3;
	}
	public String getTel() {
		return tel;
	}
	public void setTel(String tel) {
		this.tel = tel;
	}
	public String getZipcode() {
		return zipcode;
	}
	public void setZipcode(String zipcode) {
		this.zipcode = zipcode;
	}
	public String getAddr1() {
		return addr1;
	}
	public void setAddr1(String addr1) {
		this.addr1 = addr1;
	}
	public String getAddr2() {
		return addr2;
	}
	public void setAddr2(String addr2) {
		this.addr2 = addr2;
	}
	private String tel;
	private String zipcode;
	private String addr1;
	private String addr2;
	private int bookMarkCnt;
	
	public String getContentid() {
		return contentid;
	}
	public void setContentid(String contentid) {
		this.contentid = contentid;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContenttypeid() {
		return contenttypeid;
	}
	public void setContenttypeid(String contenttypeid) {
		this.contenttypeid = contenttypeid;
	}
	public String getMapx() {
		return mapx;
	}
	public void setMapx(String mapx) {
		this.mapx = mapx;
	}
	public String getMapy() {
		return mapy;
	}
	public void setMapy(String mapy) {
		this.mapy = mapy;
	}
	public String getFirstimage() {
		return firstimage;
	}
	public void setFirstimage(String firstimage) {
		this.firstimage = firstimage;
	}
	public String getContentdate() {
		return contentdate;
	}
	public void setContentdate(String contentdate) {
		this.contentdate = contentdate;
	}
	public String getContentdatem() {
		return contentdatem;
	}
	public void setContentdatem(String contentdatem) {
		this.contentdatem = contentdatem;
	}
	public String getContentDelyn() {
		return contentDelyn;
	}
	public void setContentDelyn(String contentDelyn) {
		this.contentDelyn = contentDelyn;
	}
	public int getBookMarkCnt() {
		return bookMarkCnt;
	}
	public void setBookMarkCnt(int bookMarkCnt) {
		this.bookMarkCnt = bookMarkCnt;
	}
	public int getContentReviewCnt() {
		return contentReviewCnt;
	}
	public void setContentReviewCnt(int contentReviewCnt) {
		this.contentReviewCnt = contentReviewCnt;
	}

	
}
