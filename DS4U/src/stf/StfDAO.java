package stf;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.sql.DataSource;

import apv.ApvDTO;

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

	
    // 濡쒓렇�씤 泥섎━ �븿�닔
    public int login(String STF_ID, String STF_PW) {
    	Connection conn = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
        String SQL = "SELECT * FROM STF WHERE STF_ID = ?";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, STF_ID);
            rs = pstmt.executeQuery(); // �떎�뻾 寃곌낵瑜� �꽔�쓬
            if (rs.next()) {     // 寃곌낵媛� 議댁옱�븯硫�
                if(rs.getString("STF_PW").equals(STF_PW)) {// 寃곌낵濡� �굹�삩 STF_PW瑜� 諛쏆븘�꽌 �젒�냽�쓣 �떆�룄�븳 STF_PW�� �룞�씪�븯�떎硫�
                    return 1;    // 濡쒓렇�씤 �꽦怨�
            	}
            	return 2; // 鍮꾨�踰덊샇 �삤瑜�
        	} else {
        		return 0; // �궗�슜�옄 議댁옱x
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
        return -1;      // DB �삤瑜�       
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
            rs = pstmt.executeQuery(); // �떎�뻾 寃곌낵瑜� �꽔�쓬
            if (rs.next() || STF_ID.equals("")) {     // 寃곌낵媛� 議댁옱�븯硫�
            	return 0; // �씠誘� 議댁옱�븯�뒗 �쉶�썝
        	} else {
        		return 1; // 媛��엯 媛��뒫�븳 �쉶�썝
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
        return -1;      // DB �삤瑜�       
	}
    
    public int register(String STF_ID, String STF_PW, String STF_NM, String STF_PH, String STF_EML, String STF_DEP, String STF_PF) {
    	Connection conn = null;
    	PreparedStatement pstmt = null;
        String SQL = "INSERT INTO STF VALUES (?, ?, ?, ?, ?, ?, ?)";
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
        return -1;      // DB �삤瑜�       
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
            rs = pstmt.executeQuery(); // �떎�뻾 寃곌낵瑜� �꽔�쓬
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
        return stf;      // DB �삤瑜�       
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
        return -1;      // DB �삤瑜�       
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
        return -1;      // DB �삤瑜�       
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
        return -1;      // DB �삤瑜�       
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
        return -1;      // DB �삤瑜�       
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
        return -1;      // DB �삤瑜�       
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
        return -1;      // DB �삤瑜�       
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
        return -1;      // DB �삤瑜�       
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
            rs = pstmt.executeQuery(); // �떎�뻾 寃곌낵瑜� �꽔�쓬
            if (rs.next()) {     // 寃곌낵媛� 議댁옱�븯硫�
            	if (rs.getString("STF_PF").equals("")) {
            		return "http://localhost:8080/DS4U/images/profileImage.png";
            	}
            	return "http://localhost:8080/DS4U/images/" + rs.getString("STF_PF");
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
}