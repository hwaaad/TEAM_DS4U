<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="stf.StfDAO" %>
<%@ page import="javax.mail.Transport" %>
<%@ page import="javax.mail.Message" %>
<%@ page import="javax.mail.Address" %>
<%@ page import="javax.mail.internet.InternetAddress" %>
<%@ page import="javax.mail.internet.MimeMessage" %>
<%@ page import="javax.mail.Session" %>
<%@ page import="javax.mail.Authenticator" %>
<%@ page import="util.SHA256" %>
<%@ page import="util.Gmail" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.util.Properties" %>
<% 
	StfDAO stfDAO = new StfDAO();
	String STF_ID = null;
	if (session.getAttribute("STF_ID") != null) {
		STF_ID = (String) session.getAttribute("STF_ID");
	}
	if (STF_ID == null) {
		session.setAttribute("messageType", "오류 메시지");
		session.setAttribute("messageContent", "로그인을 해주세요.");
		response.sendRedirect("login.jsp");
		return;
	}
	boolean emailChecked = stfDAO.getUserEmailChecked(STF_ID);
	if (emailChecked == true) {
		request.getSession().setAttribute("messageType", "오류 메시지");
		request.getSession().setAttribute("messageContent", "이미 인증된 회원입니다.");
		response.sendRedirect("index.jsp");
		return;
	}
	String host = "http://localhost:8080/DS4U/";
	String from = "xxx@gmail.com";
	String admin = "서울교통공사";
	String to = stfDAO.getUserEmail(STF_ID);
	String subject = "가입을 위한 인증 메일입니다.";
	String content = "해당 링크에 접속하여 이메일 인증을 진행하세요." +
			"<a href='" + host + "emailCheck.jsp?code=" + new SHA256().getSHA256(to) + "'>이메일 인증하기</a>";
	
	Properties p = new Properties();
	p.put("mail.smtp.user", admin);
	p.put("mail.smtp.host", "smtp.googlemail.com");
	p.put("mail.smtp.port", "465");
	p.put("mail.smtp.starttls.enable", "true");
	p.put("mail.smtp.auth", "true");
	p.put("mail.smtp.debug", "true");
	p.put("mail.smtp.socketFactory.port", "465");
	p.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
	p.put("mail.smtp.socketFactory.fallback", "false");
	
	try {
		Authenticator auth = new Gmail();
		Session ses = Session.getInstance(p, auth);
		ses.setDebug(true);
		MimeMessage msg = new MimeMessage(ses);
		msg.setSubject(subject);
		Address fromAddr = new InternetAddress(from, admin);
		msg.setFrom(fromAddr);
		Address toAddr = new InternetAddress(to);
		msg.addRecipient(Message.RecipientType.TO, toAddr);
		msg.setContent(content, "text/html;charset=UTF-8");
		Transport.send(msg);
	} catch (Exception e) {
		e.printStackTrace();
		request.getSession().setAttribute("messageType", "오류 메시지");
		request.getSession().setAttribute("messageContent", "오류가 발생했습니다.");
		response.sendRedirect("index.jsp");
		return;
	}

%>

<%@ include file="/head.jsp" %>
<!DOCTYPE html>
<html>
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
										이메일 인증 메일이 전송되었습니다.
									</div>
							</div>
						</div>
						<div class="content flex">						
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