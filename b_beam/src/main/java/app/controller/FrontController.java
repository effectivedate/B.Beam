package app.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/FrontController")
public class FrontController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		String url = request.getRequestURI();
		System.out.println("url : " + url);
		int length = request.getContextPath().length();
		String command = url.substring(length);
		String[] ary = command.split("/");
		String str = ary[1];
		String location = ary[2];
		
		if(str.equals("member")) {
			MemberController mbc = new MemberController(location);
			mbc.doGet(request, response);
		}else if(str.equals("board")) {
			BoardController bdc = new BoardController(location);
			bdc.doGet(request, response);
		}else if(str.equals("comment")) {
			CommentController cmt = new CommentController(location);
			cmt.doGet(request, response);
		}else if(str.equals("contents")) {
			ContentsController ctc = new ContentsController(location);
			ctc.doGet(request, response);
		}else if(str.equals("review")) {
			ReviewController rvc = new ReviewController(location);
			rvc.doGet(request, response);
		}else if(str.equals("qna")) {
			QnAController qac = new QnAController(location);
			qac.doGet(request, response);
		}else if(str.equals("report")) {
			ReportController rpc = new ReportController(location);
			rpc.doGet(request, response);
		}else if(str.equals("point")) {
			PointController ptc = new PointController(location);
			ptc.doGet(request, response);
		}
		
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		doGet(request, response);
	}

}
