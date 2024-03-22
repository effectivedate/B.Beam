<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title>Login</title>
	<link href="../source/css/member/memberLogin.css" type="text/css" rel="stylesheet">
	
	<script type="text/javascript" src="https://static.nid.naver.com/js/naverLogin_implicit-1.0.3.js" charset="utf-8"></script>
	<script type="text/javascript" src="http://code.jquery.com/jquery-1.11.3.min.js"></script>
	
</head>
<body>
	<div class="container">
		<div class="login">
			<div class="login-logo">
				<h1 class="logo">
					<a class="svgLogo" href="../index.jsp">
						<img src="../source/images/logo4.png" width="250" height="130" alt="메인화면으로 이동">
					</a>
				</h1>
			</div>
			<div class="login-body">
				<form name="frm" id="login-form">
					<div class="body-id">
						<input type="text" name="memberId" id="memberId" autofocus="autofocus" placeholder=" ID">
					</div>
					<div class="body-pwd">
						<input type="password" name="memberPwd" id="memberPwd" placeholder=" PASSWORD">
					</div>
					<div class="error_text item_style" id="checkmsg" style="display:none;">입력되지 않은 부분이 있습니다. 확인해주세요</div>
					<div class="error_text item_style" id="checkmsg2" style="display:none;">아이디 또는 비밀번호가 일치하지 않습니다. 확인해주세요</div>
					<div class="login-btn">
						<input type="button" id="login-btn" value="Login" onclick="check();">
					</div>
					<div class="login-btn">
							<input type="button" value="네이버로그인" onclick="check();" style="width:49%; background: #059905;">
							<input type="button" value="카카오로그인" onclick="check();" style="width:49%; background: #dbdb08;">
							
							<!-- 네이버 로그인 버튼 노출 영역 -->
							<div id="naver_id_login"></div>
							<!-- //네이버 로그인 버튼 노출 영역 -->
							
					</div>
					<br>
					<div class="text-join">
						<a class="" href="${pageContext.request.contextPath}/member/memberIdFind.do">아이디 찾기</a> /
						<a class="" href="${pageContext.request.contextPath}/member/memberPwdFind.do">비밀번호 찾기</a>
					</div>
					<div class="text-join">
					아직 회원이 아니신가요?
						<a class="" href="${pageContext.request.contextPath}/member/memberJoin.do">회원가입</a>
					</div>
				</form>
			</div>
		</div>
	</div>
	
	
	
	<script type="text/javascript">
	function check(){
		$("#checkmsg").css("display","none");
		$("#checkmsg2").css("display","none");
		if($("#memberId").val()==""){
			$("#checkmsg").css("display","block");
			$("#memberId").focus();
			return;
		}else if($("#memberPwd").val()==""){
			$("#checkmsg").css("display","block");
			$("#memberPwd").focus();
			return;
		}else{
			login();
			
		}
	}
	function login(){
		var id = $("#memberId").val();
		var pwd = $("#memberPwd").val();
		$.ajax({
			type : "post",
			url: "${pageContext.request.contextPath}/member/memberLoginAction.do",
			data :{"memberId":id,"memberPwd":pwd},
			dataType: "json",
			success : function(data) {
				if(data.value == 0){
					$("#checkmsg2").css("display","block");
					$("#memberPwd").focus();
				}else{
					if(data.loginCheck != 'N'){
						alert(data.loginCheck);
						return;
					}else{
						if(${not empty manager}){
							location.href='${pageContext.request.contextPath}/index.jsp';
						}else if(${not empty prevURL}){
							location.href='${prevURL}';
						}else{
							location.href='${pageContext.request.contextPath}/index.jsp';					
						}
					}
				}
			}
		});  
	}
	  	var naver_id_login = new naver_id_login("GBMgKClIDVZzjMHwAaNw", "http://localhost:8080/teamProject_main/Home.jsp");
	  	var state = naver_id_login.getUniqState();
	  	naver_id_login.setButton("white", 3,40);
	  	naver_id_login.setDomain("http://localhost:8080/teamProject_main/member/memberLogin.jsp");
	  	naver_id_login.setState(state);
	  	naver_id_login.setPopup();
	  	naver_id_login.init_naver_id_login();
	  	
	  	$(document).ready(function(){
	  		
	  		$("#memberId, #memberPwd").on("keyup", function(e){
	  			if(e.keyCode == 13){
	  				check();
	  			}
	  		});	  		
	  	});

	  	
	</script>
  
</body>
</html>