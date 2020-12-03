<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/head.jsp"%>
<%@ page import="stf.StfDAO" %>
<%@ page import="stf.StfDTO" %>
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
		StfDTO stf = new StfDAO().getUser(STF_ID);
	%>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"> 
	<link rel="stylesheet" type="text/css" href="css/headerWs.css"/>
	<link rel="stylesheet" type="text/css" href="css/navWs.css"/>
	<link rel="stylesheet" type="text/css" href="css/chatBox.css"/>
	<link rel="stylesheet" type="text/css" href="css/modal.css"/>
	<link rel="stylesheet" type="text/css" href="css/animate.css" />
	<link rel="stylesheet" type="text/css" href="css/animationCheatSheet.css" />
	<title>서울교통공사</title>
	<script src="js/bootstrap.js"></script>
	<!-- 안읽은 메세지 개수 출력 -->
	<script type="text/javascript">
		function getUnread(){
			$.ajax({
				type : 'POST',
				url : "./chatUnread",
				data : { STF_ID : encodeURIComponent('<%=STF_ID%>') },
				success : function(result) {
					if (result >= 1) {
						showUnread(result);
					} else {
						showUnread('');
					}
				}
			});
		}
		
		function getInfiniteUnread() {
			setInterval(function() {
				getUnread();
			}, 4000);
		}
		
		function showUnread(result) {
			$('#unread').html(result);
		}
		
		function chatBoxFunction(){
			var STF_ID = '<%=STF_ID%>';
			$.ajax({
				type : 'POST',
				url : "./chatBox",
				data : { STF_ID : encodeURIComponent('<%=STF_ID%>') },
				success : function(data) {
					if(data == "") return;
					$('#boxTable').html('');
					var parsed = JSON.parse(data);
					var result = parsed.result;
					for(var i = 0; i<result.length; i++){
						if(result[i][0].value == STF_ID){
							result[i][0].value = result[i][1].value;
						} else{
							result[i][1].value = result[i][0].value;
						}
						addBox(result[i][0].value, result[i][1].value, result[i][2].value, result[i][3].value, result[i][4].value, result[i][5].value);
					}
				}
			});
		}
		
		function addBox(lastID, toID, chatContent, chatTime, unread, profile){
			$('#boxTable').append('<tr onclick="location.href=\'chat.jsp?toID=' + encodeURIComponent(toID) + '\'">' +
					'<td style="width:200px;">' + 
					'<img class="media-object img-circle" style="max-width: 60px; max-height: 60px; margin: 0 auto;" src="'+ profile +'">' +
					'<h5>' + lastID + '</h5></td>' +
					'<td>' +
					'<h5>' + chatContent + ' ' +
					'<span class="label label-info">' + unread + '</span></h5>' +
					'<div class="pull-right">' + chatTime + '</div>' +
					'</td>' + 
 					'</tr>');
		}
		
		function getInfiniteBox(){
			setInterval(function(){
				chatBoxFunction();
			},3000);
		}
	</script>
</head>

<body>
	<%@ include file="/headerWs.jsp"%>
	<%@ include file="/navWs.jsp"%>
	<%@ include file="/modal.jsp" %>
	<div id="wsBody">
	<input type="hidden" value="board" id="pageType">
		<div id="wsBodyContainer">
			<h3>채팅목록 <i class="glyphicon glyphicon-phone"></i></h3>
			<div id="boardInner">
				<div id="inputWrap">
						<table class="table" style="text-align: center;border: 1px solid #dddddd; margin: 0 auto; width:100%">
							<thead>
								<tr>
									<th><h4>채팅 내역</h4></th>
								</tr>
							</thead>
							<div style="overflow-y: auto;width: 100%;max-height: 450px">
								<table class="table table-bordered table-hover" style="text-align: center;border: 1px solid #dddddd;margin: 0 auto;width:100%;">
									<tbody id="boxTable">
									</tbody>
								</table>
							</div>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<%
		if(STF_ID != null){
	%>
			<script type="text/javascript">
				$(document).ready(function(){
					getUnread();
					getInfiniteUnread();
					chatBoxFunction();
					getInfiniteBox();
				});
			</script>
	<%
		}
	%>
</body>
</html>