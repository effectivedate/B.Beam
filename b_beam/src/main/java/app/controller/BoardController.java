


package app.controller;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.tomcat.util.http.fileupload.FileItem;
import org.apache.tomcat.util.http.fileupload.FileUploadException;
import org.apache.tomcat.util.http.fileupload.disk.DiskFileItemFactory;
import org.apache.tomcat.util.http.fileupload.servlet.ServletFileUpload;
import org.apache.tomcat.util.http.fileupload.servlet.ServletRequestContext;

import app.dao.BoardDao;
import app.dao.BoardDao;
import app.dao.CommentDao;
import app.dao.PointDao;
import app.domain.BdgalleryVo;
import app.domain.BoardVo;
import app.domain.CommentVo;
import app.domain.MemberVo;
import app.domain.PageMaker;
import app.domain.SearchCriteria;

/**
 * Servlet implementation class ContentsController
 */
@WebServlet("/BoardController")
public class BoardController extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	
	private String location;
	
	public BoardController(String location) {
		this.location = location;
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		if (location.equals("board.do")) {
			
			String path ="/board/board.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(path);
			rd.forward(request, response);
			
		}else if (location.equals("galleryList.do")) {
			
			HttpSession session = request.getSession(false);
			
			int mbno = 0;
			if(session != null) {
				if(session.getAttribute("mbno") != null) {	//로그인 했으면 mbno에 세션의 mbno를 할당
					mbno = (int)session.getAttribute("mbno");
				}
			}
			SearchCriteria scri = new SearchCriteria();
			
			String keyword = request.getParameter("keyword");
			if(keyword==null) { keyword = "";}
			String page = request.getParameter("page");
			if (page == null) { page = "1";}
			
			scri.setPage(Integer.parseInt(page));
			scri.setKeyword(keyword);
			
			PageMaker pm = new PageMaker();
			pm.setScri(scri);
			
			BoardDao bd = new BoardDao();
			ArrayList<BoardVo> bv_alist = bd.galleryList(mbno, scri);
			pm.setTotalCount(bd.boardTotalCount(scri));
			
			request.setAttribute("pm", pm);
			request.setAttribute("bv_alist", bv_alist);
			
			String path ="/board/galleryList.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(path);
			rd.forward(request, response);
			
		}else if (location.equals("boardLikeUpdate.do")) {
			
			HttpSession session = request.getSession(false);
			
			int bdno = 0;
			int mbno = 0;
			
			if(request.getParameter("bdno") != null) {
				bdno = Integer.parseInt(request.getParameter("bdno"));
			}
			if(session != null) {
				if(session.getAttribute("mbno") != null) {
					mbno = (int)session.getAttribute("mbno");
				}
			}
			
			PrintWriter pw = response.getWriter();
			
			BoardDao bd = new BoardDao();
			
			int value = 0;
			value = bd.boardLikeUpdate(mbno, bdno);
			
			if(value == 1) {
				pw.println("{\"value\" : \""+value+"\"}");
			}else {
				
			}
			
		}else if (location.equals("galleryContentsInclude.do")) {
			
			HttpSession session = request.getSession(false);
			
			int mbno = 0;
			if(session != null) {
				if(session.getAttribute("mbno") != null) {	//로그인 했으면 mbno에 세션의 mbno를 할당
					mbno = (int)session.getAttribute("mbno");
				}
			}
			int bdno = Integer.parseInt(request.getParameter("bdno"));
			BoardDao bd = new BoardDao();
			BoardVo bv = new BoardVo();
			bv = bd.boardSelectOne(mbno, bdno);
			
			CommentDao cd = new CommentDao();
			ArrayList<CommentVo> cv_alist = new ArrayList<CommentVo>();
			cv_alist = cd.commentList(bdno);
			
			request.setAttribute("bv", bv);
			request.setAttribute("cv_alist", cv_alist);
			
			String path ="/board/galleryContentsInclude.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(path);
			rd.forward(request, response);
			
		}else if (location.equals("galleryWrite.do")) {
			
			String path ="/board/galleryWrite.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(path);
			rd.forward(request, response);
			
		}else if (location.equals("galleryModify.do")) {
			
			HttpSession session = request.getSession(false);
			
			int mbno = 0;
			if(session != null) {
				if(session.getAttribute("mbno") != null) {	//로그인 했으면 mbno에 세션의 mbno를 할당
					mbno = (int)session.getAttribute("mbno");
				}
			}
			int bdno = Integer.parseInt(request.getParameter("bdno"));
			BoardDao bd = new BoardDao();
			BoardVo bv = new BoardVo();
			bv = bd.boardSelectOne(mbno, bdno);
			
			
			//System.out.println("mbno : " + mbno);
			//System.out.println("bdno : " + bdno);
			
			PrintWriter out = response.getWriter();
			// 로그인한 사용자와 게시글 작성자가 같은지 확인
			if(bv.getMbno() != mbno) {
				 out.println("<script>alert('게시물을 수정할 권한이 없습니다.');location.href='"+request.getContextPath()+"/board/galleryList.do'</script>");
			}else {
				request.setAttribute("bv", bv);
				
				String path ="/board/galleryModify.jsp";
				RequestDispatcher rd = request.getRequestDispatcher(path);
				rd.forward(request, response);
			}
			
		}else if(location.equals("galleryModifyAction.do")) { 
			String savePath = request.getServletContext().getRealPath("/source/galleryImages");
			//System.out.println("savePath : " + savePath);
			//String savePath = "D:\\dev0803\\git_e\\b_beam\\b_beam\\src\\main\\webapp\\source\\galleryImages";  //절대경로
			
			// Apache Commons FileUpload라이브러리를 사용해서 다중파일업로드 구현
			DiskFileItemFactory fileItemFactory = new DiskFileItemFactory(); // 업로드된 파일을 디스크에 저장하는데 사용되는 팩토리 객체
			ServletFileUpload upload = new ServletFileUpload(fileItemFactory); // 실제 파일 업로드를 처리하는데 사용되는 객체


			try {
				List<FileItem> items = upload.parseRequest(new ServletRequestContext(request));	// 업로드 요청을 파싱해서 FileItem 객체의 리스트로 반환
				
				
				// 변수 리스트 초기화
				List<String> bdglnameList = new ArrayList<>();
				
				String bdtitle = null;
				String bdcont = null;
				String bdno = null;
				
				for (FileItem item : items) {
					if (item.isFormField()) {	//파일이 아닌경우
						
						// 제목과 내용을 받아옴
						if ("bdtitle".equals(item.getFieldName())) {
							bdtitle = item.getString("UTF-8");
						} else if ("bdcont".equals(item.getFieldName())) {
							bdcont = item.getString("UTF-8");
						}else {
							bdno = item.getString("UTF-8");
						}
					} else {		// 파일인 경우
						// 다중파일 리스트처리
						try {
							String fileName = item.getName();		// FileItem에서 업로드된 파일 이름을 가져옴
							File destFile = new File(savePath, fileName);	// 저장할 경로와 파일명을 지정하는 객체생성
							item.write(destFile);
							
							//bdglnameList에 filename을 추가
							bdglnameList.add(fileName);
							
							//System.out.println("Uploaded file: " + fileName);
							//System.out.println("destFile: " + destFile);
						} catch (Exception e) {
							e.printStackTrace();
						}
					}
				}
				int mbno = 0;
				HttpSession session = request.getSession();
				mbno = (int) session.getAttribute("mbno");
				
				int bdno_int = Integer.parseInt(bdno);
				
				BoardVo bv = new BoardVo();
				bv.setBdno(bdno_int);
				bv.setMbno(mbno);
				bv.setBdtitle(bdtitle);
				bv.setBdcont(bdcont);
				
				//System.out.println("mbno : " + mbno);
				//System.out.println("bdno_int : " + bdno_int);
				//System.out.println("bdtitle : " + bdtitle);
				//System.out.println("bdcont : " + bdcont);
				
				BdgalleryVo bgv = new BdgalleryVo();
				bgv.setBdglnameList(bdglnameList);
	
				BoardDao bd = new BoardDao();
				int value = bd.boardModify(bv, bgv);
	
				//System.out.println("Value: " + value);
	
				if (value == 0) {
					
					String path = request.getContextPath() + "/board/galleryWrite.do";
					response.sendRedirect(path);
				} else {
					String path = request.getContextPath() + "/board/galleryList.do";
					response.sendRedirect(path);
				}
			} catch (FileUploadException e) {
				e.printStackTrace();
			}
		
		}else if (location.equals("galleryDeleteAction.do")) {
			
			HttpSession session = request.getSession(false);
			
			int bdno = 0;
			int mbno = 0;
			
			if(request.getParameter("bdno") != null) {
				bdno = Integer.parseInt(request.getParameter("bdno"));
			}
			if(session != null) {
				if(session.getAttribute("mbno") != null) {
					mbno = (int)session.getAttribute("mbno");
				}
			}
			
			System.out.println("bdno : " + bdno);
			System.out.println("mbno : " + mbno);
			
			//처리하는 메소드를 만들어야 한다
			int value=0;
			
			BoardDao bd = new BoardDao();
			value = bd.boardDelete(bdno);			
			
			System.out.println("value : " + value);
			
			// JSON 형식으로 응답을 생성		//unexpected json input 오류 해결
			response.setContentType("application/json");
			response.setCharacterEncoding("UTF-8");
			PrintWriter out = response.getWriter();
			out.print("{\"success\": " + (value > 0) + "}");	// value가 0보다 크면 true 아니면 false
			out.flush();
			out.close();
				
		}else if (location.equals("noticeList.do")) {
			
			HttpSession session = request.getSession(false);
			
			int mbno = 0;
			if(session != null) {
				if(session.getAttribute("mbno") != null) {	//로그인 했으면 mbno에 세션의 mbno를 할당
					mbno = (int)session.getAttribute("mbno");
				}
			}
			SearchCriteria scri = new SearchCriteria();
			
			String page = request.getParameter("page");
			if (page == null) { page = "1";}
			
			scri.setPage(Integer.parseInt(page));
			
			PageMaker pm = new PageMaker();
			pm.setScri(scri);
			
			BoardDao bd = new BoardDao();
			ArrayList<BoardVo> alist = bd.noticeList(mbno, scri);
			pm.setTotalCount(bd.noticeTotalCount(scri));
			
			request.setAttribute("pm", pm);
			request.setAttribute("alist", alist);
			
			String path ="/board/noticeList.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(path);
			rd.forward(request, response);
			
		}else if (location.equals("noticeWrite.do")) {
			HttpSession session = request.getSession(false);
			
			int mbno = 0;
			if(session != null) {
				if(session.getAttribute("mbno") != null) {	//로그인 했으면 mbno에 세션의 mbno를 할당
					mbno = (int)session.getAttribute("mbno");
				}
			}
			
			String path ="/board/noticeWrite.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(path);
			rd.forward(request, response);
			
		}else if (location.equals("noticeWriteAction.do")) {
			
			HttpSession session = request.getSession(false);
			
			int mbno = 0;
			if(session != null) {
				if(session.getAttribute("mbno") != null) {	//로그인 했으면 mbno에 세션의 mbno를 할당
					mbno = (int)session.getAttribute("mbno");
				}
			}
			
			String bdtitle = request.getParameter("bdtitle");
			String bdcont = request.getParameter("bdcont");
			
			BoardVo bv = new BoardVo();
			
			bv.setBdtitle(bdtitle);
			bv.setBdcont(bdcont);
			bv.setMbno(mbno);
			
			//System.out.println("bdtitle : " + bdtitle);
			//System.out.println("bdcont : " + bdcont);
			//System.out.println("mbno : " + mbno);
			
			BoardDao bd = new BoardDao();
			
			int value = bd.insertBoardN(bv);
			
			//System.out.println("value : " + value);
			
			if (value == 0) {
				String path = request.getContextPath()+"/board/noticeWrite.do";
				response.sendRedirect(path);
			} else {
				String path = request.getContextPath()+"/board/noticeList.do";
				response.sendRedirect(path);
			}
			
		}else if (location.equals("notice.do")) {
			
			HttpSession session = request.getSession(false);
			
			int mbno = 0;
			if(session != null) {
				if(session.getAttribute("mbno") != null) {	//로그인 했으면 mbno에 세션의 mbno를 할당
					mbno = (int)session.getAttribute("mbno");
				}
			}
			
			int bdno = Integer.parseInt(request.getParameter("bdno"));
			
			System.out.println("bdno : " + bdno);
			
			BoardDao bd = new BoardDao();
			BoardVo bv = new BoardVo();
			bv = bd.noticeSelectOne(mbno, bdno);
			
			request.setAttribute("bv", bv);
			
			String path ="/board/notice.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(path);
			rd.forward(request, response);
			
		}else if (location.equals("noticeDelete.do")) {
			HttpSession session = request.getSession(false);
			
			int bdno = 0;
			int mbno = 0;
			
			if(request.getParameter("bdno") != null) {
				bdno = Integer.parseInt(request.getParameter("bdno"));
			}
			if(session != null) {
				if(session.getAttribute("manager").equals("U")) {
					mbno = (int)session.getAttribute("mbno");
				}
			}
			//System.out.println("bdno : " + bdno);
			//System.out.println("mbno : " + mbno);
			
			//처리하는 메소드를 만들어야 한다
			int value=0;
			
			BoardDao bd = new BoardDao();
			value = bd.noticeDelete(bdno);			
			
			System.out.println("value : " + value);
			
			response.setContentType("application/json");
			response.setCharacterEncoding("UTF-8");
			PrintWriter out = response.getWriter();
			out.print("{\"success\": " + (value > 0) + "}");
			out.flush();
			out.close();
			
		}else if (location.equals("noticeModify.do")) {
			
			HttpSession session = request.getSession(false);
			
			int mbno = 0;
			if(session != null) {
				if(session.getAttribute("mbno") != null) {	//로그인 했으면 mbno에 세션의 mbno를 할당
					mbno = (int)session.getAttribute("mbno");
				}
			}
			int bdno = Integer.parseInt(request.getParameter("bdno"));
			BoardDao bd = new BoardDao();
			BoardVo bv = new BoardVo();
			bv = bd.noticeSelectOne(mbno, bdno);
			
			
			//System.out.println("mbno : " + mbno);
			//System.out.println("bdno : " + bdno);
			
			request.setAttribute("bv", bv);
			
			String path ="/board/noticeModify.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(path);
			rd.forward(request, response);
			
		}else if (location.equals("noticeModifyAction.do")) {
			
			String bdno = request.getParameter("bdno");
			String bdtitle = request.getParameter("bdtitle");
			String bdcont = request.getParameter("bdcont");
			
			System.out.println("bdno : " + bdno);
			System.out.println("bdtitle : " + bdtitle);
			System.out.println("bdcont : " + bdcont);
			
			BoardVo bv = new BoardVo();
			bv.setBdno(Integer.parseInt(bdno));
			bv.setBdcont(bdcont);
			bv.setBdtitle(bdtitle);
			
			BoardDao bd = new BoardDao();
			int value = bd.noitceModify(bv);
			
			System.out.println("value : " + value);
			
			PrintWriter out = response.getWriter();
			
			if (value > 0) {
				out.println("<script>alert('수정되었습니다.');location.href='"+request.getContextPath()+"/board/notice.do?bdno='"+bdno+"</script>");
				/*String path = request.getContextPath()+"/board/notice.do?bdno="+bdno;
				response.sendRedirect(path);*/
			} else {
				String path = request.getContextPath() + "/board/noticeList.do";
				response.sendRedirect(path);
			}
			
		}else if (location.equals("FAQ.do")) {
			
			HttpSession session = request.getSession(false);
			
			int mbno = 0;
			if(session != null) {
				if(session.getAttribute("mbno") != null) {	//로그인 했으면 mbno에 세션의 mbno를 할당
					mbno = (int)session.getAttribute("mbno");
				}
			}
			SearchCriteria scri = new SearchCriteria();
			
			String page = request.getParameter("page");
			if (page == null) { page = "1";}
			
			scri.setPage(Integer.parseInt(page));
			
			PageMaker pm = new PageMaker();
			pm.setScri(scri);
			
			BoardDao bd = new BoardDao();
			ArrayList<BoardVo> alist = bd.FAQList(mbno, scri);
			pm.setTotalCount(bd.FAQTotalCount(scri));
			
			request.setAttribute("pm", pm);
			request.setAttribute("alist", alist);
			
			String path ="/board/FAQ.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(path);
			rd.forward(request, response);
			
		}else if (location.equals("FAQWrite.do")) {
			
			String path ="/board/FAQWrite.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(path);
			rd.forward(request, response);
			
		}else if (location.equals("FAQWriteAction.do")) {
			
			HttpSession session = request.getSession(false);
			
			int mbno = 0;
			if(session != null) {
				if(session.getAttribute("mbno") != null) {	//로그인 했으면 mbno에 세션의 mbno를 할당
					mbno = (int)session.getAttribute("mbno");
				}
			}
			
			String bdtitle = request.getParameter("bdtitle");
			String bdcont = request.getParameter("bdcont");
			
			BoardVo bv = new BoardVo();
			
			bv.setBdtitle(bdtitle);
			bv.setBdcont(bdcont);
			bv.setMbno(mbno);
			
			//System.out.println("bdtitle : " + bdtitle);
			//System.out.println("bdcont : " + bdcont);
			//System.out.println("mbno : " + mbno);
			
			BoardDao bd = new BoardDao();
			
			int value = bd.insertBoardO(bv);
			
			//System.out.println("value : " + value);
			
			if (value == 0) {
				String path = request.getContextPath()+"/board/FAQWrite.do";
				response.sendRedirect(path);
			} else {
				String path = request.getContextPath()+"/board/FAQ.do";
				response.sendRedirect(path);
			}
			
		}else if (location.equals("FAQModify.do")) {
			
			HttpSession session = request.getSession(false);
			
			int mbno = 0;
			if(session != null) {
				if(session.getAttribute("mbno") != null) {	//로그인 했으면 mbno에 세션의 mbno를 할당
					mbno = (int)session.getAttribute("mbno");
				}
			}
			int bdno = Integer.parseInt(request.getParameter("bdno"));
			BoardDao bd = new BoardDao();
			BoardVo bv = new BoardVo();
			bv = bd.FAQSelectOne(mbno, bdno);
			
			
			System.out.println("mbno : " + mbno);
			System.out.println("bdno : " + bdno);
			
			request.setAttribute("bv", bv);
			
			String path ="/board/FAQModify.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(path);
			rd.forward(request, response);
			
		}else if (location.equals("FAQModifyAction.do")) {
			
			String bdno = request.getParameter("bdno");
			String bdtitle = request.getParameter("bdtitle");
			String bdcont = request.getParameter("bdcont");
			
			System.out.println("bdno : " + bdno);
			System.out.println("bdtitle : " + bdtitle);
			System.out.println("bdcont : " + bdcont);
			
			BoardVo bv = new BoardVo();
			bv.setBdno(Integer.parseInt(bdno));
			bv.setBdcont(bdcont);
			bv.setBdtitle(bdtitle);
			
			BoardDao bd = new BoardDao();
			int value = bd.noitceModify(bv);
			
			System.out.println("value : " + value);
			
			PrintWriter out = response.getWriter();
			
			if (value > 0) {
				out.println("<script>alert('수정되었습니다.');location.href='"+request.getContextPath()+"/board/FAQ.do'</script>");
				/*String path = request.getContextPath()+"/board/notice.do?bdno="+bdno;
				response.sendRedirect(path);*/
			} else {
				String path = request.getContextPath() + "/board/FAQ.do";
				response.sendRedirect(path);
			}
			
		}else if (location.equals("FAQDelete.do")) {
			
			int bdno = 0;
			
			if(request.getParameter("bdno") != null) {
				bdno = Integer.parseInt(request.getParameter("bdno"));
			}
			//System.out.println("bdno : " + bdno);
			
			//처리하는 메소드를 만들어야 한다
			int value=0;
			
			BoardDao bd = new BoardDao();
			value = bd.FAQDelete(bdno);			
			
			//System.out.println("value : " + value);
			
			PrintWriter out = response.getWriter();
			
			response.setContentType("application/json");
			response.setCharacterEncoding("UTF-8"); 
			response.getWriter(); 
			out.print("{\"value\": " + (value > 0) + "}");
			out.flush(); out.close();
			
		}else if (location.equals("galleryWriteAction.do")) {
			
			String savePath = request.getServletContext().getRealPath("/source/galleryImages");

			//String savePath = "D:\\dev0803\\git_e\\b_beam\\b_beam\\src\\main\\webapp\\source\\galleryImages";  //절대경로
			
			// Apache Commons FileUpload라이브러리를 사용해서 다중파일업로드 구현
			DiskFileItemFactory fileItemFactory = new DiskFileItemFactory(); // 업로드된 파일을 디스크에 저장하는데 사용되는 팩토리 객체
			ServletFileUpload upload = new ServletFileUpload(fileItemFactory); // 실제 파일 업로드를 처리하는데 사용되는 객체


			try {
				List<FileItem> items = upload.parseRequest(new ServletRequestContext(request));	// 업로드 요청을 파싱해서 FileItem 객체의 리스트로 반환
				
				
				// 변수 리스트 초기화
				List<String> bdglnameList = new ArrayList<>();
				
				String bdtitle = null;
				String bdcont = null;
			
				for (FileItem item : items) {
					if (item.isFormField()) {	//파일이 아닌경우
						
						// 제목과 내용을 받아옴
						if ("bdtitle".equals(item.getFieldName())) {
							bdtitle = item.getString("UTF-8");
						} else if ("bdcont".equals(item.getFieldName())) {
							bdcont = item.getString("UTF-8");
						}
					} else {		// 파일인 경우
						// 다중파일 리스트처리
						try {
							String fileName = item.getName();		// FileItem에서 업로드된 파일 이름을 가져옴
							File destFile = new File(savePath, fileName);	// 저장할 경로와 파일명을 지정하는 객체생성
							item.write(destFile);
							
							//bdglnameList에 filename을 추가
							bdglnameList.add(fileName);
							
							//System.out.println("Uploaded file: " + fileName);
							//System.out.println("destFile: " + destFile);
						} catch (Exception e) {
							e.printStackTrace();
						}
					}
				}
				int mbno = 0;
				HttpSession session = request.getSession();
				mbno = (int) session.getAttribute("mbno");
	
				BoardVo bv = new BoardVo();
				bv.setMbno(mbno);
				bv.setBdtitle(bdtitle);
				bv.setBdcont(bdcont);
	
				BdgalleryVo bgv = new BdgalleryVo();
				bgv.setBdglnameList(bdglnameList);
	
				BoardDao bd = new BoardDao();
				int value = bd.boardInsert(bv, bgv);
				
				PointDao pd = new PointDao();
				int value2 = pd.getPointBoard(bv);
				System.out.println("value2 : " + value2);
				System.out.println("value: " + value);
				
				PrintWriter out = response.getWriter();
				if (value == 0) {
					String path = request.getContextPath() + "/board/galleryWrite.do";
					response.sendRedirect(path);
				} else {
					if (value2 > 0) {
						out.println("<script>alert('포인트가 적립되었습니다.');location.href='"+request.getContextPath()+"/board/galleryList.do'</script>");
					}		
				}
			} catch (FileUploadException e) {
				e.printStackTrace();
			}
		}
		
		
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
