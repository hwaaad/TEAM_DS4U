package req;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import req.ReqDTO;

public class ReqDAO {
	DataSource dataSource;

	public ReqDAO() {
		try {
			InitialContext initContext = new InitialContext();
			Context envContext = (Context) initContext.lookup("java:/comp/env");
			dataSource = (DataSource) envContext.lookup("jdbc/DS4U");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	

	
    public int write(String STF_ID, int APV_SQ, String APV_NM, String APV_OBJ, String APV_CONT, 
    		String APV_DATE, String REQ_REC_DATE, String REQ_SUB_DATE) {
    	Connection conn = null;
    	PreparedStatement pstmt = null;
        String SQL = "INSERT INTO REQ SELECT ?, IFNULL((SELECT MAX(REQ_SQ) + 1 FROM REQ), 1), ? ,? , ?, ?, ?, now(), ?, ?, IFNULL((SELECT MAX(REQ_GROUP) + 1 FROM REQ), 0), 0, 1";
    
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
        
            pstmt.setString(1, STF_ID);
            pstmt.setInt(2, APV_SQ);
            pstmt.setString(3, APV_NM);
            pstmt.setString(4, APV_OBJ);
            pstmt.setString(5, APV_CONT);
            pstmt.setString(6, APV_DATE);
            //pstmt.setString(7, APV_COM);
            pstmt.setString(7, REQ_REC_DATE);
            pstmt.setString(8, REQ_SUB_DATE);
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
        
        
        return -1;      // DB ����       
	}
   
    
    
    public int update_req_rec_date(String REQ_SQ) {
    	Connection conn = null;
    	PreparedStatement pstmt = null;
        String SQL = "UPDATE REQ SET REQ_STATE = 2, REQ_REC_DATE = NOW() WHERE REQ_SQ = ?";
        
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, REQ_SQ);
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
        
        
        return -1;      // DB ����       
	}
    public int update_req_sub_date(int REQ_SQ) {
    	Connection conn = null;
    	PreparedStatement pstmt = null;
        String SQL = "UPDATE REQ SET REQ_STATE = 3, REQ_SUB_DATE=NOW() WHERE REQ_SQ = ?";
    
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
        
            pstmt.setInt(1, REQ_SQ);
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
        
        
        return -1;      // DB ����       
	}
     
    public ReqDTO getReq(String REQ_SQ) {
    	ReqDTO req = new ReqDTO();
    	Connection conn = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
        String SQL = "SELECT * FROM REQ WHERE REQ_SQ = ?";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, REQ_SQ);
            rs = pstmt.executeQuery(); // ���� ����� ����
            if (rs.next()) {
            	req.setSTF_ID(rs.getString("STF_ID"));
            	req.setREQ_SQ(rs.getInt("REQ_SQ"));
             	req.setAPV_SQ(rs.getInt("APV_SQ"));
            	req.setAPV_NM(rs.getString("APV_NM").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
            	req.setAPV_OBJ(rs.getString("APV_OBJ").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
            	req.setAPV_CONT(rs.getString("APV_CONT").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
            	req.setAPV_DATE(rs.getString("APV_DATE").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
            	req.setREQ_DATE(rs.getString("REQ_DATE").substring(0, 11));
            	if(rs.getString("REQ_REC_DATE").equals("")) {
            		req.setREQ_REC_DATE(rs.getString("REQ_REC_DATE").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>")); 	
            	}else {
            		req.setREQ_REC_DATE(rs.getString("REQ_REC_DATE").substring(0, 11));
            	}
            	if(rs.getString("REQ_SUB_DATE").equals("")) {
            		req.setREQ_SUB_DATE(rs.getString("REQ_SUB_DATE").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>")); 	
            	}else {
            		req.setREQ_SUB_DATE(rs.getString("REQ_SUB_DATE").substring(0, 11));
            	}req.setREQ_GROUP(rs.getInt("REQ_GROUP"));
            	req.setREQ_SEQUENCE(rs.getInt("REQ_SEQUENCE"));
            	req.setREQ_STATE(rs.getInt("REQ_STATE"));
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
        return req;         
	}
    
    public ArrayList<ReqDTO> getList(String pageNumber) {
    	ArrayList<ReqDTO> reqList = null;
    	Connection conn = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
        String SQL = "SELECT * FROM REQ WHERE REQ_GROUP > (SELECT MAX(REQ_GROUP) FROM REQ) - ? AND REQ_GROUP <= (SELECT MAX(REQ_GROUP) FROM REQ) - ? ORDER BY REQ_GROUP DESC, REQ_SEQUENCE ASC";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, Integer.parseInt(pageNumber) * 10);
            pstmt.setInt(2, (Integer.parseInt(pageNumber) - 1) * 10);
            rs = pstmt.executeQuery(); // ���� ����� ����
            reqList = new ArrayList<ReqDTO>();
            while (rs.next()) {
            	ReqDTO req = new ReqDTO();
            	req.setSTF_ID(rs.getString("STF_ID"));
            	req.setREQ_SQ(rs.getInt("REQ_SQ"));
            	req.setAPV_SQ(rs.getInt("APV_SQ"));
            	req.setAPV_NM(rs.getString("APV_NM").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
            	req.setAPV_OBJ(rs.getString("APV_OBJ").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
            	req.setAPV_CONT(rs.getString("APV_CONT").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
            	req.setAPV_DATE(rs.getString("APV_DATE").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
            	req.setREQ_DATE(rs.getString("REQ_DATE").substring(0, 11));
            	if(rs.getString("REQ_REC_DATE").equals("")) {
            		req.setREQ_REC_DATE(rs.getString("REQ_REC_DATE").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>")); 	
            	}else {
            		req.setREQ_REC_DATE(rs.getString("REQ_REC_DATE").substring(0, 11));
            	}
            	if(rs.getString("REQ_SUB_DATE").equals("")) {
            		req.setREQ_SUB_DATE(rs.getString("REQ_SUB_DATE").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>")); 	
            	}else {
            		req.setREQ_SUB_DATE(rs.getString("REQ_SUB_DATE").substring(0, 11));
            	}req.setREQ_GROUP(rs.getInt("REQ_GROUP"));
            	req.setREQ_SEQUENCE(rs.getInt("REQ_SEQUENCE"));
            	req.setREQ_STATE(rs.getInt("REQ_STATE"));
            	reqList.add(req);
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
        return reqList;          
	}
    

    public boolean nextPage(String pageNumber) {
    	Connection conn = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
        String SQL = "SELECT * FROM REQ WHERE REQ_GROUP >= ?";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, Integer.parseInt(pageNumber) * 10);
            rs = pstmt.executeQuery(); // ���� ����� ����
            if (rs.next()) {
            	return true;
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
        return false;          	
    }
    
    public int targetPage(String pageNumber) {
    	Connection conn = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
        String SQL = "SELECT COUNT(REQ_GROUP) FROM REQ WHERE REQ_GROUP > ?";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, (Integer.parseInt(pageNumber) - 1)* 10);
            rs = pstmt.executeQuery(); // ���� ����� ����
            if (rs.next()) {
            	return rs.getInt(1) / 10;
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
        return 0;          	
    }
}