<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="stf.StfDAO" %>
<%@ page import="stf.StfDTO" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<link rel="stylesheet" type="text/css" href="css/glyphicon.css"/>
<c:set var="contextPath" value="<%=request.getContextPath() %>"/>
	<script type="text/javascript">
		function getUnread(){
			$.ajax({
				type : 'POST',
				url : "./chatUnread",
				data : {
					STF_ID : encodeURIComponent(${STF_ID}),
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
<div id="wsNav">
   <div id="navContainer">
      <h1 id="logo">
         <a href="${contextPath}/index.jsp"> <img src="${contextPath}/images/logo.jpg" /></a>
      </h1>
      
      <div id="aboutProfile">
         <a href="${contextPath }/myPage.jsp">
         <%
         	if (stf.getSTF_PF().equals("")) {
         %>
            <img class="media-object img-circle" id="profileIMG" style="border-radius: 1%; max-width: 170px; max-height: 170px; margin: margin: 0 auto; overflow: hidden;" src="${contextPath}/images/profileImage.png"/>
         <%
         	} else {
         %>
         	<img class="media-object img-circle" id="profileIMG" style="border-radius: 1%; max-width: 170px; max-height: 170px; margin: margin: 0 auto; overflow: hidden;" src="${contextPath}/profile/<%= stf.getSTF_PF() %>"/>
         <%
         	}
         %> 
         </a>
         <a href="${contextPath }/myPage.jsp"><p><i class="glyphicon glyphicon-user"></i> ${STF_ID}님</p></a>
      </div>
      <!-- 로그아웃버튼 -->
      <div>
         <form action="${contextPath }/logoutAction.jsp" method="post">
            <input type="submit" value="로그아웃" id="logoutBtn" onclick="return confirm('로그아웃 하시겠습니까?');">
         </form>
      </div>
      <script>
         $(function(){
            $(".navListDiv h3 .arrowBtn").on("click",function(){
               $(this).parent().next("ul").toggle();
            });
            
         });
      </script>
      <div id="boardDiv" class="navListDiv">
         <h3></h3>
      </div>
      <div id="boardDiv" class="navListDiv">
         <h3></h3>
      </div>
      <div id="boardDiv" class="navListDiv" style="text-align: center;">
         <h3>
         <a href="${contextPath}/index.jsp">메인</a>
         </h3>
      </div>
      <div id="boardDiv" class="navListDiv">
         <h3></h3>
      </div>
      <div id="boardDiv" class="navListDiv" style="text-align: center;">
         <h3>
            <a href="${contextPath}/boardView.jsp">커뮤니티</a>
            <a href="#" class="arrowBtn">
               <i class="glyphicon glyphicon-chevron-down"></i>
            </a>
         </h3>
         <ul hidden="true">
            <li><a href="${contextPath}/noticeView.jsp">공지사항</a></li>
            <li><a href="${contextPath}/boardView.jsp">자유게시판</a></li>
            <li>----------------</li>
            <li><a href="${contextPath}/box.jsp">채팅 <span id="unread" class="label label-info"></span></a></li>
            <li><a href="${contextPath}/find.jsp">사원찾기</a></li>
         </ul>
      </div>
      <div id="boardDiv" class="navListDiv">
         <h3></h3>
      </div>
      <div id="boardDiv" class="navListDiv" style="text-align: center;">
         <h3>
            <a href="${contextPath}/apvView.jsp">정보화 사업</a>
            <a href="#" class="arrowBtn">
                  <i class="glyphicon glyphicon-chevron-down"></i>
            </a>
         </h3>
         <ul hidden="true">
            <li><a href="${contextPath}/apvWrite.jsp">새 정보화 사업 등록</a></li>
            <li><a href="${contextPath}/apvView.jsp">정보화 사업 내역</a></li>
         </ul>
      </div>
      <div id="boardDiv" class="navListDiv">
         <h3></h3>
      </div>
      <div id="boardDiv" class="navListDiv" style="text-align: center;">
         <h3>
            <a href="${contextPath}/reqView.jsp">보안성 검토</a>
            <a href="#" class="arrowBtn">
                  <i class="glyphicon glyphicon-chevron-down"></i>
            </a>
         </h3>
         <ul hidden="true">
            <li><a href="${contextPath}/reqWrite.jsp">검토 의뢰하기</a></li>
            <li><a href="${contextPath}/reqView.jsp">진행중인 보안성 검토 현황</a></li>
            <li><a href="${contextPath}/fin_reqView.jsp">완료된 보안성 검토</a></li>
            <li><a href="${contextPath}/alertView.jsp">보안성 검토 알림</a></li>
         </ul>
      </div>
      <div id="boardDiv" class="navListDiv">
         <h3></h3>
      </div>      
      <div id="boardDiv" class="navListDiv" style="text-align: center;">
         <h3>
         	<a href="${contextPath}/stfManage.jsp">회원관리</a>
         </h3>
      </div>
      <div id="boardDiv" class="navListDiv">
         <h3></h3>
      </div>
      <div id="boardDiv" class="navListDiv">
         <h3></h3>
      </div>
      <div id="mainDiv">
         <h3>
         	<a href="${contextPath}/"><i class="fas fa-angle-left"></i><i class="glyphicon glyphicon-home"></i> 홈으로</a>
         </h3>
      </div>      
   </div>
   
		<script type="text/javascript">
			$(document).ready(function(){
				getUnread();
				getInfiniteUnread();
			});
		</script>

</div>
</html>