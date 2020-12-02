<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="stf.StfDTO" %>
<%@ page import="stf.StfDAO" %>
<%@ page import="apv.ApvDAO" %>
<%@ page import="apv.ApvDTO" %>
<%@page import="req.ReqDTO"%>
<%@page import="req.ReqDAO"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.Context" %>

<%@ include file="head.jsp" %>
<!DOCTYPE html>

<!-- //보안성검토 의뢰 수정 -->
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
	 	String APV_SQ = request.getParameter("APV_SQ");
	   	// String REQ_SQ = request.getParameter("REQ_SQ");
	   	String REQ_SQ = null;
		if (request.getParameter("REQ_SQ") != null) {
			REQ_SQ = (String) request.getParameter("REQ_SQ");
		}
	   if (REQ_SQ == null || REQ_SQ.equals("")) {
	      session.setAttribute("messageType", "오류 메시지");
	      session.setAttribute("messageContent", "접근할 수 없습니다.");
	      response.sendRedirect("index.jsp");
	      return;   
	   }
	   //글 작성자만 글 수정 가능함
	ReqDAO reqDAO = new ReqDAO();
	ReqDTO req = new ReqDAO().getReq(REQ_SQ);
	ApvDTO apv = new ApvDAO().getApv(APV_SQ);

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
		<div id="wsBodyContainer">
			<h3>보안성 검토</h3>
			<h4>새 보안성 검토 의뢰 수정</h4>
			<div id="boardInner">
				<div id="inputWrap">
				<div class="container">
					<form method="post" action="./reqUpdate" enctype="multipart/form-data">
					<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
				<thead></thead>

				<tbody>
					<tr>
						<td style="width: 130px; text-align: left;"><h5>1. 사업명</h5></td>
							<td><h5><%=req.getAPV_NM() %></h5>
						<input type="hidden"  name="APV_NM" value="<%= req.getAPV_NM() %>" ><input type="hidden"  name="APV_SQ" value="<%=req.getAPV_SQ() %>">
						 <input type="hidden" name="REQ_SQ" value="<%= req.getREQ_SQ() %>"></td>
							
					</tr>
					<tr>
						<td style="width: 130px; text-align: left;"><h5>2. 추진 목적</h5></td>
						<td><textarea class="form-control" cols="100" rows="5" name="APV_OBJ" id="APV_OBJ" maxlength="600" placeholder="추진 목적을 입력하세요."><%= req.getAPV_OBJ() %></textarea></td>			
					</tr>		
					<tr>
						<td style="width: 130px; text-align: left;"><h5>3. 사업 내용</h5></td>
						<td><textarea class="form-control" cols="100" rows="10" name="APV_CONT" id="APV_CONT" maxlength="1000" placeholder="사업 내용을 입력하세요."><%= req.getAPV_OBJ() %></textarea>
						<input type="hidden" name="APV_DATE" value="<%=apv.getAPV_DATE() %>"></td>	
					</tr>				
					<tr>
						<td style="width: 130px; text-align: left;"><h5>4. 담당자</h5></td>
						<td><h5><%= stf.getSTF_NM() %></h5>
						<input type="hidden" name="STF_NM" value="<%= stf.getSTF_NM() %>">	
						<input type="hidden" name="STF_ID" value="<%= stf.getSTF_ID() %>"></td>						
					</tr>
					<tr>
						<td style="width: 130px;text-align: left;"><h5>5. 연락처</h5></td>
						<td><h5><%=stf.getSTF_PH() %></h5>
						<input type="hidden" name="APV_PHONE" value="<%=stf.getSTF_PH() %>"></td>													
					</tr>
					<tr>
						<td style="width: 130px;text-align: left;"><h5>6. 보안성 검토의뢰 <br> &nbsp&nbsp&nbsp&nbsp&nbsp파일 첨부</h5></td>
						<td colspan="2">
							<div id="uploadArea" class="floatleft">
								<span>파일을 업로드하세요.</span>
								<input multiple="multiple" id="file" type="file" name="REQ_FILE" class="file">
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
					<tr>
						<td style="text-align: right;" colspan="2"><input class="btn" type="submit" value="등록"><a a class="btn" type="submit" href="reqView.jsp">취소</a></td>	
					</tr>																														
				</tbody>
			</table>			
		</form>
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