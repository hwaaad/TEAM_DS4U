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
	<link rel="stylesheet" type="text/css" href="css/headerWs.css"/>
	<link rel="stylesheet" type="text/css" href="css/navWs.css"/>
	<link rel="stylesheet" type="text/css" href="css/myPage.css"/>
	<link rel="stylesheet" type="text/css" href="css/modal.css"/>
	<title>서울교통공사</title>
	<script src="js/bootstrap.js"></script>
</head>

<body>
	<%@ include file="/headerWs.jsp"%>
	<%@ include file="/navWs.jsp"%>
	<%@ include file="/modal.jsp" %>
	
	<div id="wsBody">
		<div id="wsBodyContainer">
			<h3>마이페이지</h3>
			<h4>부서 수정</h4>
			<div class="myPageInner">
				<div class ="myPageModify">
				<p>부서를 변경해주세요!</p>
				<form method="post" action="./depUpdate">
					<input type="hidden" name="STF_ID" value="<%= stf.getSTF_ID() %>">									
					<div class="row btns">
						<button class="btn" name="STF_DEP" value="부서1" <% if(stf.getSTF_DEP().equals("부서1")) out.print("checked"); %>>부서1</button>											
						<button class="btn" name="STF_DEP" value="부서2" <% if(stf.getSTF_DEP().equals("부서2")) out.print("checked"); %>>부서2</button>											
						<button class="btn" name="STF_DEP" value="부서3" <% if(stf.getSTF_DEP().equals("부서3")) out.print("checked"); %>>부서3</button>																											
					</div>
						<div class="row btns">
							<button class="btn" type="submit">수정</button>
							<a href="myPage.jsp" class="btn">취소</a>
						</div>
				</form>
			</div><!-- myPageInner -->
		</div>
	</div>
</div>	
</body>
</html>