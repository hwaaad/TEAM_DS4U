<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="req.ReqDAO" %>
<%@ page import="req.ReqDTO" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="head.jsp" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.Context" %>
<!DOCTYPE html>
<html>
<%
	String STF_ID = null;
	String STF_DEP = null;
	String STF_NM = null;
	if (session.getAttribute("STF_ID") != null) {
		STF_ID = (String) session.getAttribute("STF_ID");
	}
	if (STF_ID == null) {
		session.setAttribute("messageType", "오류 메시지");
		session.setAttribute("messageContent", "로그인이 필요합니다.");
		response.sendRedirect("index.jsp");
		return;	
	}
	String pageNumber = "1";
	if (request.getParameter("pageNumber") != null) {
		pageNumber = request.getParameter("pageNumber");
	}
	try {
		Integer.parseInt(pageNumber);
	} catch (Exception e) {
		session.setAttribute("messageType", "오류 메시지");
		session.setAttribute("messageContent", "페이지 번호가 잘못되었습니다.");
		response.sendRedirect("reqView.jsp");
		return;			
	}
	ArrayList<ReqDTO> reqList = new ReqDAO().getList(pageNumber);
	
	StfDTO stf = new StfDAO().getUser(STF_ID);
	ReqDAO reqDAO = new ReqDAO();

%>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"> 
	<!-- <link rel="stylesheet" href="css/bootstrap.css">
	<link rel="stylesheet" href="css/custom.css"> -->
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/headerWs.css"/>
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/navWs.css"/>
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/modal.css"/>
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/alert.css"/>
	
	<title>서울교통공사</title>
	<script src="js/bootstrap.js"></script>
</head>

<body>
 	<%@ include file="headerWs.jsp" %>
	<%@ include file="navWs.jsp" %>
	<%@ include file="modal.jsp" %>
	<div id="wsBody">
	<input type="hidden" value="board" id="pageType">
		<div id="wsBodyContainer">
			<h3>보안성검토 회신 알림</h3>
			<div id="boardInner">
				<div id="inputWrap">
				<ul id="boardList">	
				<table class="table" style="text-align: center; border: 1px solid #dddddd">
					<thead>
						<tr>
							<td>No.</td>
							<td>사업명</td>
							<td>부서명</td>
							<td>담당자</td>
							<td>사업 회신일</td>
							<td>회신 상태 </td>
						
						</tr>
					</thead>
				<tbody>	
			<%
				
		
				for (int i=0; i<reqList.size(); i++) {
					ReqDTO req = reqList.get(i);
					
						if(session.getAttribute("STF_ID").equals(req.getSTF_ID()) && (req.getREQ_STATE()==2||req.getREQ_STATE()==3)){
										
			%>
				<tr>
				<td style="text-align: center;">
				<a href="reviewWrite.jsp?APV_SQ=<%= req.getAPV_SQ() %>">
				<%= req.getREQ_SQ() %>
					
					<td style="text-align: left;">
					<a href="apvShow.jsp?APV_SQ=<%= req.getAPV_SQ() %>">
					<%= req.getAPV_NM() %>
					</a>
					
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
					
					<td>
					<% 
							
								dataSource = (DataSource) envContext.lookup("jdbc/DS4U");
						    	try{
						    		
						    		conn = dataSource.getConnection();
						    		String SQL = "SELECT STF_NM FROM STF WHERE STF_ID = ?";
					           		pstmt = conn.prepareStatement(SQL);
					           		pstmt.setString(1, req.getSTF_ID());
					           		rs = pstmt.executeQuery();
					           		
					           	 	while (rs.next()) {
						            	
					           	 		STF_NM = rs.getString("STF_NM").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>");
						            	
						            	
						            	%>
						           <%= STF_NM %>
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
					<td style="text-align: center;">
					<a href="reqrecShow.jsp?REQ_SQ=<%= req.getREQ_SQ() %>">
					<%= req.getREQ_REC_DATE() %></td>
						<td>
						<% 
						switch(req.getREQ_STATE()){
						case 1:
							%> 검토 전 <% 
							break;
						case 2:
							%> 검토 반려 <%
							break;
						case 3:
							%> 검토 승인 <%
							break;
						case 4:
							%> 사업 완료 <% 
							break;
						default :
							%> null <% 
						}
						%>
						</td>				
				</tr>
			<%
				}
			}
				
			%>
							<tr>
					<td colspan="9">
					
						<ul id="pagination" style="margin: 0 auto;">				
					<% 
						int startPage = (Integer.parseInt(pageNumber) / 10) * 10 + 1;
						if (Integer.parseInt(pageNumber) % 10 == 0) startPage -= 10;
						int targetPage = new ReqDAO().targetPage(pageNumber);
						if (startPage != 1) {
					%>
						<li><a href="reqView.jsp?pageNumber=<%= startPage - 1 %>"><i class="fas fa-angle-left"></i></a></li>
					<%
						} else {
					%>
						<li><i class="fas fa-angle-left"></i></li>
					<%
						}
						for (int i=startPage; i<Integer.parseInt(pageNumber); i++) {
					%>
						<li><a href="reqView.jsp?pageNumber=<%= i %>"><%= i %></a></li>
					<%
						}
					%>
						<li class="active"><a href="reqView.jsp?pageNumber=<%= pageNumber %>"><%= pageNumber %></a></li>	
					<%
						for (int i=Integer.parseInt(pageNumber) + 1; i<=targetPage + Integer.parseInt(pageNumber); i++) {
							if (i < startPage + 10) {
					%>
						<li><a href="reqView.jsp?pageNumber=<%= i %>"><%= i %></a></li>
					<%
							}
						}
						if (targetPage + Integer.parseInt(pageNumber) > startPage + 9) {
					%>
						<li><a href="reqView.jsp?pageNumber=<%= startPage + 10 %>"><i class="fas fa-angle-right"></i></a></li>
					<%
						} else {
					%>
						<li><i class="fas fa-angle-right"></i></li>
					<%
						}
					%>	
						
						</ul>
					</td>
				</tr>			
			</tbody>
		</table>
	</div>
</body>
</html>	