package apv;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import javax.sql.DataSource;
import apv.ApvDTO;
import javax.naming.Context;
import javax.naming.InitialContext;

public class ApvDAO {
	
	DataSource dataSource;

	public ApvDAO() {
		try {
			InitialContext initContext = new InitialContext();
			Context envContext = (Context) initContext.lookup("java:/comp/env");
			dataSource = (DataSource) envContext.lookup("jdbc/DS4U");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
    public int write(String STF_ID, String APV_NM, String APV_DATE, String APV_STT_DATE, String APV_FIN_DATE, String APV_BUDGET, String APV_PHONE, String APV_POLICY_SQ) {
    	Connection conn = null;
    	PreparedStatement pstmt = null;
        String SQL = "INSERT INTO APV SELECT ?, IFNULL((SELECT MAX(APV_SQ) + 1 FROM APV), 1), ?, ?, ?, ?, ?, ?, ?, IFNULL((SELECT MAX(APV_GROUP) + 1 FROM APV), 0), 0";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, STF_ID);
            pstmt.setString(2, APV_NM);
            pstmt.setString(3, APV_DATE);
            pstmt.setString(4, APV_STT_DATE);
            pstmt.setString(5, APV_FIN_DATE);
            pstmt.setString(6, APV_BUDGET);
            //pstmt.setString(7, APV_COM);
            pstmt.setString(7, APV_PHONE);
            pstmt.setString(8, APV_POLICY_SQ);
            return pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
        	try {
        		if (pstmt != null) pstmt.close();
        		if (conn != null) conn.close();
        	} catch (Exception e) {
        		e.printStackTrace();
        	}       	
        }
        return -1;      // DB 오류      
	}
    
    public int file_write(String APV_FILE, String APV_RFILE) {
    	Connection conn = null;
    	PreparedStatement pstmt = null;
        String SQL = "INSERT INTO APV_FILE SELECT IFNULL((SELECT MAX(APV_FILE_SQ) + 1 FROM APV_FILE), 1), IFNULL((SELECT MAX(APV_SQ) FROM APV), 1), ?, ?, now()";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, APV_FILE);
            pstmt.setString(2, APV_RFILE);
            return pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
        	try {
        		if (pstmt != null) pstmt.close();
        		if (conn != null) conn.close();
        	} catch (Exception e) {
        		e.printStackTrace();
        	}       	
        }
        return -1;      //DB 오류         
	}
    
    public int update(String APV_NM, String APV_DATE, String APV_STT_DATE, String APV_FIN_DATE, String APV_BUDGET,
    		String APV_PHONE, String APV_POLICY_SQ, String APV_SQ) {
    	Connection conn = null;
    	PreparedStatement pstmt = null;
        String SQL = "UPDATE APV SET APV_NM= ?, APV_DATE = ?, APV_STT_DATE = ?, APV_FIN_DATE = ?, APV_BUDGET = ?, APV_PHONE=?, APV_POLICY_SQ=?, WHERE APV_SQ = ?";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
          
            pstmt.setString(1, APV_NM);
            pstmt.setString(2, APV_DATE);
            pstmt.setString(3, APV_STT_DATE);
            pstmt.setString(4, APV_FIN_DATE);
            pstmt.setString(5, APV_BUDGET); 
            pstmt.setString(6, APV_PHONE); 
            pstmt.setString(7, APV_POLICY_SQ); 
           pstmt.setInt(8, Integer.parseInt(APV_SQ));
            
            return pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
        	try {
        		if (pstmt != null) pstmt.close();
        		if (conn != null) conn.close();
        	} catch (Exception e) {
        		e.printStackTrace();
        	}       	
        }
        return -1;      // DB 오류       
	}
    public int file_update(String APV_FILE, String APV_RFILE, String APV_SQ) {
    	Connection conn = null;
    	PreparedStatement pstmt = null;
    	String SQL = "INSERT INTO APV_FILE SELECT IFNULL((SELECT MAX(APV_FILE_SQ) + 1 FROM APV_FILE), 1), ?, ?, ?, now()";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
          
            pstmt.setInt(1, Integer.parseInt(APV_SQ));
            pstmt.setString(2, APV_FILE);
            pstmt.setString(3, APV_RFILE);
            
            return pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
        	try {
        		if (pstmt != null) pstmt.close();
        		if (conn != null) conn.close();
        	} catch (Exception e) {
        		e.printStackTrace();
        	}       	
        }
        return -1;      // DB 오류       
	}
    
    public int delete(String APV_SQ) {
    	Connection conn = null;
    	PreparedStatement pstmt = null;
        String SQL = "UPDATE APV SET APV_AVAILABLE = 0 WHERE APV_SQ = ?";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, Integer.parseInt(APV_SQ));
            return pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
        	try {
        		if (pstmt != null) pstmt.close();
        		if (conn != null) conn.close();
        	} catch (Exception e) {
        		e.printStackTrace();
        	}       	
        }
        return -1;      // DB 오류       
	}
    public ApvDTO getApv(String APV_SQ) {
    	ApvDTO apv = new ApvDTO();
    	Connection conn = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
        String SQL = "SELECT * FROM APV WHERE APV_SQ = ?";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, APV_SQ);
            rs = pstmt.executeQuery(); // ���� ����� ����
            if (rs.next()) {
            	apv.setAPV_SQ(rs.getInt("APV_SQ"));
            	apv.setSTF_ID(rs.getString("STF_ID"));
            	apv.setAPV_NM(rs.getString("APV_NM").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
            	apv.setAPV_DATE(rs.getString("APV_DATE").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
            	apv.setAPV_STT_DATE(rs.getString("APV_STT_DATE").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
            	apv.setAPV_FIN_DATE(rs.getString("APV_FIN_DATE").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
            	apv.setAPV_BUDGET(rs.getString("APV_BUDGET").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
            	//apv.setAPV_COM(rs.getString("APV_COM").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
            	apv.setAPV_PHONE(rs.getString("APV_PHONE").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
            	apv.setAPV_POLICY_SQ(rs.getString("APV_POLICY_SQ").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));      
            	//apv.setAPV_FILE(rs.getString("APV_FILE"));
            	//apv.setAPV_RFILE(rs.getString("APV_RFILE"));
            	apv.setAPV_GROUP(rs.getInt("APV_GROUP"));
            	apv.setAPV_SEQUENCE(rs.getInt("APV_SEQUENCE"));
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
        return apv;         
	}
    
    public ArrayList<ApvDTO> getList(String pageNumber) {
    	ArrayList<ApvDTO> apvList = null;
    	Connection conn = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
        String SQL = "SELECT * FROM APV WHERE APV_GROUP > (SELECT MAX(APV_GROUP) FROM APV) - ? AND APV_GROUP <= (SELECT MAX(APV_GROUP) FROM APV) - ? ORDER BY APV_GROUP DESC, APV_SEQUENCE ASC";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, Integer.parseInt(pageNumber) * 10);
            pstmt.setInt(2, (Integer.parseInt(pageNumber) - 1) * 10);
            rs = pstmt.executeQuery(); // ���� ����� ����
            apvList = new ArrayList<ApvDTO>();
            while (rs.next()) {
            	ApvDTO apv = new ApvDTO();
            	apv.setSTF_ID(rs.getString("STF_ID"));
            	apv.setAPV_SQ(rs.getInt("APV_SQ"));
            	apv.setAPV_NM(rs.getString("APV_NM").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
            	apv.setAPV_DATE(rs.getString("APV_DATE").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
            	apv.setAPV_STT_DATE(rs.getString("APV_STT_DATE").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
            	apv.setAPV_FIN_DATE(rs.getString("APV_FIN_DATE").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
            	apv.setAPV_BUDGET(rs.getString("APV_BUDGET").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
            	//apv.setAPV_COM(rs.getString("APV_COM").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
            	apv.setAPV_PHONE(rs.getString("APV_PHONE").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
            	apv.setAPV_POLICY_SQ(rs.getString("APV_POLICY_SQ").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));      
            	//apv.setAPV_FILE(rs.getString("APV_FILE"));
            	//apv.setAPV_RFILE(rs.getString("APV_RFILE"));
            	apv.setAPV_GROUP(rs.getInt("APV_GROUP"));
            	apv.setAPV_SEQUENCE(rs.getInt("APV_SEQUENCE"));
            	apvList.add(apv);
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
        return apvList;          
	}
    
    public String getFile(String APV_FILE_SQ) {
    	Connection conn = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
        String SQL = "SELECT APV_FILE FROM APV_FILE WHERE APV_FILE_SQ = ?";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, APV_FILE_SQ);
            rs = pstmt.executeQuery(); // ���� ����� ����
            if (rs.next()) {
            	return rs.getString("APV_FILE");
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
    
    public String getRealFile(String APV_FILE_SQ) {
    	Connection conn = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
        String SQL = "SELECT APV_RFILE FROM APV_FILE WHERE APV_FILE_SQ = ?";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, APV_FILE_SQ);
            rs = pstmt.executeQuery(); // ���� ����� ����
            if (rs.next()) {
            	return rs.getString("APV_RFILE");
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
        String SQL = "SELECT * FROM APV WHERE APV_GROUP >= ?";
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
        String SQL = "SELECT COUNT(APV_GROUP) FROM APV WHERE APV_GROUP > ?";
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
    public int apvAllCount() {
    	Connection conn = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
        String SQL = "SELECT COUNT(*) FROM APV";
        try {
        	conn = dataSource.getConnection();
        	pstmt = conn.prepareStatement(SQL);
        	rs = pstmt.executeQuery();
			if(rs.next()) {
				int count = rs.getInt(1);
				return count;
			}
			return 0;
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			try {
				if(pstmt != null) pstmt.close();
				if(rs != null) rs.close();
				if(conn != null) conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return -1;
	}
}