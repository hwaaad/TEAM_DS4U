<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="stf.StfDTO" %>
<%@ page import="stf.StfDAO" %>
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
	<meta name="viewport" content="width=device-width, initial-scale=1">  <!-- 반응형 웹에 사용하는 메타태그 -->
       <!-- viewport = 화면 표시영역, content = 모바일에 맞게 크기 조정, initial = 초기화면 배율, shrink-to-fit=no = 줄임방지 -->
	<link rel="stylesheet" href="css/bootstrap.css"> <!-- 스타일시트 bootstrap.css 참조 -->
	<link rel="stylesheet" href="css/custom.css"> <!-- 참조  -->
	<title>서울교통공사</title>
	<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
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
    <nav class ="navbar navbar-default">   <!-- navbar-색상 -->
        <div class="navbar-header">   <!-- 홈페이지 로고 -->
            <button type="button" class="navbar-toggle collapsed"
                data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
                aria-expand="false">
				<!-- class="navbar-toggle collapsed" : 네비게이션 화면 출력유무-->
				<!-- data-toggle="collapse" : 모바일에서 클릭 시 메뉴 나옴 -->				
                <span class ="icon-bar"></span> <!-- 줄였을때 옆에 짝대기 -->
                <span class ="icon-bar"></span> <!-- 아이콘 이미지 -->
                <span class ="icon-bar"></span>
            </button>
			<a class="navbar-brand" href="index.jsp"><img alt="Brand" src="images/logo.jpg"></a>
            	<!-- bootstrap navbar 기본 메뉴바 -->
                               
        </div>        
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <ul class="nav navbar-nav">       <!-- navbar-nav : 네비게이션 바 메뉴 -->
                <li><a href="index.jsp">메인</a></li>
                <li><a href="boardView.jsp">게시판</a></li>
				<li><a href="apvView.jsp">정보화 사업</a></li>
                <li><a href="reqView.jsp">보안성 검토</a></li>
            </ul>
            <ul class="nav navbar-nav navbar-right">
                <li class="dropdown">
                	<a href="#" class = "dropdown-toggle"
                    	data-toggle="dropdown" role ="button" aria-haspopup="true"
                    	aria-expanded="false">회원관리<span class="caret"></span>
                    </a>
                    <ul class="dropdown-menu">
                    	<li class="active"><a href="update.jsp">회원정보수정</a></li> 
                        <li><a href="logoutAction.jsp">로그아웃</a></li>                  
                    </ul>
                </li>
            </ul>
        <form action="./index.jsp" method="get" class="form-inline my-2 my-lg-0">
			<input type="text" name="search" class="form-control mr-sm-2" type="search" placeholder="내용을 입력하세요." aria-label="Search">
			<button class="btn btn-outline-success my-2 my-sm-0" type="submit">검색</button>
		</form>                
       	</div> 
	</nav>
	<div class="container">
		<form method="post" action="./userUpdate">
			<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th colspan="2"><h4>회원정보수정</h4></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style="width: 110px;"><h5>아이디</h5></td>
						<td><h5><%= stf.getSTF_ID() %></h5>
						<input type="hidden" name="STF_ID" value="<%= stf.getSTF_ID() %>"></td>						
					</tr>
					<tr>
						<td style="width: 110px;"><h5>비밀번호</h5></td>
						<td colspan="2"><input onkeyup="passwordCheckFunction();" class="form-control" id="STF_PW1" type="password" name="STF_PW1" maxlength="20" placeholder="비밀번호를 입력하세요."></td>				
					</tr>		
					<tr>
						<td style="width: 110px;"><h5>비밀번호 확인</h5></td>
						<td colspan="2"><input onkeyup="passwordCheckFunction();" class="form-control" id="STF_PW2" type="password" name="STF_PW2" maxlength="20" placeholder="비밀번호를 다시 입력하세요."></td>				
					</tr>
					<tr>
						<td style="width: 110px;"><h5>이름</h5></td>
						<td colspan="2"><input class="form-control" id="STF_NM" type="text" name="STF_NM" maxlength="30" placeholder="이름을 입력하세요." value="<%= stf.getSTF_NM() %>"></td>				
					</tr>
					<tr>
						<td style="width: 110px;"><h5>전화번호</h5></td>
						<td colspan="2"><input class="form-control" id="STF_PH" type="text" name="STF_PH" maxlength="13" placeholder="전화번호를 입력하세요." value="<%= stf.getSTF_PH() %>"></td>				
					</tr>
					<tr>
						<td style="width: 110px;"><h5>이메일</h5></td>
						<td colspan="2"><input class="form-control" id="STF_EML" type="email" name="STF_EML" maxlength="30" placeholder="이메일을 입력하세요." value="<%= stf.getSTF_EML() %>"></td>				
					</tr>
					<tr>
						<td style="width: 110px;"><h5>부서</h5></td>						
						<td colspan="2">
							<div class="btn-group" data-toggle="buttons">
								<label class="btn btn-primary <% if(stf.getSTF_DEP().equals("기계처")) out.print("active"); %>">
									<input type="radio" name="STF_DEP" autocomplete="off" value="기계처" <% if(stf.getSTF_DEP().equals("기계처")) out.print("checked"); %>>기계처										
								</label>
								<label class="btn btn-primary <% if(stf.getSTF_DEP().equals("정보통신처")) out.print("active"); %>">
									<input type="radio" name="STF_DEP" autocomplete="off" value="정보통신처" <% if(stf.getSTF_DEP().equals("정보통신처")) out.print("checked"); %>>정보통신처											
								</label>
								<label class="btn btn-primary <% if(stf.getSTF_DEP().equals("IT기획처")) out.print("active"); %>">
									<input type="radio" name="STF_DEP" autocomplete="off" value="IT기획처" <% if(stf.getSTF_DEP().equals("IT기획처")) out.print("checked"); %>>IT기획처										
								</label>																
							</div>						
					</tr>
					<tr>
						<td style="text-align: left;" colspan="3"><h5 style="color: red;" id="passwordCheckMessage"></h5><input class="btn btn-primary pull-right" type="submit" value="수정"></td>
					</tr>																														
				</tbody>
			</table>
		</form>
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
</body>
</html>