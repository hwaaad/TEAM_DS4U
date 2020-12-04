<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="education.EducationDAO" %>
<%@ page import="education.EducationDTO" %>
<%@ include file="/head.jsp" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<%
	String STF_ID = null;
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
	String EDUCATION_SQ = null;
	if (request.getParameter("EDUCATION_SQ") != null) {
		EDUCATION_SQ = (String) request.getParameter("EDUCATION_SQ");
	}
	if (EDUCATION_SQ == null || EDUCATION_SQ.equals("")) {
		session.setAttribute("messageType", "오류 메시지");
		session.setAttribute("messageContent", "게시물을 선택해주세요.");
		response.sendRedirect("index.jsp");
		return;	
	}
	EducationDAO educationDAO = new EducationDAO();
	EducationDTO education = educationDAO.getEducation(EDUCATION_SQ);
	if (education.getEDUCATION_AVAILABLE() == 0) {
		session.setAttribute("messageType", "오류 메시지");
		session.setAttribute("messageContent", "삭제된 게시물입니다.");
		response.sendRedirect("educationView.jsp");
		return;	
	}
	educationDAO.hit(EDUCATION_SQ);
	StfDTO stf = new StfDAO().getUser(STF_ID);
%>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/headerWs.css"/>
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/navWs.css"/>
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/board.css"/>
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/modal.css"/>
	<title>서울교통공사</title>
	<script src="js/bootstrap.js"></script>
	<script src="${contextPath}/lib/ckeditor4/ckeditor.js"></script>
</head>
<body>
	<%@ include file="/headerWs.jsp" %>
	<%@ include file="/navWs.jsp" %>
	<%@ include file="/modal.jsp" %>
	
	<div id="wsBody">
	<input type="hidden" value="board" id="pageType">
		<div id="wsBodyContainer">
		
			<h3>교육자료 게시판</h3>
			<h4>교육자료 상세보기</h4>
			<div id="boardInner">
				<div id="boardDetail">
					<div class="row">
						<h5 id="title">
							<span>교육자료 제목</span>
							<span class="bold"><%= education.getEDUCATION_NM() %></span>
						</h5>
					</div>
					<div class="row clearFix">
						<div class="floatleft">
							<span>작성자</span>
							<span class="bold"><%= education.getSTF_ID() %></span>
						</div>
						<div class="floatleft">
							<span>조회수</span> 
							<span class="bold"><%= education.getEDUCATION_HIT() + 1 %></span>
						</div>
						
						<div class="floatleft">
							<span>작성일</span>
							<span class="bold"><%= education.getEDUCATION_DT() %></span>
						</div>
					</div>
					<div id="content" class="row">
						<pre><%= education.getEDUCATION_TXT() %></pre>
					</div>
					<div class="row">
						<p>
							<i class="fas fa-save"></i>
							<a href="educationDownload.jsp?EDUCATION_SQ=<%= education.getEDUCATION_SQ() %>"><%= education.getEDUCATION_FILE() %></a>
						</p>
					</div>
					<div class="row btns">
						
							<a href="educationView.jsp" class="btn">목록</a>
						<%
							
						%>
						
						<%
							if (STF_ID.equals(education.getSTF_ID())) {								
						%>
							<a href="educationUpdate.jsp?EDUCATION_SQ=<%= education.getEDUCATION_SQ() %>" class="btn">수정</a>
							<a href="educationDelete?EDUCATION_SQ=<%= education.getEDUCATION_SQ() %>" class="btn" onclick="return confirm('정말로 삭제하시겠습니까?');">삭제</a>
						<%		
							}
						%>						
					</div>
				</div>
				
</body>
</html>