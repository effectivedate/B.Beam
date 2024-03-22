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
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import app.dao.ReportDao;
import app.domain.MemberVo;
import app.domain.PageMaker;
import app.domain.ReportVo;
import app.domain.SearchCriteria;

/**
 * Servlet implementation class ContentsController
 */
@WebServlet("/ReportController")
public class ReportController extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	
    private String location;
    
    public ReportController(String location) {
		this.location = location;
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		if (location.equals("report.do")) {
			
			SearchCriteria scri = new SearchCriteria();
			
			String page = request.getParameter("page");
			if (page == null) { page = "1";}
			
			scri.setPage(Integer.parseInt(page));
			
			PageMaker pm = new PageMaker();
			pm.setScri(scri);
			
			ReportDao rpd = new ReportDao();
			ArrayList<ReportVo> alist = rpd.reportList(scri);
			pm.setTotalCount(rpd.reportTotalCount(scri));
			
			request.setAttribute("pm", pm);
			request.setAttribute("alist", alist);
			
			String path ="/report/report.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(path);
			rd.forward(request, response);				

		}else if (location.equals("reportPopup.do")) {
			
			HttpSession session = request.getSession(false);
			
			int mbno = 0; //신고자
			int mbno2 =0; //피신고자
			int no =0; //컨텐츠번호
			String cate = "";//컨텐츠종류
			
			if (session != null) {
				if (session.getAttribute("mbno") != null) {
					mbno = (int) session.getAttribute("mbno");
				}
			}
			if (request.getParameter("mbno2") != null ) {
				mbno2 = Integer.parseInt(request.getParameter("mbno2"));
			}
			if (request.getParameter("no") != null ) {
				no = Integer.parseInt(request.getParameter("no"));
			}
			if (request.getParameter("cate") != null) {
				cate = request.getParameter("cate");
			}
			ReportDao rpd = new ReportDao();
			MemberVo mv = rpd.getContentsMv(no, cate);
			
			
			System.out.println("mbno2 : " + mv.getMbno());
			System.out.println("no : " + no);
			System.out.println("cate : " + cate);

			session.setAttribute("mbno", mbno);
			session.setAttribute("mv", mv);
			session.setAttribute("cate", cate);
			session.setAttribute("no", no);
			String path ="/report/reportPopup.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(path);
			rd.forward(request, response);		
				
		} else if (location.equals("reportAction.do")) {
			HttpSession session = request.getSession(false);
			
			int mbno = 0;
			int mbno2 = 0;
			int bdno = 0;
			int rvno = 0;
			int cmno = 0;
			
			if (request.getParameter("mbno") != null) {
				mbno = Integer.parseInt(request.getParameter("mbno"));
			}
			if (request.getParameter("bdno") != null) {
				bdno = Integer.parseInt(request.getParameter("bdno"));
			}
			if (request.getParameter("mbno2") != null ) {
				mbno2 = Integer.parseInt(request.getParameter("mbno2"));
			}
			if (request.getParameter("rvno") != null ) {
				rvno = Integer.parseInt(request.getParameter("rvno"));
			}
			if (request.getParameter("cmno") != null) {
				cmno = Integer.parseInt(request.getParameter("cmno"));
			}
			
			String rpcate = request.getParameter("rpcate");

			ReportVo rpv = new ReportVo();
			rpv.setMbno(mbno);
			rpv.setMbno2(mbno2);
			rpv.setBdno(bdno);
			rpv.setRvno(rvno);
			rpv.setCmno(cmno);
			rpv.setRpcate(rpcate);
			
			
			System.out.println("mbno : " + mbno);
			System.out.println("mbno2 : " + mbno2);
			System.out.println("bdno : " + bdno);
			System.out.println("rvno : " + rvno);
			System.out.println("cmno : " + cmno);
			System.out.println("rpcate : " + rpcate);
			
			ReportDao rpd = new ReportDao();
			int value = 0;
			
			value = rpd.reportInsert(rpv, rvno, cmno);
			
			System.out.println("value : " + value);
			
			// JSON 형식으로 응답을 생성	
			response.setContentType("application/json");
			response.setCharacterEncoding("UTF-8");
			PrintWriter out = response.getWriter();
			out.print("{\"success\": " + (value > 0) + "}");	// value가 0보다 크면 true 아니면 false
			out.flush();
			out.close();
			
		} else if (location.equals("reportedBoardDeleteUpdate.do")) {
			//신고된 목록에서 원글 삭제
			
			String delYN = request.getParameter("delYN"); //Y, N : 삭제 or 삭제취소 결정
			String rpnoArr = request.getParameter("rpnoArr");
			String reportedBoardNumArr = request.getParameter("reportedBoardNumArr");
			
			JSONParser jParser = new JSONParser(); 
			JSONArray jArr = null;
			JSONArray jArr2 = null;
			try {
				jArr = (JSONArray)jParser.parse(rpnoArr);
				jArr2 = (JSONArray)jParser.parse(reportedBoardNumArr);
			} catch (ParseException e) {
				e.printStackTrace();
			}
			
			for(int i = 0; i < jArr.size(); i++) {
				System.out.println("jArr["+i+"] : " + jArr.get(i));
				System.out.println("jArr2["+i+"] : " + jArr2.get(i));
			}
			
			ReportDao rpd = new ReportDao();
			int value = 0;
			int rpno = 0;
			int reportedBoardNum = 0;
			
			for(int i = 0; i < jArr.size(); i++) {
				rpno = Integer.parseInt(jArr.get(i).toString());
				reportedBoardNum = Integer.parseInt(jArr2.get(i).toString());
				rpd.reportedBoardDeleteUpdate(delYN, rpno, reportedBoardNum);
				value += 1;
			}
			System.out.println("value : " + value);
//			JSON 형식으로 응답을 생성	
//			response.setContentType("application/json");
			
			PrintWriter pw = response.getWriter();
			String responseStr = "{\"value\" : \""+value+"\"}";
			pw.print(responseStr);	// value가 0보다 크면 true 아니면 false
			pw.close();
			
		} else if (location.equals("selectReportedUser.do")) {	
			//유저 선택 시 모달에 불러올 해당 유저 정보
			
			int rpno = 0;
			rpno = Integer.parseInt(request.getParameter("rpno"));
			
			ReportVo rpv = new ReportVo();
			ReportDao rpd = new ReportDao();
			
			rpv = rpd.selectReportedUser(rpno);
			String mbname = rpv.getMbname();
			String mbemail= rpv.getMbemail();
			int mbno2 = rpv.getMbno2();
			
			PrintWriter pw = response.getWriter();
			String responseStr = "{\"rpno\" : \""+rpno+"\", \"mbname\": \""+mbname+"\", \"mbemail\": \""+mbemail+"\", \"mbno2\": \""+mbno2+"\"}";
			pw.println(responseStr);
			pw.close();
			
		} else if (location.equals("penaltyUpdate.do")) {
			//특정 유저에게 패널티를 부여함
			
			int rpno = 0;
			int mbno2 = 0;
			String pndelyn = null;
			
			if(request.getParameter("rpno") != null) {
				rpno = Integer.parseInt(request.getParameter("rpno"));
			}
			if(request.getParameter("mbno2") != null) {
				mbno2 = Integer.parseInt(request.getParameter("mbno2"));
			}
			if(request.getParameter("pndelyn") != null) {
				pndelyn = (String)(request.getParameter("pndelyn"));
			}
			
			System.out.println("rpno : " + rpno);
			System.out.println("mbno2 : " + mbno2);
			System.out.println("pndelyn : " + pndelyn);
			
			ReportDao pd = new ReportDao();
			int value = 0;
			value = pd.penaltyUpdate(rpno, mbno2, pndelyn);
			
			if (value == 0) {
				PrintWriter pw = response.getWriter();
				pw.println("<script>alert('패널티 부여 에러');history.back();</script>");
			} else {
				String path = request.getContextPath()+"/report/report.do";
				response.sendRedirect(path);
			}
			
		}
	}
	
	

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
