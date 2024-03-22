package app.domain;

public class SearchCriteria extends Criteria{
	private String contentsTypeId;
	private String SearchType;
	private String keyword;

	public String getContentsTypeId()	{	return contentsTypeId;	}
	public String getSearchType()		{	return SearchType;	}
	public String getKeyword()			{	return keyword;			}

	public void setContentsTypeId(String contentsTypeId)	{	this.contentsTypeId = contentsTypeId;	}
	public void setSearchType(String SearchType)			{	this.SearchType = SearchType;			}
	public void setKeyword(String keyword)					{	this.keyword = keyword;					}

}
