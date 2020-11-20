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
	<link rel="stylesheet" type="text/css" href="css/main.css"/>
	<link rel="stylesheet" type="text/css" href="css/animate.css"/>
	<link rel="stylesheet" type="text/css" href="css/animationCheatSheet.css"/>
	<link rel="stylesheet" type="text/css" href="css/modal.css"/>
	<script src="js/bootstrap.js"></script>
	<title>서울교통공사</title>
</head>

<body>
	<%@ include file="/headerMain.jsp" %>
	<%@ include file="/modal.jsp" %>
		
	<div id="welcome">
		<section id="main-cover" class="box">
			<div class="container">
				<div class="text">
					<div class="head-body-up animated fadeInUp">.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;.</div>
					<div class="head-body-down animated fadeInUp">서울교통공사</div>
					<div class="head-title"><p class="animated fadeInUp">DS4U</p></div>
					<div class="head-caption animated fadeInUp">DS4U<br>정보화사업 보안성검토 Project</div>
				</div>
			</div>
		</section>
	</div>
		
	<div><%@ include file="/footerMain.jsp" %></div>

</body>
</html>