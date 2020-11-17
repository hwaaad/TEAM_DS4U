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
	String profile = new StfDAO().getProfile(STF_ID);
%>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" type="text/css" href="css/headerWs.css"/>
	<link rel="stylesheet" type="text/css" href="css/navWs.css"/>
	<link rel="stylesheet" type="text/css" href="css/myPage.css"/>
	<link rel="stylesheet" type="text/css" href="css/modal.css"/>
	<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
	<title>서울교통공사</title>
	<script src="js/bootstrap.js"></script>
</head>
<body>
	<%@ include file="/headerWs.jsp"%>
	<%@ include file="/navWs.jsp"%>
	<%@ include file="/modal.jsp" %>
	
	<div id="wsBody">
		<input type="hidden" value="mypage" id="pageType">
		<div id="wsBodyContainer">
			<h3>마이페이지</h3>
			<h4>프로필 사진 수정</h4>
			<div class="myPageInner">
				<div class ="myPageModify profileModify">
					<p>프로필 이미지를 변경해주세요!</p>
					<form class="profileImgForm" method="post" action="./userProfile" enctype="multipart/form-data">
						<input type="hidden" name="STF_ID" value="<%= stf.getSTF_ID() %>">						
						<div id="profileImg">
							<img alt="나의 프로필 사진" class="thumbNailImg">
						</div>
						<div class="attachImgArea clearFix">		
							<input type="hidden" id="profileImgType" name="profileImgType"> 
							<input type="file" id="attachImgBtn" name="STF_PF" class="file" value="사진 선택" accept="image/*" multiple="multiple">
							<label for="attachImgBtn">프로필 변경</label>
							<input type="button" id="defalutImgBtn">
							<label for="defalutImgBtn">기본이미지</label>
						</div>
						<div class="row btns">
							<button class="btn imgUpload" type="submit" name="STF_PF">적용</button>
							<a href="myPage.jsp" class="btn">취소</a>
						</div>
					</form>
				</div>
			</div><!-- myPageInner -->
		</div>
	</div>
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