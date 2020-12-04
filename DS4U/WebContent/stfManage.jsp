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
	if (!STF_ID.equals("admin")) {
		session.setAttribute("messageType", "오류 메시지");
		session.setAttribute("messageContent", "접근 권한이 없습니다.");
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
	ArrayList<StfDTO> reqList = new StfDAO().getList();
	StfDTO stf = new StfDAO().getUser(STF_ID);
	
%>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"> 
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/headerWs.css"/>
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/navWs.css"/>
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/manage.css"/>
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
			<h3>전체 회원 정보</h3>
			<div id="boardInner">
				<ul id="boardList">
					<li id="listHead">
						<div>ID</div>
						<div>이름</div>
						<div>전화번호</div>
						<div>이메일</div>
						<div>부서</div>
						<div>프로필</div>
						<div>관리자 여부</div>
					</li>			
			<table class="table" style="text-align: center; border: 1px solid #dddddd">
			<tbody>
			<%
				for (int i=0; i<reqList.size(); i++) {
					StfDTO req = reqList.get(i);					
			%>
				<tr>
					<form method="post" action="./adminUpdate">
						<td><%= req.getSTF_ID() %><input type="hidden" name="STF_ID" value="<%= req.getSTF_ID() %>"></td>
						<td><%= req.getSTF_NM() %></td>
						<td><%= req.getSTF_PH() %></td>		
						<td><%= req.getSTF_EML() %></td>
						<td><%= req.getSTF_DEP() %></td>
						<td><%= req.getSTF_PF() %></td>
						<td>
						<% if (req.getSTF_DEP().equals("부서4")){ %>
							<input type="radio" name="STF_ADM" autocomplete="off" value="관리자" checked>관리자
							<input type="radio" name="STF_ADM" autocomplete="off" value="사원">사원
							<%
							}else{
							%>
							<input type="radio" name="STF_ADM" autocomplete="off" value="관리자">관리자
							<input type="radio" name="STF_ADM" autocomplete="off" value="사원" checked>사원
							<%
							}
							%>
						</td>
						<td>
						<button class="btn" type="submit">수정</button>
						</td>
					</form>
				</tr>
			<%
				}
			%>
				<tr>
					<td colspan="7">
						
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