<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="stf.StfDTO" %>
<%@ page import="stf.StfDAO" %>
<%@ page import="apv.ApvDAO" %>
<%@ page import="apv.ApvDTO" %>
<%@page import="req.ReqDTO"%>
<%@page import="req.ReqDAO"%>
<%@page import="req.ReqfileDTO"%>
<%@page import="req.ReqfileDAO"%>
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
	
	String REQ_SQ = null;
	if (request.getParameter("REQ_SQ") != null) {
		REQ_SQ = (String) request.getParameter("REQ_SQ");
	}
	StfDTO stf = new StfDAO().getUser(STF_ID);
	ReqDTO req = new ReqDAO().getReq(REQ_SQ);

%>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/headerWs.css"/>
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/navWs.css"/>
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/req.css"/>
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/modal.css"/>
	<title>보안점검표 제출</title>
	<script src="js/bootstrap.js"></script>
</head>

<body>
<%@ include file="/headerWs.jsp" %>
	<%@ include file="/navWs.jsp" %>
	
    <!-- 왼쪽, 오른쪽 바깥여백을 auto로 주면 중앙정렬된다.  -->
 	<div id="wsBody">
		<div id="wsBodyContainer">
			<h3>보안 점검표 </h3>
			<h4>보안 점검표 제출</h4>
			<div id="boardInner">
				<div id="inputWrap">
				<div class="container">
					<form method="post" action="./reqfileWrite" enctype="multipart/form-data">
					<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
				<thead></thead>

				<tbody>
					<tr>
						<td style="width: 130px; text-align: center;"><h5> 사업명</h5></td>
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
						    		String SQL = "SELECT APV_NM FROM REQ WHERE REQ_SQ = ?";
						    		
					           		pstmt = conn.prepareStatement(SQL);
					           		pstmt.setString(1, REQ_SQ);
					           		rs = pstmt.executeQuery();
					           		
					           	 	while (rs.next()) {
						            	
					          
					           	 		String APV_NM = rs.getString("APV_NM").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>");
	
						            	%>
						            	<input type="hidden" name="APV_NM" value="<%=APV_NM %>"><%= APV_NM %>
						          			
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
					<tr>
					<td style="width: 130px;"><h5> 담당자</h5></td>
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
						<input type="hidden" name="STF_ID" value="<%= stf.getSTF_ID() %>"></td>						
					</tr>
					
					<tr>
						<td style="width: 130px;"><h5>파일 첨부</h5></td>
						<td colspan="2">
							<div id="uploadArea" class="floatleft">
								<span>파일을 업로드하세요.</span>
								<input multiple="multiple" id="file" type="file" name="REQF_FILE" class="file">
							</div>
							<script type="text/javascript">
								$(function(){
									$("#file").change(function(){
										let $span = $("#uploadArea span");
										console.log(this.files);
										$span.empty();
										if(this.files.length>0){
											$span.addClass("on");
											$.each(this.files, function(idx,item){
												$span.append("파일 "+ (idx+1) +" : "+item.name+"<br/>");
											})
										} else {
											$span.removeClass("on");
											$span.text("파일을 업로드하세요.");
										}
									})
								})
							</script>
						
				
						<input type="hidden" name="REQ_SQ" value="<%= REQ_SQ %>"></td>			
					
						</tr>
				
					<tr>
						<td style="text-align: right;" colspan="2"><input class="btn" type="submit" value="등록"><a a class="btn" type="submit" href="reqView.jsp">취소</a></td>	
					</tr>																														
				</tbody>
			</table>			
	</form>
	
	</div>
</div>

	
	<%
		String messageContent = null;
		if (session.getAttribute("messageContent") != null) {
			messageContent = (String) session.getAttribute("messageContent");
		}
		String messageType = null;
		if (session.getAttribute("messageType") != null) {
			messageType = (String) session.getAttribute("messageType");
		}
		if (messageContent != null) {
	%>
	<div class="modal fade" id="messageModal" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="vertical-alignment-helper">
			<div class="modal-dialog vertical-align-center">
				<div class="modal-content <% if(messageType.equals("오류 메시지")) out.println("panel-warning"); else out.println("panel-success");%>">
					<div class="modal-header panel-heading">
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&times</span>
							<span class="sr-only">Close</span>
						</button>
						<h4 class="modal-title">
							<%= messageType %>
						</h4>
					</div>
					<div class="modal-body">
						<%= messageContent %>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-primary" data-dismiss="modal">확인</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script>
		$('#messageModal').modal("show");
	</script>		
	<%
		session.removeAttribute("messageContent");
		session.removeAttribute("messageType");
		}
	%>
	<script type="text/javascript">
		$(document).on('click', '.browse', function() {
			var file = $(this).parent().parent().parent().find('.file');
			file.trigger('click');
		});
		$(document).on('change', '.file', function() {
			$(this).parent().find('.form-control').val($(this).val().replace(/C:\\fakepath\\/i, ''));
		});
	</script>        
</body>
</html>