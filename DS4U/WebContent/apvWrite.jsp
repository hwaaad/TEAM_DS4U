<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="stf.StfDTO" %>
<%@ page import="stf.StfDAO" %>
<%@ page import="apv.ApvDTO" %>
<%@ page import="apv.ApvDAO" %>
<%@ include file="head.jsp" %>
<!DOCTYPE html>
<html>
<%
	String APV_SQ=null;
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
	ApvDTO apv = new ApvDAO().getApv(APV_SQ);
%>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/headerWs.css"/>
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/navWs.css"/>
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/apv.css"/>
	<link rel="stylesheet" type="text/css" href="${contextPath}/css/modal.css"/>
	<link rel="stylesheet" href="http://code.jquery.com/ui/1.8.18/themes/base/jquery-ui.css" type="text/css" />  
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>  
	<script src="http://code.jquery.com/ui/1.8.18/jquery-ui.min.js"></script>
	<title>서울교통공사</title>
	<script src="js/bootstrap.js"></script>
	<script type="text/javascript">
    $(document).ready(function () {
            $.datepicker.setDefaults($.datepicker.regional['ko']); 
            $( "#startDate" ).datepicker({
                 changeMonth: true, 
                 changeYear: true,
                 nextText: '다음 달',
                 prevText: '이전 달', 
                 dayNames: ['일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일'],
                 dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'], 
                 monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
                 monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
                 dateFormat: "yy/mm/dd",
                 onClose: function( selectedDate ) {    
                      //시작일(startDate) datepicker가 닫힐때
                      //종료일(endDate)의 선택할수있는 최소 날짜(minDate)를 선택한 시작일로 지정
                     $("#endDate").datepicker( "option", "minDate", selectedDate );
                     $("#APV_STT_DATE").datepicker( "option", "minDate", selectedDate );
                     $("#APV_FIN_DATE").datepicker( "option", "minDate", selectedDate );
                 }    
 
            });
            $( "#endDate" ).datepicker({
                 changeMonth: true, 
                 changeYear: true,
                 nextText: '다음 달',
                 prevText: '이전 달', 
                 dayNames: ['일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일'],
                 dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'], 
                 monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
                 monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
                 dateFormat: "yy/mm/dd",
                 onClose: function( selectedDate ) {    
                     // 종료일(endDate) datepicker가 닫힐때
                     // 시작일(startDate)의 선택할수있는 최대 날짜(maxDate)를 선택한 시작일로 지정
                     $("#startDate").datepicker( "option", "maxDate", selectedDate );
                     $("#APV_STT_DATE").datepicker( "option", "maxDate", selectedDate );
                     $("#APV_FIN_DATE").datepicker( "option", "maxDate", selectedDate );
                 }    
 
            });    
	    });
	</script>


</head>

<body>
	<%@ include file="/headerWs.jsp" %>
	<%@ include file="/navWs.jsp" %>
	<%@ include file="/modal.jsp" %>

 	<div id="wsBody">
		<div id="wsBodyContainer">
			<h3>정보화 사업</h3>
			<h4>새 정보화 사업 등록</h4>
			<div id="boardInner">
				<div id="inputWrap">
				<div class="container">
					<form method="post" action="./apvWrite" enctype="multipart/form-data">
					<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
				<thead></thead>



				<tbody>
					<tr>
						<td style="width: 130px; text-align: left;"><h5>1. 사업명</h5></td>
						<td><textarea class="form-control" cols="100" name="APV_NM" id="APV_NM" maxlength="64" placeholder="사업명을 입력하세요."></textarea></td>						
					</tr>
					<tr>
						<td style="width: 130px; text-align: left;"><h5>2. 사업 기간</h5></td>
						<td>
						<input type="text" name="startDate" id="startDate"> ~ <input type="text" name="endDate" id="endDate">
						<input type="hidden" name="APV_DATE" id="APV_DATE">			
						</td>			
					</tr>		
					<tr>
						<td style="width: 130px; text-align: left;"><h5>3. 사업 시작일</h5></td>
						<td>
						<input type="text" name="APV_STT_DATE" id="APV_STT_DATE">
						</td>
					</tr>
					<tr>
						<td style="width: 130px; text-align: left;"><h5>4. 사업 종료일</h5></td>
						<td>
						<input type="text" name="APV_FIN_DATE" id="APV_FIN_DATE">
						</td>				
					</tr>
					<tr>
						<td style="width: 130px; text-align: left;"><h5>5. 소요 예산</h5></td>
						<td><textarea class="form-control" cols="100" name="APV_BUDGET" id="APV_BUDGET" maxlength="15" placeholder="소요 예산(원)을 입력하세요."></textarea></td>					
					</tr>					
					<tr>
						<td style="width: 130px;"><h5>6. 담당자</h5></td>
						<td><h5><%=stf.getSTF_NM() %></h5>
						<input type="hidden" name="STF_NM" value="<%=stf.getSTF_NM()%>">	
						<input type="hidden" name="STF_ID" value="<%= stf.getSTF_ID() %>"></td>						
					</tr>
					<tr>
						<td style="width: 130px; text-align: left;"><h5>7. 연락처</h5></td>
						<td><h5><%=stf.getSTF_PH() %></h5>
						<input type="hidden" name="APV_PHONE" value="<%=stf.getSTF_PH() %>"></td>													
					</tr>
					<tr>
						<td style="width: 130px; text-align: left;"><h5>8. 사업방침번호</h5></td>
						<td><textarea class="form-control" cols="100" name="APV_POLICY_SQ" id="APV_POLICY_SQ" maxlength="30" placeholder="사업방침번호를 입력하세요."></textarea></td>									
					</tr>
					<tr>
						<td style="width: 130px;"><h5>9. 파일 첨부</h5></td>
						<td colspan="2">
							<div id="uploadArea" class="floatleft">
								<span>파일을 업로드하세요.</span>
								<input multiple="multiple" id="file" type="file" name="APV_FILE" class="file">
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
						</td>		
					<tr>
						<td style="text-align: right;" colspan="2"><input class="btn" type="submit" value="등록"><a a class="btn" type="submit" href="apvView.jsp">취소</a></td>	
					</tr>																														
				</tbody>
			</table>			
		</form>
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
	<script type="text/javascript">
		$(function () {
			$("#APV_STT_DATE").datepicker({
		        dateFormat:"yy/mm/dd",
		        dayNamesMin:["일","월","화","수","목","금","토"],
		        monthNames:["1월","2월","3월","4월","5월","6월","7월","8월","9월","10월","11월","12월"],
		        
		    });
			$("#APV_FIN_DATE").datepicker({
		        dateFormat:"yy/mm/dd",
		        dayNamesMin:["일","월","화","수","목","금","토"],
		        monthNames:["1월","2월","3월","4월","5월","6월","7월","8월","9월","10월","11월","12월"],
		        
		    });
		    
		});
	</script>
</body>
</html>