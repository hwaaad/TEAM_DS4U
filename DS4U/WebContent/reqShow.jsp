<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="req.ReqDAO" %>
<%@ page import="req.ReqDTO" %>
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
	
	ReqDAO reqDAO = new ReqDAO();
	ReqDTO req = reqDAO.getReq(REQ_SQ);
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
							<tr>
								<th colspan="2"><h4></h4></th>
							</tr>
							<tr>
								<td style="background-color: #fafafa; color: #000000; width: 120px; "><h5>사업명</h5></td>
								<td style="width: 800px;" colspan="2"><h5><%= req.getAPV_NM() %></h5></td>
							</tr>				
							<tr>
								<td style="background-color: #fafafa; color: #000000; width: 120px;"><h5>추진 목적</h5></td>
								<td colspan="2"><h5><%= req.getAPV_OBJ() %></h5></td>
							</tr>
							<tr>
								<td style="background-color: #fafafa; color: #000000; width: 120px;"><h5>사업 내용</h5></td>
								<td colspan="2"><h5><%= req.getAPV_CONT() %></h5></td>
							</tr>
							<tr>
								<td style="background-color: #fafafa; color: #000000; width: 120px;"><h5>사업 기간</h5></td>
								<td colspan="2"><h5><%= req.getAPV_DATE() %></h5></td>
							</tr>
							<tr>
								<td style="background-color: #fafafa; color: #000000; width: 120px;"><h5>검토 요청일</h5></td>
								<td colspan="2"><h5><%= req.getREQ_DATE() %></h5></td>
							</tr>
							<tr>
								<td style="background-color: #fafafa; color: #000000; width: 120px;"><h5>회신일</h5></td>
								<td colspan="2"><h5><%= req.getREQ_REC_DATE() %></h5></td>
							</tr>
							<tr>
								<td style="background-color: #fafafa; color: #000000; width: 120px;"><h5>보안점검표 제출일</h5></td>
								<td colspan="2"><h5><%= req.getREQ_SUB_DATE() %></h5></td>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td colspan="5" style="text-align : right;">
									<a href="apvView.jsp" class="btn btn-primary">목록</a>
			
								</td>
							</tr>			
						</tbody>
					
					</table>
				</div>	
		      
</body>
</html>