<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="education.EducationDAO" %>
<%@ page import="education.EducationDTO" %>
<%@ page import="stf.StfDAO" %>
<%@ page import="stf.StfDTO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.net.URLEncoder" %>
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
	if (session.getAttribute("STF_ID") != null) {
		STF_ID = (String) session.getAttribute("STF_ID");
	}
	if (STF_ID == null) {
		session.setAttribute("messageType", "오류 메시지");
		session.setAttribute("messageContent", "로그인이 필요합니다.");
		response.sendRedirect("index.jsp");
		return;	
	}
	boolean emailChecked = new StfDAO().getUserEmailChecked(STF_ID);
	if (emailChecked == false) {
		session.setAttribute("messageType", "오류 메시지");
		session.setAttribute("messageContent", "이메일 인증이 필요합니다.");
		response.sendRedirect("emailSendConfirm.jsp");
		return;
	}
	String pageNumber = "1";
	if (request.getParameter("pageNumber") != null) {
		pageNumber = request.getParameter("pageNumber");
	}
	try {
		Integer.parseInt(pageNumber);
	} catch (Exception e) {
		session.setAttribute("messageType", "오류 메시지");
		session.setAttribute("messageContent", "페이지 번호가 잘못되었습니다.");
		response.sendRedirect("educationView.jsp");
		return;			
	}
	ArrayList<EducationDTO> educationList = new EducationDAO().getList(pageNumber);
	
	request.setCharacterEncoding("UTF-8");
	
	
	String searchType = "최신순";
	String search = "";
	int PageNumber = 1;

	if (request.getParameter("searchType") != null) {
		searchType = request.getParameter("searchType");
	}
	if (request.getParameter("search") != null) {
		search = request.getParameter("search");
	}
	if (request.getParameter("PageNumber") != null) {
		try {
			PageNumber = Integer.parseInt(request.getParameter("PageNumber"));
		} catch (Exception e) {
			System.out.println("검색 페이지 번호 오류");
		}		
	} 
	
	
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
	
	
	StfDTO stf = new StfDAO().getUser(STF_ID);
	
%>

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"> 
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/headerWs.css"/>
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/navWs.css"/>
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/education.css"/>
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/modal.css"/>
	<title>서울교통공사</title>
	<script src="js/bootstrap.js"></script>
</head>

<body>
	<%@ include file="/headerWs.jsp" %>
 < <%@ include file="/navWs.jsp" %> 
	<%@ include file="/modal.jsp" %>
	
	<div id="wsBody">
	<input type="hidden" value="education" id="pageType">
		<div id="wsBodyContainer">
			<h3>교육자료</h3>
			<div id="educationInner">
				<div id="inputWrap">
				<ul id="educationList">
					<li id="listHead">
						<div>No.</div>
						<div>제목</div>
						<div>작성자</div>
						<div>작성일</div>
						<div>조회수</div>
					</li>		
			<table class="table" style="text-align: center; border: 1px solid #dddddd">
			<tbody>		

			<%
				for (int i=0; i<educationList.size(); i++) {
					EducationDTO education = educationList.get(i);
			%>
				<tr>
					<td><%= education.getEDUCATION_SQ() %></td>
					<td style="text-align: left;">
					<a href="educationShow.jsp?EDUCATION_SQ=<%= education.getEDUCATION_SQ() %>">
			<%
				for (int j=0; j<education.getEDUCATION_LEVEL(); j++) {
			%>
					<span class="fas fa-angle-right" aria-hidden="true"></span>
			<% 
				}
			%>
			<%
				if (education.getEDUCATION_AVAILABLE() == 0) {
			%>
				(삭제된 게시물입니다.)
			<%
				} else {
			%>
				<%= education.getEDUCATION_NM() %>
			<%
				}
			%>
				</a></td>
					<td><%= education.getSTF_ID() %></td>
					<td><%= education.getEDUCATION_DT() %></td>
					<td><%= education.getEDUCATION_HIT() %></td></tr>
			<%
				}
			%>			
				<tr>
					<td colspan="5">
					<a href="${contextPath}/educationWrite.jsp" id="writeBtn2">글쓰기</a>
					<div id="searchWrap">
						<form action="./educationSearch.jsp" method="get" id="educationSearchForm2">	
							
							<select name="searchType" id="searchType">
									<option value="최신순">최신순</option>
									<option value="조회순" <% if (searchType.equals("조회순")) out.println("selected"); %>>조회순</option>
							</select>
							<input type="text" name="search"><button>검색</button>
						</form>
					</div>	
											
					</td>
				</tr>
			<%
				
			%>
				<tr>
					<td colspan="5">
					<ul id=pagination>
					<% 
						int startPage = (Integer.parseInt(pageNumber) / 10) * 10 + 1;
						if (Integer.parseInt(pageNumber) % 10 == 0) startPage -= 10;
						int targetPage = new EducationDAO().targetPage(pageNumber);
						if (startPage != 1) {
					%>
						<li><a href="educationView.jsp?pageNumber=<%= startPage - 1 %>"><i class="fas fa-angle-left"></i></a></li>
					<%
						} else {
					%>
						<li><i class="fas fa-angle-left"></i></li>
					<%
						}
						for (int i=startPage; i<Integer.parseInt(pageNumber); i++) {
					%>
						<li><a href="educationView.jsp?pageNumber=<%= i %>"><%= i %></a></li>
					<%
						}
					%>
						<li class="active"><a href="educationView.jsp?pageNumber=<%= pageNumber %>"><%= pageNumber %></a></li>	
					<%
						for (int i=Integer.parseInt(pageNumber) + 1; i<=targetPage + Integer.parseInt(pageNumber); i++) {
							if (i < startPage + 10) {
					%>
						<li><a href="educationView.jsp?pageNumber=<%= i %>"><%= i %></a></li>
					<%
							}
						}
						if (targetPage + Integer.parseInt(pageNumber) > startPage + 9) {
					%>
						<li><a href="educationView.jsp?pageNumber=<%= startPage + 10 %>"><i class="fas fa-angle-right"></i></a></li>
					<%
						} else {
					%>
						<li><i class="fas fa-angle-right"></i></li>
					<%
						}
					%>							
					</ul>
					</td>
				</tr>							
			</tbody>
			</table>
			</ul>		
			</div>
			</div>
		</div>
	</div>
	
</body>
</html>