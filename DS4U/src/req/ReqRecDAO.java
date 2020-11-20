package req;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class ReqRecDAO {
	DataSource dataSource;
	
	public ReqRecDAO() {
		try {
			InitialContext initContext = new InitialContext();
			Context envContext = (Context) initContext.lookup("java:/comp/env");
			dataSource = (DataSource) envContext.lookup("jdbc/DS4U");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	public int write(String STF_ID, String REQ_SQ, String APV_NM, String REQ_REC_TXT, 
    		String REQ_REC_FILE, String REQ_REC_RFILE) {
    	Connection conn = null;
    	PreparedStatement pstmt = null;
        String SQL = "INSERT INTO REQ_REC SELECT ?, ?, IFNULL((SELECT MAX(REQ_REC_SQ) + 1 FROM REQ_REC), 1),? , ?, now(), ?, ?";
    
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
        
            pstmt.setString(1, STF_ID);
            pstmt.setString(2, REQ_SQ);
            pstmt.setString(3, APV_NM);
            pstmt.setString(4, REQ_REC_TXT);
            pstmt.setString(5, REQ_REC_FILE);
            pstmt.setString(6, REQ_REC_RFILE);
        	return pstmt.executeUpdate();
        
        }  catch (Exception e) {
        
            e.printStackTrace();
        }
        
       
        finally {
        	try {
        	
        		if (pstmt != null) pstmt.close();
        		if (conn != null) conn.close();
        	} catch (Exception e) {
        		e.printStackTrace();
        	}      
        
        	
        }
        
        
        return -1;      // DB 오류       
	}
	 public ReqRecDTO getReqRec(String REQ_SQ) {
	    	ReqRecDTO req_rec = new ReqRecDTO();
	    	Connection conn = null;
	    	PreparedStatement pstmt = null;
	    	ResultSet rs = null;
	        String SQL = "SELECT * FROM REQ_REC WHERE REQ_SQ = ?";
	        try {
	        	conn = dataSource.getConnection();
	            pstmt = conn.prepareStatement(SQL);
	            pstmt.setString(1, REQ_SQ);
	            rs = pstmt.executeQuery(); // 실행 결과를 넣음
	            if (rs.next()) {
	            	req_rec.setSTF_ID(rs.getString("STF_ID"));
	            	req_rec.setREQ_SQ(rs.getInt("REQ_SQ"));
	            	req_rec.setREQ_REC_SQ(rs.getInt("REQ_REC_SQ"));
	            	req_rec.setAPV_NM(rs.getString("APV_NM").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
	            	req_rec.setREQ_REC_TXT(rs.getString("REQ_REC_TXT").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
	            	req_rec.setREQ_REC_DATE(rs.getString("REQ_REC_DATE").substring(0, 11) + rs.getString("REQ_REC_DATE").substring(11, 13) + "시" + rs.getString("REQ_REC_DATE").substring(14, 16) + "분");
	            	req_rec.setREQ_REC_FILE(rs.getString("REQ_REC_FILE"));
	            	req_rec.setREQ_REC_RFILE(rs.getString("REQ_REC_RFILE"));
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        } finally {
	        	try {
	        		if (rs != null) rs.close();
	        		if (pstmt != null) pstmt.close();
	        		if (conn != null) conn.close();
	        	} catch (Exception e) {
	        		e.printStackTrace();
	        	}       	
	        }
	        return req_rec;         
		}
	 public String getFile(String REQ_SQ) {
	    	Connection conn = null;
	    	PreparedStatement pstmt = null;
	    	ResultSet rs = null;
	        String SQL = "SELECT REQ_REC_FILE FROM REQ_REC WHERE REQ_SQ = ?";
	        try {
	        	conn = dataSource.getConnection();
	            pstmt = conn.prepareStatement(SQL);
	            pstmt.setString(1, REQ_SQ);
	            rs = pstmt.executeQuery(); // 실행 결과를 넣음
	            if (rs.next()) {
	            	return rs.getString("REQ_REC_FILE");
	        	}
	            return "";
	        } catch (Exception e) {
	            e.printStackTrace();
	        } finally {
	        	try {
	        		if (rs != null) rs.close();
	        		if (pstmt != null) pstmt.close();
	        		if (conn != null) conn.close();
	        	} catch (Exception e) {
	        		e.printStackTrace();
	        	}       	
	        }
	        return "";          	
	    }
	    
	    public String getRealFile(String REQ_SQ) {
	    	Connection conn = null;
	    	PreparedStatement pstmt = null;
	    	ResultSet rs = null;
	        String SQL = "SELECT REQ_REC_RFILE FROM REQ_REC WHERE REQ_SQ = ?";
	        try {
	        	conn = dataSource.getConnection();
	            pstmt = conn.prepareStatement(SQL);
	            pstmt.setString(1, REQ_SQ);
	            rs = pstmt.executeQuery(); // 실행 결과를 넣음
	            if (rs.next()) {
	            	return rs.getString("REQ_REC_RFILE");
	        	}
	            return "";
	        } catch (Exception e) {
	            e.printStackTrace();
	        } finally {
	        	try {
	        		if (rs != null) rs.close();
	        		if (pstmt != null) pstmt.close();
	        		if (conn != null) conn.close();
	        	} catch (Exception e) {
	        		e.printStackTrace();
	        	}       	
	        }
	        return "";          	
	    }
}
