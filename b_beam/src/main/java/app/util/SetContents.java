package app.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Hashtable;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import app.dao.ContentsDao;
import app.dbconn.DbConn;
import app.domain.ContentsVo;
import app.domain.PageMaker;
import app.domain.SearchCriteria;

public class SetContents {
	private Connection conn;
	private PreparedStatement pstmt;
	public SetContents() {

		DbConn dbconn = new DbConn();
		this.conn = dbconn.getConnection();
	}
	public void updateContents() {
		PageMaker pm = new PageMaker();
		SearchCriteria scri = new SearchCriteria();
		ContentsDao cd = new ContentsDao();
		scri.setNumOfRows(500);
		pm.setScri(scri);
		Hashtable<String, String> hash = new Hashtable<String, String>();
//		ArrayList<ContentsVo> aryList = new ArrayList<ContentsVo>();
		JSONObject body = cd.ContentsList(pm);
		JSONObject items = (JSONObject)body.get("items");
		int totalCount = Integer.parseInt(body.get("totalCount").toString());
		if(pm.getScri().getNumOfRows() < totalCount) {
			scri.setNumOfRows(totalCount);
			pm.setScri(scri);
			body = cd.ContentsList(pm);
		}
		JSONArray item = (JSONArray)items.get("item");
		for(int i = 0; i < item.size(); i++) {
			JSONObject contents = (JSONObject)item.get(i);
//			ContentsVo cv = new ContentsVo();
//			cv.setContentid(contents.get("contentid").toString());
//			cv.setContentdatem(contents.get("modifiedtime").toString());
//			aryList.add(cv);
			hash.put(contents.get("contentid").toString(), contents.get("modifiedtime").toString());
		}
		String sql = "select contentid, DATE_FORMAT(contentdatem,'%Y%m%d%H%i%s')as contentdatem from tempcontents";
		try {
			pstmt = conn.prepareStatement(sql);
			ResultSet rs = pstmt.executeQuery();
			while(rs.next()) {
				String contentdatem = hash.get(rs.getString("contentid"));
				if(!contentdatem.equals(rs.getString("contentdatem"))) {
					cd.setTempContents(rs.getString("contentid"));
				}
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		
	}
}
