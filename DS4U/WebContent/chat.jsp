<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>  
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
		String toID = null;
		if(request.getParameter("toID") != null){
			toID = (String)request.getParameter("toID");	
		}
		if(STF_ID == null){
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "로그인이 되어있지 않습니다.");
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
		if(toID == null){
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "대화 상대가 없습니다.");
			response.sendRedirect("index.jsp");
			return;
		}
		if (STF_ID.equals(URLDecoder.decode(toID, "UTF-8"))) {
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "자기 자신과는 채팅할 수 없습니다.");
			response.sendRedirect("find.jsp");
			return;			
		}
		String fromProfile = new StfDAO().getProfile(STF_ID);
		String toProfile = new StfDAO().getProfile(toID);
		Date now = new Date();
		SimpleDateFormat simpleDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String strNow = simpleDate.format(now);
		simpleDate.applyPattern("yyyy년 MM월 dd일 a HH시 mm분 E요일");
		strNow = simpleDate.format(new Date());
		StfDTO stf = new StfDAO().getUser(STF_ID);
	%>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="css/bootstrap.css">
	<link rel="stylesheet" type="text/css" href="css/headerWs.css"/>
	<link rel="stylesheet" type="text/css" href="css/navWs.css"/>
	<link rel="stylesheet" type="text/css" href="css/modal.css"/>
	<link rel="stylesheet" type="text/css" href="css/chat.css"/>
	<title>채팅</title>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
	<script src="js/bootstrap.js"></script>
	<script type="text/javascript">
		function autoClosingAlert(selector, delay){
			var alert = $(selector).alert();
			alert.show();
			window.setTimeout(function(){
				alert.hide();
			}, delay);
		}
		
		function submitFunction(){
			var fromID = '<%=STF_ID%>';
			var toID = '<%=toID%>';
			var chatContent = $('#chatContent').val();
			$.ajax({
				type : 'POST',
				url : './chatSubmitServlet',
				data : {
					fromID : encodeURIComponent(fromID),
					toID : encodeURIComponent(toID),
					chatContent : encodeURIComponent(chatContent)
				},
				success : function(result){
					if(result == 1){
						autoClosingAlert('#successMessage', 2000);
					} else if(result == 0){
						autoClosingAlert('#dangerMessage', 2000);
					} else{
						autoClosingAlert('#warningMessage', 2000);
					}
				}
			});
			$('#chatContent').val('');
		}
		
		
		function addChat(chatName, chatContent, chatTime){
			if (chatName == "나") {
				$('#chatList').append('<div class ="row">' +
						'<div class="col-lg-12">' + 
						'<div class="media">' +
						'<a class="pull-right" href="#">' +
						'<img class="media-object img-circle" style="width:30px;height:30px" src="<%= fromProfile %>" alt="">' +
						'</a>' +
						'<div class="media-body">' +
						'<h4 class="media-heading pull-right">' +
						chatName +
						'</h4>' +
						'<h4 class="media-heading">' +
						'<span class="small">' +
						chatTime +
						'</span>' +
						'</h4>' +
						'<p class=pull-right>' +
						chatContent +
						'</p>' +
						'</div>' +
						'</div>' +
						'</div>' +
						'</div>' +
						'<hr>');
			} else {
				$('#chatList').append('<div class ="row">' +
						'<div class="col-lg-12">' + 
						'<div class="media">' +
						'<a class="pull-left" href="#">' +
						'<img class="media-object img-circle" style="width:30px;height:30px" src="<%= toProfile %>" alt="">' +
						'</a>' +
						'<div class="media-body">' +
						'<h4 class="media-heading">' +
						chatName +
						'<span class="small pull-right">' +
						chatTime +
						'</span>' +
						'</h4>' +
						'<p>' +
						chatContent +
						'</p>' +
						'</div>' +
						'</div>' +
						'</div>' +
						'</div>' +
						'<hr>');
			}
			$('#chatList').scrollTop($('#chatList')[0].scrollHeight);
		}
		
		var lastID = 0;
		function chatListFunction(type){
			var fromID = '<%=STF_ID%>';
			var toID = '<%=toID%>';
			$.ajax({
				type : "POST",
				url : "./chatListServlet",
				data : {
					fromID : encodeURIComponent(fromID),
					toID : encodeURIComponent(toID),
					listType : type /*처음에는 chatID가 0 이상인것부터 쭉, 그다음부터는 lastID 이후로 쭉(lastID는 계속 업데이트됨)*/
				},
				success : function(data){
					if(data == "") return;
					var parsed = JSON.parse(data);
					var result = parsed.result;
					for(var i = 0; i < result.length; i++){
						if(result[i][0].value == fromID){
							result[i][0].value = '나';
						}
						addChat(result[i][0].value, result[i][2].value, result[i][3].value);
					}
					lastID = Number(parsed.last);
				}
			});
		}
		
		function getInfiniteChat(){
			setInterval(function (){
				chatListFunction(lastID);
			}, 3000);
		}
		
		$(document).ready(function(){
			getUnread();
			getInfiniteUnread(); /* 메세지함 script */
			chatListFunction('0'); 
			getInfiniteChat();
		});
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
						<div class="container bootstrap snippet">
							<div class="row">
								<div class="col-xs-12">
									<div class="portlet portlet-default">
										<div class="portlet-heading">
											<div class="portlet-title">
												<h4><i class="fa fa-circle text-green"></i><%= toID  %></h4>
											</div>
											<div class="clearfix"></div>
										</div>
										<div id="chat" class="panel-collapse collapse in">
					                        <div class="row">
					                            <div class="col-lg-12">
					                                <p class="text-center text-muted big"><%= strNow %></p>
					                            </div>
					                        </div>
											<div id="chatList" class="portlet-body chat-widget" style="overflow-y:auto;width:auto;height:600px"></div>
											<div class="portlet-footer">
											<form role="form">
												<div class="row" style="height: 90px;">
													<div class="form-group col-xs-11">
														<textarea style="height: 80px;" id="chatContent" class="form-control" placeholder="메세지를 입력하세요." maxlength="100"></textarea>
													</div>
													<div class="form-group">
														<button type="button" class="btn btn pull right" style="height:80px" onclick="submitFunction()">전송</button>
														<div class="clearfix"></div>
													</div>
												</div>
											</form>
											</div>
										</div>
									</div>
									<!-- 메세지 전송 결과 모달 팝업창 -->
									<div class="alert alert-success" id="successMessage" style="display: none;">
										<strong>메세지를 보냈습니다.</strong>
									</div>
									<div class="alert alert-danger" id="dangerMessage" style="display: none;">
										<strong>내용을 입력하세요.</strong>
									</div>
									<div class="alert alert-warning" id="warningMessage" style="display: none;">
										<strong>DB 오류가 발생했습니다.</strong>
									</div>
								</div>
							</div>
						</div>
						</table>
				</div>
			</div>
		</div>
	</div>
	
	<script>
		$(document).ready(function() {
			chatListFunction('0');
			getInfiniteChat();
		})
	</script>
</body>
</html>