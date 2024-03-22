package app.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;

import app.dbconn.DbConn;
import app.domain.MemberVo;
import app.util.TempPwd;

public class MemberDao {

	private Connection conn;
	private PreparedStatement pstmt;
	
	public MemberDao() {
		DbConn dbconn = new DbConn();
		this.conn = dbconn.getConnection();
	}
	
	public int memberInsert(MemberVo mv){
		int exec = 0;
		
		 String sql = "INSERT INTO member(mbid, mbpwd, mbname, mbemail, mbaddr)"
	                + "VALUES (?, ?, ?, ?, ?)";
		
		
		try{
			 pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
		        pstmt.setString(1, mv.getMbid());
		        pstmt.setString(2, mv.getMbpwd());
		        pstmt.setString(3, mv.getMbname());
		        pstmt.setString(4, mv.getMbemail());
		        pstmt.setString(5, mv.getMbaddr());
		        exec = pstmt.executeUpdate();
			
				// 생성된 mbno 가져오기
				try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
					if (generatedKeys.next()) {
						mv.setMbno(generatedKeys.getInt(1));
					}
				}
			}catch(Exception e){
				e.printStackTrace();
			}
		
		return exec;
	}
	
	public int memberIdCheck(String mbid){
				int value=0;  // 결과값이 0인지 아닌지
				
				String sql="select count(*) as cnt from member where mbid=?";
				ResultSet rs = null;
				try{
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, mbid);
					rs = pstmt.executeQuery();
					
					if (rs.next()){
						value =	rs.getInt("cnt");
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
				return value;
			}

	
	public int memberNicknameCheck(String mbname){
		int value=0;
		
		String sql = "select count(*) as cnt from member where mbname=?";
		ResultSet rs = null;
		
		try{
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, mbname);
			rs = pstmt.executeQuery();
			
			if (rs.next()){
				value =	rs.getInt("cnt");
				//value가 0이면 일치하지않는다
				//1 일치한다
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
		
		return value;
	}
	
	public int memberEmailCheck(String mbemail){
		int value=0;
		
		String sql = "select count(*) as cnt from member where mbemail=?";
		ResultSet rs = null;
		
		try{
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, mbemail);
			rs = pstmt.executeQuery();
			
			if (rs.next()){
				value =	rs.getInt("cnt");
				//value가 0이면 일치하지않는다
				//1 일치한다
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
		
		return value;
	}
	 public int memberPwdCheck(MemberVo mv) {
		 int value=0;
			
			String sql = "select count(*) as cnt from member where mbno=? and mbpwd=?";
			ResultSet rs = null;
			
			try{
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, mv.getMbno());
				pstmt.setString(2, mv.getMbpwd());
				rs = pstmt.executeQuery();
				
				if (rs.next()){
					value =	rs.getInt("cnt");
					//value가 0이면 일치하지않는다
					//1 일치한다
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
			
			return value;
	 }
	
	public MemberVo memberLoginCheck(MemberVo mv) {
	    
	    String sql = "SELECT mbno, mbname, manager FROM member WHERE mbid=? AND mbpwd=?";
	    String sql2 = "SELECT m.*, p.pndelyn, p.pndate"
		    		+ ", CASE"
		    		+ " WHEN p.pndelyn IN('', null, 'N') THEN 'N'"
		    		+ " WHEN p.pndelyn = 'W' THEN IF(DATE_ADD(p.pndate, INTERVAL 1 WEEK) < NOW(), 'N'"
		    		+ ", CONCAT('회원님의 계정은 ', DATE_FORMAT(DATE_ADD(p.pndate, INTERVAL 1 WEEK), '%Y-%m-%d %H:%i:%s'), ' 까지 이용하실 수 없습니다.'))"
		    		+ " WHEN p.pndelyn = 'M' THEN IF(DATE_ADD(p.pndate, INTERVAL 1 MONTH) < NOW(), 'N'"
		    		+ ", CONCAT('회원님의 계정은 ', DATE_FORMAT(DATE_ADD(p.pndate, INTERVAL 1 MONTH), '%Y-%m-%d %H:%i:%s'), ' 까지 이용하실 수 없습니다.'))"
		    		+ " WHEN p.pndelyn = 'S' THEN '회원님의 계정은 영구정지 상태입니다.'"
		    		+ " END AS loginCheck"
		    		+ " FROM member m JOIN (SELECT * FROM penalty WHERE mbno = ? ORDER BY pnno DESC, pndate DESC LIMIT 1) p"
		    		+ " ON m.mbno = p.mbno";
	    
	    ResultSet rs = null;
	    
	    try {
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, mv.getMbid());
	        pstmt.setString(2, mv.getMbpwd());
	        rs = pstmt.executeQuery();
	        
	        if (rs.next()) {
	           mv = new MemberVo();
	           mv.setMbno(rs.getInt("mbno"));
	           mv.setMbname(rs.getString("mbname"));
	           mv.setManager(rs.getString("manager"));
	        }
			
		}catch(Exception e){
			e.printStackTrace();
		}
	    
	    try {
			pstmt = conn.prepareStatement(sql2);
			pstmt.setInt(1, mv.getMbno());
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				mv.setLoginCheck(rs.getString("loginCheck"));
			}
		} catch (Exception e) {
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
		
		return mv;
	}

	 public String memberIdFind(String mbemail) {
	        String memberId = null;
	        
	        String sql = "SELECT mbid FROM member WHERE mbemail=?";
	        ResultSet rs = null;

	        try {
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setString(1, mbemail);
	            rs = pstmt.executeQuery();

	            if (rs.next()) {
	                memberId = rs.getString("mbid");
	            }

	        } catch (Exception e) {
	            e.printStackTrace();
	        } finally {
	            try {
	                rs.close();
	                pstmt.close();
	                conn.close();
	            } catch (Exception e) {
	                e.printStackTrace();
	            }
	        }

	        return memberId;
	    }
	 
	 

	 public String memberPwdFind(String mbid, String mbemail) {
		    String sql = "SELECT mbid FROM member WHERE mbid=? AND mbemail=?";
		    ResultSet rs = null;

		    try {
		        pstmt = conn.prepareStatement(sql);
		        pstmt.setString(1, mbid);
		        pstmt.setString(2, mbemail);
		        rs = pstmt.executeQuery();

		        if (rs.next()) {
		            // 해당 회원이 존재하면 비밀번호를 임시비밀번호로 변경
		            TempPwd tp = new TempPwd(); 
		            String newTempPassword = tp.getTempPassword(); // 임시 비밀번호 생성

		            // 비밀번호 변경 SQL
		            sql = "UPDATE member SET mbpwd=? WHERE mbid=? and mbemail=?";
		            pstmt = conn.prepareStatement(sql);
		            pstmt.setString(1, newTempPassword); // 임시 비밀번호로 변경
		            pstmt.setString(2, mbid);
		            pstmt.setString(3, mbemail);

		            int rowsUpdated = pstmt.executeUpdate();

		            if (rowsUpdated > 0) {
		                // 변경된 비밀번호를 반환
		                return newTempPassword;
		            }
		        }

		    } catch (Exception e) {
		        e.printStackTrace();
		    } finally {
		        try {
		            rs.close();
		            pstmt.close();
		            conn.close();
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
		    }

		    return null; 
		}
	 
	

	 
	 public MemberVo memberInfo(int mbno) {
		 MemberVo mv = new MemberVo();
		 String sql = "SELECT * FROM member WHERE mbno=? AND mbdelyn='N'";
		 ResultSet rs = null;
		 
		 try {
			 pstmt = conn.prepareStatement(sql);
			 pstmt.setInt(1, mbno);
			 rs = pstmt.executeQuery();
			 
			 if (rs.next()) {
				 mv.setMbno(rs.getInt("mbno"));
				 mv.setMbid(rs.getString("mbid"));
				 mv.setMbemail(rs.getString("mbemail"));
				 mv.setMbname(rs.getString("mbname"));
				 
			 }
			 
		 } catch (Exception e) {
			 e.printStackTrace();
		 } finally {
			 try {
				 if (rs != null) {
					 rs.close();
				 }
				 pstmt.close();
				 
			 } catch (Exception e) {
				 e.printStackTrace();
			 }
		 }
		 
		 return mv;
		 
	 }
	 public int memberInfoModify(MemberVo mv) {
		    int rowsUpdated = 0;

		    try {
		        String sql = "UPDATE member SET mbpwd=?, mbname=? WHERE mbno=?";

		        pstmt = conn.prepareStatement(sql);

		        pstmt.setString(1, mv.getMbpwd());
		        pstmt.setString(2, mv.getMbname());
		        pstmt.setInt(3, mv.getMbno());

		        rowsUpdated = pstmt.executeUpdate();

		        if (rowsUpdated > 0) {
		            System.out.println("회원 정보가 성공적으로 업데이트되었습니다.");
		        } else {
		            System.out.println("회원 정보 업데이트에 실패했습니다.");
		        }

		    } catch (Exception e) {
		        e.printStackTrace();
		    } finally {
		        try {
		            pstmt.close();
		            conn.close();
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
		    }

		    return rowsUpdated;
		}
	 
	 public int memberDelete(int mbno, String pwd) {
		 int rowsUpdated = 0;

		    try {
		        String sql = "UPDATE member SET mbdelyn='Y' WHERE mbno=? and mbpwd=?";

		        pstmt = conn.prepareStatement(sql);

		        pstmt.setInt(1, mbno);
		        pstmt.setString(2, pwd);

		        rowsUpdated = pstmt.executeUpdate();

		        if (rowsUpdated > 0) {
		            System.out.println("회원 정보가 성공적으로 업데이트되었습니다.");
		        } else {
		            System.out.println("회원 정보 업데이트에 실패했습니다.");
		        }

		    } catch (Exception e) {
		        e.printStackTrace();
		    } finally {
		        try {
		            pstmt.close();
		            conn.close();
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
		    }

		    return rowsUpdated;
		}
	 
	 public ArrayList<MemberVo>  memberSelectAll(){
			//무한배열클래스 객체생성해서 데이터를 담을 준비를 한다
			ArrayList<MemberVo> alist =new ArrayList<MemberVo>();
			ResultSet rs = null;
			
			String sql="select * from member where delyn='N' order by mbno desc";
			try{
				pstmt = conn.prepareStatement(sql);
				//DB에 있는 값을 담아오는 전용객체
				rs = pstmt.executeQuery();
				//rs.next()는 다음값이 있는지 확인하는 메소드 있으면true
				while(rs.next()){
					MemberVo mv = new MemberVo();
					mv.setMbno(rs.getInt("mbno")); 
					mv.setMbid( rs.getString("mbid") );
					mv.setMbname( rs.getString("mbname"));
					mv.setMbdate(rs.getString("mbdate"));
					alist.add(mv);
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
			
			return alist;
		} 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	}


