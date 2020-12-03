package stf;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.sql.DataSource;
import javax.naming.Context;
import javax.naming.InitialContext;
import java.util.ArrayList;

public class StfDAO {

	DataSource dataSource;
	
	public StfDAO() {
		try {
			InitialContext initContext = new InitialContext();
			Context envContext = (Context) initContext.lookup("java:/comp/env");
			dataSource = (DataSource) envContext.lookup("jdbc/DS4U");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
    // 로그인 처리 함수
    public int login(String STF_ID, String STF_PW) {
    	Connection conn = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
        String SQL = "SELECT STF_PW FROM STF WHERE STF_ID = ?";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, STF_ID);
            rs = pstmt.executeQuery(); // 실행 결과를 넣음
            if (rs.next()) {     // 결과가 존재하면
                if(rs.getString("STF_PW").equals(STF_PW)) {// 결과로 나온 STF_PW를 받아서 접속을 시도한 STF_PW와 동일하다면
                    return 1;    // 로그인 성공
            	}
            	return 2; // 비밀번호 오류
        	} else {
        		return 0; // 사용자 존재x
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
        return -1;      // DB 오류       
	}
    
    public int registerCheck(String STF_ID) {
    	Connection conn = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
        String SQL = "SELECT * FROM STF WHERE STF_ID = ?";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, STF_ID);
            rs = pstmt.executeQuery(); // 실행 결과를 넣음
            if (rs.next() || STF_ID.equals("")) {     // 결과가 존재하면
            	return 0; // 이미 존재하는 회원
        	} else {
        		return 1; // 가입 가능한 회원
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
        return -1;      // DB 오류       
	}
    
    public int register(String STF_ID, String STF_PW, String STF_NM, String STF_PH, String STF_EML, String STF_DEP, String STF_PF, String STF_EMLHASH, boolean STF_EMLCK) {
    	Connection conn = null;
    	PreparedStatement pstmt = null;
        String SQL = "INSERT INTO STF VALUES (?, ?, ?, ?, ?, ?, ?, ?, false)";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, STF_ID);
            pstmt.setString(2, STF_PW);
            pstmt.setString(3, STF_NM);
            pstmt.setString(4, STF_PH);
            pstmt.setString(5, STF_EML);
            pstmt.setString(6, STF_DEP);
            pstmt.setString(7, STF_PF);
            pstmt.setString(8, STF_EMLHASH);
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
    public StfDTO getUser(String STF_ID) {
    	StfDTO stf = new StfDTO();
    	Connection conn = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
        String SQL = "SELECT * FROM STF WHERE STF_ID = ?";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, STF_ID);
            rs = pstmt.executeQuery(); // 실행 결과를 넣음
            if (rs.next()) {
            	stf.setSTF_ID(STF_ID);
            	stf.setSTF_PW(rs.getString("STF_PW"));
            	stf.setSTF_NM(rs.getString("STF_NM"));
            	stf.setSTF_PH(rs.getString("STF_PH"));
            	stf.setSTF_EML(rs.getString("STF_EML"));
            	stf.setSTF_DEP(rs.getString("STF_DEP"));
            	stf.setSTF_PF(rs.getString("STF_PF"));
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
        return stf;      // DB 오류       
	}    
    public int update(String STF_ID, String STF_PW, String STF_NM, String STF_PH, String STF_EML, String STF_DEP) {
    	Connection conn = null;
    	PreparedStatement pstmt = null;
        String SQL = "UPDATE STF SET STF_PW = ?, STF_NM = ?, STF_PH = ?, STF_EML = ?, STF_DEP = ? WHERE STF_ID = ?";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, STF_PW);
            pstmt.setString(2, STF_NM);
            pstmt.setString(3, STF_PH);
            pstmt.setString(4, STF_EML);
            pstmt.setString(5, STF_DEP);
            pstmt.setString(6, STF_ID);
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
    public int name_Update(String STF_ID, String STF_NM) {
    	Connection conn = null;
    	PreparedStatement pstmt = null;
        String SQL = "UPDATE STF SET STF_NM = ? WHERE STF_ID = ?";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, STF_NM);
            pstmt.setString(2, STF_ID);
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
    public int pw_Update(String STF_ID, String STF_PW) {
    	Connection conn = null;
    	PreparedStatement pstmt = null;
        String SQL = "UPDATE STF SET STF_PW = ? WHERE STF_ID = ?";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, STF_PW);
            pstmt.setString(2, STF_ID);
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
    public int email_Update(String STF_ID, String STF_EML) {
    	Connection conn = null;
    	PreparedStatement pstmt = null;
        String SQL = "UPDATE STF SET STF_EML = ? WHERE STF_ID = ?";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, STF_EML);
            pstmt.setString(2, STF_ID);
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
    public int phone_Update(String STF_ID, String STF_PH) {
    	Connection conn = null;
    	PreparedStatement pstmt = null;
        String SQL = "UPDATE STF SET STF_PH = ? WHERE STF_ID = ?";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, STF_PH);
            pstmt.setString(2, STF_ID);
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
    public int dep_Update(String STF_ID, String STF_DEP) {
    	Connection conn = null;
    	PreparedStatement pstmt = null;
        String SQL = "UPDATE STF SET STF_DEP = ? WHERE STF_ID = ?";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, STF_DEP);
            pstmt.setString(2, STF_ID);
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
    public int profile(String STF_ID, String STF_PF) {
    	Connection conn = null;
    	PreparedStatement pstmt = null;
        String SQL = "UPDATE STF SET STF_PF = ? WHERE STF_ID = ?";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, STF_PF);
            pstmt.setString(2, STF_ID);
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
    public String getProfile(String STF_ID) {
    	Connection conn = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
        String SQL = "SELECT STF_PF FROM STF WHERE STF_ID = ?";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, STF_ID);
            rs = pstmt.executeQuery(); // 실행 결과를 넣음
            if (rs.next()) {     // 결과가 존재하면
            	if (rs.getString("STF_PF").equals("")) {
            		return "http://localhost:8080/DS4U/images/profileImage.png";
            	}
            	return "http://localhost:8080/DS4U/profile/" + rs.getString("STF_PF");
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
        return "http://localhost:8080/DS4U/images/profileImage.png";      
	}
    public String getUserEmail(String STF_ID) {
    	Connection conn = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
        String SQL = "SELECT STF_EML FROM STF WHERE STF_ID = ?";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, STF_ID);
            rs = pstmt.executeQuery();
            if (rs.next()) {
            	return rs.getString(1);
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
        return null;      // DB 오류      
	}   	
    
    public boolean getUserEmailChecked(String STF_ID) {
    	Connection conn = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
        String SQL = "SELECT STF_EMLCK FROM STF WHERE STF_ID = ?";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, STF_ID);
            rs = pstmt.executeQuery();
            if (rs.next()) {
            	return rs.getBoolean(1);
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
        return false;      // DB 오류      
	}
    public boolean setUserEmailChecked(String STF_ID) {
    	Connection conn = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
        String SQL = "UPDATE STF SET STF_EMLCK = true WHERE STF_ID = ?";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, STF_ID);
            pstmt.executeUpdate();
            return true;
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
        return false;      // DB 오류      
	}
    public ArrayList<StfDTO> getList(){ //모든 회원정보 리턴해주는 메소드 
		ArrayList<StfDTO> stfList = null; //필요한객체 초기화 
		Connection conn = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
    	String SQL = "SELECT * FROM STF";
		try {
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			stfList = new ArrayList<StfDTO>();
			while(rs.next()){
				StfDTO dto =  new StfDTO();
				dto.setSTF_ID(rs.getString("STF_ID"));
				dto.setSTF_PW(rs.getString("STF_PW"));
				dto.setSTF_NM(rs.getString("STF_NM"));
				dto.setSTF_PH(rs.getString("STF_PH"));
				dto.setSTF_EML(rs.getString("STF_EML"));
				dto.setSTF_DEP(rs.getString("STF_DEP"));
				dto.setSTF_PF(rs.getString("STF_PF"));
				stfList.add(dto);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(rs!=null)	rs.close();
				if(pstmt!=null)	pstmt.close();
				if(conn!=null)	conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return stfList;
	}
    
}