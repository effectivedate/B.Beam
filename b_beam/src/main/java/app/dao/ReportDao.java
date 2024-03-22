package app.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import app.dbconn.DbConn;
import app.domain.CommentVo;
import app.domain.MemberVo;
import app.domain.PenaltyVo;
import app.domain.ReportVo;
import app.domain.ReviewVo;
import app.domain.SearchCriteria;

public class ReportDao {

	private Connection conn;
	private PreparedStatement pstmt;
	
	public ReportDao() {
		DbConn dbconn = new DbConn();
		this.conn = dbconn.getConnection();
	}
	
	//신고게시판 신고목록
	public ArrayList<ReportVo> reportList(SearchCriteria scri ) {
		
		ArrayList<ReportVo> alist = new ArrayList<ReportVo>();
		ResultSet rs = null;
		
		String sql = "SELECT r.*, m.mbname, b.bdcont, rv.rvcont, rv.contentid, c.cmcont, c.bdno, p.pndelyn, bdno_count, rvno_count, cmno_count"
				+ " FROM report r "
				+ " JOIN member m on r.mbno2 = m.mbno"
				+ " LEFT JOIN board b on r.bdno = b.bdno"
				+ " LEFT JOIN review rv on r.rvno = rv.rvno"
				+ " LEFT JOIN comment c on r.cmno = c.cmno"
				+ " LEFT JOIN penalty p on r.rpno = p.rpno"
				+ " LEFT JOIN (SELECT bdno, COUNT(*) AS bdno_count FROM report WHERE bdno IS NOT NULL GROUP BY bdno) AS report_count_bd ON r.bdno = report_count_bd.bdno"
				+ " LEFT JOIN (SELECT rvno, COUNT(*) AS rvno_count FROM report WHERE rvno IS NOT NULL GROUP BY rvno) AS report_count_rv ON r.rvno = report_count_rv.rvno"
				+ " LEFT JOIN (SELECT cmno, COUNT(*) AS cmno_count FROM report WHERE cmno IS NOT NULL GROUP BY cmno) AS report_count_cm ON r.cmno = report_count_cm.cmno"
				+ " ORDER by r.rpno DESC"
				+ " LIMIT ?, ?";
		
		int perPageNum = 20;
		scri.setNumOfRows(perPageNum);
		
		try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setInt(1, (scri.getPage()-1) * scri.getNumOfRows());
			pstmt.setInt(2, scri.getNumOfRows());
			
			rs = pstmt.executeQuery();
			
			while (rs.next()) {
				ReportVo rpv= new ReportVo();
				ReviewVo rv = new ReviewVo();
				CommentVo cv = new CommentVo();
				PenaltyVo pv = new PenaltyVo();
				
				rpv.setRpno(rs.getInt("rpno"));
				rpv.setMbno2(rs.getInt("mbno2"));
				rpv.setMbno(rs.getInt("mbno"));
				rpv.setRvno(rs.getInt("rvno"));
				rpv.setBdno(rs.getInt("bdno"));
				rpv.setCmno(rs.getInt("cmno"));
				rpv.setRpcate(rs.getString("rpcate"));
				rpv.setRpdelyn(rs.getString("rpdelyn"));
				rpv.setMbname(rs.getString("mbname"));
				rpv.setBdcont(rs.getString("bdcont"));
				rpv.setBdno_count(rs.getInt("bdno_count"));
				rpv.setRvno_count(rs.getInt("rvno_count"));
				rpv.setCmno_count(rs.getInt("cmno_count"));
				
				rv.setRvcont(rs.getString("rvcont"));
				rpv.setReviewVo(rv);
				rv.setContentid(rs.getString("contentid"));
				
				cv.setCmcont(rs.getString("cmcont"));
				cv.setBdno(rs.getInt("c.bdno"));
				rpv.setCommnetVo(cv);
				
				pv.setPndelyn(rs.getString("pndelyn"));
				rpv.setPenaltyVo(pv);
				
				alist.add(rpv);
				
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				rs.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		return alist;
	}
	
	//신고글 총 개수
	public int reportTotalCount(SearchCriteria scri) {
		int value = 0;
		ResultSet rs = null;
		
		String sql = "SELECT COUNT(rpno) as cnt FROM report WHERE rpdelyn = 'N'";
		
		try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
			
			rs = pstmt.executeQuery();
			
			while (rs.next()) {
				value = rs.getInt("cnt");
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				rs.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		return value;
	}
	
	//신고된 유저 정보 조회
	public ReportVo selectReportedUser(int rpno) { 
		
		ReportVo rpv = null;
		ResultSet rs = null;
		String sql = "SELECT rp.*, m.mbname, m.mbemail FROM report rp JOIN member m"
					+ " ON rp.mbno2 = m.mbno WHERE rp.rpno = ?";
		
		try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setInt(1,rpno); 
			
			rs = pstmt.executeQuery();
		
			if (rs.next()) {
				rpv = new ReportVo();
				rpv.setRpno(rs.getInt("rpno"));
				rpv.setMbno2(rs.getInt("mbno2"));
				rpv.setMbno(rs.getInt("mbno"));
				rpv.setRvno(rs.getInt("rvno"));
				rpv.setBdno(rs.getInt("bdno"));
				rpv.setCmno(rs.getInt("cmno"));
				rpv.setRpcate(rs.getString("rpcate"));
				rpv.setRpdelyn(rs.getString("rpdelyn"));
				rpv.setMbname(rs.getString("mbname"));
				rpv.setMbemail(rs.getString("mbemail"));
			}
		
		} catch (SQLException e) { e.printStackTrace(); }
		
		return rpv; 
	}
	
	//신고기능
	public int reportInsert(ReportVo rpv, int rvno, int cmno) {
		int exec = 0;
		String cate = "";  
		String category="";
		
		// 신고된 게시글 종류 확인
		if (rpv.getBdno() != 0) {
			cate = "bd";
		} else if (rvno != 0) {
			cate = "rv";
		} else if (cmno != 0) {
			cate = "cm";
		}
		
		if (cate.equals("bd")) {
			category = "bdno";
		}
		if (cate.equals("rv")) {
			category = "rvno";
		} 
		if (cate.equals("cm")) {
			category = "cmno";
		}
		String sql = "INSERT INTO report(mbno, mbno2, "+category+", rpcate, rpdelyn) "
				+ " VALUES(?, ?, ?, ?, 'N')";
		
		try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
			
			pstmt.setInt(1, rpv.getMbno());
			pstmt.setInt(2, rpv.getMbno2());
			if ("bdno".equals(category)) {
				pstmt.setInt(3, rpv.getBdno());
			} else if ("rvno".equals(category)) {
				pstmt.setInt(3, rvno);
			} else if ("cmno".equals(category)) {
				pstmt.setInt(3, cmno);
			}
			pstmt.setString(4, rpv.getRpcate());
			
			exec = pstmt.executeUpdate();
			
		} catch(SQLException e) {
			e.printStackTrace();
		}
		
		return exec;
	}
	
	//신고된 글들의 삭제 기능
	public int reportedBoardDeleteUpdate(String delYN, int rpno, int reportedBoardNum) {
		
		ResultSet rs = null;
		int value = 0;
		String bdType = "";	//board 종류를 담을 변수 r, b, c : review(리뷰), board(갤러리), comment(댓글)
		String sql = "";
		
		String sql_boardTypeCheck = "SELECT IF(rvno IS NOT NULL, 'r', IF(bdno IS NOT NULL, 'b'"
								  + ", IF(cmno IS NOT NULL, 'c', 'c'))) AS bdType FROM report"
								  + " WHERE rpno = ?";
		
		String sql_reviewDelete = "UPDATE report rp, review rv SET rp.rpdelyn = '"+delYN+"', rv.rvdelyn = '"+delYN+"' WHERE rp.rpno = ? AND rv.rvno = ?";
		String sql_boardDelete = "UPDATE report rp, board b SET rp.rpdelyn = '"+delYN+"', b.bddelyn = '"+delYN+"' WHERE rp.rpno = ? AND b.bdno = ?";
		String sql_commentDelete = "UPDATE report rp, comment c SET rp.rpdelyn = '"+delYN+"', c.cmdelyn = '"+delYN+"' WHERE rp.rpno = ? AND c.cmno = ?";
		
		try{
			pstmt = conn.prepareStatement(sql_boardTypeCheck);
			pstmt.setInt(1, rpno);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				bdType = rs.getString("bdType");
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		if (bdType.equals("r")) {
			sql = sql_reviewDelete;
		}else if(bdType.equals("b")) {
			sql = sql_boardDelete;
		}else {
			sql = sql_commentDelete;
		}
		
		try{
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, rpno);
			pstmt.setInt(2, reportedBoardNum);
			
			value = pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			try {
				rs.close();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
		
		return value;
	}
	
	//패널티 부여 pndelyn에는 '', 'N', 'W', 'M', 'S' 값들 중 하나 넘어옴
	//'', 'N', 'W', 'M', 'S' : 패널티 미부여 처리(패널티 부여 취소), 허위신고 처리, 일주일 정지, 한달 정지, 영구정지
	public int penaltyUpdate(int rpno, int mbno2, String pndelyn) {
		
		ResultSet rs = null;
		String sql = "";
		int value = 0;
		
		String sql_penaltyCheck = "SELECT COUNT(mbno) AS cnt FROM penalty WHERE rpno = "+rpno+" AND mbno = "+mbno2;
		String sql_penaltyInsert = "INSERT INTO penalty(rpno, mbno, pndelyn) VALUES("+rpno+", "+mbno2+", '"+pndelyn+"')";
		String sql_penaltyUpdate = "UPDATE penalty SET pndelyn = '"+pndelyn+"' WHERE rpno = "+rpno+" AND mbno = "+mbno2;
		
		try{
			pstmt = conn.prepareStatement(sql_penaltyCheck);
			rs = pstmt.executeQuery(sql_penaltyCheck);
			
			while(rs.next()) {
				value = rs.getInt("cnt");
			}
			
		} catch (SQLException e ) {
			e.printStackTrace();
		}
		
		if(value == 0) {
			sql = sql_penaltyInsert;
		}else {
			sql = sql_penaltyUpdate;
		}
		
		try {
			pstmt = conn.prepareStatement(sql);
			value = pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			try {
				rs.close();
				pstmt.close();
				conn.close();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
		
		return value;
	}
	
	//신고된 컨텐츠별 mbno 가져오기 
	 public MemberVo getContentsMv(int no, String cate){
			
		 	MemberVo mv = new MemberVo();
			ResultSet rs = null;
			String table1 = "";
			switch(cate) {
			case "bdno" : 
				table1="board";
				break;
			case "rvno" : 
				table1="review";
				break;
			case "cmno" : 
				table1="comment";
				break;
			}
			String sql = "SELECT a.mbno, m.mbname "
					+ "FROM "+ table1 + " a "
					+ "JOIN member m ON a.mbno = m.mbno "
					+ "WHERE a."+cate+" = ?";
			System.out.println(sql);
			System.out.println("table:" + table1);
			
			
			try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
				pstmt.setInt(1, no); 
				
				rs = pstmt.executeQuery();
			
				if (rs.next()) {
					mv.setMbno(rs.getInt("mbno"));
					mv.setMbname(rs.getString("mbname"));
				}
			
			} catch (SQLException e) { e.printStackTrace(); }
			
			return mv; 
		}
	
		
}
