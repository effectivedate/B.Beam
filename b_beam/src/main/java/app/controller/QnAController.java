package app.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Enumeration;

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

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import app.dao.BoardDao;
import app.dao.MemberDao;
import app.dao.QnADao;
import app.dao.ReviewDao;
import app.domain.BoardVo;
import app.domain.MemberVo;
import app.domain.QnAVo;
import app.domain.ReviewVo;

/**
 * Servlet implementation class ContentsController
 */
@WebServlet("/QnAController")
public class QnAController extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	
    private String location;
    
    public QnAController(String location) {
		this.location = location;
    }
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		if (location.equals("qna.do")) {
			
			String path ="/qna/qna.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(path);
			rd.forward(request, response);
			
		}else if (location.equals("myQnA.do")) {
			
			HttpSession session = request.getSession();
			QnADao qd = new QnADao();
			int mbno = 0;
			if(session.getAttribute("mbno") != null) {
			 mbno = (int) session.getAttribute("mbno");
			}
			
			ArrayList<QnAVo> q_alist = qd.qnaSelectAll(mbno);
			request.setAttribute("q_alist", q_alist);
			
			
			String path ="/qna/myQnA.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(path);
			rd.forward(request, response);
		
		}else if(location.equals("qnaWriteAction.do")) {
			 
			QnAVo qv = new QnAVo();
			
			// 폼에서 값 가져오기
			String qtitle = request.getParameter("bdtitle");
			String qcont = request.getParameter("bdcont");
			
			
			qv.setQtitle(qtitle);
			qv.setQcont(qcont);
			
			HttpSession session = request.getSession();
			int mbno = (int) session.getAttribute("mbno");
			qv.setQmbno(mbno);
			
			
			QnADao qd = new QnADao();
			int result = qd.qnaInsert(qv);
			
			if (result == 0) {
				// 삽입 실패
				response.setContentType("text/html;charset=UTF-8");
				PrintWriter out = response.getWriter();
				out.println("<script>alert('QnA를 제출하는 데 실패했습니다. 다시 시도해주세요.'); history.back();</script>");
				out.flush();
				out.close();
			} else {
				// 데이터베이스에 성공적으로 삽입
				response.sendRedirect(request.getContextPath() + "/qna/myQnA.do");
			
			}
		}else if(location.equals("qnaModify.do")) {
			
			int qano = Integer.parseInt(request.getParameter("qano"));
			int qmbno = Integer.parseInt(request.getParameter("qmbno"));
			
			QnADao qd = new QnADao();
			QnAVo qv = qd.qnaModify(qano, qmbno);
			request.setAttribute("qv", qv);
				
			String path ="/qna/myQnA.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(path);	
			rd.forward(request, response);
			
		
		}else if (location.equals("qnaModifyAction.do")) {
			
			QnAVo qv = new QnAVo();
			int qano = Integer.parseInt(request.getParameter("qano"));
			String qtitle = request.getParameter("modify-title");
			String qcont = request.getParameter("modify-content");
			
			qv.setQano(qano);
			qv.setQtitle(qtitle);
			qv.setQcont(qcont);
			
			
			QnADao qd = new QnADao();
			int result = qd.qModify(qv);
				if (result > 0) {
					// 수정 성공
					response.sendRedirect(request.getContextPath() + "/qna/myQnA.do");
				} else {
					// 수정 실패
					response.setContentType("text/html;charset=UTF-8");
					PrintWriter out = response.getWriter();
					out.println("<script>alert('QnA 수정에 실패했습니다. 다시 시도해주세요.'); history.back();</script>");
					out.flush();
					out.close();
				
			}
				
		}else if (location.equals("qnaDeleteAction.do")) {
					
			int qano = Integer.parseInt(request.getParameter("qano"));
			
			QnADao qd = new QnADao();
			int result = qd.qnaDelete(qano);
			if (result >0) {
				//삭제성공
				response.sendRedirect(request.getContextPath() + "/qna/myQnA.do");
			}else {
				response.setContentType("text/html;charset=UTF-8");
				PrintWriter out = response.getWriter();
				out.println("<script>alert('삭제에 실패했습니다. 다시 시도해주세요.'); history.back();</script>");
				out.flush();
				out.close();
			}
			
		}else if (location.equals("managerMyQnA.do")) {
		
			HttpSession session = request.getSession();
			QnADao qd = new QnADao();
			
			int mbno = 0;
			if(session.getAttribute("mbno") != null) {
			 mbno = (int) session.getAttribute("mbno");
			}
			
			ArrayList<QnAVo> qna_alist = qd.mngqnaSelectAll();
			request.setAttribute("qna_alist", qna_alist);
			
//			for(QnAVo qav :qna_alist) {
//				System.out.println( qav.getAmbno());
//			}
			
			String path ="/qna/managerMyQnA.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(path);
			rd.forward(request, response);
			
		}else if (location.equals("mngWriteAction.do")) {
			
			HttpSession session = request.getSession();
			int ambno = (int) session.getAttribute("mbno");
			
			QnADao qd = new QnADao();
			QnAVo qv = new QnAVo();
			int qano = Integer.parseInt(request.getParameter("qano"));
			String acont = request.getParameter("bdcont");
			
			qv.setQano(qano);
			qv.setAcont(acont);
			qv.setAmbno(ambno);
			
			int result = qd.mngqnaInsert(qv);
			
			
			
			if (result == 0) {
				// 삽입 실패
				response.setContentType("text/html;charset=UTF-8");
				PrintWriter out = response.getWriter();
				out.println("<script>alert('QnA를 제출하는 데 실패했습니다. 다시 시도해주세요.'); history.back();</script>");
				out.flush();
				out.close();
			} else {
				// 데이터베이스에 성공적으로 삽입
				response.sendRedirect(request.getContextPath() + "/qna/managerMyQnA.do");
			
			}
		}else if (location.equals("mngqnaModifyAction.do")) {
				QnAVo qv = new QnAVo();
				int qano = Integer.parseInt(request.getParameter("qano"));
				String acont = request.getParameter("modify-content");  

				qv.setQano(qano);
				qv.setAcont(acont);

				QnADao qd = new QnADao();
				int result = qd.mngqnaModify(qv);
				if (result > 0) {
				// 수정 성공
				response.sendRedirect(request.getContextPath() + "/qna/managerMyQnA.do");
				} else {
				// 수정 실패
				response.setContentType("text/html;charset=UTF-8");
				PrintWriter out = response.getWriter();
				out.println("<script>alert('QnA 수정에 실패했습니다. 다시 시도해주세요.'); history.back();</script>");
				out.flush();
					out.close();
			
			}	
		}else if (location.equals("mngqnaDeleteAction.do")) {
					
			int qano = Integer.parseInt(request.getParameter("qano"));
			
			QnADao qd = new QnADao();
			int result = qd.mngqnaDelete(qano);
			if (result >0) {
				//삭제성공
				response.sendRedirect(request.getContextPath() + "/qna/managerMyQnA.do");
			}else {
				response.setContentType("text/html;charset=UTF-8");
				PrintWriter out = response.getWriter();
				out.println("<script>alert('삭제에 실패했습니다. 다시 시도해주세요.'); history.back();</script>");
				out.flush();
				out.close();
			}
			
		}
			
			
		
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
