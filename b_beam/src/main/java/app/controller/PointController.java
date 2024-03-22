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

import app.dao.PointDao;
import app.domain.PointVo;

/**
 * Servlet implementation class ContentsController
 */
@WebServlet("/PointController")
public class PointController extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	
    private String location;
    
    public PointController(String location) {
		this.location = location;
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		if (location.equals("memberPoint.do")) {
			HttpSession session = request.getSession();
			int mbno = 0;
			if (session.getAttribute("mbno") == null) {
				PrintWriter out = response.getWriter();
				out.println("<script>alert('회원 전용 기능입니다. 로그인을 해주세요.');"
							+ "document.location.href='" + request.getContextPath() + "/member/memberLogin.do'</script>");
			} else {
				mbno = (int)session.getAttribute("mbno");
				System.out.println(mbno);
			}
			
			PointVo pv = new PointVo();
			PointDao pd = new PointDao();
			
			pv = pd.pointInfo(mbno);
			
			request.setAttribute("pv", pv);
			
			String path ="/point/memberPoint.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(path);
			rd.forward(request, response);
		}else if (location.equals("managerPoint.do")) {
			
			String path ="/point/managerPoint.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(path);
			rd.forward(request, response);
		}else if (location.equals("usePointAction.do")) {
			HttpSession session = request.getSession();
			int mbno = 0;
			int ptpt = 0;
			
			if (session.getAttribute("mbno") != null) {
				mbno = (int)session.getAttribute("mbno");
			}
			
			ptpt = Integer.parseInt(request.getParameter("ptpt"));
			
			PointVo pv = new PointVo();
			PointDao pd = new PointDao();
			
			pv.setMbno(mbno);
			pv.setPtpt(ptpt);
			
			System.out.println("mbno : " + mbno);
			
			int value = 0;
			value = pd.usePoint(pv);
			
			System.out.println("value : " + value);
			
			response.setContentType("application/json");
			response.setCharacterEncoding("UTF-8");
			PrintWriter out = response.getWriter();
			out.print("{\"success\": " + (value > 0) + "}");
			out.flush();
			out.close();
			
		}
		
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
