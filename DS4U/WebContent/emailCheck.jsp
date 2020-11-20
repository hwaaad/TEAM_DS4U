<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="stf.StfDAO" %>
<%@ page import="util.SHA256" %>
<% 
	request.setCharacterEncoding("UTF-8");
	String code = null;
	if (request.getParameter("code") != null) {
		code = (String) request.getParameter("code");
	}
	StfDAO stfDAO = new StfDAO();
	String STF_ID = null;
	if (session.getAttribute("STF_ID") != null) {
		STF_ID = (String) session.getAttribute("STF_ID");
	}
	if (STF_ID == null) {
		session.setAttribute("messageType", "오류 메시지");
		session.setAttribute("messageContent", "로그인이 필요합니다.");
		response.sendRedirect("login.jsp");
		return;	
	}
	String STF_EML = stfDAO.getUserEmail(STF_ID);
	boolean isRight = (new SHA256().getSHA256(STF_EML).equals(code)) ? true : false;
	if (isRight == true) {
		stfDAO.setUserEmailChecked(STF_ID);
		session.setAttribute("messageType", "성공 메시지");
		session.setAttribute("messageContent", "인증에 성공했습니다.");
		response.sendRedirect("index.jsp");
		return;			
	}
	else {
		session.setAttribute("messageType", "오류 메시지");
		session.setAttribute("messageContent", "유효하지 않은 코드입니다.");
		response.sendRedirect("index.jsp");
		return;		
	}
%>