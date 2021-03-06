<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="apv.ApvDAO" %>
<%@ page import="apv.ApvDTO" %>
<%@ include file="/head.jsp" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
	String APV_SQ = null;
	if (request.getParameter("APV_SQ") != null) {
		APV_SQ = (String) request.getParameter("APV_SQ");
	}
	if (APV_SQ == null || APV_SQ.equals("")) {
		session.setAttribute("messageType", "오류 메시지");
		session.setAttribute("messageContent", "게시물을 선택해주세요.");
		response.sendRedirect("index.jsp");
		return;	
	}
	StfDTO stf = new StfDAO().getUser(STF_ID);
	ApvDAO apvDAO = new ApvDAO();
	ApvDTO apv = apvDAO.getApv(APV_SQ);
	String APV_FILE = null;
%>

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/headerWs.css"/>
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/navWs.css"/>
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/apv.css"/>
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
		
			<h3>정보화 사업</h3>
			<h4>정보화 사업 상세보기</h4>
			<div id="boardInner">
				<div id="boardDetail">
				<div class="container">
					<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
						<tbody>
							<tr>
								<th style="width: 1000px; background-color: #EAEAEA !important; margin: 0 auto" colspan="3" ><h4>정보화 사업 상세보기</h4></th>
							</tr>
							<tr>
								<td style="width: 120px; font-weight: 600; background-color: #EAEAEA !important;"><h5>사업명</h5></td>
								<td style="width: 1000px; text-align: center;" colspan="3"><h5><%= apv.getAPV_NM() %></h5></td>
							</tr>				
							<tr>
								<td style="width: 120px; font-weight: 600; background-color: #EAEAEA !important; border-top: 1px solid #E0E0E0; border-bottom: 1px solid #E0E0E0;"><h5>사업기간</h5></td>
								<td style="width: 1000px; text-align: center;" colspan="3"><h5><%= apv.getAPV_DATE() %></h5></td>
							</tr>
							<tr>
								<td style="width: 120px; font-weight: 600; background-color: #EAEAEA !important;"><h5>사업시작일</h5></td>
								<td style="width: 1000px; text-align: center;" colspan="3"><h5><%= apv.getAPV_STT_DATE() %></h5></td>
							</tr>
							<tr>
								<td style="width: 120px; font-weight: 600; background-color: #EAEAEA !important;"><h5>사업종료일</h5></td>
								<td style="width: 1000px; text-align: center;" colspan="3"><h5><%= apv.getAPV_FIN_DATE() %></h5></td>
							</tr>
							<tr>
								<td style="width: 120px; font-weight: 600; background-color: #EAEAEA !important;"><h5>소요예산</h5></td>
								<td style="width: 1000px; text-align: center;" colspan="3"><h5><%= apv.getAPV_BUDGET() %></h5></td>
							</tr>
							<tr>
								<td style="width: 120px; font-weight: 600; background-color: #EAEAEA !important;"><h5>사업담당자</h5></td>
								<td style="width: 1000px; text-align: center;" colspan="3">
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
					           	 				STF_NM = rs.getString("STF_NM");
							           		%>
						         				  <h5><%= STF_NM %></h5></td>
						            		<%
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
									 %>
						
								</td>
							</tr>
							<tr>
								<td style="width: 120px; font-weight: 600; background-color: #EAEAEA !important;"><h5>연락처</h5></td>
								<td style="width: 1000px; text-align: center;" colspan="3"><h5><%= apv.getAPV_PHONE() %></h5></td>
							</tr>
							<tr>
								<td style="width: 120px; font-weight: 600; background-color: #EAEAEA !important;"><h5>사업방침번호</h5></td>
								<td style="width: 1000px; text-align: center;" colspan="3"><h5><%= apv.getAPV_POLICY_SQ() %></h5></td>
							</tr>
							<tr>
								<td style="width: 120px; font-weight: 600; background-color: #EAEAEA !important;"><h5>사업방침<br>첨부파일</h5></td>
								<td style="width: 1000px; text-align: center;" colspan="3">
								<% 
								
						    	try{
						    		
						    		conn = dataSource.getConnection();
						    		String SQL = "SELECT APV_FILE_SQ, APV_FILE, APV_UPLOAD_TIME FROM APV_FILE WHERE APV_SQ = ?";
					           		pstmt = conn.prepareStatement(SQL);
					           		pstmt.setInt(1, apv.getAPV_SQ());
					           		rs = pstmt.executeQuery();
					           		int i=0;
					           	 	while (rs.next()) {
						            	
					           	 		APV_FILE = rs.getString("APV_FILE").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>");
						            	int APV_FILE_SQ = rs.getInt("APV_FILE_SQ");
						            	String APV_UPLOAD_TIME = rs.getString("APV_UPLOAD_TIME").substring(0, 11);
						            			%><a href="apvDownload.jsp?APV_FILE_SQ=<%= APV_FILE_SQ %>">
								
						           파일번호 <%= ++i %> : <%= APV_FILE %> (등록 날짜 : <%= APV_UPLOAD_TIME %>)</a><br>
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
								<td style="width: 1000px; text-align: right;" colspan="3">
									<a href="apvView.jsp" class="btn btn-primary pull right">목록</a>
									
									<%
										if (STF_ID.equals(apv.getSTF_ID())) {								
									%>
									
										<a href="apvUpdate.jsp?APV_SQ=<%= apv.getAPV_SQ() %>" class="btn">수정</a>
									<%		
										}
									%>												
									</div>	
								</td>
						</tbody>
					</table>
				</div>		
				</div>
			</div>
		</div>
	</div>      
</body>
</html>