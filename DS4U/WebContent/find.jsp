<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="stf.StfDAO" %>
<%@ page import="stf.StfDTO" %>
<%@ include file="/head.jsp"%>
<!DOCTYPE html>
<html>
	<%
		String STF_ID = null;
		if (session.getAttribute("STF_ID") != null) {
			STF_ID = (String) session.getAttribute("STF_ID");
		}
		if (STF_ID == null){
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "현재 로그인이 되어있지 않습니다.");
			response.sendRedirect("index.jsp");
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
	<link rel="stylesheet" type="text/css" href="css/find.css"/>
	<link rel="stylesheet" type="text/css" href="css/navWs.css"/>
	<link rel="stylesheet" type="text/css" href="css/modal.css"/>
	<link rel="stylesheet" type="text/css" href="css/animate.css" />
	<link rel="stylesheet" type="text/css" href="css/animationCheatSheet.css" />
	<title>사원 검색</title>
	<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
	<!-- 안읽은 메세지 개수 출력 기능 script -->
	<script type="text/javascript">
	function getUnread(){
		$.ajax({
			type : 'POST',
			url : "./chatUnread",
			data : {
				STF_ID : encodeURIComponent('<%=STF_ID%>')
			},
			success : function(result){
				if(result >= 1){
					showUnread(result);
				} else{
					showUnread('');
				}
			}
		});
	}
		
		function getInfiniteUnread(){
			setInterval(function(){
				getUnread();
			}, 4000);
		}
		
		function showUnread(result){
			$('#unread').html(result);
		}
	</script>
	<!-- 친구 찾기 기능 script -->
	<script type="text/javascript">
		function findFunction(){
			var STF_ID = $('#findID').val();
			$.ajax({
				type : 'POST',
				url : './userFind',
				data : { STF_ID : STF_ID },
				success : function(result){
					if (result == -1) {
						$('#checkMessage').html('사원을 찾을 수 없습니다.');
						$('#checkType').attr('class', 'modal-content panel-warning');
						failFriend();						
					}
					else {
						$('#checkMessage').html('사원찾기에 성공했습니다.');
						$('#checkType').attr('class', 'modal-content panel-success');
						var data = JSON.parse(result);
						var profile = data.STF_PF;
						getFriend(STF_ID, profile);
					} 
					$('#checkModal').modal("show");
				}
			});
		}
		
		function getFriend(findID, STF_PF){
			$('#friendResult').html('<thead>' +
					'<tr>' + 
					'<th><h4>검색결과</h4></th>' + 
					'</thead>' +
					'<tbody>' +
					'<tr>' +
					'<td style="text-align:center;">' + 
					'<img class="media-object img-circle" style="max-width: 300px; margin: 0 auto;" src="'+ STF_PF +'">' +
					'<h3>' + findID + '</h3><a href="chat.jsp?toID=' + encodeURIComponent(findID) + '" class="btn btn-primary pull-right">' + '메세지 보내기</a></td>' +
					'</tr>' +
					'</tbody>');
		}
		
		function failFriend(){
			$('#friendResult').html('');
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
			<h3>사원찾기 <i class="glyphicon glyphicon-search"></i></h3>
			<div id="boardInner">
				<div id="inputWrap">
				<table class="table" style="text-align: center;border: 1px solid #dddddd; margin: 0 auto; width:100%">
					<thead>
						<tr>
							<th><h4>사원 검색</h4></th>
						</tr>
					</thead>
					<tbody>
					<div style="overflow-y: auto;width: 100%;max-height: 450px">
					<table class="table table-bordered table-hover" style="text-align: center;border: 1px solid #dddddd;margin: 0 auto;width:100%;">
						<tr>
							<td style="width: 110px"><h5>사원 아이디</h5></td>
							<td><input type="text" class="form-control" id="findID" maxlength="20" style="width:90%" placeholder="검색할 아이디를 입력해주세요."></td>
						</tr>
						<tr>
							<td colspan="2"><button class="btn btn-primary pull-right" onclick="findFunction();">검색</button></td>
						</tr>
					</table>
					</div>
					</tbody>
				</table>
			</div>
			<div class="container">
				<table id="friendResult" class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd; margin: 0 auto; width:70%;">
				</table>
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
				});
			</script>
	<%
		}
	%>
</body>
</html>