<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="stf.StfDTO" %>
<%@ page import="stf.StfDAO" %>
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
	StfDTO stf = new StfDAO().getUser(STF_ID);
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
	<script src="${contextPath}/lib/ckeditor4/ckeditor.js"></script>

</head>
<body>
	<%@ include file="/headerWs.jsp" %>
	<%@ include file="/navWs.jsp" %>
		
	<div id="wsBody">
		<div id="wsBodyContainer">
			<h3>자유게시판</h3>
			<h4>새 게시글 작성</h4>
			<div id="boardInner">
				<div id="inputWrap">
				<div class="container">
					<form method="post" action="./boardWrite" enctype="multipart/form-data">
					<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
						<thead></thead>
					<tbody>
						<tr>
							<td style="width: 110px;"><h5>아이디</h5></td>
							<td><h5><%= stf.getSTF_ID() %></h5>
							<input type="hidden" name="STF_ID" value="<%= stf.getSTF_ID() %>"></td>						
						</tr>
						<tr>
							<td style="width: 110px;"><h5>글 제목</h5></td>
							<td><textarea id="title" cols="100" maxlength="64" name="BOARD_NM" placeholder="글 제목을 입력하세요."></textarea></td>							
						</tr>
						<tr>
							<td style="width: 110px;"><h5>글 내용</h5></td>
							<td><textarea class="form-control" cols="100" rows="10" id="content" name="BOARD_TXT" maxlength="255" placeholder="글 내용을 입력하세요."></textarea></td>					
						</tr>
						<tr>
						<td style="width: 110px;"><h5>파일 첨부</h5></td>
						<td colspan="2">
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
							<td style="text-align: right;" colspan="2"><input class="btn" type="submit" value="등록"><a a class="btn" type="submit" href="boardView.jsp">취소</a></td>						
						</tr>																														
					</tbody>
				</table>
				</form>		
				</div>
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
	<script>
		$('#messageModal').modal("show");
	</script>		
	<%
		session.removeAttribute("messageContent");
		session.removeAttribute("messageType");
		}
	%>
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