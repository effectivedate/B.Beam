<%@ page language="java" 
    pageEncoding="UTF-8"%>
    
<link href="../source/css/home.css" type="text/css" rel="stylesheet">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<header class="header">
	<div class="header-logo">
		<h1 class="logo">
			<a class="svgLogo" href="${pageContext.request.contextPath}/">
				<img src="${pageContext.request.contextPath}/source/images/logo4.png" width="150" height="80" alt="메인화면으로 이동">
					
			</a>
		</h1>
	</div>
	<div class="menu">
		<ul class="depth1">
			<li>
				<a href="${pageContext.request.contextPath}/contents/contentsList.do">컨텐츠</a>
			</li>
			<li>
				<a href="${pageContext.request.contextPath}/contents/contentsRanking.do">TOP10</a>
			</li>
			<li>
				<a href="${pageContext.request.contextPath}/board/galleryList.do">갤러리</a>
			</li>
			<li>
				<c:choose>
					<c:when test="${not empty manager}">
						<a href="${pageContext.request.contextPath}/report/report.do">관리자페이지</a>
					</c:when>
					<c:otherwise>
						<a href="${pageContext.request.contextPath}/member/memberInfo.do">마이페이지</a>
					</c:otherwise>
				</c:choose>
			</li>
			<li>
				<a href="${pageContext.request.contextPath}/board/noticeList.do">고객지원</a>
			</li>
		</ul>
	</div>
	<c:choose>
		<c:when test="${not empty mbno}">
			<div class="logout">
				<a class="logoutbutton" href="${pageContext.request.contextPath}/member/memberLogout.do">
					<img src="${pageContext.request.contextPath}/source/images/logout.png">
					<br>로그아웃
				</a>
			</div>
		</c:when>
		<c:otherwise>
			<div class="login">
				<a class="loginbutton" href="${pageContext.request.contextPath}/member/memberLogin.do">
					<img src="${pageContext.request.contextPath}/source/images/login.png">
					<br>로그인/회원가입
				</a>
			</div>
		</c:otherwise>
	</c:choose>
</header>