<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
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
		<div class="back-btn">
			<input type="button" style="height: 33px;" name="btn" value="≪" onclick="location.href='${pageContext.request.contextPath}/member/memberLogin.do';">
		</div>
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
						<input type="text" name="memberEmail" id="memberEmail" placeholder=" 가입한 E-mail 입력">
					</div>
					<div class="pass_text findid" id="memberIdView" style="display:none;">
						아이디는 <span id="memberId"></span> 입니다.
					</div>
					<div class="error_text item_style" id="checkmsg" style="display:none;">입력되지 않은 부분이 있습니다. 확인해주세요</div>
					<div class="error_text item_style" id="checkmsg2" style="display:none;">일치하는 이메일이 없습니다. 확인해주세요</div>
					<div class="login-btn">
						<input type="button" name="btn" value="아이디 찾기" onclick="check();">
					</div>	
					<div class="login-btn" id="pwfind" style="display:none">
						<input type="button" name="btn" value="비밀번호 찾기" onclick="location.href='${pageContext.request.contextPath}/member/memberPwdFind.do'">
					</div>
				</form>
			</div>
		</div>
	</div>
	<script>
	function check(){
		$("#checkmsg").css("display","none");
		$("#checkmsg2").css("display","none");
		$("#memberIdView").css("display","none");
		if($("#memberEmail").val()==""){
			$("#checkmsg").css("display","");
			$("#memberEmail").focus();
			return;
		}else{
			findId();
		}
	}
	function findId(){
		var email = $("#memberEmail").val();
		$.ajax({
			type : "post",
			url: "${pageContext.request.contextPath}/member/memberIdFindAction.do",
// 			url: "./memberIdFindEmailCheck.jsp",
			data :{"memberEmail":email},
			dataType: "json",
			success : function(data) {
				if(data.value == 0){
					$("#checkmsg2").css("display","");
					$("#memberEmail").focus();
				}else{
					$("#memberIdView").css("display","");
					$("#memberId").empty();
					$("#memberId").html(data.memberId);
					$("#memberId").css("font-size","20px");
					$("#pwfind").css("display","")
					
				}
			}
		});  
		
	}
	</script>
</body>
</html>