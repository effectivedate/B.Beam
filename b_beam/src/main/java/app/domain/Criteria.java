package app.domain;

// 페이징을 하기 위한 기준이 되는 클래스
public class Criteria {
	private int page;		// 페이지 번호를 담는 변수
	private int numOfRows;	// 리스트에 한 페이지에 보여지는 게시물 수
	
	public Criteria() {
		this.page = 1;
		this.numOfRows = 20;
	}

	public int getPage() 		{return page;		}
	public int getNumOfRows()	{return numOfRows;	}

	public void setPage(int page)				{this.page = page;				}
	public void setNumOfRows(int numOfRows)	{this.numOfRows = numOfRows;	}
	
	
}
