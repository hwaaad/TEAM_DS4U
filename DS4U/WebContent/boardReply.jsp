<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="stf.StfDTO" %>
<%@ page import="stf.StfDAO" %>
<%@ include file="/head.jsp" %>
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
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	DataSource dataSource;
	InitialContext initContext = new InitialContext();
	Context envContext = (Context) initContext.lookup("java:/comp/env");
	dataSource = (DataSource) envContext.lookup("jdbc/DS4U");
	try {
		conn = dataSource.getConnection();
		String SQL = "SELECT STF_DEP FROM STF WHERE STF_ID = ?";
		pstmt = conn.prepareStatement(SQL);
		pstmt.setString(1, STF_ID);
		rs = pstmt.executeQuery();
		while (rs.next()) {
        	
   	 		STF_DEP = rs.getString("STF_DEP").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>");
        	
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
			<h4>답변하기</h4>
			<div id="boardInner">
				<div id="inputWrap">
				<div class="container">
					<form method="post" action="./boardReply" enctype="multipart/form-data">
					<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
						<thead>
							<tr>
								<th colspan="3"><h4>답변 작성</h4></th>
							</tr>						
						</thead>
						<tbody>
						<tr>
							<td style="width: 110px;"><h5>아이디</h5></td>
							<td style="width: 830px;"><h5><%= stf.getSTF_ID() %></h5><input type="hidden" name="STF_ID" value="<%= stf.getSTF_ID() %>">
							<input type="hidden" name="BOARD_SQ" value="<%= BOARD_SQ %>"></td>						
						</tr>
						<tr>
							<td style="width: 110px;"><h5>글 종류</h5></td>
							<td style="width: 830px;">
								<select id="BOARD_TYPE" name="BOARD_TYPE">
								<% 
									if (STF_DEP.equals("부서4")){
								%>
									<option value="일반">일반</option>
								<%
									} else {
								%>
									<option value="일반">일반</option>
								<%
									}
								%>
								</select>
							</td>
						</tr>								
						<tr>
							<td style="width: 110px;"><h5>글 제목</h5></td>
							<td style="width: 830px;"><textarea id="title" cols="110" maxlength="64" name="BOARD_NM" placeholder="글 제목을 입력하세요."></textarea></td>							
						</tr>
						<tr>
							<td style="width: 110px;"><h5>글 내용</h5></td>
							<td style="width: 830px;"><textarea class="form-control" cols="110" rows="10" id="content" name="BOARD_TXT" maxlength="255" placeholder="글 내용을 입력하세요."></textarea></td>					
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
								<input class="btn" type="submit" value="등록" onclick="return confirm('답변 작성을 완료하시겠습니까?');">
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