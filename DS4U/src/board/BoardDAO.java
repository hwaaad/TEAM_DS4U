package board;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class BoardDAO {
	DataSource dataSource;	
	public BoardDAO() {
		try {
			InitialContext initContext = new InitialContext();
			Context envContext = (Context) initContext.lookup("java:/comp/env");
			dataSource = (DataSource) envContext.lookup("jdbc/DS4U");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
    public int write(String STF_ID, String BOARD_TYPE, String BOARD_NM, String BOARD_TXT, String BOARD_FILE, String BOARD_RFILE) {
    	Connection conn = null;
    	PreparedStatement pstmt = null;
        String SQL = "INSERT INTO BOARD SELECT ?, IFNULL((SELECT MAX(BOARD_SQ) + 1 FROM BOARD), 1), ?, ?, ?, now(), 0, ?, ?, IFNULL((SELECT MAX(BOARD_GROUP) + 1 FROM BOARD), 0), 0, 0, 1";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, STF_ID);
            pstmt.setString(2, BOARD_TYPE);
            pstmt.setString(3, BOARD_NM);
            pstmt.setString(4, BOARD_TXT);
            pstmt.setString(5, BOARD_FILE);
            pstmt.setString(6, BOARD_RFILE);
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
    
    public BoardDTO getBoard(String BOARD_SQ) {
    	BoardDTO board = new BoardDTO();
    	Connection conn = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
        String SQL = "SELECT * FROM BOARD WHERE BOARD_SQ = ?";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, BOARD_SQ);
            rs = pstmt.executeQuery(); // 실행 결과를 넣음
            if (rs.next()) {
            	board.setSTF_ID(rs.getString("STF_ID"));
            	board.setBOARD_SQ(rs.getInt("BOARD_SQ"));
            	board.setBOARD_TYPE(rs.getString("BOARD_TYPE"));
            	board.setBOARD_NM(rs.getString("BOARD_NM").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
            	board.setBOARD_TXT(rs.getString("BOARD_TXT").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
            	board.setBOARD_DT(rs.getString("BOARD_DT").substring(0, 11));
            	board.setBOARDHIT(rs.getInt("BOARDHIT"));
            	board.setBOARD_FILE(rs.getString("BOARD_FILE"));
            	board.setBOARD_RFILE(rs.getString("BOARD_RFILE"));
            	board.setBOARD_GROUP(rs.getInt("BOARD_GROUP"));
            	board.setBOARD_SEQUENCE(rs.getInt("BOARD_SEQUENCE"));
            	board.setBOARD_LEVEL(rs.getInt("BOARD_LEVEL"));
            	board.setBOARD_AVAILABLE(rs.getInt("BOARD_AVAILABLE"));
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
        return board;         
	}
    
    public ArrayList<BoardDTO> getList(String pageNumber) {
    	ArrayList<BoardDTO> boardList = null;
    	Connection conn = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
        String SQL = "SELECT * FROM BOARD WHERE BOARD_GROUP > (SELECT MAX(BOARD_GROUP) FROM BOARD) - ? AND BOARD_GROUP <= (SELECT MAX(BOARD_GROUP) FROM BOARD) - ? ORDER BY BOARD_GROUP DESC, BOARD_SEQUENCE ASC";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, Integer.parseInt(pageNumber) * 10);
            pstmt.setInt(2, (Integer.parseInt(pageNumber) - 1) * 10);
            rs = pstmt.executeQuery(); // 실행 결과를 넣음
            boardList = new ArrayList<BoardDTO>();
            while (rs.next()) {
            	BoardDTO board = new BoardDTO();
            	board.setSTF_ID(rs.getString("STF_ID"));
            	board.setBOARD_SQ(rs.getInt("BOARD_SQ"));
            	board.setBOARD_TYPE(rs.getString("BOARD_TYPE"));
            	board.setBOARD_NM(rs.getString("BOARD_NM").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
            	board.setBOARD_TXT(rs.getString("BOARD_TXT").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
            	board.setBOARD_DT(rs.getString("BOARD_DT").substring(0, 11));
            	board.setBOARDHIT(rs.getInt("BOARDHIT"));
            	board.setBOARD_FILE(rs.getString("BOARD_FILE"));
            	board.setBOARD_RFILE(rs.getString("BOARD_RFILE"));
            	board.setBOARD_GROUP(rs.getInt("BOARD_GROUP"));
            	board.setBOARD_SEQUENCE(rs.getInt("BOARD_SEQUENCE"));
            	board.setBOARD_LEVEL(rs.getInt("BOARD_LEVEL"));
            	board.setBOARD_AVAILABLE(rs.getInt("BOARD_AVAILABLE"));
            	boardList.add(board);
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
        return boardList;          
	}
    
    public int hit(String BOARD_SQ) {
    	Connection conn = null;
    	PreparedStatement pstmt = null;
        String SQL = "UPDATE BOARD SET BOARDHIT = BOARDHIT + 1 WHERE BOARD_SQ = ?";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, BOARD_SQ);
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
    
    public String getFile(String BOARD_SQ) {
    	Connection conn = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
        String SQL = "SELECT BOARD_FILE FROM BOARD WHERE BOARD_SQ = ?";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, BOARD_SQ);
            rs = pstmt.executeQuery(); // 실행 결과를 넣음
            if (rs.next()) {
            	return rs.getString("BOARD_FILE");
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
    
    public String getRealFile(String BOARD_SQ) {
    	Connection conn = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
        String SQL = "SELECT BOARD_RFILE FROM BOARD WHERE BOARD_SQ = ?";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, BOARD_SQ);
            rs = pstmt.executeQuery(); // 실행 결과를 넣음
            if (rs.next()) {
            	return rs.getString("BOARD_RFILE");
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
    public int update(String BOARD_SQ, String BOARD_TYPE, String BOARD_NM, String BOARD_TXT, String BOARD_FILE, String BOARD_RFILE) {
    	Connection conn = null;
    	PreparedStatement pstmt = null;
        String SQL = "UPDATE BOARD SET BOARD_TYPE = ?, BOARD_NM = ?, BOARD_TXT = ?, BOARD_FILE = ?, BOARD_RFILE = ? WHERE BOARD_SQ = ?";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, BOARD_TYPE);
            pstmt.setString(2, BOARD_NM);
            pstmt.setString(3, BOARD_TXT);
            pstmt.setString(4, BOARD_FILE);
            pstmt.setString(5, BOARD_RFILE);            
            pstmt.setInt(6, Integer.parseInt(BOARD_SQ));
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
    
    public int delete(String BOARD_SQ) {
    	Connection conn = null;
    	PreparedStatement pstmt = null;
        String SQL = "UPDATE BOARD SET BOARD_AVAILABLE = 0 WHERE BOARD_SQ = ?";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, Integer.parseInt(BOARD_SQ));
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
    
    public int reply(String STF_ID, String BOARD_TYPE, String BOARD_NM, String BOARD_TXT, String BOARD_FILE, String BOARD_RFILE, BoardDTO parent) {
    	Connection conn = null;
    	PreparedStatement pstmt = null;
        String SQL = "INSERT INTO BOARD SELECT ?, IFNULL((SELECT MAX(BOARD_SQ) + 1 FROM BOARD), 1), ?, ?, ?, now(), 0, ?, ?, ?, ?, ?, 1";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, STF_ID);
            pstmt.setString(2, BOARD_TYPE);
            pstmt.setString(3, BOARD_NM);
            pstmt.setString(4, BOARD_TXT);
            pstmt.setString(5, BOARD_FILE);
            pstmt.setString(6, BOARD_RFILE);
            pstmt.setInt(7, parent.getBOARD_GROUP());
            pstmt.setInt(8, parent.getBOARD_SEQUENCE() + 1);
            pstmt.setInt(9, parent.getBOARD_LEVEL() + 1);
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
    
    public int replyUpdate(BoardDTO parent) {
    	Connection conn = null;
    	PreparedStatement pstmt = null;
        String SQL = "UPDATE BOARD SET BOARD_SEQUENCE = BOARD_SEQUENCE + 1 WHERE BOARD_GROUP = ? AND BOARD_SEQUENCE > ?";
        try {
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, parent.getBOARD_GROUP());
            pstmt.setInt(2, parent.getBOARD_SEQUENCE());
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
        String SQL = "SELECT * FROM BOARD WHERE BOARD_GROUP >= ?";
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
        String SQL = "SELECT COUNT(BOARD_GROUP) FROM BOARD WHERE BOARD_GROUP > ?";
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
    
    public ArrayList<BoardDTO> getSearch(String BOARD_TYPE, String searchType, String search, int PageNumber) {
    	if (BOARD_TYPE.equals("전체")) {
    		BOARD_TYPE = "";
    	}
    	ArrayList<BoardDTO> searchList = null;
    	Connection conn = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
        String SQL = "";
        try {
        	if (searchType.equals("최신순")) {
        		SQL = "SELECT * FROM BOARD WHERE BOARD_TYPE LIKE ? AND CONCAT(STF_ID, BOARD_NM, BOARD_TXT) LIKE " + "? ORDER BY BOARD_SQ DESC LIMIT " + PageNumber * 5 + ", " + PageNumber * 5 + 6;
        	} else if (searchType.equals("조회순")) {
        		SQL = "SELECT * FROM BOARD WHERE BOARD_TYPE LIKE ? AND CONCAT(STF_ID, BOARD_NM, BOARD_TXT) LIKE " + "? ORDER BY BOARDHIT DESC LIMIT " + PageNumber * 5 + ", " + PageNumber * 5 + 6;
        	}
        	conn = dataSource.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, "%" + BOARD_TYPE + "%");
            pstmt.setString(2, "%" + search + "%");
            rs = pstmt.executeQuery(); 
            searchList = new ArrayList<BoardDTO>();
            while (rs.next()) {             	
            	BoardDTO board = new BoardDTO();
                board.setSTF_ID(rs.getString("STF_ID"));
                board.setBOARD_SQ(rs.getInt("BOARD_SQ"));
                board.setBOARD_TYPE(rs.getString("BOARD_TYPE"));
                board.setBOARD_NM(rs.getString("BOARD_NM").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
                board.setBOARD_TXT(rs.getString("BOARD_TXT").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
                board.setBOARD_DT(rs.getString("BOARD_DT").substring(0, 11));
                board.setBOARDHIT(rs.getInt("BOARDHIT"));
                board.setBOARD_FILE(rs.getString("BOARD_FILE"));
                board.setBOARD_RFILE(rs.getString("BOARD_RFILE"));
                board.setBOARD_GROUP(rs.getInt("BOARD_GROUP"));
                board.setBOARD_SEQUENCE(rs.getInt("BOARD_SEQUENCE"));
                board.setBOARD_LEVEL(rs.getInt("BOARD_LEVEL"));
                board.setBOARD_AVAILABLE(rs.getInt("BOARD_AVAILABLE"));                
            	searchList.add(board);        
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