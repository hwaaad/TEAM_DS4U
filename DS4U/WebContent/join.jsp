<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/head.jsp" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<!--  <link rel="stylesheet" href="css/bootstrap.css">
	<link rel="stylesheet" href="css/custom.css">-->
	<link rel="stylesheet" type="text/css" href="css/headerMain.css" />
	<link rel="stylesheet" type="text/css" href="css/animate.css" />
	<link rel="stylesheet" type="text/css" href="css/join.css" />
	<link rel="stylesheet" type="text/css" href="css/modal.css"/>
	<title>서울교통공사</title>
	<script src="js/bootstrap.js"></script>
	<script type="text/javascript">
		function registerCheckFunction() {
			var STF_ID = $('#STF_ID').val();
			$.ajax({
				type: 'POST',
				url: './userRegisterCheck',
				data: {STF_ID: STF_ID},
				success: function(result) {
					if (result == 1) {
						$('#checkMessage').html('사용 가능한 아이디 입니다.');
						$('#checkType').attr('class', 'modal-content panel-success');
					} else {
						$('#checkMessage').html('사용할 수 없는 아이디 입니다.');
						$('#checkType').attr('class', 'modal-content panel-warning');
					}
					$('#checkModal').modal("show");
				}
			});
		}
		function passwordCheckFunction() {
			var STF_PW1 = $('#STF_PW1').val();
			var STF_PW2 = $('#STF_PW2').val();
			if (STF_PW1 != STF_PW2) {
				$('#passwordCheckMessage').html('비밀번호가 서로 다릅니다.');
			} else {
				$('#passwordCheckMessage').html('비밀번호 확인이 완료되었습니다.');
			}
		}
	</script>
</head>
<body>
	<%
		String STF_ID = null;
		if (session.getAttribute("STF_ID") != null) {
			STF_ID = (String) session.getAttribute("STF_ID");
		}
		if (STF_ID != null) {
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "이미 로그인 되어 있습니다.");
			response.sendRedirect("index.jsp");
			return;
		}
	%>
	<div id="wrap">
		<%@ include file="/headerMain.jsp"%>
		<div id="joinAll">
			<section class="joinStep3-section">
				<div id="joinBox" class="animated fadeIn">
					<div class="header">
						<!--파도 위 내용-->
						<div class="inner-header flex">
							<div class="joinBox-Head">
								<h3 style='font-weight: bolder; font-size: 30px'>회원가입</h3>
								<p>
									<i class="fas fa-circle" style="color: #DDB4AB"></i>&nbsp;&nbsp;
									<i class="fas fa-circle" style="color: #DDB4AB"></i>&nbsp;&nbsp;
									<i class="fas fa-circle" style="color: #DDB4AB"></i>&nbsp;&nbsp;
								</p>
							</div>
						</div>
					</div>
					<!--header end-->
					<!--파도 아래 내용-->
					<div class="content box3 flex">
						<div class="joinBox-Body">
							<form action="./userRegister" method="post" id="joinMemberForm">
								<div>
									<h4>ID</h4>
									<input class="form-control" type="text" id="STF_ID" name="STF_ID" maxlength="10" placeholder="아이디를 입력하세요." style="width: 230px;">
									<button class="btn btn-primary" onclick="registerCheckFunction();" type="button" style="width: 90px;">중복체크</button>
								</div>
								<div>
									<h4>PASSWORD</h4>
									<input onkeyup="passwordCheckFunction();" class="form-control" id="STF_PW1" type="password" name="STF_PW1" maxlength="20" placeholder="비밀번호를 입력하세요.">
								</div>
								<div>
									<h4>PASSWORD CHECK</h4>
									<input onkeyup="passwordCheckFunction();" class="form-control" id="STF_PW2" type="password" name="STF_PW2" maxlength="20" placeholder="비밀번호를 다시 입력하세요.">
								</div>
								<div>
									<h4>NAME</h4>
									<input class="form-control" id="STF_NM" type="text" name="STF_NM" maxlength="30" placeholder="이름을 입력하세요.">
								</div>
								<div>
									<h4>PHONE</h4>
									<input class="form-control" id="STF_PH" type="text" name="STF_PH" maxlength="13" placeholder="전화번호를 입력하세요.">
								</div>
								<div>
									<h4>EMAIL</h4>
									<input class="form-control" id="STF_EML" type="email" name="STF_EML" maxlength="30" placeholder="이메일을 입력하세요.">
								</div>																								
								<div>
									<h4>DETARTMENT</h4>
									<div></div>
									<label class="btn btn-primary active">
										<input type="radio" name="STF_DEP" autocomplete="off" value="부서1" checked>부서1											
									</label>
									<label class="btn btn-primary">
										<input type="radio" name="STF_DEP" autocomplete="off" value="부서2" checked>부서2											
									</label>
									<label class="btn btn-primary">
										<input type="radio" name="STF_DEP" autocomplete="off" value="부서3" checked>부서3											
									</label>		
								</div>
								<div></div>
								<div></div>
								<div></div>																
								<div class="joinCheckbox">
									<input type="checkbox" id="checkbox" value="1" class="joinCheckboxInput"> 서울교통공사가 제공하는 서비스 약관에 동의합니다.<br>
									<span id="checkCheckBox" class="checkSentenceRed"></span>
								</div>
								<div>
									<h5 style="color: red;" id="passwordCheckMessage"></h5><input type="submit" value="회원등록" class="joinFormButton">
								</div>
							</form>
						</div>
					</div>
					<!--Content ends-->
				</div>
			</section>
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
	<div class="modal fade" id="checkModal" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="vertical-alignment-helper">
			<div class="modal-dialog vertical-align-center">
				<div id="checkType" class="modal-content panel-info">
					<div class="modal-header panel-heading">
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&times</span>
							<span class="sr-only">Close</span>
						</button>
						<h4 class="modal-title">
							확인 메시지
						</h4>
					</div>
					<div id="checkMessage" class="modal-body">
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-primary" data-dismiss="modal">확인</button>
					</div>
				</div>
			</div>
		</div>	
	</div>
</body>
</html>