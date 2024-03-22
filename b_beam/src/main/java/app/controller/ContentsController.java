package app.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import app.dao.BookmarkDao;
import app.dao.ContentsDao;
import app.dao.ReviewDao;
import app.domain.ContentsVo;
import app.domain.PageMaker;
import app.domain.ReviewVo;
import app.domain.SearchCriteria;

/**
 * Servlet implementation class ContentsController
 */
@WebServlet("/ContentsController")
public class ContentsController extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	
    private String location;
    
    public ContentsController(String location) {
		this.location = location;
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		if (location.equals("contentsList.do")) {

	        HttpSession session = request.getSession();
			String contenttypeid="";
			String keyword="";
			String page="1";
			if(request.getParameter("contenttypeid")!=null)	{
				contenttypeid=request.getParameter("contenttypeid");
			}
			if(request.getParameter("keyword")!=null) {
				keyword=request.getParameter("keyword");
			}
			if(request.getParameter("page")!=null){
				page=request.getParameter("page");
			}

			
			PageMaker pm = new PageMaker();
			SearchCriteria sc = new SearchCriteria();
			sc.setContentsTypeId(contenttypeid);
			sc.setKeyword(keyword);
			sc.setPage(Integer.parseInt(page));
			
			pm.setScri(sc);
			ContentsDao cd = new ContentsDao();
			ReviewDao rvd = new ReviewDao();
			

			ArrayList<ContentsVo> aryList = new ArrayList<ContentsVo>();
			ArrayList<String> contentidList = new ArrayList<String>();
			JSONObject body = cd.ContentsList(pm);
			JSONObject items = (JSONObject)body.get("items");
			int totalCount = Integer.parseInt(body.get("totalCount").toString());
			JSONArray item = (JSONArray)items.get("item");
			System.out.println(totalCount);
			pm.setTotalCount(totalCount);
			for(int i = 0; i < item.size(); i++) {
				ContentsVo cv = new ContentsVo();
				JSONObject contents = (JSONObject)item.get(i);
				contentidList.add(contents.get("contentid").toString());
				cv.setContentid(contents.get("contentid").toString());
				cv.setContenttypeid(contents.get("contenttypeid").toString());
				cv.setContentdate(contents.get("createdtime").toString());
				cv.setFirstimage(contents.get("firstimage").toString());
				cv.setFirstimage2(contents.get("firstimage2").toString());
				cv.setTitle(contents.get("title").toString());
				cv.setMapx(contents.get("mapx").toString());
				cv.setMapy(contents.get("mapy").toString());
				cv.setContentRating(rvd.getReviewAverage(cv.getContentid()));
				cv.setContentReviewCnt(cd.getReviewcnt(cv.getContentid()));
				cv.setContentLikeYN("N");
				aryList.add(cv);
			}
			if(session.getAttribute("mbno")!=null&&!session.getAttribute("mbno").equals("")) {
				BookmarkDao bmd= new BookmarkDao();
				String[] myBmList=bmd.getContentsListBookmark((int)session.getAttribute("mbno"), contentidList);
////				request.setAttribute("myBmList", myBmList);
				for(int i = 0; i < aryList.size(); i++) {
					for(int j = 0; j < myBmList.length;j++) {
						if(aryList.get(i).getContentid().equals(myBmList[j])) {
							ContentsVo temCv = aryList.get(i);
							temCv.setContentLikeYN("Y");
							aryList.set(i, temCv);
						}
					}
					
				}
			}
			request.setAttribute("aryList", aryList);
			request.setAttribute("pm", pm);
			
			
			
			String path ="/contents/contentsList.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(path);
			rd.forward(request, response);
		}else if (location.equals("contentsDetail.do")) {

	        HttpSession session = request.getSession();
	        String contentid = request.getParameter("contentid");
	        JSONParser parser = new JSONParser(); 
	        ContentsDao cd = new ContentsDao();
//	        JSONObject contents = cd.ContentsViewDetail(contentid);
//	        ContentsVo cv = new ContentsVo();
	        ContentsVo cv = cd.getTempContents(contentid);
	        JSONObject contents;
			try {
				contents = (JSONObject)parser.parse(cv.getDetailCommon1());
		        JSONArray img =(JSONArray)parser.parse(cv.getDetailImage1());
		        JSONArray menuimg = (JSONArray)parser.parse(cv.getMenuImage1());
		        JSONObject intro = (JSONObject)parser.parse(cv.getDetailIntro1());
		        request.setAttribute("menuImage", menuimg);
		        request.setAttribute("contentsImage", img);
		        request.setAttribute("cv", cv);
		        request.setAttribute("contents", contents);
		        request.setAttribute("contentIntro", intro);
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
//			cv.setAddr1(contents.get("addr1").toString());
//			cv.setContentid(contents.get("contentid").toString());
//			cv.setContenttypeid(contents.get("contenttypeid").toString());
//			cv.setContentdate(contents.get("createdtime").toString());
//			cv.setTitle(contents.get("title").toString());
//			cv.setTel(contents.get("tel").toString());
//			cv.setZipcode(contents.get("zipcode").toString());
//			cv.setFirstimage(contents.get("firstimage").toString());
//			cv.setFirstimage2(contents.get("firstimage2").toString());
//			cv.setMapx(contents.get("mapx").toString());
//			cv.setMapy(contents.get("mapy").toString());
//			JSONObject intro = cd.ContentsViewIntro(contentid,cv.getContenttypeid());
//			JSONArray img = cd.ContentsViewDetailImage(contentid);
//			JSONArray menuimg = new JSONArray();
			String path ="/contents/contentsDetail.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(path);
			rd.forward(request, response);
		}else if (location.equals("getBookmark.do")) {
	        HttpSession session = request.getSession();
			String contentid = request.getParameter("contentid");
			int value = 0;
			if(session.getAttribute("mbno")!=null&&!session.getAttribute("mbno").equals("")) {
				BookmarkDao bmd= new BookmarkDao();
				ArrayList<String> contentidList = new ArrayList<String>();
				contentidList.add(contentid);
				String[] myBm=bmd.getContentsListBookmark((int)session.getAttribute("mbno"), contentidList);
////				request.setAttribute("myBmList", myBmList);
				if(myBm.length>0) {
					value=1;
				}
			}else {
				value=2;
			}
			PrintWriter out = response.getWriter();
			out.print("{\"value\":"+value+"}");
		}else if (location.equals("doBookmark.do")) {
	        HttpSession session = request.getSession();
			String contentid = request.getParameter("contentid");
			int mbno = (int)session.getAttribute("mbno");
			BookmarkDao bd = new BookmarkDao();
			int value = bd.doBookmark(mbno, contentid); 
			PrintWriter out = response.getWriter();
			out.print("{\"value\":"+value+"}");
		}else if (location.equals("undoBookmark.do")) {
	        HttpSession session = request.getSession();
			String contentid = request.getParameter("contentid");
			int mbno = (int)session.getAttribute("mbno");
			BookmarkDao bd = new BookmarkDao();
			int value = bd.undoBookmark(mbno, contentid); 
			PrintWriter out = response.getWriter();
			out.print("{\"value\":"+value+"}");
		}else if (location.equals("contentsRanking.do")) {
			ContentsDao cd = new ContentsDao();
			ReviewDao rvd  = new ReviewDao();
			int rankcnt = 10;
			ArrayList<ContentsVo> viewContents = cd.getViewRanking(rankcnt);
			ArrayList<ContentsVo> reviewContents = cd.getReviewRanking(rankcnt);
			ArrayList<ContentsVo> bookmarkContents = cd.getBookmarkRanking(rankcnt); 
			ArrayList<ContentsVo> ratingContents = cd.getIndexRatingRanking(rankcnt); 

			request.setAttribute("vcList", viewContents);
			request.setAttribute("rcList", reviewContents);
			request.setAttribute("bcList", bookmarkContents);
			request.setAttribute("rtList", ratingContents);
			
			String path ="/contents/contentsRanking.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(path);
			rd.forward(request, response);
		}else if (location.equals("bookmarkedContents.do")) {
			ContentsDao cd = new ContentsDao();
	        HttpSession session = request.getSession();
	        int mbno = 0;
	        if(session.getAttribute("mbno") != null) {
	        	mbno = (int) session.getAttribute("mbno");
	        }
	        
			ArrayList<ContentsVo> bmList = cd.getBookmarkedContents(mbno);

			request.setAttribute("bmList", bmList);
			String path ="/contents/bookmarkedContents.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(path);
			rd.forward(request, response);
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
