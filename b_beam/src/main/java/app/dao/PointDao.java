package app.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import app.dbconn.DbConn;
import app.domain.BoardVo;
import app.domain.CommentVo;
import app.domain.PointVo;
import app.domain.ReviewVo;

public class PointDao {
	
	private Connection conn;
	
	public PointDao() {
		DbConn dbconn = new DbConn();
		this.conn = dbconn.getConnection();
	}
	
	public int getPointBoard (BoardVo bv) {
		int exec = 0;
		ResultSet rs = null;
		
		String sql = "select count(bdno) as cnt FROM board where mbno = ? and date(bddate) = CURDATE()";
		
		String sql2 = "INSERT INTO point (mbno, ptpm, ptrs, ptpt, acpt, rmpt)\r\n"
				+  "SELECT ?, 'P', '글작성', 1000, acpt + 1000, rmpt + 1000\r\n"
				+ " FROM \r\n"
				+ " (SELECT acpt FROM point WHERE mbno = ? ORDER by ptno desc LIMIT 1) as acptup,"
				+ " (SELECT rmpt FROM point WHERE mbno = ? ORDER by ptno desc LIMIT 1) as rmptup";
		
		try {
	        conn.setAutoCommit(false); // 트랜잭션 시작
		
			try (PreparedStatement pstmt = conn.prepareStatement(sql);
				PreparedStatement pstmt2 = conn.prepareStatement(sql2)) {
				
				pstmt.setInt(1, bv.getMbno());
				
				rs = pstmt.executeQuery();
				
				if (rs.next()) {
					// count = 오늘 작성한 게시글 수
					int count = rs.getInt("cnt");
					
					if (count >= 1) {
						pstmt2.setInt(1, bv.getMbno());
						pstmt2.setInt(2, bv.getMbno());
						pstmt2.setInt(3, bv.getMbno());
						
						exec = pstmt2.executeUpdate();
					}
				}
			}
			
			conn.commit(); 
			conn.setAutoCommit(true); 
					
		} catch (SQLException e) {
			try {
				conn.rollback(); // 예외 발생 시 트랜잭션 롤백
			} catch (SQLException rollbackException) {
				rollbackException.printStackTrace();
			}
		
			e.printStackTrace();
		}
		
		return exec;
	}
	
	public int getPointJoin (BoardVo bv) {
		int exec = 0;
		ResultSet rs = null;
		
		String sql = "select count(mbno) as cnt FROM member where mbno = ?";
		
		String sql2 = "INSERT INTO point (mbno, ptpm, ptrs, ptpt, acpt, rmpt)"
				+  " VALUES(?, 'P', '회원가입', 1000, ptpt, ptpt)";
		
		try {
	        conn.setAutoCommit(false); // 트랜잭션 시작
		
			try (PreparedStatement pstmt = conn.prepareStatement(sql);
				PreparedStatement pstmt2 = conn.prepareStatement(sql2)) {
				
				pstmt.setInt(1, bv.getMbno());
				
				rs = pstmt.executeQuery();
				
				if (rs.next()) {
					int count = rs.getInt("cnt");
					
					if (count == 1) {
						pstmt2.setInt(1, bv.getMbno());
						
						exec = pstmt2.executeUpdate();
					}
				}
			}
			
			conn.commit(); 
			conn.setAutoCommit(true); 
					
		} catch (SQLException e) {
			try {
				conn.rollback(); // 예외 발생 시 트랜잭션 롤백
			} catch (SQLException rollbackException) {
				rollbackException.printStackTrace();
			}
		
			e.printStackTrace();
		}
		
		return exec;
	}
	
	public int getPointComment (CommentVo cv) {
		int exec = 0;
		ResultSet rs = null;
		
		String sql = "select count(cmno) as cnt FROM comment where mbno = ? and date(cmdate) = CURDATE()";
		
		String sql2 = "INSERT INTO point (mbno, ptpm, ptrs, ptpt, acpt, rmpt)\r\n"
				+  "SELECT ?, 'P', '댓글작성', 1000, acpt + 1000, rmpt + 1000\r\n"
				+ " FROM \r\n"
				+ " (SELECT acpt FROM point WHERE mbno = ? ORDER by ptno desc LIMIT 1) as acptup,"
				+ " (SELECT rmpt FROM point WHERE mbno = ? ORDER by ptno desc LIMIT 1) as rmptup";
		
		try {
	        conn.setAutoCommit(false); // 트랜잭션 시작
		
			try (PreparedStatement pstmt = conn.prepareStatement(sql);
				PreparedStatement pstmt2 = conn.prepareStatement(sql2)) {
				
				pstmt.setInt(1, cv.getMbno());
				
				rs = pstmt.executeQuery();
				
				if (rs.next()) {
					// count = 오늘 작성한 댓글 수
					int count = rs.getInt("cnt");
					
					if (count >= 1) {
						pstmt2.setInt(1, cv.getMbno());
						pstmt2.setInt(2, cv.getMbno());
						pstmt2.setInt(3, cv.getMbno());
						
						exec = pstmt2.executeUpdate();
					}
				}
			}
			
			conn.commit(); 
			conn.setAutoCommit(true); 
					
		} catch (SQLException e) {
			try {
				conn.rollback(); // 예외 발생 시 트랜잭션 롤백
			} catch (SQLException rollbackException) {
				rollbackException.printStackTrace();
			}
		
			e.printStackTrace();
		}
		
		return exec;
	}
	
	public int getPointReview (ReviewVo rv) {
		int exec = 0;
		ResultSet rs = null;
		
		String sql = "select count(rvno) as cnt FROM review where mbno = ? and date(rvdate) = CURDATE()";
		
		String sql2 = "INSERT INTO point (mbno, ptpm, ptrs, ptpt, acpt, rmpt)\r\n"
				+  "SELECT ?, 'P', '리뷰작성', 1000, acpt + 1000, rmpt + 1000\r\n"
				+ " FROM \r\n"
				+ " (SELECT acpt FROM point WHERE mbno = ? ORDER by ptno desc LIMIT 1) as acptup,"
				+ " (SELECT rmpt FROM point WHERE mbno = ? ORDER by ptno desc LIMIT 1) as rmptup";
		
		try {
	        conn.setAutoCommit(false); // 트랜잭션 시작
		
			try (PreparedStatement pstmt = conn.prepareStatement(sql);
				PreparedStatement pstmt2 = conn.prepareStatement(sql2)) {
				
				pstmt.setInt(1, rv.getMbno());
				rs = pstmt.executeQuery();
				
				if (rs.next()) {
					// count = 오늘 작성한 리뷰 수
					int count = rs.getInt("cnt");
					
					if (count >= 1) {
						pstmt2.setInt(1, rv.getMbno());
						pstmt2.setInt(2, rv.getMbno());
						pstmt2.setInt(3, rv.getMbno());
						
						exec = pstmt2.executeUpdate();
					}
				}
			}
			
			conn.commit(); 
			conn.setAutoCommit(true); 
					
		} catch (SQLException e) {
			try {
				conn.rollback(); // 예외 발생 시 트랜잭션 롤백
			} catch (SQLException rollbackException) {
				rollbackException.printStackTrace();
			}
		
			e.printStackTrace();
		}
		
		return exec;
	}
	
	public int usePoint (PointVo pv) {
		int exec = 0;
		
		String sql = "INSERT INTO point (mbno, ptpm, ptrs, ptpt, acpt, rmpt)\r\n"
				+  "SELECT ?, 'M', '포인트사용', -?, acpt, rmpt - ?\r\n"
				+ " FROM \r\n"
				+ " (SELECT acpt FROM point WHERE mbno = ? ORDER by ptno desc LIMIT 1) as acptup,"
				+ " (SELECT rmpt FROM point WHERE mbno = ? ORDER by ptno desc LIMIT 1) as rmptup";
		
		try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setInt(1, pv.getMbno());
			pstmt.setInt(2, pv.getPtpt());
			pstmt.setInt(3, pv.getPtpt());
			pstmt.setInt(4, pv.getMbno());
			pstmt.setInt(5, pv.getMbno());
			
			exec = pstmt.executeUpdate();
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return exec;
	}
	
	public PointVo pointInfo(int mbno) {
		PointVo pv = new PointVo();
		String sql = "SELECT * FROM point WHERE mbno = ? ORDER by ptno desc limit 1";
		ResultSet rs = null;
		
		try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setInt(1, mbno);
			rs = pstmt.executeQuery();
			
			if (rs.next()) {
				pv.setMbno(rs.getInt("mbno"));
				pv.setPtpm(rs.getString("ptpm"));
				pv.setPtrs(rs.getString("ptrs"));
				pv.setPtpt(rs.getInt("ptpt"));
				pv.setAcpt(rs.getInt("acpt"));
				pv.setRmpt(rs.getInt("rmpt"));
				pv.setPtdate(rs.getString("ptdate"));
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return pv;
	}
	
}
