<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="app.domain.MemberVo" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title>Login</title>
	<link href="../source/css/member/memberInfoModify.css" type="text/css" rel="stylesheet">
	
	<script type="text/javascript" src="https://static.nid.naver.com/js/naverLogin_implicit-1.0.3.js" charset="utf-8"></script>
	<script type="text/javascript" src="http://code.jquery.com/jquery-1.11.3.min.js"></script>
	
</head>
<body>
	<jsp:include page="../source/include/header.jsp"/>
	
	<div class="container">
		<div class="container-title">
			<h1>MyPage</h1>
		</div>
		<div class="inner-container">
			<jsp:include page="../source/include/mypageNavi.jsp"/>
			<div class="btn-area">
				<button type="button" class="btn-QnAList btn1 clicked" onclick="location.href='${pageContext.request.contextPath}/member/memberInfo.do';">내 정보</button>
				<button type="button" class="btn-QnA btn1"  onclick="location.href='${pageContext.request.contextPath}/member/memberInfoModify.do';" >내 정보 수정</button>
				<button type="button" class="btn-QnA btn1" onclick="location.href='${pageContext.request.contextPath}/member/memberResign.do';">회원 탈퇴</button>
			</div>
			<div class="member-info">
				<div class="tab-name-area">
					<span> 회원 정보 </span>
				</div>
				<div class="login-body">
					<table class="info-cont">
						<tr>
							<td>
								아이디
							</td>
							<td>
								${mv.mbid}
							</td>
						</tr>
						<tr>
							<td>
								닉네임
							</td>
							<td>
								${mv.mbname}
							</td>
						</tr>
						<tr>
							<td>
								이메일
							</td>
							<td>
								${mv.mbemail}
							</td>
						</tr>
						<tr>
							<td>
								포인트
							</td>
							<td>
								${pv.rmpt}p
							</td>
						</tr>
					</table>
					<div style="color: #6d6b70;">
						* 회원가입시 1000p 적립<br>
						* 게시글 1개 작성시 1000p 적립<br>
						* 리뷰 1개 작성시 1000p 적립<br>
						* 댓글 1개 작성시 1000p 적립
					</div>
				</div>
				<div class="info-btn">
					<input type="button" class="btn" value="수정" onclick="location.href='${pageContext.request.contextPath}/member/memberInfoModify.do';">
					<input type="button" class="btn" value="탈퇴" onclick="location.href='${pageContext.request.contextPath}/member/memberResign.do';">
				</div>
			</div>
		</div>
	</div>
	<jsp:include page="../source/include/footer.jsp"/>
</body>
</html>