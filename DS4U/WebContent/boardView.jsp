<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="board.BoardDAO" %>
<%@ page import="board.BoardDTO" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="head.jsp" %>
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
	String pageNumber = "1";
	if (request.getParameter("pageNumber") != null) {
		pageNumber = request.getParameter("pageNumber");
	}
	try {
		Integer.parseInt(pageNumber);
	} catch (Exception e) {
		session.setAttribute("messageType", "오류 메시지");
		session.setAttribute("messageContent", "페이지 번호가 잘못되었습니다.");
		response.sendRedirect("boardView.jsp");
		return;			
	}
	ArrayList<BoardDTO> boardList = new BoardDAO().getList(pageNumber);
%>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"> 
	<!-- <link rel="stylesheet" href="css/bootstrap.css">
	<link rel="stylesheet" href="css/custom.css"> -->
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/headerWs.css"/>
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/navWs.css"/>
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/board.css"/>
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/modal.css"/>
	<title>서울교통공사</title>
	<script src="js/bootstrap.js"></script>
</head>

<body>
	<%@ include file="headerWs.jsp" %>
	<%@ include file="navWs.jsp" %>
	<div id="wsBody">
	<input type="hidden" value="board" id="pageType">
		<div id="wsBodyContainer">
			<h3>자유게시판</h3>
			<div id="boardInner">
				<ul id="boardList">
					<li id="listHead">
						<div>No.</div>
						<div>제목</div>
						<div>작성자</div>
						<div>작성일</div>
						<div>조회수</div>
					</li>			
			<table class="table" style="text-align: center; border: 1px solid #dddddd">
			<tbody>		

			<%
				for (int i=0; i<boardList.size(); i++) {
					BoardDTO board = boardList.get(i);
			%>
					<tr>
						<td><%= board.getBOARD_SQ() %></td>
						<td style="text-align: left;">
						<a href="boardShow.jsp?BOARD_SQ=<%= board.getBOARD_SQ() %>">
			<%
				for (int j=0; j<board.getBOARD_LEVEL(); j++) {
			%>
					<span class="fas fa-angle-right" aria-hidden="true"></span>
			<% 
				}
			%>
			<%
				if (board.getBOARD_AVAILABLE() == 0) {
			%>
				(삭제된 게시물입니다.)
			<%
				} else {
			%>
				<%= board.getBOARD_NM() %>
			<%
				}
			%>
				</a></td>
					<td><%= board.getSTF_ID() %></td>
					<td><%= board.getBOARD_DT() %></td>
					<td><%= board.getBOARDHIT() %></td>

			<%
				}
			%>					
				<tr>
					<td colspan="5">
						<a href="${contextPath}/boardWrite.jsp" id="writeBtn">글쓰기</a>
					<ul id=pagination>
					<% 
						int startPage = (Integer.parseInt(pageNumber) / 10) * 10 + 1;
						if (Integer.parseInt(pageNumber) % 10 == 0) startPage -= 10;
						int targetPage = new BoardDAO().targetPage(pageNumber);
						if (startPage != 1) {
					%>
						<li><a href="boardView.jsp?pageNumber=<%= startPage - 1 %>"><i class="fas fa-angle-left"></i></a></li>
					<%
						} else {
					%>
						<li><i class="fas fa-angle-left"></i></li>
					<%
						}
						for (int i=startPage; i<Integer.parseInt(pageNumber); i++) {
					%>
						<li><a href="boardView.jsp?pageNumber=<%= i %>"><%= i %></a></li>
					<%
						}
					%>
						<li class="active"><a href="boardView.jsp?pageNumber=<%= pageNumber %>"><%= pageNumber %></a></li>	
					<%
						for (int i=Integer.parseInt(pageNumber) + 1; i<=targetPage + Integer.parseInt(pageNumber); i++) {
							if (i < startPage + 10) {
					%>
						<li><a href="boardView.jsp?pageNumber=<%= i %>"><%= i %></a></li>
					<%
							}
						}
						if (targetPage + Integer.parseInt(pageNumber) > startPage + 9) {
					%>
						<li><a href="boardView.jsp?pageNumber=<%= startPage + 10 %>"><i class="fas fa-angle-right"></i></a></li>
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
		</div>
	</div>

	<%
		String messageContent = null;
		if (session.getAttribute("messageContent") != null) {
			messageContent = (String) session.getAttribute("messageContent");
		}
		String messageType = null;
		if (session.getAttribute("messageType") != null) {
			messageType = (String) session.getAttribute("messageType");
		}
		if (messageContent != null) {
	%>
	
	<div class="modal fade" id="messageModal" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="vertical-alignment-helper">
			<div class="modal-dialog vertical-align-center">
				<div class="modal-content <% if(messageType.equals("오류 메시지")) out.println("panel-warning"); else out.println("panel-success");%>">
					<div class="modal-header panel-heading">
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&times</span>
							<span class="sr-only">Close</span>
						</button>
						<h4 class="modal-title">
							<%= messageType %>
						</h4>
					</div>
					<div class="modal-body">
						<%= messageContent %>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-primary" data-dismiss="modal">확인</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%
		session.removeAttribute("messageContent");
		session.removeAttribute("messageType");
		}
	%>	   
	<script>
		$('#messageModal').modal("show");
	</script>	      
</body>
</html>