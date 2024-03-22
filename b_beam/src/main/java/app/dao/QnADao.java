package app.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import app.dbconn.DbConn;
import app.domain.BoardVo;
import app.domain.QnAVo;
import app.domain.SearchCriteria;

public class QnADao {

	private Connection conn;
	private PreparedStatement pstmt;
	
	public QnADao() {
		DbConn dbconn = new DbConn();
		this.conn = dbconn.getConnection();
	}
	
	
	public ArrayList<QnAVo> qnaSelectAll(int mbno){
		ArrayList<QnAVo> q_alist = new ArrayList<QnAVo>();
		ResultSet rs = null;
		
		String sql = "SELECT a.*,\r\n"
				+ " m.mbname AS ambname \r\n"
				+ " FROM qna a \r\n"
				+ "LEFT JOIN member m ON a.ambno = m.mbno AND m.manager = 'M'\r\n"
				+ "WHERE a.qadelyn = 'N' \r\n"
				+ "AND a.qmbno = ? ORDER BY a.qdate DESC";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, mbno);
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				QnAVo qv = new QnAVo();
				qv.setQano(rs.getInt("qano"));
				qv.setQmbno(rs.getInt("qmbno"));
				qv.setAmbno(rs.getInt("ambno"));
				qv.setQcont(rs.getString("qcont"));
				qv.setQdate(rs.getString("qdate"));
				qv.setQtitle(rs.getString("qtitle"));
				qv.setAcont(rs.getString("acont"));
				qv.setAmbname(rs.getString("ambname"));
				
				q_alist.add(qv);
			
			
			}
			
		}catch(Exception e){
			e.printStackTrace();		
		}finally{
			try{
				rs.close();
				pstmt.close();
				conn.close();
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		
		return q_alist;
	} 
	
	
	public int qnaInsert(QnAVo qv){
		int exec = 0;
		
		String sql = "insert into qna (qmbno,qtitle,qcont,qdate)\r\n"
				+ "VALUES(?,?,?,NOW())";
		
		try{
			pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
			pstmt.setInt(1, qv.getQmbno());
			pstmt.setString(2, qv.getQtitle());
			pstmt.setString(3, qv.getQcont());
			exec = pstmt.executeUpdate();  
			// 생성된 qano 가져오기
			try (ResultSet rs = pstmt.getGeneratedKeys()) {
				if (rs.next()) {
					qv.setQano(rs.getInt(1));
				}
			}
			
			}catch(Exception e){
				e.printStackTrace();
			}
				finally {				
					try {
						pstmt.close();
						conn.close();
					} catch (SQLException e) {
						e.printStackTrace();
					}
				}			
			
		return exec;	
	}
	
	public QnAVo qnaModify(int qano,int qmbno) {
		ResultSet rs = null;
		String sql = "SELECT qcont, qtitle FROM qna WHERE qano=? AND qmbno=? AND qadelyn='N'";
		
		QnAVo qv = new QnAVo();
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, qano);
			pstmt.setInt(2, qmbno);
			
			rs = pstmt.executeQuery();

			if (rs.next()) {
				qv.setQcont(rs.getString("qcont"));
				qv.setQtitle(rs.getString("qtitle"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				pstmt.close();
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}

		return qv;
	}

	
	public int qModify(QnAVo qv) { 
		int exec = 0;
		String sql ="UPDATE qna SET qtitle=?, qcont=?, qdatem=NOW() WHERE qano=?  AND qadelyn='N'";
		try { pstmt = conn.prepareStatement(sql); 
			pstmt.setString(1, qv.getQtitle());
			pstmt.setString(2, qv.getQcont()); 
			pstmt.setInt(3, qv.getQano());
		
			exec = pstmt.executeUpdate(); 
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return exec;
	}	


	
	
	
	public int qnaDelete(int qano) {
		
		int exec = 0;		
	
		String sql ="UPDATE qna SET  qadelyn='Y' WHERE qano=? ";
		
		try{		
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, qano);	
		
		exec = pstmt.executeUpdate();	
		
		}catch(Exception e){			
			e.printStackTrace();
		}
		return exec;	
	}
	
	public ArrayList<QnAVo> mngqnaSelectAll() {
		ArrayList<QnAVo> qna_alist = new ArrayList<>();
		ResultSet rs = null;

		String sql = "SELECT a.*,\r\n"
				+ "	u.mbname AS qmbname,\r\n"
				+ "    m.mbname AS ambname\r\n"
				+ "FROM qna a \r\n"
				+ "LEFT JOIN member u ON a.qmbno = u.mbno AND u.manager = 'U'\r\n"
				+ "LEFT JOIN member m ON a.ambno = m.mbno AND m.manager = 'M'\r\n"
				+ "WHERE a.qadelyn = 'N'\r\n"
				+ "ORDER BY a.qdate DESC";
		
		try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			while (rs.next()) {
				QnAVo qv = new QnAVo();
				qv.setQano(rs.getInt("qano"));
				qv.setAmbno(rs.getInt("ambno"));
				qv.setQmbno(rs.getInt("qmbno"));
				qv.setQcont(rs.getString("qcont"));
				qv.setAcont(rs.getString("acont"));
				qv.setQdate(rs.getString("qdate"));
				qv.setAdate(rs.getString("adate"));
				qv.setAdatem(rs.getString("adatem"));
				qv.setQtitle(rs.getString("qtitle"));
				qv.setQmbname(rs.getString("qmbname"));
				qv.setAmbname(rs.getString("ambname"));
				
				qna_alist.add(qv);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
		}

	    return qna_alist;
	}
	
	
	public int mngqnaInsert(QnAVo qv){
		int exec = 0;
		
		String sql = "UPDATE qna SET ambno = ?, acont=? , adate= NOW()  WHERE qano= ? and  qadelyn='N'";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, qv.getAmbno());
			pstmt.setString(2, qv.getAcont());
			pstmt.setInt(3, qv.getQano());
			exec = pstmt.executeUpdate();

			System.out.println(sql);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				pstmt.close();
				//conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}

		return exec;
	}


	public int mngqnaModify(QnAVo qv) {
		int exec = 0;
		String sql = "UPDATE qna SET acont=?, adatem=NOW() WHERE qano=? AND qadelyn='N'";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, qv.getAcont());
			pstmt.setInt(2, qv.getQano());
			
			exec = pstmt.executeUpdate();
			

			System.out.println(sql);
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
		}
		return exec;
	}
	
	public int mngqnaDelete(int qano) {
		int exec = 0;
		String sql = "UPDATE qna SET qadelyn='Y' WHERE qano=? ";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, qano);

			exec = pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
		}
		return exec;
	}
	
	
	
	
	
	
	
	
	
	
	
}
