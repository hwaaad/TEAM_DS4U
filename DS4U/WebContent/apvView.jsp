<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="apv.ApvDAO" %>
<%@ page import="apv.ApvDTO" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="head.jsp" %>
<!DOCTYPE html>
<html>
<%
	String STF_ID = null;
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
	boolean emailChecked = new StfDAO().getUserEmailChecked(STF_ID);
	if (emailChecked == false) {
		session.setAttribute("messageType", "오류 메시지");
		session.setAttribute("messageContent", "이메일 인증이 필요합니다.");
		response.sendRedirect("emailSendConfirm.jsp");
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
		response.sendRedirect("apvView.jsp");
		return;			
	}
	StfDTO stf = new StfDAO().getUser(STF_ID);
	ArrayList<ApvDTO> apvList = new ApvDAO().getList(pageNumber);
%>

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<!-- <link rel="stylesheet" href="css/bootstrap.css">
	<link rel="stylesheet" href="css/custom.css"> -->
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/headerWs.css"/>
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/navWs.css"/>
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/apv.css"/>
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/modal.css"/>
	<title>서울교통공사</title>
	<script src="js/bootstrap.js"></script>
</head>

<body>
	<%@ include file="headerWs.jsp" %>
	<%@ include file="navWs.jsp" %>
	<%@ include file="/modal.jsp" %>
	
	<div id="wsBody">
	<input type="hidden" value="board" id="pageType">
		<div id="wsBodyContainer">
			<h3>정보화 사업</h3>
			<div id="boardInner" style="text-align: left;">
				<ul id="boardList">
					<li id="listHead">
						<div>No.</div>
						<div>사업명</div>
						<div>사업 기간</div>
						<div>사업 시작일</div>
						<div>사업 종료일</div>
						<div>소요 예산</div>
						<div>사업 담당자</div>
						<div>연락처</div>
						<div>사업 방침번호</div>
					</li>			
			<table class="table" style="text-align: center; border: 1px solid #dddddd">
			<tbody>
			<%
				for (int i=0; i<apvList.size(); i++) {
					ApvDTO apv = apvList.get(i);
			%>
					<tr>
						<td><%= apv.getAPV_SQ() %></td>
						<td style="text-align: left;"><a href="apvShow.jsp?APV_SQ=<%= apv.getAPV_SQ() %>"><%= apv.getAPV_NM() %></a></td>
						<td><%= apv.getAPV_DATE() %></td>
						<td><%= apv.getAPV_STT_DATE() %></td>
						<td><%= apv.getAPV_FIN_DATE() %></td>
						<td><%= apv.getAPV_BUDGET() %></td>
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
						    		String SQL = "SELECT STF_NM FROM STF WHERE STF_ID = ?";
					           		pstmt = conn.prepareStatement(SQL);
					           		pstmt.setString(1, apv.getSTF_ID());
					           		rs = pstmt.executeQuery();
									
					           		
									while (rs.next()) {
						            	
					           	 		STF_NM = rs.getString("STF_NM").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>");
						            	
						            	
						            		%>
						         	  <%=STF_NM%>
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
						<td><%= apv.getAPV_PHONE() %></td>
						<td><%= apv.getAPV_POLICY_SQ() %></td>
					</tr>
			<%
				}
			%>
				<tr>
					<td colspan="9">
						<a href="${contextPath}/apvWrite.jsp" id="writeBtn">글쓰기</a>
					<ul id=pagination>
					<% 
						int startPage = (Integer.parseInt(pageNumber) / 10) * 10 + 1;
						if (Integer.parseInt(pageNumber) % 10 == 0) startPage -= 10;
						int targetPage = new ApvDAO().targetPage(pageNumber);
						if (startPage != 1) {
					%>
						<li><a href="apvView.jsp?pageNumber=<%= startPage - 1 %>"><i class="fas fa-angle-left"></i></a></li>
					<%
						} else {
					%>
						<li><i class="fas fa-angle-left"></i></li>
					<%
						}
						for (int i=startPage; i<Integer.parseInt(pageNumber); i++) {
					%>
						<li><a href="apvView.jsp?pageNumber=<%= i %>"><%= i %></a></li>
					<%
						}
					%>
						<li class="active"><a href="apvView.jsp?pageNumber=<%= pageNumber %>"><%= pageNumber %></a></li>	
					<%
						for (int i=Integer.parseInt(pageNumber) + 1; i<=targetPage + Integer.parseInt(pageNumber); i++) {
							if (i < startPage + 10) {
					%>
						<li><a href="apvView.jsp?pageNumber=<%= i %>"><%= i %></a></li>
					<%
							}
						}
						if (targetPage + Integer.parseInt(pageNumber) > startPage + 9) {
					%>
						<li><a href="apvView.jsp?pageNumber=<%= startPage + 10 %>"><i class="fas fa-angle-right"></i></a></li>
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