<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/head.jsp" %>
<!DOCTYPE html>
<html>
<%
	String STF_ID = null;
	if (session.getAttribute("STF_ID") != null) {
		STF_ID = (String) session.getAttribute("STF_ID");
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
								<h3 style='font-weight: bolder; font-size: 30px'>이메일 인증</h3>
									<div class="alert" role="alert">
										이메일 주소 인증이 필요합니다.
									</div>
									
							</div>
						</div>
						<div class="content flex">						
							<div id="joinBtnInLoginForm">
								<input type="button" value="인증메일 다시 받기" class="loginFormButton" onclick="location.href='${contextPath}/emailSend.jsp'">
							</div>
							<div id="joinBtnInLoginForm">
								<input type="button" value="돌아가기" class="loginFormButton" onclick="location.href='${contextPath}/index.jsp'">
							</div>
						</div>						
					</div>
				</div>
			</section>
		</div>
	</div>
					
</body>
</html>