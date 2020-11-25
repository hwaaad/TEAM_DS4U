<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="stf.StfDTO" %>
<%@ page import="stf.StfDAO" %>
<%@ page import="board.BoardDTO" %>
<%@ page import="board.BoardDAO" %>
<%@ include file="/head.jsp" %>
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
	StfDTO stf = new StfDAO().getUser(STF_ID);
	String BOARD_SQ = request.getParameter("BOARD_SQ");
	if (BOARD_SQ == null || BOARD_SQ.equals("")) {
		session.setAttribute("messageType", "오류 메시지");
		session.setAttribute("messageContent", "접근할 수 없습니다.");
		response.sendRedirect("index.jsp");
		return;	
	}
	// 글 작성자만 글 수정 가능
	BoardDAO boardDAO = new BoardDAO();
	BoardDTO board = boardDAO.getBoard(BOARD_SQ);
	if (!STF_ID.equals(board.getSTF_ID())) {
		session.setAttribute("messageType", "오류 메시지");
		session.setAttribute("messageContent", "권한이 없습니다.");
		response.sendRedirect("index.jsp");
		return;
	}
%>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/headerWs.css"/>
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/navWs.css"/>
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/board.css"/>
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/modal.css"/>
	<title>서울교통공사</title>
	<script src="${contextPath}/lib/ckeditor4/ckeditor.js"></script>
	<script src="js/bootstrap.js"></script>
</head>

<body>
	<%@ include file="/headerWs.jsp" %>
	<%@ include file="/navWs.jsp" %>
	<%@ include file="/modal.jsp" %>

	<div id="wsBody">
		<div id="wsBodyContainer">
			<h3>자유게시판</h3>
			<h4>게시글 수정</h4>
			<div id="boardInner">
				<div id="inputWrap">
				<div class="container">
					<form method="post" action="./boardUpdate" enctype="multipart/form-data">
						<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
							<thead>
								<tr>
									<th colspan="3"><h4>게시물 수정</h4></th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td style="width: 110px;"><h5>아이디</h5></td>
									<td style="width: 830px;"><h5><%= stf.getSTF_ID() %></h5><input type="hidden" name="STF_ID" value="<%= stf.getSTF_ID() %>"></td>
									<input type="hidden" name="BOARD_SQ" value="<%= BOARD_SQ %>">						
								</tr>
								<tr>
									<td style="width: 110px;"><h5>글 종류</h5></td>
									<td style="width: 830px;">
										<select id="boardType" name="BOARD_TYPE">
											<option value="일반">일반</option>
											<option value="공지">공지</option>
										</select>
									</td>
								</tr>	
								<tr>
									<td style="width: 110px;"><h5>글 제목</h5></td>
									<td style="width: 830px;"><textarea class="form-control" id="title" cols="100" maxlength="64" name="BOARD_NM" placeholder="글 제목을 입력하세요."><%= board.getBOARD_NM() %></textarea></td>						
								</tr>
								<tr>
									<td style="width: 110px;"><h5>글 내용</h5></td>
									<td style="width: 830px;"><textarea class="form-control" cols="100" rows="10" name="BOARD_TXT" maxlength="255" placeholder="글 내용을 입렵하세요."><%= board.getBOARD_TXT() %></textarea></td>					
								</tr>												
								<tr>
									<td style="width: 110px;"><h5>파일 첨부</h5></td>
									<td style="width: 830px;" colspan="2">
										<div id="uploadArea" class="floatleft">
											<span>파일을 업로드하세요.</span>
											<input multiple="multiple" id="file" type="file" name="BOARD_FILE" class="file">
										</div>
										<script type="text/javascript">
											$(function(){
												$("#file").change(function(){
													let $span = $("#uploadArea span");
													console.log(this.files);
													$span.empty();
													if(this.files.length>0){
														$span.addClass("on");
														$.each(this.files, function(idx,item){
															$span.append("파일 "+ (idx+1) +" : "+item.name+"<br/>");
														})
													} else {
														$span.removeClass("on");
														$span.text("파일을 업로드하세요.");
													}
												})
											})
										</script>
									</td>				
								</tr>	
								<tr>
									<td style="text-align: right;" colspan="2">
										<input class="btn" type="submit" value="수정">
										<a a class="btn" type="submit" href="boardView.jsp">취소</a>
									</td>						
								</tr>																														
							</tbody>
						</table>
					</form>
				</div>
				</div>
			</div>
		</div>
	</div>	
	<script type="text/javascript">
		$(document).on('click', '.browse', function() {
			var file = $(this).parent().parent().parent().find('.file');
			file.trigger('click');
		});
		$(document).on('change', '.file', function() {
			$(this).parent().find('.form-control').val($(this).val().replace(/C:\\fakepath\\/i, ''));
		});
	</script>        
</body>
</html>