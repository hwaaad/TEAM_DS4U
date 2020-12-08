<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
	String STF_DEP = null;
	if(session.getAttribute("STF_ID") != null) {
		STF_ID = (String) session.getAttribute("STF_ID");
	}
	if (STF_ID == null) {
		session.setAttribute("messageType", "오류 메시지");
		session.setAttribute("messageContent", "로그인이 필요합니다.");
		response.sendRedirect("index.jsp");
		return;	
	}
	String REQ_SQ = null;
	if (request.getParameter("REQ_SQ") != null) {
		REQ_SQ = request.getParameter("REQ_SQ");
	}
	// int change_req_sq = Integer.parseInt(REQ_SQ);
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
	// String STF_DEP = (String) request.getAttribute("STF_DEP");
	if(!STF_DEP.equals("부서4")){
		
		session.setAttribute("messageType", "오류 메시지");
		session.setAttribute("messageContent", "권한이 없습니다.");
		response.sendRedirect("reqView.jsp");
		return;
		
	}
	ReqDTO req = new ReqDAO().getReq(REQ_SQ);
	StfDTO stf = new StfDAO().getUser(STF_ID);
%>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/headerWs.css"/>
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/navWs.css"/>
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/req.css"/>
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/modal.css"/>
	<title>보안성 검토 회신</title>
	<script src="js/bootstrap.js"></script>
	
</head>
<body>
<%@ include file="/headerWs.jsp" %>
	<%@ include file="/navWs.jsp" %>
	<div id="wsBody">
		<div id="wsBodyContainer">
			<h3>보안성 검토</h3>
			<h4>보안성 검토 회신 내용 등록</h4>
			<div id="boardInner">
				<div id="inputWrap">
				<div class="container">
					<form method="post" action="./reqRecWrite" enctype="multipart/form-data">
					<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
				<thead></thead>

				<tbody>
					<tr>
						<input type="hidden" name="REQ_SQ" value="<%= REQ_SQ %>">
						<td style="width: 130px; font-weight: 600; background-color: #EAEAEA !important; text-align: center;"><h5>1. 사업명</h5></td>
							<td style="width: 1000px; text-align: center;"> <%
								try {
									conn = dataSource.getConnection();
									String SQL = "SELECT REQ_SQ, APV_NM FROM REQ WHERE REQ_SQ = ?";
									pstmt = conn.prepareStatement(SQL);
									pstmt.setString(1, REQ_SQ);
									rs = pstmt.executeQuery();
									while (rs.next()) {
							        	// int REQ_SQ = rs.getInt("REQ_SQ");
							   	 		String APV_NM = rs.getString("APV_NM").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>");
							   	 		%> <input type="hidden" name="APV_NM" value="<%= APV_NM %>"><%= APV_NM %>
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
								} %>
							</td>	
					</tr>
					<tr>
						<td style="width: 130px; font-weight: 600; background-color: #EAEAEA !important; text-align: center;"><h5>2. 검토 내용</h5></td>
						<td style="width: 1000px;"><textarea class="form-control" cols="140" rows="5" name="REQ_REC_TXT" id="REQ_REC_TXT" maxlength="600" placeholder="검토 내용을 입력하세요."></textarea></td>			
					</tr>	
					<tr>	
						<td style="width: 130px; font-weight: 600; background-color: #EAEAEA !important; text-align: center;"><h5>3. 검토 결과</h5></td>
						<td style="width: 1000px; text-align: center;">
						<input type="radio" name="REQ_APPROVAL" autocomplete="off" value="승인" checked>승인 
						<input type="radio" name="REQ_APPROVAL" autocomplete="off" value="반려" checked>반려
						</td>
					</tr>	
					<tr>
						<td style="width: 130px; font-weight: 600; background-color: #EAEAEA !important;"><h5>4. 회신 담당자</h5></td>
						<td style="width: 1000px; text-align: center;"><h5><%= stf.getSTF_ID() %></h5>
						<input type="hidden" name="STF_ID" value="<%= stf.getSTF_ID() %>"></td>						
					</tr>
					<tr>
						<td style="width: 130px; font-weight: 600; background-color: #EAEAEA !important;"><h5>5. 파일 첨부</h5></td>
						<td colspan="2">
							<div id="uploadArea" class="floatleft">
								<span>파일을 업로드하세요.</span>
								<input multiple="multiple" id="file" type="file" name="REQ_REC_FILE" class="file">
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
</body>
</html>