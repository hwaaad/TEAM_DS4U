<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>" />
<div id="header">
	<div class="container clearFix">
		<h1 id="logo" class="floatleft">
			<a href="${contextPath}/"> <img src="${contextPath }/images/logo.jpg" />
			</a>
		</h1>
		<div id="m-gnb">
			<div class="gnbBtn">
				<a href="#"></a>
				<ul>
					<li></li>
					<li></li>
					<li></li>
				</ul>
			</div>
			<script type="text/javascript">
				$(function(){
					$("#m-gnb .gnbBtn a").click(function(){
						$(this).next("ul").toggleClass("active");
						$("#m-gnb .gnbUl").toggleClass("active");
						return false;
					});
				});
			</script>
			<ul class="gnbUl">
				<li>
					<h2>
						<a lang="en" href="${contextPath}/index.jsp"> Main </a>
					</h2>
				</li>
			 <li>
					<h2>
						<a lang="en" href="${contextPath}/boardView.jsp"> Board </a>
					</h2>
				</li>
				<li>
					<h2>
						<a lang="en" href="${contextPath}/apvView.jsp"> Business </a>
					</h2>
				</li>
			 	<li>
					<h2>
						<a lang="en" href="${contextPath}/reqView.jsp"> Security </a>
					</h2>
				</li>
				<li>
					<h2>
						<a lang="en" href="${contextPath}/alertView.jsp"> Alarm </a>
					</h2>
				</li>
				<li class="memberBtn">
					<c:choose>
						<c:when test="${STF_ID != null }">
							<a lang="en" href="${contextPath}/myPage.jsp" class="btn">MyPage</a>
							<a lang="en" href="${contextPath}/logoutAction.jsp" class="btn">Logout</a>
						</c:when>
						<c:otherwise>
							<a lang="en" href="${contextPath}/login.jsp" class="btn">Login</a>
							<a lang="en" href="${contextPath}/join.jsp" class="btn">Join</a>
						</c:otherwise>
					</c:choose>
				</li>
			</ul>
		</div>
		<nav id="gnb" class="floatleft">
			<ul>
				<li>
					<h2>
						<a lang="en" href="${contextPath}/index.jsp"> Main </a>
					</h2>
				</li>
			 	<li>
					<h2>
						<a lang="en" href="${contextPath}/boardView.jsp"> Board </a>
					</h2>
				</li>
			 	<li>
					<h2>
						<a lang="en" href="${contextPath}/apvView.jsp"> Business </a>
					</h2>
				</li>
				<li>
					<h2>
						<a lang="en" href="${contextPath}/reqView.jsp"> Security </a>
					</h2>
				</li>
				<li>
					<h2>
						<a lang="en" href="${contextPath}/alertView.jsp"> Alarm </a>
					</h2>
				</li>
			</ul>
		</nav>
		<div id="member-nav" class="floatleft">
			<ul>
			<c:choose>
				<c:when test="${STF_ID != null }">
					<li><a lang="en" href="${contextPath}/myPage.jsp" class="btn">MyPage</a></li>
					<li><a lang="en" href="${contextPath}/logoutAction.jsp" class="btn">Logout</a></li>
				</c:when>
				<c:otherwise>
					<li><a lang="en" href="${contextPath}/login.jsp" class="btn">Login</a></li>
					<li><a lang="en" href="${contextPath}/join.jsp" class="btn">Join</a></li>
				</c:otherwise>
			</c:choose>
			</ul>
		</div>
	</div>
</div>
