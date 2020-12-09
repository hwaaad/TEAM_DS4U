<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="req.ReqDAO" %>
<%@ page import="req.ReqDTO" %>
<%@ page import="stf.StfDAO" %>
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
	String STF_NM = null;
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
		response.sendRedirect("fin_reqView.jsp");
		return;			
	}
	ArrayList<ReqDTO> reqList = new ReqDAO().getList(pageNumber);
	ReqDAO reqDAO = new ReqDAO();
	
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
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/req.css"/>
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/modal.css"/>
	<title>서울교통공사</title>
	<script src="js/bootstrap.js"></script>
</head>

<body>
 	<%@ include file="headerWs.jsp" %>
	<%@ include file="navWs.jsp" %>
	<%@ include file="/modal.jsp" %>
	
	<div id="wsBody">
	<input type="hidden" value="board" id="pageType">
		<div id="wsBodyContainer">
			<h3>보안성 검토</h3>
			<h4>완료된 보안성 검토</h4>
			<div id="boardInner">
				<ul id="boardList">
				<table class="table" style="text-align: center; border: 1px solid #dddddd">
					<li id="listHead">
						<div>No.</div>
						<div>사업명</div>
						<div>부서명</div>
						<div>담당자</div>
						<div>검토 요청일</div>
						<div>회신일</div>
						<div>보안점검표 제출일</div>
						<div>상태</div>
					</li>			
				
				<tbody>	
				<%	
					if (reqDAO.fin_reqSearchCount(searchType, search, PageNumber) <= 0) {
				%>	
					<table class="table" style="text-align: center; border: 1px solid #dddddd">
						<tbody>	
							<tr>
								<td style="width: 1200px; text-align: center; border-right:1px solid #dddddd">검색 결과가 없습니다.</td>
							</tr>
							<tr>
								<td colspan="9">
									<a href="${contextPath}/fin_reqView.jsp" id="writeBtn">목록</a>
									<div id="searchWrap">
										<form action="./fin_reqSearch.jsp" method="get" id="boardSearchForm">							
											<select name="searchType" id="searchType">
												<option value="사업명">사업명</option>
												<option value="작성자" <% if (searchType.equals("작성자")) out.println("selected"); %>>작성자</option>
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
				ArrayList<ReqDTO> searchList = new ArrayList<ReqDTO>();
				searchList = new ReqDAO().getfinSearch(searchType, search, PageNumber);
				for (int i=0; i<searchList.size(); i++) {
					if (i == 10) break;
					ReqDTO req = searchList.get(i);
					
			%>
					<tr>
					<td><%= req.getREQ_SQ() %></td>
					<td style="text-align: left;">
					<a href="reqShow.jsp?REQ_SQ=<%= req.getREQ_SQ() %>">
					<%= req.getAPV_NM() %>
				</a></td>
				<td>
					<% 
								
								Connection conn = null;
						    	PreparedStatement pstmt = null;
						    	ResultSet rs = null;
						    	DataSource dataSource;
						    	InitialContext initContext = new InitialContext();
								Context envContext = (Context) initContext.lookup("java:/comp/env");
								dataSource = (DataSource) envContext.lookup("jdbc/DS4U");
						    	try{
						    		
						    		conn = dataSource.getConnection();
						    		String SQL = "SELECT STF_DEP FROM STF WHERE STF_ID = ?";
					           		pstmt = conn.prepareStatement(SQL);
					           		pstmt.setString(1, req.getSTF_ID());
					           		rs = pstmt.executeQuery();
					           		
					           	 	while (rs.next()) {
						            	
					           	 		STF_DEP = rs.getString("STF_DEP").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>");
						            	
						            	
						            	%>
						           <%= STF_DEP %>
						            	<%
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
						 %>
						
					</td>
					<td>
					<%
								try{
						    		
						    		conn = dataSource.getConnection();
						    		String SQL = "SELECT STF_NM FROM STF WHERE STF_ID = ?";
					           		pstmt = conn.prepareStatement(SQL);
					           		pstmt.setString(1, req.getSTF_ID());
					           		rs = pstmt.executeQuery();
									
					           		
									while (rs.next()) {
						            	
					           	 		STF_NM = rs.getString("STF_NM").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>");
						            	
						            	
						            	%>
						           <%=STF_NM%>
						            	<%
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
					%>
					</td>
					<td>
					<a href="reqShow.jsp?REQ_SQ=<%= req.getREQ_SQ() %>">
					<%= req.getREQ_DATE() %></a></td>
					<td>
					<% 
					if (req.getREQ_REC_DATE().equals("")) {
						session.setAttribute("REQ_SQ", req.getREQ_SQ());
					%>
					<a href="reqReciveWrite.jsp?REQ_SQ=<%= req.getREQ_SQ() %>" id = "writeBtn2">등록</a>
					<% 
					} else {
					%> 
						<a href="reqrecShow.jsp?REQ_SQ=<%= req.getREQ_SQ() %>"> <%= req.getREQ_REC_DATE()%></a>	
					<% 
					}
					%>
					</td>
					<td>
					<% 
					if (req.getREQ_SUB_DATE().equals("")) {
						session.setAttribute("REQ_SQ", req.getREQ_SQ());
					%>
					<a href="reqfileWrite.jsp?REQ_SQ=<%= req.getREQ_SQ() %>" id = "writeBtn2">등록</a>
					<% 
					} else {
					%> 
						<a href="reqfileShow.jsp?REQ_SQ=<%= req.getREQ_SQ() %>"> <%= req.getREQ_SUB_DATE()%></a>	
					<% 
					}
					%>
					</td>
					<td>
					<% 
					switch(req.getREQ_STATE()){
					case 1:
						%> 검토 전 <% 
						break;
					case 2:
						%> 검토 반려 <%
						break;
					case 3:
						%> 검토 승인 <%
						break;
					case 4:
						%> 사업 완료 <% 
						break;
					default :
						%> null <% 
					}
					%>
					</td>					
				</tr>
				
				
			<%
				}
			%>
			
		
			
				<tr>
					<td colspan="9">
						<a href="${contextPath}/fin_reqView.jsp" id="writeBtn">목록</a>
						<div id="searchWrap">
							<form action="./fin_reqSearch.jsp" method="get" id="boardSearchForm">							
								<select name="searchType" id="searchType">
									<option value="사업명">사업명</option>
									<option value="작성자" <% if (searchType.equals("작성자")) out.println("selected"); %>>작성자</option>
								</select>
								<input type="text" name="search" type="submit"><button>검색</button>
							</form>
						</div>					
					</td>
				</tr>
				
				
					<td colspan="9">
					<ul id=pagination>
					<% 
						if (PageNumber <= 0) {
					%>
						<li><a class="page-link disabled"><i class="fas fa-angle-left"></i></a></li>
					<%
						} else {
					%>
						<li><a href="fin_reqSearch.jsp?searchType=<%= URLEncoder.encode(searchType, "UTF-8") %>&search=<%= URLEncoder.encode(search, "UTF-8") %>&PageNumber=<%= PageNumber-1 %>"><i class="fas fa-angle-left"></i></a></li>
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
						<li><a href="fin_reqSearch.jsp?searchType=<%= URLEncoder.encode(searchType, "UTF-8") %>&search=<%= URLEncoder.encode(search, "UTF-8") %>&PageNumber=<%= PageNumber+1 %>"><i class="fas fa-angle-right"></i></a></li>
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