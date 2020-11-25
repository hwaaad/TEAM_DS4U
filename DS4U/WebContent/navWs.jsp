<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="stf.StfDAO" %>
<%@ page import="stf.StfDTO" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="contextPath" value="<%=request.getContextPath() %>"/>

<div id="wsNav">
   <div id="navContainer">
      <h1 id="logo">
         <a href="${contextPath}/index.jsp"> <img src="${contextPath}/images/logo.jpg" /></a>
      </h1>
      
      <div id="aboutProfile">
         <a href="${contextPath }/myPage.jsp">
            <img alt="나의 프로필 사진" src="${contextPath }/images/profileImage.png" />
         </a>
         <a href="${contextPath }/myPage.jsp"><p>${STF_ID}님</p></a>
      </div>
      <!-- 로그아웃버튼 -->
      <div>
         <form action="${contextPath }/logoutAction.jsp" method="post">
            <input type="submit" value="로그아웃" id="logoutBtn">
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
         <h3>
         <a></a>
         </h3>
      </div>
      <div id="boardDiv" class="navListDiv">
         <h3>
         <a></a>
         </h3>
      </div>
      <div id="boardDiv" class="navListDiv" style="text-align: center;">
         <h3>
         <a href="${contextPath}/index.jsp">메인</a>
         </h3>
      </div>
      <div id="boardDiv" class="navListDiv">
         <h3>
         <a></a>
         </h3>
      </div>
      <div id="boardDiv" class="navListDiv" style="text-align: center;">
         <h3>
            <a href="${contextPath}/boardView.jsp">게시판</a>
            <a href="#" class="arrowBtn">
               <i class="fas fa-angle-down"></i>
            </a>
         </h3>
         <ul hidden="true">
            <li><a href="${contextPath}/#">공지사항</a></li>
            <li><a href="${contextPath}/boardView.jsp">자유게시판</a></li>
         </ul>
      </div>
      <div id="boardDiv" class="navListDiv">
         <h3>
            <a></a>
         </h3>
      </div>
      <div id="boardDiv" class="navListDiv" style="text-align: center;">
         <h3>
            <a href="${contextPath}/apvView.jsp">정보화 사업</a>
            <a href="#" class="arrowBtn">
                  <i class="fas fa-angle-down"></i>
            </a>
         </h3>
         <ul hidden="true">
            <li><a href="${contextPath}/apvWrite.jsp">새 정보화 사업 등록</a></li>
            <li><a href="${contextPath}/apvView.jsp">정보화 사업 내역</a></li>
         </ul>
      </div>
      <div id="boardDiv" class="navListDiv">
         <h3>
         <a></a>
         </h3>
      </div>
      <div id="boardDiv" class="navListDiv" style="text-align: center;">
         <h3>
            <a href="${contextPath}/reqView.jsp">보안성 검토</a>
            <a href="#" class="arrowBtn">
                  <i class="fas fa-angle-down"></i>
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
         <h3>
         <a></a>
         </h3>
      </div>      
      <div id="boardDiv" class="navListDiv" style="text-align: center;">
         <h3>
         <a href="${contextPath}/stfManage.jsp">회원관리</a>
         </h3>
      </div>
      <div id="boardDiv" class="navListDiv">
         <h3>
         <a></a>
         </h3>
      </div>
      <div id="boardDiv" class="navListDiv">
         <h3>
         <a></a>
         </h3>
      </div>
      <div id="mainDiv">
         <h3>
         <a href="${contextPath}/"><i class="fas fa-angle-left"></i> 홈으로</a>
         </h3>
      </div>
      
   </div>
<%---------------------------------------------회원정보 모달 ----------------------------------------------------%>
      <div id="memberInfoModal" class="attachModal">
         <div class="header">
                  <!--파도 위 내용-->
                  <div class="inner-header flex">
                     <div class="loginBox-Head">
                        <h3 style='font-weight: bolder; font-size: 24px'>회원정보</h3>
                     </div>
                  </div>
         </div><!--header end-->
         
         <br>
         <div class="modalBody" id="memberInfoBody" align="center">
               </div>
         </div> <!-- end modalBody -->
      </div><!-- end memberInfoModal -->
</div>