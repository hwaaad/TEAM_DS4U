<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="req.ReqDAO" %>
<%@ page import="req.ReqDTO" %>
<%@ page import="apv.ApvDAO" %>
<%@ page import="apv.ApvDTO" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.Context" %>
<%@ include file="/head.jsp" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<%

	String APV_SQ = null;
	String STF_ID = null;
	String STF_NM = null;
	String STF_PH = null;
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
	String REQ_SQ = null;
	if (request.getParameter("REQ_SQ") != null) {
		REQ_SQ = (String) request.getParameter("REQ_SQ");
	}
	if (REQ_SQ == null || REQ_SQ.equals("")) {
		session.setAttribute("messageType", "오류 메시지");
		session.setAttribute("messageContent", "게시물을 선택해주세요.");
		response.sendRedirect("index.jsp");
		return;	
	}
	
	ReqDAO reqDAO = new ReqDAO();
	ReqDTO req = reqDAO.getReq(REQ_SQ);
	
	ApvDAO apvDAO = new ApvDAO();
	ApvDTO apv = apvDAO.getApv(APV_SQ);
%>

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/headerWs.css"/>
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/navWs.css"/>
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/req.css"/>
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/modal.css"/>
	<title>서울교통공사</title>
	<script src="js/bootstrap.js"></script>
</head>

<body>
 	<%@ include file="/headerWs.jsp" %>
	<%@ include file="/navWs.jsp" %>
	<%@ include file="/modal.jsp" %>
	
	<div id="wsBody">
	<input type="hidden" value="board" id="pageType">
		<div id="wsBodyContainer">
		
			<h3>보안성 검토</h3>
			<h4>보안성 검토 의뢰 상세보기</h4>
			<div id="boardInner">
				<div id="boardDetail">
				<div class="container">
					<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
						<thead>
							<tr>
								<th colspan="2"><h4></h4></th>
							</tr>
							<tr>
								<td style="background-color: #fafafa; color: #000000; width: 120px; "><h5>사업명</h5></td>
								<td style="width: 800px;" colspan="2"><h5><%= req.getAPV_NM() %></h5></td>
							</tr>				
							<tr>
								<td style="background-color: #fafafa; color: #000000; width: 120px;"><h5>추진 목적</h5></td>
								<td colspan="2"><h5><%= req.getAPV_OBJ() %></h5></td>
							</tr>
							<tr>
								<td style="background-color: #fafafa; color: #000000; width: 120px;"><h5>사업 내용</h5></td>
								<td colspan="2"><h5><%= req.getAPV_CONT() %></h5></td>
							</tr>
							<tr>
								<td style="background-color: #fafafa; color: #000000; width: 120px;"><h5>사업 기간</h5></td>
								<td colspan="2"><h5><%= req.getAPV_DATE() %></h5></td>
							</tr>
							<tr>
								<td style="background-color: #fafafa; color: #000000; width: 120px;"><h5>사업담당자</h5></td>
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
							</tr>
							<tr>
								<td style="background-color: #fafafa; color: #000000; width: 120px;"><h5>연락처</h5></td>
								<td>
								<%
								try{
						    		
						    		conn = dataSource.getConnection();
						    		String SQL = "SELECT STF_PH FROM STF WHERE STF_ID = ?";
					           		pstmt = conn.prepareStatement(SQL);
					           		pstmt.setString(1, req.getSTF_ID());
					           		rs = pstmt.executeQuery();
					           		
					           	 	while (rs.next()) {
						            	
					           	 		STF_PH = rs.getString("STF_PH").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>");
						            	
						            	
						            	%>
						           <%= STF_PH %>
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
							</tr>
							<tr>
								<td style="background-color: #fafafa; color: #000000; width: 120px;"><h5>검토 요청일</h5></td>
								<td colspan="2"><h5><%= req.getREQ_DATE() %></h5></td>
							</tr>
							<tr>
								<td style="background-color: #fafafa; color: #000000; width: 120px;"><h5>회신일</h5></td>
								<td colspan="2"><h5><%= req.getREQ_REC_DATE() %></h5></td>
							</tr>
							<tr>
								<td style="background-color: #fafafa; color: #000000; width: 120px;"><h5>보안점검표 제출일</h5></td>
								<td colspan="2"><h5><%= req.getREQ_SUB_DATE() %></h5></td>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td colspan="5" style="text-align : right;">
									<%
									if(req.getREQ_STATE()==3){ %>
									<a href="fin_reqView.jsp" class="btn btn-primary">목록</a>
									<%
									}else{
									%>
									<a href="reqView.jsp" class="btn btn-primary">목록</a>
									<% } %>
									
									<%
								if (STF_ID.equals(req.getSTF_ID())) {								
							%>
							
								<a href="reqUpdate.jsp?REQ_SQ=<%= req.getREQ_SQ() %>" class="btn">수정</a>
								<a href="reqDelete?REQ_SQ=<%= req.getREQ_SQ() %>" class="btn" onclick="return confirm('정말로 삭제하시겠습니까?');">삭제</a>
							<%		
								}
							%>
								</td>
							</tr>			
						</tbody>
					
					</table>
				</div>	
		      
</body>
</html>