package req;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import req.ReqDTO;


	public class ReqfileDAO {
		DataSource dataSource;

		public  ReqfileDAO() {
			try {
				InitialContext initContext = new InitialContext();
				Context envContext = (Context) initContext.lookup("java:/comp/env");
				dataSource = (DataSource) envContext.lookup("jdbc/DS4U");
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		

		
	
		 public int write(String STF_ID, int REQ_SQ, String APV_NM, String REQF_FILE, String REQF_RFILE) {
		    	Connection conn = null;
		    	PreparedStatement pstmt = null;
		        String SQL = "INSERT INTO REQF SELECT ?, IFNULL((SELECT MAX(REQF_SQ) + 1 FROM REQF), 1), ? , ?, now(), ?, ?, IFNULL((SELECT MAX(REQF_GROUP) + 1 FROM REQF), 0), 0";
		    
		        try {
		        	conn = dataSource.getConnection();
		            pstmt = conn.prepareStatement(SQL);
		        
		            pstmt.setString(1, STF_ID);
		            pstmt.setInt(2, REQ_SQ);
		            pstmt.setString(3, APV_NM);
		            pstmt.setString(4, REQF_FILE);
		            pstmt.setString(5, REQF_RFILE);
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
		   
	   
	  
		  
		    public int update(ReqfileDTO reqf) {
		    	Connection conn = null;
		    	PreparedStatement pstmt = null;
		
		    	String SQL2 = "UPDATE REQ, REQF SET REQ.REQ_SUB_DATE = REQF.REQ_SUB_DATE WHERE REQ.REQ_SQ= REQF.REQ_SQ";
		    	
		    	//String SQL2 = "UPDATE REQ SET REQ_SUB_DATE = ? WHERE REQ_SQ= ?";
		    	//String SQL = "INSERT INTO REQ (REQ_SUB_DATE) VALUES 'TEST' WHERE REQ_SQ=2";
		       // String SQL = "update REQ as t2 JOIN REQF as t1 on t1.REQ_SQ = t2.REQ_SQ set t2.REQ_SUB_DATE = t1.REQ_SUB_DATE";
		    	try {
		         	conn = dataSource.getConnection();
		         	
		             pstmt = conn.prepareStatement(SQL2);
		          
		             pstmt.executeUpdate();
		         	
		         
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
	    
	     
	    public ReqfileDTO getReqf(String REQ_SQ) {
	    	ReqfileDTO reqf = new ReqfileDTO();
	    	Connection conn = null;
	    	PreparedStatement pstmt = null;
	    	ResultSet rs = null;
	        String SQL = "SELECT * FROM REQF WHERE REQ_SQ = ?";
	        try {
	        	conn = dataSource.getConnection();
	            pstmt = conn.prepareStatement(SQL);
	            pstmt.setString(1, REQ_SQ);
	            rs = pstmt.executeQuery(); // 실행 결과를 넣음
	            if (rs.next()) {
	            	reqf.setSTF_ID(rs.getString("STF_ID"));
	            	reqf.setREQF_SQ(rs.getInt("REQF_SQ"));
	             	reqf.setREQ_SQ(rs.getInt("REQ_SQ"));
	             	reqf.setAPV_NM(rs.getString("APV_NM").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
	            	reqf.setREQ_SUB_DATE(rs.getString("REQ_SUB_DATE").substring(0, 11) + rs.getString("REQ_SUB_DATE").substring(11, 13) + "시" + rs.getString("REQ_SUB_DATE").substring(14, 16) + "분");
	            	reqf.setREQF_FILE(rs.getString("REQF_FILE"));
	            	reqf.setREQF_RFILE(rs.getString("REQF_RFILE"));
	            	reqf.setREQF_GROUP(rs.getInt("REQF_GROUP"));
	            	reqf.setREQF_SEQUENCE(rs.getInt("REQF_SEQUENCE"));
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
	        return reqf;         
		}
	    
	    public ArrayList<ReqfileDTO> getList(String pageNumber) {
	    	ArrayList<ReqfileDTO> reqfList = null;
	    	Connection conn = null;
	    	PreparedStatement pstmt = null;
	    	ResultSet rs = null;
	        String SQL = "SELECT * FROM REQF WHERE REQF_GROUP > (SELECT MAX(REQF_GROUP) FROM REQF) - ? AND REQF_GROUP <= (SELECT MAX(REQF_GROUP) FROM REQF) - ? ORDER BY REQF_GROUP DESC, REQF_SEQUENCE ASC";
	        try {
	        	conn = dataSource.getConnection();
	            pstmt = conn.prepareStatement(SQL);
	            pstmt.setInt(1, Integer.parseInt(pageNumber) * 10);
	            pstmt.setInt(2, (Integer.parseInt(pageNumber) - 1) * 10);
	            rs = pstmt.executeQuery(); // 실행 결과를 넣음
	            reqfList = new ArrayList<ReqfileDTO>();
	            while (rs.next()) {
	            	ReqfileDTO reqf = new ReqfileDTO();
	            	reqf.setSTF_ID(rs.getString("STF_ID"));
	            	reqf.setREQF_SQ(rs.getInt("REQF_SQ"));
	             	reqf.setREQ_SQ(rs.getInt("REQ_SQ"));
	             	reqf.setAPV_NM(rs.getString("APV_NM").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
	            	reqf.setREQ_SUB_DATE(rs.getString("REQ_SUB_DATE").substring(0, 11) + rs.getString("REQ_SUB_DATE").substring(11, 13) + "시" + rs.getString("REQ_SUB_DATE").substring(14, 16) + "분");
	            	reqf.setREQF_GROUP(rs.getInt("REQF_GROUP"));
	            	reqf.setREQF_SEQUENCE(rs.getInt("REQF_SEQUENCE"));
	            
	            	reqfList.add(reqf);
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
	        return reqfList;          
		}
	    
	    public String getFile(String REQ_SQ) {
	    	Connection conn = null;
	    	PreparedStatement pstmt = null;
	    	ResultSet rs = null;
	        String SQL = "SELECT REQF_FILE FROM REQF WHERE REQ_SQ = ?";
	        try {
	        	conn = dataSource.getConnection();
	            pstmt = conn.prepareStatement(SQL);
	            pstmt.setString(1, REQ_SQ);
	            rs = pstmt.executeQuery(); // 실행 결과를 넣음
	            if (rs.next()) {
	            	return rs.getString("REQF_FILE");
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
	        String SQL = "SELECT REQF_RFILE FROM REQF WHERE REQ_SQ = ?";
	        try {
	        	conn = dataSource.getConnection();
	            pstmt = conn.prepareStatement(SQL);
	            pstmt.setString(1, REQ_SQ);
	            rs = pstmt.executeQuery(); // 실행 결과를 넣음
	            if (rs.next()) {
	            	return rs.getString("REQF_RFILE");
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
	    
	    
	    
	    public boolean nextPage(String pageNumber) {
	    	Connection conn = null;
	    	PreparedStatement pstmt = null;
	    	ResultSet rs = null;
	        String SQL = "SELECT * FROM REQF WHERE REQF_GROUP >= ?";
	        try {
	        	conn = dataSource.getConnection();
	            pstmt = conn.prepareStatement(SQL);
	            pstmt.setInt(1, Integer.parseInt(pageNumber) * 10);
	            rs = pstmt.executeQuery(); // 실행 결과를 넣음
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
	        String SQL = "SELECT COUNT(REQF_GROUP) FROM REQF WHERE REQF_GROUP > ?";
	        try {
	        	conn = dataSource.getConnection();
	            pstmt = conn.prepareStatement(SQL);
	            pstmt.setInt(1, (Integer.parseInt(pageNumber) - 1)* 10);
	            rs = pstmt.executeQuery(); // 실행 결과를 넣음
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


