<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/head.jsp" %>
<%@ page import="req.ReqDAO" %>
<%@ page import="req.ReqDTO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="board.BoardDAO" %>
<%@ page import="board.BoardDTO" %>
<%@ page import="java.net.URLEncoder" %>
<!DOCTYPE html>
<html>
<%	
	String STF_ID = null;
	String STF_DEP = null;
	if (session.getAttribute("STF_ID") != null) {
		STF_ID = (String) session.getAttribute("STF_ID");
	}
	ArrayList<ReqDTO> reqList = new ReqDAO().getList2();
	ArrayList<ReqDTO> reqList2 = new ReqDAO().getList3();
	ArrayList<ReqDTO> reqList3 = new ReqDAO().getList4();
	ArrayList<BoardDTO> boardList = new BoardDAO().getList2();
%>

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" type="text/css" href="css/headerMain.css"/>
	<link rel="stylesheet" type="text/css" href="css/footerMain.css"/>
	<link rel="stylesheet" type="text/css" href="css/main.css"/>
	<link rel="stylesheet" type="text/css" href="css/animate.css"/>
	<link rel="stylesheet" type="text/css" href="css/animationCheatSheet.css"/>
	<link rel="stylesheet" type="text/css" href="css/modal.css"/>
	<script src="js/bootstrap.js"></script>
	<title>서울교통공사</title>
	 <style>
      body{
      style="font-size:5px";
      }
      table {
        width: 100%;
      }
      th, td {
        padding: 10px;
        border-bottom: 1px solid #dadada;
      }
    </style>
</head>

<body>
    
	<%@ include file="/headerMain.jsp" %>
	<%@ include file="/modal.jsp" %>
		
	<div id="welcome">
	<section id="main-cover" class="box">
		<div style="color:white; width:2000px; height:300px; " >
		1. 전체 정보화사업 
	<table>
      <thead>
        <tr>
          <th>No.</th>
          <th>사업명</th>
          <th>부서명</th>
          <th>담당자</th>
          <th>검토 요청일</th>
          <th>회신일</th>
           
        </tr>
      </thead>
      
      <tbody>
      <%
		for (int i=0; i<reqList.size(); i++) {
			ReqDTO req = reqList.get(i);					
	  %>
			<tr>
					<td><%= req.getREQ_SQ() %></td>
					<td><%= req.getAPV_NM() %></td>	
					
					<td>
					<% 
								
								Connection conn = null;
						    	PreparedStatement pstmt = null;
						    	ResultSet rs = null;
						    	DataSource dataSource;
						    	InitialContext initContext = new InitialContext();
								Context envContext = (Context) initContext.lookup("java:/comp/env");
								dataSource = (DataSource) envContext.lookup("jdbc/DS4U");
						    	try{
						    		
						    		conn = dataSource.getConnection();
						    		String SQL = "SELECT STF_DEP FROM STF WHERE STF_ID = ?";
					           		pstmt = conn.prepareStatement(SQL);
					           		pstmt.setString(1, req.getSTF_ID());
					           		rs = pstmt.executeQuery();
					           		
					           	 	while (rs.next()) {
						            	
					           	 		STF_DEP = rs.getString("STF_DEP").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>");
						            	
						            	
						            	%>
						           <%= STF_DEP %>
						            	<%
						            } 									
						    	}catch (Exception e) {
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
						 %>
						
					</td>
					
					
					<td><%= req.getSTF_ID() %></td>
					<td><%= req.getREQ_DATE() %></td>
					<td> <%= req.getREQ_REC_DATE() %> </td>
					
				</tr>
      </tbody>
      <%
		}
	  %>
  </table> 
		</div>
		<div style="color:white; width:2000px; height:300px;">
		2. 진행중인 정보화사업
	<table>
      <thead>
        <tr>
          <th>No.</th>
          <th>사업명</th> 
          <th>부서명</th>    
          <th>담당자</th>
          <th>검토 요청일</th>
          <th>회신일</th>
           
        </tr>
      </thead>
      
      <tbody>
      <%
		for (int i=0; i<reqList2.size(); i++) {
			ReqDTO req = reqList2.get(i);					
	  %>
			<tr>
					<td><%= req.getREQ_SQ() %></td>
					<td><%= req.getAPV_NM() %></td>	
					
					<td>
					<% 
								
								Connection conn = null;
						    	PreparedStatement pstmt = null;
						    	ResultSet rs = null;
						    	DataSource dataSource;
						    	InitialContext initContext = new InitialContext();
								Context envContext = (Context) initContext.lookup("java:/comp/env");
								dataSource = (DataSource) envContext.lookup("jdbc/DS4U");
						    	try{
						    		
						    		conn = dataSource.getConnection();
						    		String SQL = "SELECT STF_DEP FROM STF WHERE STF_ID = ?";
					           		pstmt = conn.prepareStatement(SQL);
					           		pstmt.setString(1, req.getSTF_ID());
					           		rs = pstmt.executeQuery();
					           		
					           	 	while (rs.next()) {
						            	
					           	 		STF_DEP = rs.getString("STF_DEP").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>");
						            	
						            	
						            	%>
						           <%= STF_DEP %>
						            	<%
						            } 									
						    	}catch (Exception e) {
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
						 %>
						
					</td>
					
					<td><%= req.getSTF_ID() %></td>
					<td><%= req.getREQ_DATE() %></td>
					<td><%= req.getREQ_REC_DATE() %></td>
					
				</tr>
      </tbody>
      <%
		}
	  %>
  </table> 
		</div>
		<div style="color:white; width:2000px; height:300px; ">
		3. 완료된 정보화사업
	<table>
      <thead>
        <tr>
          <th>No.</th>
          <th>사업명</th> 
          <th>부서명</th>    
          <th>담당자</th>
          <th>검토 요청일</th>
          <th>회신일</th>
          <th>보안점검표 제출일</th>
        </tr>
      </thead>
      
      <tbody>
      <%
		for (int i=0; i<reqList3.size(); i++) {
			ReqDTO req = reqList3.get(i);					
	  %>
			<tr>
					<td><%= req.getREQ_SQ() %></td>
					<td><%= req.getAPV_NM() %></td>	
					
					<td>
					<% 
								
								Connection conn = null;
						    	PreparedStatement pstmt = null;
						    	ResultSet rs = null;
						    	DataSource dataSource;
						    	InitialContext initContext = new InitialContext();
								Context envContext = (Context) initContext.lookup("java:/comp/env");
								dataSource = (DataSource) envContext.lookup("jdbc/DS4U");
						    	try{
						    		
						    		conn = dataSource.getConnection();
						    		String SQL = "SELECT STF_DEP FROM STF WHERE STF_ID = ?";
					           		pstmt = conn.prepareStatement(SQL);
					           		pstmt.setString(1, req.getSTF_ID());
					           		rs = pstmt.executeQuery();
					           		
					           	 	while (rs.next()) {
						            	
					           	 		STF_DEP = rs.getString("STF_DEP").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>");
						            	
						            	
						            	%>
						           <%= STF_DEP %>
						            	<%
						            } 									
						    	}catch (Exception e) {
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
						 %>
						
					</td>
					
					<td><%= req.getSTF_ID() %></td>
					<td><%= req.getREQ_DATE() %></td>
					<td><%= req.getREQ_REC_DATE() %></td>
					<td><%= req.getREQ_SUB_DATE() %></td>
				</tr>
      </tbody>
      <%
		}
	  %>
  </table> 
		</div>
		<div style="color:white; width:2000px; height:300px; ">
		4.     공지사항
		
  <table>
      <thead>
        <tr>
          <th>No.</th> 
          <th>부서명</th>    
          <th>글쓴이</th>
          <th>제목</th>
          <th>날짜</th>
          <th>조회수</th>
           
        </tr>
      </thead>
      
      <tbody>
      <%
		for (int i=0; i<boardList.size(); i++) {
			BoardDTO req = boardList.get(i);					
	  %>
			<tr>
					<td><%= req.getBOARD_SQ() %></td>
					
					<td>
					<% 
								
								Connection conn = null;
						    	PreparedStatement pstmt = null;
						    	ResultSet rs = null;
						    	DataSource dataSource;
						    	InitialContext initContext = new InitialContext();
								Context envContext = (Context) initContext.lookup("java:/comp/env");
								dataSource = (DataSource) envContext.lookup("jdbc/DS4U");
						    	try{
						    		
						    		conn = dataSource.getConnection();
						    		String SQL = "SELECT STF_DEP FROM STF WHERE STF_ID = ?";
					           		pstmt = conn.prepareStatement(SQL);
					           		pstmt.setString(1, req.getSTF_ID());
					           		rs = pstmt.executeQuery();
					           		
					           	 	while (rs.next()) {
						            	
					           	 		STF_DEP = rs.getString("STF_DEP").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>");
						            	
						            	
						            	%>
						           <%= STF_DEP %>
						            	<%
						            } 									
						    	}catch (Exception e) {
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
						 %>
						
					</td>
					
					
					
					<td><%= req.getSTF_ID() %></td>
					<td><%= req.getBOARD_NM() %></td>	
					<td><%= req.getBOARD_DT() %></td>
					<td><%= req.getBOARDHIT() %></td>
					
				</tr>
      </tbody>
      <%
		}
	  %>
  </table> 
  </div>
			<div class="container">
				<div class="text">
				
					<div class="head-body-up animated fadeInUp">.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;.</div>
					<div class="head-body-down animated fadeInUp">서울교통공사</div>
					<div class="head-title"><p class="animated fadeInUp">DS4U</p></div>
					<div class="head-caption animated fadeInUp">DS4U<br>정보화사업 보안성검토 Project</div>
				</div>
			</div>
		</section>
	</div>
		
	<div><%@ include file="/footerMain.jsp" %></div>

</body>
</html>