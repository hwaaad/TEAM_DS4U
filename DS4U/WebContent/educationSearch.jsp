<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="education.EducationDAO" %>
<%@ page import="education.EducationDTO" %>
<%@ page import="stf.StfDAO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.net.URLEncoder" %>
<%@ include file="head.jsp" %>
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
	EducationDAO educationDAO = new EducationDAO();
	
	request.setCharacterEncoding("UTF-8");
	String searchType = "최신순";
	String search = "";
	int PageNumber = 0;
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
  <%@ include file="/navWs.jsp" %>
	<%@ include file="/modal.jsp" %>
	<div id="wsBody">
	<input type="hidden" value="education" id="pageType">
		<div id="wsBodyContainer">
			<h3>교육자료</h3>
			<div id="educationInner">
				<div id="inputWrap">
				<ul id="educationList">
					<table class="table" style="text-align: center; border: 1px solid #dddddd">
					<thead>
						<tr>
							<td>No.</td>
							<td>제목</td>
							<td>작성자</td>
							<td>작성일</td>
							<td>조회수</td>
						</tr>
					</thead>	
				<tbody>	
				<%	
					if (educationDAO.educationSearchCount(searchType, search, PageNumber) <= 0) {
				%>	
					<table class="table" style="text-align: center; border: 1px solid #dddddd">
						<tbody>	
							<tr>
								<td style="width: 977px; text-align: center; border-right:1px solid #dddddd">검색 결과가 없습니다.</td>
							</tr>
							<tr>
								<td colspan="5">
									<a href="${contextPath}/educationView.jsp" id="writeBtn2">목록</a>
									<div id="searchWrap">
										<form action="./educationSearch.jsp" method="get" id="educationSearchForm">							
											<select name="searchType" id="searchType">
												<option value="최신순">최신순</option>
												<option value="조회순" <% if (searchType.equals("조회순")) out.println("selected"); %>>조회순</option>
											</select>
											<input type="text" name="search" type="submit"><button>검색</button>
										</form>
									</div>					
								</td>
							</tr>
						</tbody>
					</table>			
				<%	
			} else {
				ArrayList<EducationDTO> searchList = new ArrayList<EducationDTO>();
				searchList = new EducationDAO().getSearch(searchType, search, PageNumber);
				for (int i=0; i<searchList.size(); i++) {
					if (i == 10) break;
					EducationDTO education = searchList.get(i);
					
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
				<td><%= education.getEDUCATION_HIT() %></td>
			<%
				}
			%>
			
		
			
				<tr>
					<td colspan="5">
						<a href="${contextPath}/educationView.jsp" id="writeBtn2">목록</a>
						<div id="searchWrap">
							<form action="./educationSearch.jsp" method="get" id="educationSearchForm">							
								<select name="searchType" id="searchType">
									<option value="최신순">최신순</option>
									<option value="조회순" <% if (searchType.equals("조회순")) out.println("selected"); %>>조회순</option>
								</select>
								<input type="text" name="search" type="submit"><button>검색</button>
							</form>
						</div>					
					</td>
				</tr>
				
				
					<td colspan="5">
					<ul id=pagination>
					<% 
						if (PageNumber <= 0) {
					%>
						<li><a class="page-link disabled"><i class="fas fa-angle-left"></i></a></li>
					<%
						} else {
					%>
						<li><a href="educationSearch.jsp?searchType=<%= URLEncoder.encode(searchType, "UTF-8") %>&search=<%= URLEncoder.encode(search, "UTF-8") %>&PageNumber=<%= PageNumber-1 %>"><i class="fas fa-angle-left"></i></a></li>
					<%
						}
					%>
					<% 
						if (searchList.size() < 6) {
					%>
						<li><a class="page-link disabled"><i class="fas fa-angle-right"></i></a></li>
					<%
						} else {
					%>
						<li><a href="educationSearch.jsp?searchType=<%= URLEncoder.encode(searchType, "UTF-8") %>&search=<%= URLEncoder.encode(search, "UTF-8") %>&PageNumber=<%= PageNumber+1 %>"><i class="fas fa-angle-right"></i></a></li>
					<%
						}
					%>	
					</ul>
					</td>
					<%
						}			
					%>
				
					
											
			</tbody>
			</table>
			</ul>		
			</div>
			</div>
		</div>
	</div>
	
</body>
</html>