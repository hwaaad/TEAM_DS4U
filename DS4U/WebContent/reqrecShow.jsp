<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="req.ReqRecDAO" %>
<%@ page import="req.ReqRecDTO" %>
<%@ page import="req.ReqDAO" %>
<%@ page import="req.ReqDTO" %>
<%@ include file="/head.jsp" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="java.util.ArrayList" %>
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
	String REQ_SQ = null;
	if (request.getParameter("REQ_SQ") != null) {
		REQ_SQ = (String) request.getParameter("REQ_SQ");
	}
	if (REQ_SQ == null || REQ_SQ.equals("")) {
		session.setAttribute("messageType", "오류 메시지");
		session.setAttribute("messageContent", "게시물을 선택해주세요.");
		response.sendRedirect("index.jsp");
		return;	
	}
	StfDTO stf = new StfDAO().getUser(STF_ID);
	ReqDAO reqDAO = new ReqDAO();
	ReqDTO req = reqDAO.getReq(REQ_SQ);
	ReqRecDAO reqrecDAO = new ReqRecDAO();
	ReqRecDTO reqrec = reqrecDAO.getReqRec(REQ_SQ);
	ArrayList<ReqRecDTO> reqrecList = new ReqRecDAO().getList(REQ_SQ);
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
	<input type="hidden" value="board" id="pageType">
		<div id="wsBodyContainer">
		
			<h3>보안성 검토</h3>
			<h4>보안성 검토 의뢰 상세보기</h4>
			<div id="boardInner">
				<div id="boardDetail">
				<div class="container">
					
					<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
						<thead>
							<%
				for (int i=0; i<reqrecList.size(); i++) {
					ReqRecDTO reqrec2 = reqrecList.get(i);
					
			%>
							<tr>
								<th colspan="2"><h4></h4></th>
							</tr>
							<tr>
								<td style="background-color: #fafafa; color: #000000; width: 120px; "><h5>사업명</h5></td>
								<td style="width: 800px;" colspan="2"><h5><%= reqrec2.getAPV_NM() %></h5></td>
							</tr>				
							<tr>
								<td style="background-color: #fafafa; color: #000000; width: 120px;"><h5>검토 내용</h5></td>
								<td colspan="2"><h5><%= reqrec2.getREQ_REC_TXT() %></h5></td>
							</tr>
							<tr>
								<td style="background-color: #fafafa; color: #000000; width: 120px;"><h5>검토 결과</h5></td>
								<td colspan="2"><h5><%= reqrec2.getREQ_APPROVAL() %></h5></td>
							</tr>
							<tr>
								<td style="background-color: #fafafa; color: #000000; width: 120px;"><h5>회신 담당자</h5></td>
								<td colspan="2"><h5><%= reqrec2.getSTF_ID() %></h5></td>
							</tr>
							<tr>
								<td style="background-color: #fafafa; color: #000000; width: 120px;"><h5>회신 날짜</h5></td>
								<td colspan="2"><h5><%= reqrec2.getREQ_REC_DATE() %></h5></td>
							</tr>
							<tr>
								<td style="background-color: #fafafa; color: #000000; width: 120px;"><h5>첨부파일</h5></td>
								<td colspan="2"><a href="reqrecDownload.jsp?REQ_REC_SQ=<%= reqrec2.getREQ_REC_SQ() %>"><%= reqrec2.getREQ_REC_FILE() %></a></td>
							</tr>
							<% }%>
						</thead>
						<tbody>
							<tr>
								<td colspan="5" style="text-align : right;">
								
									<a href="reqReciveWrite.jsp?REQ_SQ=<%= reqrec.getREQ_SQ() %>" class="btn btn-primary">회신 추가하기</a>
									<%
									if(req.getREQ_STATE()==3){ %>
									<a href="fin_reqView.jsp" class="btn btn-primary">목록</a>
									<%
									}else{
									%>
									<a href="reqView.jsp" class="btn btn-primary">목록</a>
									<% } %>
			
								</td>
							</tr>			
						</tbody>
					</table>
					
				</div>	
		      
</body>
</html>