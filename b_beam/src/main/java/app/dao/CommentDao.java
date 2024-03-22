package app.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import app.dbconn.DbConn;
import app.domain.CommentVo;

public class CommentDao {
	
	private Connection conn;
	private PreparedStatement pstmt;
	
	public CommentDao() {
		DbConn dbconn = new DbConn();
		this.conn = dbconn.getConnection();
	}
	
	//특정 갤러리 글 선택시 해당 bdno를 foreign key로 갖는 댓글목록 가져옴
	public ArrayList<CommentVo> commentList(int bdno){
		
		ArrayList<CommentVo> cv_alist = new ArrayList<CommentVo>();
		
		ResultSet rs = null;
		
		String sql = "SELECT c.*, m.mbname FROM comment c JOIN member m ON c.mbno = m.mbno WHERE c.bdno = ? AND c.cmdelyn = 'N'";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, bdno);
			
			rs = pstmt.executeQuery();
			while (rs.next()) {
				CommentVo cv = new CommentVo();
				cv.setCmno(rs.getInt("cmno"));
				cv.setMbno(rs.getInt("mbno"));
				cv.setBdno(rs.getInt("bdno"));
				cv.setCmcont(rs.getString("cmcont"));
				cv.setCmdate(rs.getString("cmdate"));
				cv.setCmdatem(rs.getString("cmdatem"));
				cv.setMbname(rs.getString("mbname"));
				
				cv_alist.add(cv);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return cv_alist;
	}
	
	//댓글 작성 시 해당 bdno를 매개변수로 받아서 foreign key로 사용
	public int commentInsert(CommentVo cv) {
		
		int value = 0;
		
		String sql = "INSERT INTO comment(mbno, bdno, cmcont) VALUES(?, ?, ?)";
		
		try {
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, cv.getMbno());
			pstmt.setInt(2, cv.getBdno());
			pstmt.setString(3, cv.getCmcont());
			
			value = pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		}		
		
		return value;
	}
	
	//댓글 수정 시 해당 댓글의 index를 매개변수로 받아서 일치하는 cmno의 댓글 내용을 수정
	public int commentModify(CommentVo cv) {
		
		int value = 0;
		
		return value;	
	}
	
	//댓글 삭제(업데이트 => cmdelyn = 'Y') 시 해당 댓글의 index를 매개변수로 받아서 
	//일치하는 cmno의 댓글 내용을 삭제(수정)
	public int commentDelete(int cmno) {
		
		int value = 0;
		
		String sql = "UPDATE comment SET cmdelyn = 'Y' WHERE cmno = ?";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, cmno);
			
			value = pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return value;	
	}
	
	//댓글 추천 시  해당 댓글의 index를 매개변수로 받아서 일치하는 cmno의 추천받은 횟수 증가
	public int commentLikeCntUpdate(int cmno) {
		
		int value = 0;
		
		return value;			
	}

}
