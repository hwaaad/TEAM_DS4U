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
	<link rel="stylesheet" type="text/css" href="css/base.css"/>
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
			<h4>개인정보 관리</h4>
			<div class="myPageInner">
				<div class ="myPageAccount">
					<div class="myPageContent">
						<div class="myPageTitle">
							<p class="title">프로필</p>
							<p class="content">수정을 원하는 탭을 선택</p>
						</div>
						<div class="myPageContentRow clearFix modifyRow" onclick="location.href='${contextPath}/pfUpdate.jsp'">
							<p class="title">사진</p>
							<p class="content msg">현재 프로필 사진 업로드 기능이 비활성화 되었습니다.</p>
							<div id="profileImg">
								<img alt="나의 프로필 사진" src="${contextPath }/images/profileImage.png"" />
							</div>
						</div>
						<div class="myPageContentRow clearFix">
							<p class="title">아이디</p>
							<p class="content" id="STF_ID"><%= stf.getSTF_ID() %></p>
						</div>						
						<div class="contentLine"></div>
						<div class="myPageContentRow clearFix modifyRow" onclick="location.href='${contextPath}/nameUpdate.jsp'">
							<p class="title">이름</p>
							<p class="content" id="STF_NM"><%= stf.getSTF_NM() %></p>						
							<p><i class="fas fa-chevron-right"></i></p>
						</div>
						<div class="contentLine"></div>
						<div class="myPageContentRow clearFix modifyRow" onclick="location.href='${contextPath}/pwUpdate.jsp'">
							<p class="title">비밀번호</p>
							<p class="content">******</p>
							<p><i class="fas fa-chevron-right"></i></p>
						</div>
					</div>
					<div class="myPageContent">
						<div class="myPageTitle">
							<p class="title">연락처 정보</p>
							<p class="content">수정을 원하는 탭을 선택</p>
						</div>
						<div class="myPageContentRow clearFix modifyRow" onclick="location.href='${contextPath}/emailUpdate.jsp'">
							<p class="title">이메일</p>
							<p class="content" id="STF_EML"><%= stf.getSTF_EML() %></p>
							<p><i class="fas fa-chevron-right"></i></p>
						</div>
						<div class="contentLine"></div> 
						<div class="myPageContentRow clearFix modifyRow" onclick="location.href='${contextPath}/phoneUpdate.jsp'">
							<p class="title">핸드폰 번호</p>
							<p class="content" id="STF_PH"><%= stf.getSTF_PH() %></p>
							<p><i class="fas fa-chevron-right"></i></p>
						</div>
						<div class="contentLine"></div> 
						<div class="myPageContentRow clearFix modifyRow" onclick="location.href='${contextPath}/depUpdate.jsp'">
							<p class="title">부서</p>
							<p class="content" id="STF_DEP"><%= stf.getSTF_DEP() %></p>
							<p><i class="fas fa-chevron-right"></i></p>
						</div>						
					</div>
					<div class="myPageAccountRow">
						<div class="row btns btnR">
							<a href="index.jsp" class="btn"><i class="fa fa-arrow-left" aria-hidden="true"></i> 이전</a>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	         
</body>
</html>