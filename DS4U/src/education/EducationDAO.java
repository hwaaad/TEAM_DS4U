package education;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import education.EducationDTO;

public class EducationDAO {
	DataSource dataSource;	
	public EducationDAO() {
		try {
			InitialContext initContext = new InitialContext();
			Context envContext = (Context) initContext.lookup("java:/comp/env");
			dataSource = (DataSource) envContext.lookup("jdbc/DS4U");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
    public int write(String STF_ID, String EDUCATION_NM, String EDUCATION_TXT, String EDUCATION_FILE, String EDUCATION_RFILE) {
    	Connection conn = null;
    	PreparedStatement pstmt = null;
        String SQL = "INSERT INTO EDUCATION SELECT ?, IFNULL((SELECT MAX(EDUCATION_SQ) + 1 FROM EDUCATION), 1), ?, ?, now(), 0, ?, ?, IFNULL((SELECT MAX(EDUCATION_GROUP) + 1 FROM EDUCATION), 0), 0, 0, 1";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, STF_ID);
            pstmt.setString(2, EDUCATION_NM);
            pstmt.setString(3, EDUCATION_TXT);
            pstmt.setString(4, EDUCATION_FILE);
            pstmt.setString(5, EDUCATION_RFILE);
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
    
    public EducationDTO getEducation(String EDUCATION_SQ) {
    	EducationDTO education = new EducationDTO();
    	Connection conn = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
        String SQL = "SELECT * FROM EDUCATION WHERE EDUCATION_SQ = ?";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, EDUCATION_SQ);
            rs = pstmt.executeQuery(); // 실행 결과를 넣음
            if (rs.next()) {
            	education.setSTF_ID(rs.getString("STF_ID"));
            	education.setEDUCATION_SQ(rs.getInt("EDUCATION_SQ"));
            	education.setEDUCATION_NM(rs.getString("EDUCATION_NM").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
            	education.setEDUCATION_TXT(rs.getString("EDUCATION_TXT").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
            	education.setEDUCATION_DT(rs.getString("EDUCATION_DT").substring(0, 11));
            	education.setEDUCATION_HIT(rs.getInt("EDUCATION_HIT"));
            	education.setEDUCATION_FILE(rs.getString("EDUCATION_FILE"));
            	education.setEDUCATION_RFILE(rs.getString("EDUCATION_RFILE"));
            	education.setEDUCATION_GROUP(rs.getInt("EDUCATION_GROUP"));
            	education.setEDUCATION_SEQUENCE(rs.getInt("EDUCATION_SEQUENCE"));
            	education.setEDUCATION_LEVEL(rs.getInt("EDUCATION_LEVEL"));
            	education.setEDUCATION_AVAILABLE(rs.getInt("EDUCATION_AVAILABLE"));
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
        return education;        
	}
    
    public ArrayList<EducationDTO> getList(String pageNumber) {
    	ArrayList<EducationDTO> educationList = null;
    	Connection conn = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
        String SQL = "SELECT *FROM EDUCATION WHERE EDUCATION_GROUP > (SELECT MAX(EDUCATION_GROUP) FROM EDUCATION) - ? AND EDUCATION_GROUP <= (SELECT MAX(EDUCATION_GROUP) FROM EDUCATION) - ? ORDER BY EDUCATION_GROUP DESC, EDUCATION_SEQUENCE ASC";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, Integer.parseInt(pageNumber) * 10);
            pstmt.setInt(2, (Integer.parseInt(pageNumber) - 1) * 10);
            rs = pstmt.executeQuery(); // 실행 결과를 넣음
            educationList = new ArrayList<EducationDTO>();
            while (rs.next()) {
            	EducationDTO education = new EducationDTO();
            	education.setSTF_ID(rs.getString("STF_ID"));
            	education.setEDUCATION_SQ(rs.getInt("EDUCATION_SQ"));
            	education.setEDUCATION_NM(rs.getString("EDUCATION_NM").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
            	education.setEDUCATION_TXT(rs.getString("EDUCATION_TXT").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
            	education.setEDUCATION_DT(rs.getString("EDUCATION_DT").substring(0, 11));
            	education.setEDUCATION_HIT(rs.getInt("EDUCATION_HIT"));
            	education.setEDUCATION_FILE(rs.getString("EDUCATION_FILE"));
            	education.setEDUCATION_RFILE(rs.getString("EDUCATION_RFILE"));
            	education.setEDUCATION_GROUP(rs.getInt("EDUCATION_GROUP"));
            	education.setEDUCATION_SEQUENCE(rs.getInt("EDUCATION_SEQUENCE"));
            	education.setEDUCATION_LEVEL(rs.getInt("EDUCATION_LEVEL"));
            	education.setEDUCATION_AVAILABLE(rs.getInt("EDUCATION_AVAILABLE"));
            	educationList.add(education);
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
        return educationList;          
	}
    
    public int hit(String EDUCATION_SQ) {
    	Connection conn = null;
    	PreparedStatement pstmt = null;
        String SQL = "UPDATE EDUCATION SET EDUCATION_HIT = EDUCATION_HIT + 1 WHERE EDUCATION_SQ = ?";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, EDUCATION_SQ);
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
    
    public String getFile(String EDUCATION_SQ) {
    	Connection conn = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
        String SQL = "SELECT EDUCATION_FILE FROM EDUCATION WHERE EDUCATION_SQ = ?";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, EDUCATION_SQ);
            rs = pstmt.executeQuery(); // 실행 결과를 넣음
            if (rs.next()) {
            	return rs.getString("EDUCATION_FILE");
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
    
    public String getRealFile(String EDUCATION_SQ) {
    	Connection conn = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
        String SQL = "SELECT EDUCATION_RFILE FROM EDUCATION WHERE EDUCATION_SQ = ?";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, EDUCATION_SQ);
            rs = pstmt.executeQuery(); // 실행 결과를 넣음
            if (rs.next()) {
            	return rs.getString("EDUCATION_RFILE");
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
    public int update(String EDUCATION_SQ, String EDUCATION_NM, String EDUCATION_TXT, String EDUCATION_FILE, String EDUCATION_RFILE) {
    	Connection conn = null;
    	PreparedStatement pstmt = null;
        String SQL = "UPDATE EDUCATION SET EDUCATION_NM = ?, EDUCATION_TXT = ?, EDUCATION_FILE = ?, EDUCATION_RFILE = ? WHERE EDUCATION_SQ = ?";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, EDUCATION_NM);
            pstmt.setString(2, EDUCATION_TXT);
            pstmt.setString(3,EDUCATION_FILE);
            pstmt.setString(4, EDUCATION_RFILE);            
            pstmt.setInt(5, Integer.parseInt(EDUCATION_SQ));
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
    
    public int delete(String EDUCATION_SQ) {
    	Connection conn = null;
    	PreparedStatement pstmt = null;
        String SQL = "UPDATE EDUCATION SET EDUCATION_AVAILABLE = 0 WHERE EDUCATION_SQ = ?";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, Integer.parseInt(EDUCATION_SQ));
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
    
   
    
  
    
    public boolean nextPage(String pageNumber) {
    	Connection conn = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
        String SQL = "SELECT * FROM EDUCATION WHERE EDUCATION_GROUP >= ?";
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
        String SQL = "SELECT COUNT(EDUCATION_GROUP) FROM EDUCATION WHERE EDUCATION_GROUP > ?";
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
    
   
	
    public ArrayList<EducationDTO> getSearch(String searchType, String search, int PageNumber) {
    	
    	ArrayList<EducationDTO> searchList = null;
    	Connection conn = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
        String SQL = "";
        try {
        	if (searchType.equals("최신순")) {
        		SQL = "SELECT * FROM EDUCATION WHERE CONCAT(STF_ID, EDUCATION_NM, EDUCATION_TXT) LIKE " + "? ORDER BY EDUCATION_SQ DESC LIMIT " + PageNumber * 5 + ", " + PageNumber * 5 + 6;
        	} else if (searchType.equals("조회순")) {
        		SQL = "SELECT * FROM EDUCATION WHERE CONCAT(STF_ID, EDUCATION_NM, EDUCATION_TXT) LIKE " + "? ORDER BY EDUCATION_HIT DESC LIMIT " + PageNumber * 5 + ", " + PageNumber * 5 + 6;
        	}
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, "%" + search + "%");
            rs = pstmt.executeQuery(); 
            searchList = new ArrayList<EducationDTO>();
            while (rs.next()) {             	
            	EducationDTO education = new EducationDTO();
                education.setSTF_ID(rs.getString("STF_ID"));
                education.setEDUCATION_SQ(rs.getInt("EDUCATION_SQ"));
                education.setEDUCATION_NM(rs.getString("EDUCATION_NM").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
                education.setEDUCATION_TXT(rs.getString("EDUCATION_TXT").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
                education.setEDUCATION_DT(rs.getString("EDUCATION_DT").substring(0, 11));
                education.setEDUCATION_HIT(rs.getInt("EDUCATION_HIT"));
                education.setEDUCATION_FILE(rs.getString("EDUCATION_FILE"));
                education.setEDUCATION_RFILE(rs.getString("EDUCATION_RFILE"));
                education.setEDUCATION_GROUP(rs.getInt("EDUCATION_GROUP"));
                education.setEDUCATION_SEQUENCE(rs.getInt("EDUCATION_SEQUENCE"));
                education.setEDUCATION_LEVEL(rs.getInt("EDUCATION_LEVEL"));
                education.setEDUCATION_AVAILABLE(rs.getInt("EDUCATION_AVAILABLE"));                
            	searchList.add(education);        
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
        return searchList;     
	}
}