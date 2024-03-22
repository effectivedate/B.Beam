package app.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.InetAddress;
import java.util.ArrayList;
import java.util.Random;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import app.dao.MemberDao;
import app.dao.PointDao;
import app.domain.BoardVo;
import app.domain.MemberVo;
import app.domain.PointVo;
import app.util.MailSender;

/**
 * Servlet implementation class ContentsController
 */
@WebServlet("/MemberController")
public class MemberController extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	
    private String location;
    
    public MemberController(String location) {
		this.location = location;
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		if (location.equals("member.do")) {
			
			String path ="/member/member.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(path);
			rd.forward(request, response);
		}else if (location.equals("memberJoin.do")) {
			
			String path ="/member/memberJoin.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(path);
			rd.forward(request, response);
		}else if(location.equals("memberJoinAction.do")) {
			
			request.setCharacterEncoding("UTF-8");
			response.setContentType("text/html;charset=UTF-8");
			
			//데이터를 넘겨주면 요청 객체는 그 값을 받아서 넘어온 매개변수에
			//담긴 값을 꺼내서 새로운 변수에 담는다
			MemberVo mv = new MemberVo();
			mv.setMbid(request.getParameter("memberId"));
			mv.setMbpwd(request.getParameter("memberPwd"));
			mv.setMbname(request.getParameter("memberName"));
			mv.setMbemail(request.getParameter("memberEmail"));
			mv.setMbaddr(request.getParameter("postcode")+"/"+request.getParameter("addr")+"/"+request.getParameter("detail_addr"));
			//DB에 입력한다
			MemberDao md = new MemberDao();
			int exec = md.memberInsert(mv);
			
			//System.out.println("exec : " + exec);
			int mbno = mv.getMbno();
			
			//System.out.println("mbno : " + mbno);
			
			if(mbno > 0) {
				BoardVo bv = new BoardVo();
				bv.setMbno(mbno);
				
				PointDao pd = new PointDao();
				int value = pd.getPointJoin(bv);
				
				//System.out.println("value : " + value);
			}
			
			PrintWriter out = response.getWriter();
			
			if (exec == 1) {
				//자동이동메소드
				//response.sendRedirect(request.getContextPath()+"/member/memberList.html");	
				out.println("<script>alert('회원가입 되었습니다.'); alert('회원가입 축하 포인트가 적립되었습니다.');"
				+	"document.location.href='"+request.getContextPath()+"/member/memberLogin.do'</script>");
			}else{
				out.println("<script>history.back();</script>");	
			}
		} else if (location.equals("getsign.do")) {
			   
		        HttpSession session = request.getSession();
		        String authNumber = (String)session.getAttribute("MAIL_NUMBER");
		        String AuthCode = request.getParameter("AuthCode");
		        int value = 0;
		        if (authNumber == null) {
		        	value = 0;
		        }else if(AuthCode.equals(authNumber)) {
		        	value = 1;
		        }
		        System.out.println("value: " + value);
		        response.setContentType("application/json");
		        response.setCharacterEncoding("UTF-8");

		        PrintWriter out = response.getWriter();
		        out.print("{\"value\":\"" + value + "\"}");
		}else if (location.equals("memberIdCheck.do")) {
				    String memberId = request.getParameter("memberId");

				    MemberDao md = new MemberDao();
				    int value = md.memberIdCheck(memberId);

				    // JSON 응답을 생성
				    JSONObject jsonResponse = new JSONObject();
				    jsonResponse.put("value", value);

				    response.setContentType("application/json");
				    response.setCharacterEncoding("UTF-8");

				    PrintWriter out = response.getWriter();
				    out.print(jsonResponse.toJSONString());
				    
		} else if (location.equals("memberNickCheck.do")) {
				    String nick = request.getParameter("memberName");

				    MemberDao md = new MemberDao();
				    int value = md.memberNicknameCheck(nick);

				    // JSON 응답을 생성
				    JSONObject jsonResponse = new JSONObject();
				    jsonResponse.put("value", value);

				    response.setContentType("application/json");
				    response.setCharacterEncoding("UTF-8");

				    PrintWriter out = response.getWriter();
				    out.print(jsonResponse.toJSONString());
				    
		} else if (location.equals("memberEmailCheck.do")) {
				    String email = request.getParameter("memberEmail");
				    MemberDao md = new MemberDao();
				    int value = 0;
				    Random random = new Random();
				    String authNumber = "";

				    for(int i=0; i < 6; i++) {
				        authNumber += random.nextInt(10);			
				    }
				    MailSender mail = new MailSender();

				    value = md.memberEmailCheck(email);
				    String str = "{\"value\":\"" + value + "\"}";

				    if (value == 0) {
				        String title = "회원가입 인증 메일입니다.";
				        String body = "인증번호 : " + authNumber;

				        if (mail.MailSend(email, title, body)) {
				            HttpSession session = request.getSession();
				            session.removeAttribute("MAIL_NUMBER");
				            session.setAttribute("MAIL_NUMBER", authNumber);
				            System.out.println((String)session.getAttribute("MAIL_NUMBER"));
				            System.out.println("send mail ok");
				        }
				    }

				    response.setContentType("application/json");
				    response.setCharacterEncoding("UTF-8");

				    PrintWriter out = response.getWriter();
				    out.print(str);
				
		}else if (location.equals("memberLogin.do")) {
			String referer = "";
			HttpSession session= request.getSession();
			if(request.getHeader("REFERER")!=null) {
				referer = (String)request.getHeader("REFERER");
				session.setAttribute("prevURL", referer);
			}
			

			String path ="/member/memberLogin.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(path);
			rd.forward(request, response);
		}else if(location.equals("memberLoginAction.do")) {
			
			MemberVo mv1 = new MemberVo();
			mv1.setMbid(request.getParameter("memberId"));
			mv1.setMbpwd(request.getParameter("memberPwd"));
			
			
			MemberDao md = new MemberDao();
			int mbno = 0;
			MemberVo mv2 = md.memberLoginCheck(mv1);
			mbno = mv2.getMbno();
			
			System.out.println(mbno);
			System.out.println(mv2.getManager());
			System.out.println("mv2.getLoginCheck() : " + mv2.getLoginCheck());
			//mv2.getLoginCheck()가 null or "N"이면 정상상태 아니면 패널티로 인한 로그인 불가처리
			
			//Action처리하는 용도는 send방식으로 보낸다
			PrintWriter out = response.getWriter();
			if(mv2.getLoginCheck() == null) {
				mv2.setLoginCheck("N");
			}
			if (mbno != 0 && mv2.getLoginCheck().equals("N")) {  //일치하면
				//세션에 회원아이디를 담는다 
				HttpSession session =  request.getSession();
				session.setAttribute("mbname", mv2.getMbname());
				session.setAttribute("mbno", mbno);
				if(mv2.getManager().equals("M")) {
					session.setAttribute("manager", mv2.getManager());
				}
			}
			JSONObject jsonResponse = new JSONObject();
			jsonResponse.put("value", mbno);
			jsonResponse.put("loginCheck", mv2.getLoginCheck());
			out.print(jsonResponse.toJSONString());
			
		}else if(location.equals("memberLogout.do")) {
			
			HttpSession session= request.getSession();
			session.removeAttribute("mbid");
			session.removeAttribute("mbno");
			session.invalidate();
			
			response.sendRedirect(request.getContextPath()+"/");
			
		}else if (location.equals("memberIdFind.do")) {
			
			String path ="/member/memberIdFind.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(path);
			rd.forward(request, response);
		} else if (location.equals("memberIdFindAction.do")) {
		    String email = request.getParameter("memberEmail"); // 변경: email 파라미터로 받음

		    MemberDao md = new MemberDao();
		    String memberId = md.memberIdFind(email);
		    int value = 0;
			PrintWriter out = response.getWriter();
			JSONObject jsonResponse = new JSONObject();
		    if (memberId != null) {
		        // 아이디를 찾았을 때의 처리
		    	value = 1;
		        String star = "";
		        for (int i = 0; i < (memberId.length() - 4); i++) {
		            star += "*";
		        }
		        memberId = memberId.substring(0, 2) + star + memberId.substring(memberId.length() - 2);
			    //아이디 일부 가리기
			    jsonResponse.put("memberId", memberId);
		    }

		    jsonResponse.put("value", value);
			out.print(jsonResponse.toJSONString());
			
			
		}else if (location.equals("memberPwdFind.do")) {
			
			String path ="/member/memberPwdFind.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(path);
			rd.forward(request, response);
			
			
		} else if (location.equals("memberPwdFindAction.do")) {
		    // 사용자가 입력한 아이디와 이메일
		    String memberId = request.getParameter("memberId");
		    String email = request.getParameter("memberEmail");

		    // DAO를 통해 임시 비밀번호 생성 및 업데이트
		    MemberDao md = new MemberDao();
		    String newTempPassword = md.memberPwdFind(memberId, email);

		    if (newTempPassword != null) {
		        // 임시 비밀번호를 사용자 이메일로 전송
		        MailSender mail = new MailSender();
		        String title = "임시 비밀번호 안내";
		        String body = "임시 비밀번호: " + newTempPassword + "\n\n임시 비밀번호로 로그인 후 반드시 비밀번호를 변경해주세요.";
		        if (mail.MailSend(email, title, body)) {
		            // 이메일 전송 성공 시 표시
		            PrintWriter out = response.getWriter();
		            out.println("<script>alert('임시 비밀번호가 이메일로 전송되었습니다.');</script>");
		        } else {
		            // 이메일 전송 실패 시 표시
		            PrintWriter out = response.getWriter();
		            out.println("<script>alert('이메일 전송에 실패했습니다. 다시 시도해주세요.');</script>");
		        }
		    } else {
		        // 해당 회원이 존재하지 않거나 변경이 실패한 경우 메시지 표시
		        PrintWriter out = response.getWriter();
		        out.println("<script>alert('입력하신 정보와 일치하는 회원이 없거나 비밀번호 변경에 실패했습니다.');</script>");
		    }
					
		} else if (location.equals("memberInfo.do")) {
		    HttpSession session = request.getSession();
		    int loginMbno = 0;
		    if(session.getAttribute("mbno") == null) {
	    		PrintWriter out = response.getWriter();
	    		out.println("<script>alert('회원 전용 기능입니다. 로그인을 해주세요.');"
			                + "document.location.href='" + request.getContextPath() + "/member/memberLogin.do'</script>");
		    }else {
		    	loginMbno = (int) session.getAttribute("mbno");
		    	System.out.println(loginMbno);
		    }
		    // 세션에서 가져온 회원 번호 저장
		    
		    MemberDao md = new MemberDao();
		    MemberVo mv = md.memberInfo(loginMbno);
		    
		    request.setAttribute("mv", mv);
		    
		    PointDao pd = new PointDao();
		    PointVo pv = pd.pointInfo(loginMbno);
		    
		    request.setAttribute("pv", pv);

		    String path = "/member/memberInfo.jsp";

		    RequestDispatcher rd = request.getRequestDispatcher(path);
		    rd.forward(request, response);
		    
		    
		}else if(location.equals("memberInfoModify.do")){
		
			String path ="/member/memberInfoModify.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(path);
			rd.forward(request, response);
		
		}else if(location.equals("Pwdcheck.do")){

			String CPwd = request.getParameter("currentPwd");	
			int Mbno = Integer.parseInt(request.getParameter("mbno"));
			System.out.println(CPwd);
			System.out.println(Mbno);
			int value = 0;
			MemberVo mv = new MemberVo();
			mv.setMbpwd(CPwd);
			mv.setMbno(Mbno);
			MemberDao md = new MemberDao();
			value=md.memberPwdCheck(mv);
	        PrintWriter out = response.getWriter();
			JSONObject jsonResponse = new JSONObject();
			jsonResponse.put("value", value);
			out.print(jsonResponse.toJSONString());
		
		} else if (location.equals("memberInfoModifyAction.do")) {

		    String newPassword = request.getParameter("memberPwd");
		    String newName = request.getParameter("memberName");

		    // 세션에서 회원 ID 가져오기
		    HttpSession session = request.getSession();
		    int mbno = (int) session.getAttribute("mbno");

		    // 새로운 비밀번호와 이름을 가지고 있는 MemberVo 객체 생성
		    MemberVo mv = new MemberVo();
		    mv.setMbpwd(newPassword);
		    mv.setMbname(newName);
		    mv.setMbno(mbno);

		    // 데이터베이스에서 회원 정보 업데이트
		    MemberDao md = new MemberDao();
		    int rowsUpdated = md.memberInfoModify(mv);

		    PrintWriter out = response.getWriter();

		    if (rowsUpdated > 0) {
		        // 업데이트 성공
		        out.println("<script>alert('회원 정보가 성공적으로 수정되었습니다.');"
		                + "document.location.href='" + request.getContextPath() + "/member/memberInfo.do'</script>");
		    } else {
		        // 업데이트 실패
		        out.println("<script>alert('회원 정보 수정에 실패했습니다. 다시 시도해주세요.');history.back();</script>");
		    }
		
			
		}else if (location.equals("memberResign.do")) {
			
			String path ="/member/memberResign.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(path);
			rd.forward(request, response);
		}else if (location.equals("memberResignAction.do")) {
			// 세션에서 가져온 회원 번호 저장
			HttpSession session = request.getSession();
		    int loginMbno = 0;
		    if(session.getAttribute("mbno") == null) {
	    		PrintWriter out = response.getWriter();
	    		out.println("<script>alert('회원 전용 기능입니다. 로그인을 해주세요.');"
			                + "document.location.href='" + request.getContextPath() + "/member/memberLogin.do'</script>");
		    }else {
		    	loginMbno = (int) session.getAttribute("mbno");
		    	System.out.println(loginMbno);
		    }
		    // password
		    String memberPwd = request.getParameter("memberPwd");
		    
		    MemberDao md = new MemberDao();
		    int rowsUpdated = md.memberDelete(loginMbno,memberPwd);

		    PrintWriter out = response.getWriter();

		    if (rowsUpdated > 0) {
		        // 삭제 성공
		        out.println("<script>alert('회원탈퇴에 성공했습니다.');"
		                + "document.location.href='" + request.getContextPath() + "/'</script>");

				session.removeAttribute("mbid");
				session.removeAttribute("mbno");
				session.invalidate();
		    } else {
		        // 업데이트 실패
		        out.println("<script>alert('회원탈퇴에 실패했습니다. 다시 시도해주세요.');history.back();</script>");
		    }
		} else if (location.equals("memberList.do")) {
				
				MemberDao md =new MemberDao();
				ArrayList<MemberVo> list =  md.memberSelectAll();
				
				request.setAttribute("list", list);
				
			String path ="/member/memberList.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(path);
			rd.forward(request, response);
			
		}
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
