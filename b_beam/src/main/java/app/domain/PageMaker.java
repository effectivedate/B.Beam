package app.domain;

//하단 페이지 네비게이션에 필요한 변수들의 집합 클래스
public class PageMaker {

	// 하단의 페이지 목록 번호
	private int displayPageNum = 10;
	private int startPage;	// 목록의 시작 번호 변수
	private int endPage;	// 목록의 끝 번호 변수
	private int totalCount;	// 총 게시물 수 담는 변수
	private int totalEndPage;	// 마지막 페이지 번호 담는 변수

	private boolean prev;	// 이전 버튼 존재 여부
	private boolean next;	// 다음 버튼 존재 여부
	
	private SearchCriteria scri;

	public int getDisplayPageNum()	{return displayPageNum;	}
	public int getStartPage()		{return startPage;		}
	public int getEndPage()			{return endPage;		}
	public int getTotalCount()		{return totalCount;		}
	public int getTotalEndPage()	{return totalEndPage;	}
	public boolean isPrev()			{return prev;			}
	public boolean isNext()			{return next;			}
	public SearchCriteria getScri()	{return scri;			}

	public void setDisplayPageNum(int displayPageNum)	{this.displayPageNum = displayPageNum;	}
	public void setStartPage(int startPage)				{this.startPage = startPage;			}
	public void setEndPage(int endPage)					{this.endPage = endPage;				}
	public void setPrev(boolean prev)					{this.prev = prev;						}
	public void setNext(boolean next)					{this.next = next;						}
	public void setScri(SearchCriteria scri)			{this.scri = scri;						}
	public void setTotalCount(int totalCount){
		this.totalCount = totalCount;
		calcData();	// 페이지 목록 갯수를 나타내 주기 위한 계산식
	}
	private void calcData() {
		// 1. 기본적으론 1에서 10까지 나타나게 설정
		// 1 / 10 = 0.1 (올림처리)-> 1 * 10 == 10
		endPage = (int)(Math.ceil(scri.getPage()/(double)displayPageNum) * displayPageNum);
		
		// 2. endPage설정했으면 startPage 설정
		// endPage에서 - displayPageNum + 1;
		startPage = (endPage - displayPageNum) + 1;
		
		// 3. 실제 페이지 값을 뽑겠다
		totalEndPage = (int)Math.ceil(totalCount/(double)scri.getNumOfRows());
		
		// 4. 설정endPage와 실제endPage 비교
		if (endPage > totalEndPage) {
			endPage = totalEndPage;
		}
		
		// 5. 이전 다음버튼 유무
		prev = (startPage == 1 ? false : true);
		next = (endPage == totalEndPage ? false : true);
	}
	
}
