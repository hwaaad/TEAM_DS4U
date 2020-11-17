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
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/headerWs.css"/>
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/navWs.css"/>
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/req.css"/>
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/modal.css"/>
	<title>서울교통공사</title>
	<script src="js/bootstrap.js"></script>
	
	 <script>
    function getSelectValue(frm)
   	 {
    	frm.APV_NM.value = frm.selectBox.options[frm.selectBox.selectedIndex].text;
    	frm.APV_SQ.value = frm.selectBox.options[frm.selectBox.selectedIndex].value;
   	 } <!-- selectBox에서 정보화사업 클릭시 해당 APV_SQ와 APV_NM을 가져옴-->
    </script>
    
    
</head>
<body>
	<%@ include file="/headerWs.jsp" %>
	<%@ include file="/navWs.jsp" %>
	<%@ include file="/modal.jsp" %>

 	<div id="wsBody">
		<div id="wsBodyContainer">
			<h3>보안성 검토</h3>
			<h4>새 보안성 검토 의뢰 등록</h4>
			<div id="boardInner">
				<div id="inputWrap">
				<div class="container">
					<form method="post" action="./reqWrite" enctype="multipart/form-data">
					<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
				<thead></thead>

				<tbody>
					<tr>
						<td style="width: 130px; text-align: left;"><h5>1. 사업명</h5></td>
							<td> <select name="selectBox" onChange="getSelectValue(this.form);">	
								<option value="" selected>===선택해주세요===</option>
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
						       
					           		String SQL = "SELECT APV_SQ, APV_NM FROM APV";
					           		pstmt = conn.prepareStatement(SQL);
					          		rs = pstmt.executeQuery();
					           
					            while (rs.next()) {
					            	
					          		int APV_SQ = rs.getInt("APV_SQ");
					            	String APV_NM = rs.getString("APV_NM").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>");
		    
					            	%>
					            		<option value=<%=APV_SQ%>><%=APV_NM%></option>
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
					
					
						</select>
						<input type="hidden"  name="APV_NM" ><input type="hidden"  name="APV_SQ" ></td>	
					</tr>
					<tr>
						<td style="width: 130px; text-align: left;"><h5>2. 추진 목적</h5></td>
						<td><textarea class="form-control" cols="100" rows="5" name="APV_OBJ" id="APV_OBJ" maxlength="600" placeholder="추진 목적을 입력하세요."></textarea></td>			
					</tr>		
					<tr>
						<td style="width: 130px; text-align: left;"><h5>3. 사업 내용</h5></td>
						<td><textarea class="form-control" cols="100" rows="10" name="APV_CONT" id="APV_CONT" maxlength="1000" placeholder="사업 내용을 입력하세요."></textarea></td>
					</tr>
					<tr>
						<td style="width: 130px; text-align: left;"><h5>4. 사업 기간</h5></td>
						<td><textarea class="form-control" cols="100" name="APV_DATE" id="APV_DATE" maxlength="100" placeholder="사업 기간을 입력하세요."></textarea></td>				
					</tr>				
					<tr>
						<td style="width: 130px;"><h5>5. 담당자</h5></td>
						<td><h5><%= stf.getSTF_ID() %></h5>
						<input type="hidden" name="STF_ID" value="<%= stf.getSTF_ID() %>"></td>						
					</tr>
					<tr>
						<td style="width: 130px;"><h5>6. 파일 첨부</h5></td>
						<td colspan="2">
							<div id="uploadArea" class="floatleft">
								<span>파일을 업로드하세요.</span>
								<input multiple="multiple" id="file" type="file" name="APV_FILE" class="file">
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