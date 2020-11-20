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
	boolean emailChecked = new StfDAO().getUserEmailChecked(STF_ID);
	if (emailChecked == false) {
		session.setAttribute("messageType", "오류 메시지");
		session.setAttribute("messageContent", "이메일 인증이 필요합니다.");
		response.sendRedirect("emailSendConfirm.jsp");
		return;
	}
	StfDTO stf = new StfDAO().getUser(STF_ID);
	String BOARD_SQ = null;
	if (request.getParameter("BOARD_SQ") != null) {
		BOARD_SQ = (String) request.getParameter("BOARD_SQ");
	}
	if (BOARD_SQ == null || BOARD_SQ.equals("")) {
		session.setAttribute("messageType", "오류 메시지");
		session.setAttribute("messageContent", "게시물을 선택해주세요.");
		response.sendRedirect("index.jsp");
		return;	
	}
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
                <li class="active"><a href="boardView.jsp">게시판</a></li>
            	<li><a href="apvView.jsp">정보화사업</a></li>
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
		<form method="post" action="./boardReply" enctype="multipart/form-data">
			<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th colspan="3"><h4>답변 작성 작성</h4></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style="width: 110px;"><h5>아이디</h5></td>
						<td><h5><%= stf.getSTF_ID() %></h5>
						<input type="hidden" name="STF_ID" value="<%= stf.getSTF_ID() %>">
						<input type="hidden" name="BOARD_SQ" value="<%= BOARD_SQ %>"></td>							
					</tr>
					<tr>
						<td style="width: 110px;"><h5>글 제목</h5></td>
						<td><input class="form-control" type="text" maxlength="64" name="BOARD_NM" placeholder="글 제목을 입력하세요."></td>						
					</tr>
					<tr>
						<td style="width: 110px;"><h5>글 내용</h5></td>
						<td><textarea class="form-control" rows="10" name="BOARD_TXT" maxlength="255" placeholder="글 내용을 입렵하세요."></textarea></td>					
					</tr>											
					<tr>
						<td style="width: 110px;"><h5>파일 업로드</h5></td>
						<td colspan="2">
							<input type="file" name="BOARD_FILE" class="file">
							<div class="input-group	col-xs-12">
								<span class="input-group-addon"><i class="glyphicon glyphicon-picture"></i></span>
								<input type="text" class="form-control input-lg" disabled placeholder="파일을 업로드하세요.">
								<span class="input-group-btn">
									<button class="browse btn btn-primary input-lg" type="button"><i class="glyphicon glyphicon-search"></i>파일찾기</button>
								</span>
							</div>
						</td>				
					</tr>		

					<tr>
						<td style="text-align: left;" colspan="3"><h5 style="color: red;"></h5><input class="btn btn-primary pull-right" type="submit" value="등록"></td>
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
	<%
		if (STF_ID != null) {
	%>
		<script type="text/javascript">
			$(document).ready(function() {
				getUnread();
				getInfiniteUnread();
			});
		</script>	
	<%
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