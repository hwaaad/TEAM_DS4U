<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/head.jsp" %>
<!DOCTYPE html>
<html>
<%
	String STF_ID = null;
	if (session.getAttribute("STF_ID") != null) {
		STF_ID = (String) session.getAttribute("STF_ID");
	}
	if (STF_ID != null) {
		session.setAttribute("messageType", "오류 메시지");
		session.setAttribute("messageContent", "이미 로그인 되어 있습니다.");
		response.sendRedirect("index.jsp");
		return;
	}
%>

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" type="text/css" href="css/headerMain.css"/>
	<link rel="stylesheet" type="text/css" href="css/footerMain.css"/>
	<link rel="stylesheet" type="text/css" href="css/animate.css"/>
	<link rel="stylesheet" type="text/css" href="css/login.css"/>
	<link rel="stylesheet" type="text/css" href="css/modal.css"/>
	<script src="js/bootstrap.js"></script>
	<title>서울교통공사</title>
</head>

<body>
	<%@ include file="/headerMain.jsp" %>
	<%@ include file="/modal.jsp" %>
	
	<div id="wrap">
		<div id="loginAll">
			<section>
				<div id="loginBox" class="animated fadeIn">
					<div class="header">
						<div class="inner-header flex">
							<div class="loginBox-Head">
								<h3 style='font-weight: bolder; font-size: 30px'>로그인</h3>
								<p>LOG IN</p>
							</div>
						</div>
					</div>
					<div class="content flex">
						<div class="loginBox-Body">
							<form action="./userLogin" method="post" id="loginForm">	
								<div>
									<h4>ID</h4>
									<input type="text" name="STF_ID" placeholder="아이디를 입력하세요." id="STF_ID" maxlength="10">
								</div>
								<div class="pwDiv">
									<h4>PASSWORD</h4>
									<input type="password" name="STF_PW" placeholder="비밀번호를 입력하세요." id="STF_PW" maxlength="20">
									<a class="pwForget" href='${contextPath}/pwReset.jsp'>비밀번호를 잊어버리셨나요?</a>
								</div>
								<div>
								</div>
								<div>
									<input type="submit" value="로그인" class="loginFormButton">
								</div>
								<div id="joinBtnInLoginForm">
									<input type="button" value="회원가입" class="loginFormButton" onclick="location.href='${contextPath}/join.jsp'">
								</div>
							</form>
						</div>
					</div>
				</div>
			</section>
		</div>
	</div>
					
</body>
</html>