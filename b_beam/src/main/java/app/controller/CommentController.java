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

import org.json.simple.JSONObject;

import app.dao.CommentDao;
import app.dao.PointDao;
import app.domain.CommentVo;

/**
 * Servlet implementation class ContentsController
 */
@WebServlet("/CommentController")
public class CommentController extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	
    private String location;
    
    public CommentController(String location) {
		this.location = location;
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		if (location.equals("comment.do")) {
			
			String path ="/comment/comment.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(path);
			rd.forward(request, response);
			
		}else if(location.equals("commentList.do")) {
			
			ArrayList<CommentVo> alist = new ArrayList<CommentVo>();
			int bdno = 0;
			int cmno = 0;
			int mbno = 0;
			String cmcont = "";
			String cmdate = "";
			String cmdatem = "";
			String mbname = "";
			String str = "";
			
			if(!request.getParameter("bdno").equals(null)) {
				bdno = Integer.parseInt(request.getParameter("bdno"));
			}
			
			CommentDao cd = new CommentDao();
			alist = cd.commentList(bdno);
			
			for(int i = 0; i < alist.size(); i++) {
				cmno = alist.get(i).getCmno();
				mbno = alist.get(i).getMbno();
				cmcont = alist.get(i).getCmcont();
				cmdate = alist.get(i).getCmdate();
				cmdatem = alist.get(i).getCmdatem();
				mbname = alist.get(i).getMbname();
				
				str += "{\"cmno\" : \""+cmno+"\","
					+  "\"mbno\" : \""+mbno+"\","
					+ "\"cmcont\" : \""+cmcont+"\","
					+ "\"cmdate\" : \""+cmdate+"\","
					+ "\"cmdatem\" : \""+cmdatem+"\","
					+ "\"mbname\" : \""+mbname+"\"},";
			}
			if(!str.equals("")) {
				str = str.substring(0, str.length()-1);
			}
			
			PrintWriter pw = response.getWriter();
			
			pw.println("[" + str +"]");
			
			
		}else if(location.equals("commentWrite.do")) {
			
			CommentVo cv = new CommentVo();
			CommentDao cd = new CommentDao();
			
			if(request.getParameter("mbno") != null) {
				cv.setMbno(Integer.parseInt(request.getParameter("mbno")));
			}
			if(request.getParameter("bdno") != null) {
				cv.setBdno(Integer.parseInt(request.getParameter("bdno")));
			}
			if(request.getParameter("cmcont") != null) {
				cv.setCmcont(request.getParameter("cmcont"));
			}
			
			int value = 0;
			value = cd.commentInsert(cv);
			
			PointDao pd = new PointDao();
			int value2 = 0;
			value2 = pd.getPointComment(cv);
			
			//System.out.println("value2 : " + value2);
			
			PrintWriter pw = response.getWriter();
			String responseStr = "{\"value\" : \""+value+"\", \"value2\" : \""+value2+"\"}";
			pw.println(responseStr);			
			
		}else if(location.equals("commentModify.do")) {
			
			
			
		}else if(location.equals("commentDelete.do")) {
			
			int cmno = 0;
			int value = 0;
			CommentDao cd = new CommentDao();
			
			if(request.getParameter("cmno") != null) {
				cmno = Integer.parseInt(request.getParameter("cmno"));
			}
			value = cd.commentDelete(cmno);
			
			PrintWriter pw = response.getWriter();
			String responseStr = "{\"value\" : \""+value+"\"}";
			pw.println(responseStr);
			
		}
		
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
