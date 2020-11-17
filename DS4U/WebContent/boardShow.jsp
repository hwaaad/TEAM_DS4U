<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="board.BoardDAO" %>
<%@ page import="board.BoardDTO" %>
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
	String BOARD_SQ = null;
	if (request.getParameter("BOARD_SQ") != null) {
		BOARD_SQ = (String) request.getParameter("BOARD_SQ");
	}
	if (BOARD_SQ == null || BOARD_SQ.equals("")) {
		session.setAttribute("messageType", "오류 메시지");
		session.setAttribute("messageContent", "게시물을 선택해주세요.");
		response.sendRedirect("index.jsp");
		return;	
	}
	BoardDAO boardDAO = new BoardDAO();
	BoardDTO board = boardDAO.getBoard(BOARD_SQ);
	if (board.getBOARD_AVAILABLE() == 0) {
		session.setAttribute("messageType", "오류 메시지");
		session.setAttribute("messageContent", "삭제된 게시물입니다.");
		response.sendRedirect("boardView.jsp");
		return;	
	}
	boardDAO.hit(BOARD_SQ);
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
		
			<h3>자유게시판</h3>
			<h4>게시글 상세보기</h4>
			<div id="boardInner">
				<div id="boardDetail">
					<div class="row">
						<h5 id="title">
							<span>제목</span>
							<span class="bold"><%= board.getBOARD_NM() %></span>
						</h5>
					</div>
					<div class="row clearFix">
						<div class="floatleft">
							<span>작성자</span>
							<span class="bold"><%= board.getSTF_ID() %></span>
						</div>
						<div class="floatleft">
							<span>조회수</span> 
							<span class="bold"><%= board.getBOARDHIT() + 1 %></span>
						</div>
						<div class="floatleft">
							<span>작성일</span>
							<span class="bold"><%= board.getBOARD_DT() %></span>
						</div>
					</div>
					<div id="content" class="row">
						<pre><%= board.getBOARD_TXT() %></pre>
					</div>
					<div class="row">
						<p>
							<i class="fas fa-save"></i>
							<a href="boardDownload.jsp?BOARD_SQ=<%= board.getBOARD_SQ() %>"><%= board.getBOARD_FILE() %></a>
						</p>
					</div>
					<div class="row btns">
						<a href="boardView.jsp" class="btn">목록</a>
						<a href="boardReply.jsp?BOARD_SQ=<%= board.getBOARD_SQ() %>" class="btn btn-primary">답변</a>
						<%
							if (STF_ID.equals(board.getSTF_ID())) {								
						%>
							<a href="boardUpdate.jsp?BOARD_SQ=<%= board.getBOARD_SQ() %>" class="btn">수정</a>
							<a href="boardDelete?BOARD_SQ=<%= board.getBOARD_SQ() %>" class="btn" onclick="return confirm('정말로 삭제하시겠습니까?');">삭제</a>
						<%		
							}
						%>						
					</div>
				</div>
				<div id="boardReply">
					<h4>댓글</h4>
					<div id="replyWrap">
						<ul id="replyBox" class="clearFix">
							<li>댓글이 없습니다.</li>
						</ul>
						<form id="addReplyDiv">
							<div class="replyImg"><img src="${contextPath}/showProfileImg"></div>
							<div id="inputBox">
								<textarea rows="3" name="rContent"></textarea>
								<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
								<button class="btn" onclick="addReply(); return false;">댓글 등록</button>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
	
</body>
</html>