<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="stf.StfDTO" %>
<%@ page import="stf.StfDAO" %>
<%@ include file="/head.jsp" %>
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
	StfDTO stf = new StfDAO().getUser(STF_ID);
%>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" type="text/css" href="css/headerWs.css"/>
	<link rel="stylesheet" type="text/css" href="css/navWs.css"/>
	<link rel="stylesheet" type="text/css" href="css/myPage.css"/>
	<link rel="stylesheet" type="text/css" href="css/modal.css"/>
	<title>서울교통공사</title>
	<script src="js/bootstrap.js"></script>
	<script type="text/javascript">
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
	<%@ include file="/headerWs.jsp"%>
	<%@ include file="/navWs.jsp"%>
	<%@ include file="/modal.jsp" %>
	
	<div id="wsBody">
	<input type="hidden" value="mypage" id="pageType">
		<div id="wsBodyContainer">
			<h3>마이페이지</h3>
			<h4>비밀번호 수정</h4>
			<div class="myPageInner">
				<div class ="myPageModify">
					<p>비밀번호를 변경하세요</p>
					<form method="post" action="./pwUpdate" class="modifyPw" >
						<input type="hidden" name="STF_ID" value="<%= stf.getSTF_ID() %>">
						<input onkeyup="passwordCheckFunction();" class="content" id="STF_PW1" type="password" name="STF_PW1" maxlength="20" placeholder="새 비밀번호를 입력하세요.">
						<input onkeyup="passwordCheckFunction();" class="content" id="STF_PW2" type="password" name="STF_PW2" maxlength="20" placeholder="비밀번호를 다시 입력하세요.">
						<div style="color: red;" id="passwordCheckMessage"></div>
						<div class="row btns">
							<button class="btn" type="submit">수정</button>
							<a href="myPage.jsp" class="btn">취소</a>
						</div>
					</form>
				</div>
			</div><!-- myPageInner -->
		</div>
	</div><!-- end wsBody -->

</body>
</html>