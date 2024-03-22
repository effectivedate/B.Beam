package app.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import app.dbconn.DbConn;
import app.domain.BdgalleryVo;
import app.domain.BoardVo;
import app.domain.SearchCriteria;

public class BoardDao {
	
	private Connection conn;
	private PreparedStatement pstmt;
	
	public BoardDao() {
		DbConn dbconn = new DbConn();
		this.conn = dbconn.getConnection();
	}
	
	public ArrayList<BoardVo> galleryList(int mbno, SearchCriteria scri){
		
		ArrayList<BoardVo> bv_alist = new ArrayList<BoardVo>();
		ResultSet rs = null;
		
		PreparedStatement pstmt2 = null;
		ResultSet rs2 = null;
		
		String str = "";
		String str2 = "";
		
		//mbno != 0 : 로그인했다면 galleryList 페이지로 넘어왔을 시 좋아요(하트 아이콘) 색 표시 여부
		if(mbno != 0) {	
			str = ", IF((SELECT COUNT(l.lkno) FROM like_ l WHERE l.bdno = b.bdno AND l.mbno = "+mbno+" AND l.lkdelyn = 'N') = 1, 'Y', 'N') AS bdLikeYN";
		}
		//태그 클릭 시 해당 태그와 일치하는 태그를 가진 글들을 부르는 조건문 쿼리에 추가
		if(!scri.getKeyword().equals("")) {
			str2 = " AND b.bdtag LIKE '%" +scri.getKeyword()+ "%' OR b.bdcontag LIKE '%" +scri.getKeyword()+ "%'";
		}
		
		String sql = "SELECT b.*"
					+ ", (SELECT COUNT(l.lkno) FROM like_ l where l.bdno = b.bdno and l.lkdelyn = 'N') AS bdLikeCnt"
					+ ", (SELECT COUNT(c.bdno) FROM comment c WHERE c.bdno = b.bdno) AS bdCommentCnt"
					+ ", (SELECT IF(COUNT(mbaddr) = 1, 'Y', 'N') FROM member m WHERE m.mbno = b.mbno AND m.mbaddr LIKE '%전주%') AS localPeopleYN"
					+ str
					+ " FROM (SELECT b.*, m.mbname FROM board b JOIN member m ON b.mbno = m.mbno WHERE m.mbdelyn = 'N' AND b.bdcate = 'G' AND b.bddelyn = 'N') b"
					+ str2
					+ " ORDER by b.bdno DESC"
					+ " LIMIT ?, ?";
		
		String sql2 = "SELECT * FROM bdgallery WHERE bdno = ? AND bdgldelyn = 'N'";
		
		//scri.getNumOfRows() : 페이지에 표시할 글 개수 (Criteria.java에 기본값 20으로 할당되어있음)
		int perPageNum = 12;			//페이지 당 표시할 글 개수 -> 12개
		scri.setNumOfRows(perPageNum);	//갤러리 페이지에 표시할 글 개수를 설정함
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, (scri.getPage() - 1) * scri.getNumOfRows());
			pstmt.setInt(2, scri.getNumOfRows());
						
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				BoardVo bv = new BoardVo();
				bv.setBdno(rs.getInt("bdno"));
				int bdno = rs.getInt("bdno");
				bv.setMbno(rs.getInt("mbno"));
				bv.setBdcate(rs.getString("bdcate"));
				bv.setBdtitle(rs.getString("bdtitle"));
				bv.setBdcont(rs.getString("bdcont"));
				bv.setBdtag(rs.getString("bdtag"));
				bv.setBdcontag(rs.getString("bdcontag"));
				bv.setBddate(rs.getString("bddate"));
				bv.setBddatem(rs.getString("bddatem"));
				bv.setBddelyn(rs.getString("bddelyn"));
				bv.setBdLikeCnt(rs.getInt("bdLikeCnt"));
				bv.setBdCommentCnt(rs.getInt("bdCommentCnt"));
				bv.setMbname(rs.getString("mbname"));
				bv.setLocalPeople(rs.getString("localPeopleYN"));
				if(mbno != 0) {
					bv.setBdLikeYN(rs.getString("bdLikeYN"));
				}
				
				//ArrayList<String> bdFilename에
				//bdno가 일치하는 bdgallery의 값들을 담는다.
				
				try {
					pstmt2 = conn.prepareStatement(sql2);
					pstmt2.setInt(1, bdno);
					
					rs2 = pstmt2.executeQuery();
					
					ArrayList<String> bdFilename = new ArrayList<String>();
					
					while(rs2.next()) {
						bdFilename.add(rs2.getString("bdglname"));
					}
					bv.setBdFilename(bdFilename);
					
				}catch (Exception e) {
					e.printStackTrace();
				}
				
				bv_alist.add(bv);
			}
			
		} catch (Exception e) {
			
			e.printStackTrace();
			
		}finally {
			try {
				rs.close();
				rs2.close();
				//pstmt.close();
				//pstmt 닫아버리면 컨트롤러에서 메서드 호출 후 바로밑에 bd.boardTotalCount에서 pstmt를 못씀
				pstmt2.close();
				//conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		return bv_alist;
	}
	
	//글 클릭 시 bdno를 가져가 해당하는 글 정보를 모달에 띄울
	//mbno는 로그인 하면 가져감
	public BoardVo boardSelectOne(int mbno, int bdno) {
		
		BoardVo bv = new BoardVo();
		ResultSet rs = null;
		
		PreparedStatement pstmt2 = null;
		ResultSet rs2 = null;
		
		String str = "";
		if(mbno != 0) {
			str = ", IF((SELECT COUNT(l.lkno) FROM like_ l WHERE l.bdno = b.bdno AND l.mbno = "+mbno+" AND l.lkdelyn = 'N') = 1, 'Y', 'N') AS bdLikeYN";
		}
		
		String sql = "SELECT b.*"
					+ ", (SELECT COUNT(l.lkno) FROM like_ l where l.bdno = b.bdno and l.lkdelyn = 'N') AS likeCnt"
					+ ", (SELECT IF(COUNT(mbaddr) = 1, 'Y', 'N') FROM member m WHERE m.mbno = b.mbno AND m.mbaddr LIKE '%전주%') AS localPeopleYN"
					+ str
					+ " FROM (SELECT b.*, m.mbname FROM board b JOIN member m ON b.mbno = m.mbno WHERE m.mbdelyn = 'N' AND b.bddelyn = 'N') b"
					+ " WHERE b.bdno = ?";
		
		String sql2 = "SELECT * FROM bdgallery WHERE bdno = ? AND bdgldelyn = 'N'";
		
		try {
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, bdno);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				bv.setBdno(rs.getInt("bdno"));
				bv.setMbno(rs.getInt("mbno"));
				bv.setBdcate(rs.getString("bdcate"));
				bv.setBdtitle(rs.getString("bdtitle"));
				bv.setBdcont(rs.getString("bdcont"));
				bv.setBdtag(rs.getString("bdtag"));
				bv.setBdcontag(rs.getString("bdcontag"));
				bv.setBddate(rs.getString("bddate"));
				bv.setBddatem(rs.getString("bddatem"));
				bv.setBddelyn(rs.getString("bddelyn"));
				if(mbno != 0) {
					bv.setBdLikeYN(rs.getString("bdLikeYN"));
				}
				bv.setMbname(rs.getString("mbname"));
				bv.setLocalPeople(rs.getString("localPeopleYN"));
				
				//ArrayList<String> bdFilename에 
				//bdno가 일치하는 bdgallery의 값들을 담는다
				try {
					pstmt2 = conn.prepareStatement(sql2);
					pstmt2.setInt(1, bdno);
					
					rs2 = pstmt2.executeQuery();
					ArrayList<String> bdFilename = new ArrayList<String>();
					
					while(rs2.next()) {
						bdFilename.add(rs2.getString("bdglname"));
					}
					
					bv.setBdFilename(bdFilename);
					
				}catch (Exception e) {
					e.printStackTrace();
				}finally {
					try {
						pstmt2.close();
						rs2.close();
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
				
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return bv;
	}
	
	//galleryList 글 likeYN
	public int boardLikeUpdate(int mbno, int bdno) {
		
		int value = 0;
		ResultSet rs = null;
		String sql = "";
		String sql_likeCheck = "SELECT COUNT(lkno) AS cnt FROM like_ WHERE bdno = "+bdno+" AND mbno = "+mbno+"";
		
		String sql_likeInsert = "INSERT INTO like_(mbno, bdno, lkdate, lkdelyn)"
					+ " VALUES(?, ?, NOW(), 'N')";
		
		//lkdelyn 컬럼 값이 Y면 N으로 아니면 Y로 
		String sql_likeUpdateYN = "UPDATE like_ SET lkdelyn = IF(lkdelyn = 'Y', 'N', 'Y')"
								+ ", lkdatem = NOW() WHERE mbno = ? AND bdno = ?";
		
		try {
			pstmt = conn.prepareStatement(sql_likeCheck);

			rs= pstmt.executeQuery();
			
			while (rs.next()) {
				value = rs.getInt("cnt");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		if(value == 0) {
			sql = sql_likeInsert;
		}else {
			sql = sql_likeUpdateYN;
		}
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, mbno);
			pstmt.setInt(2, bdno);
			
			value = pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			try {
				pstmt.close();
				conn.close();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
		
		return value;
	}

	//galleryList 글 총 개수
	public int boardTotalCount(SearchCriteria scri) {
		
		int value = 0;
		
		ResultSet rs = null;
		
		String str = "";
		if(!scri.getKeyword().equals("")) {
			str = " AND bdtag LIKE '%"+scri.getKeyword()+"%' OR bdcontag LIKE '%"+scri.getKeyword()+"%'";
		}
		
		String sql = "SELECT COUNT(bdno) AS cnt FROM board WHERE bdcate = 'G' AND bddelyn = 'N'" + str;
		
		try {
			pstmt = conn.prepareStatement(sql);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				value = rs.getInt("cnt");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			try {
				rs.close();
				pstmt.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		return value;
	}
	
	public int insertBoard(BoardVo bv) {
		int exec = 0;

		String sql = "INSERT INTO board(mbno, bdtitle, bdcont, bdcate) VALUES(?,?,?,'G')";

		try (PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
			pstmt.setInt(1, bv.getMbno());
			pstmt.setString(2, bv.getBdtitle());
			pstmt.setString(3, bv.getBdcont());
			exec = pstmt.executeUpdate();
			
			// 생성된 bdno 가져오기
			try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
				if (generatedKeys.next()) {
					bv.setBdno(generatedKeys.getInt(1));
				}
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
		return exec;
	}

	public int insertBdgallery(BdgalleryVo bgv) {
		int exec = 0;

		String sql = "INSERT INTO bdgallery(bdno, bdglname) VALUES(?,?)";
		
		try (PreparedStatement pstmt = conn.prepareStatement(sql)) {

			List<String> bdglnameList = bgv.getBdglnameList();

			for (String bdglname : bdglnameList) {
				pstmt.setInt(1, bgv.getBdno());
				pstmt.setString(2, bdglname);
				exec += pstmt.executeUpdate();
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		return exec;
	}
	    
	public int boardInsert(BoardVo bv, BdgalleryVo bgv) {
		
		int exec1 = insertBoard(bv);
		
		if (exec1 > 0) {
			// board 테이블에 레코드가 성공적으로 삽입되었을 때
			// 해당 bdno를 가져와서 bdgallery 테이블에 삽입
			int bdno = bv.getBdno();

				bgv.setBdno(bdno);
				int exec2 = insertBdgallery(bgv);

				// board 및 bdgallery 삽입 결과의 총합 반환
				return exec1 + exec2;
		} else {
			// board 테이블에 레코드 삽입이 실패했을 경우
			return exec1;
		}

	}
	
	public int boardDelete(int bdno) {
		int exec1 = 0;
		int exec2 = 0;
		String sql = "update board set bddelyn = 'Y', bddatem = now() where bdno = ?";
		
		try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setInt(1, bdno);
			exec1 = pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		if (exec1 > 0) {
			
			// board 테이블 삭제 성공하면 bdgallery 테이블 삭제 
			String sql2 = "update bdgallery set bdgldelyn = 'Y', bdgldatem = now() where bdno = ? ";
			
			try (PreparedStatement pstmt2 = conn.prepareStatement(sql2);) {
				pstmt2.setInt(1, bdno);
				exec2 = pstmt2.executeUpdate();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		
		
		return exec1 + exec2;
	}
	
	public int boardModify(BoardVo bv, BdgalleryVo bgv) {
		int exec1 = 0;
		int exec2 = 0;
		int exec3 = 0;
		
		String sql = "update board set bdtitle = ?, bdcont = ?, bddatem = now() where bdno = ?";
		
		try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setString(1, bv.getBdtitle());
			pstmt.setString(2, bv.getBdcont());
			pstmt.setInt(3, bv.getBdno());
			exec1 = pstmt.executeUpdate();
		
			if (exec1 > 0) {
				//board 테이블 수정 성공했을 경우 bdgallery 테이블 수정
				String sql2 = "update bdgallery set bdgldelyn = 'Y', bdgldatem = now() where bdno = ?";
				
				try (PreparedStatement pstmt2 = conn.prepareStatement(sql2)) {
					pstmt2.setInt(1, bv.getBdno());
					exec2 = pstmt2.executeUpdate();
				} catch (SQLException e) {
					e.printStackTrace();
				}
				
				String sql3 = "INSERT INTO bdgallery(bdno, bdglname, bdgldatem) VALUES(?,?, now())";
				
				List<String> bdglnameList = bgv.getBdglnameList();
				
				for (String bdglname : bdglnameList) {
					try (PreparedStatement pstmt3 = conn.prepareStatement(sql3)) {
						pstmt3.setInt(1, bv.getBdno());
						pstmt3.setString(2, bdglname);
						exec3 += pstmt3.executeUpdate();
					} catch (SQLException e) {
						e.printStackTrace();
					}
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return exec1 + exec2 + exec3;
	}
	
	public int insertBoardN(BoardVo bv) {
		int exec = 0;
		
		String sql = "INSERT INTO board(mbno, bdtitle, bdcont, bdcate) VALUES(?,?,?,'N')";
		
		try (PreparedStatement pstmt  = conn.prepareStatement(sql)) {
			pstmt.setInt(1, bv.getMbno());
			pstmt.setString(2, bv.getBdtitle());
			pstmt.setString(3, bv.getBdcont());
			
			exec = pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return exec;
	}
	
	public int insertBoardO(BoardVo bv) {
		int exec = 0;
		
		String sql = "INSERT INTO board(mbno, bdtitle, bdcont, bdcate) VALUES(?,?,?,'O')";
		
		try (PreparedStatement pstmt  = conn.prepareStatement(sql)) {
			pstmt.setInt(1, bv.getMbno());
			pstmt.setString(2, bv.getBdtitle());
			pstmt.setString(3, bv.getBdcont());
			
			exec = pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return exec;
	}
	
	public ArrayList<BoardVo> noticeList(int mbno, SearchCriteria scri) {
		
		ArrayList<BoardVo> alist = new ArrayList<BoardVo>();
		ResultSet rs = null;
		
		String sql = "SELECT b.bdno, b.bdcate, b.bdtitle, b.bdcont, b.bddate, m.mbno, m.mbname "
				+ " FROM board b JOIN member m ON b.mbno = m.mbno WHERE b.bddelyn = 'N' AND b.bdcate = 'N' "
				+ " ORDER BY b.bdno DESC"
				+ " LIMIT ?, ?";
			int perPageNum = 10;			//페이지 당 표시할 글 개수 -> 10개
			scri.setNumOfRows(perPageNum);	//갤러리 페이지에 표시할 글 개수를 설정함		
				
		
			try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
				pstmt.setInt(1, (scri.getPage() - 1) * scri.getNumOfRows());
				pstmt.setInt(2, scri.getNumOfRows());
				
				rs = pstmt.executeQuery();
				
				while(rs.next()) {
					BoardVo bv = new BoardVo();
					bv.setMbno(rs.getInt("m.mbno"));
					bv.setMbname(rs.getString("m.mbname"));
					bv.setBdno(rs.getInt("b.bdno"));
					bv.setBdcate(rs.getString("b.bdcate"));
					bv.setBdtitle(rs.getString("b.bdtitle"));
					bv.setBdcont(rs.getString("b.bdcont"));
					bv.setBddate(rs.getString("b.bddate"));
					alist.add(bv);
				}
				
			} catch (SQLException e) {
				e.printStackTrace();
			}finally {
				try {
					rs.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			
			
		return alist;
	}
	
	public int noticeTotalCount(SearchCriteria scri) {
		
		int value = 0;
		ResultSet rs = null;
		
		String sql = "SELECT COUNT(bdno) as cnt FROM board WHERE  bddelyn = 'N' and bdcate = 'N'";
		
		try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				value = rs.getInt("cnt");
			}
			
		} catch (Exception e) {
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

	
	public BoardVo noticeSelectOne(int mbno, int bdno) {
		BoardVo bv = null;
		ResultSet rs = null;
		String sql = "SELECT * FROM board where bdno = ? and bdcate='N'";
		
		try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setInt(1, bdno);
			rs = pstmt.executeQuery();
			
			if (rs.next()) {
				bv = new BoardVo();
				bv.setBdtitle(rs.getString("bdtitle"));
				bv.setBdcont(rs.getString("bdcont"));
				bv.setBddate(rs.getString("bddate"));
				bv.setBdno(rs.getInt("bdno"));
				bv.setMbno(rs.getInt("mbno"));
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		} finally{
			try{
				rs.close();
				conn.close();
			}catch(Exception e){
				e.printStackTrace();
			}
		}	
		
		return bv;
	}
	
	public int noticeDelete(int bdno) {
		int exec = 0;
		
		String sql = "update board set bddelyn = 'Y', bddatem = now() where bdno = ?";
		
		try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setInt(1, bdno);
			exec = pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return exec;
	}
	
	public int noitceModify(BoardVo bv) {
		int exec = 0;
		
		String sql = "update board set bdtitle = ?, bdcont = ?, bddatem = now() where bdno = ?";
		
		try(PreparedStatement pstmt = conn.prepareStatement(sql)) {
			
			pstmt.setString(1, bv.getBdtitle());
			pstmt.setString(2, bv.getBdcont());
			pstmt.setInt(3, bv.getBdno());
			
			exec = pstmt.executeUpdate();
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return exec;
	}
	
	public ArrayList<BoardVo> FAQList(int mbno, SearchCriteria scri) {
		
		ArrayList<BoardVo> alist = new ArrayList<BoardVo>();
		ResultSet rs = null;
		
		String sql = "SELECT b.bdno, b.bdcate, b.bdtitle, b.bdcont, b.bddate, m.mbno, m.mbname "
				+ " FROM board b JOIN member m ON b.mbno = m.mbno WHERE b.bddelyn = 'N' AND b.bdcate = 'O' "
				+ " ORDER BY b.bdno DESC"
				+ " LIMIT ?, ?";
			int perPageNum = 10;			//페이지 당 표시할 글 개수 -> 10개
			scri.setNumOfRows(perPageNum);	//갤러리 페이지에 표시할 글 개수를 설정함		
				
		
			try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
				pstmt.setInt(1, (scri.getPage() - 1) * scri.getNumOfRows());
				pstmt.setInt(2, scri.getNumOfRows());
				
				rs = pstmt.executeQuery();
				
				while(rs.next()) {
					BoardVo bv = new BoardVo();
					bv.setMbno(rs.getInt("m.mbno"));
					bv.setMbname(rs.getString("m.mbname"));
					bv.setBdno(rs.getInt("b.bdno"));
					bv.setBdcate(rs.getString("b.bdcate"));
					bv.setBdtitle(rs.getString("b.bdtitle"));
					bv.setBdcont(rs.getString("b.bdcont"));
					bv.setBddate(rs.getString("b.bddate"));
					alist.add(bv);
				}
				
			} catch (SQLException e) {
				e.printStackTrace();
			}finally {
				try {
					rs.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			
			
		return alist;
	}
	
	public int FAQTotalCount(SearchCriteria scri) {
		
		int value = 0;
		ResultSet rs = null;
		
		String sql = "SELECT COUNT(bdno) as cnt FROM board WHERE  bddelyn = 'N' and bdcate = 'O'";
		
		try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				value = rs.getInt("cnt");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			try {
				rs.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return value;
	}
	
	public BoardVo FAQSelectOne(int mbno, int bdno) {
		
		BoardVo bv = null;
		ResultSet rs = null;
		String sql = "SELECT * FROM board where bdno = ? and bdcate='O'";
		
		try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setInt(1, bdno);
			rs = pstmt.executeQuery();
			
			if (rs.next()) {
				bv = new BoardVo();
				bv.setBdtitle(rs.getString("bdtitle"));
				bv.setBdcont(rs.getString("bdcont"));
				bv.setBddate(rs.getString("bddate"));
				bv.setBdno(rs.getInt("bdno"));
				bv.setMbno(rs.getInt("mbno"));
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		} finally{
			try{
				rs.close();
				conn.close();
			}catch(Exception e){
				e.printStackTrace();
			}
		}	
		
		return bv;
	}
	
	public int FAQModify(BoardVo bv) {
		int exec = 0;
		
		String sql = "update board set bdtitle = ?, bdcont = ?, bddatem = now() where bdno = ?";
		
		try(PreparedStatement pstmt = conn.prepareStatement(sql)) {
			
			pstmt.setString(1, bv.getBdtitle());
			pstmt.setString(2, bv.getBdcont());
			pstmt.setInt(3, bv.getBdno());
			
			exec = pstmt.executeUpdate();
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return exec;
	}
	
	public int FAQDelete(int bdno) {
		int exec = 0;
		
		String sql = "update board set bddelyn='Y', bddatem = now() where bdno=?"; 
		
		try(PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setInt(1, bdno);
			
			exec = pstmt.executeUpdate();
			
		} catch(SQLException e) {
			e.printStackTrace();
		}
		
		return exec;
	}

}
