<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title>Insert title here</title>
	<link href="../source/css/member/memberInfoModify.css" type="text/css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>

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
				<button type="button" class="btn-QnAList btn1" onclick="location.href='${pageContext.request.contextPath}/member/memberInfo.do';">내 정보</button>
				<button type="button" class="btn-QnA btn1"  onclick="location.href='${pageContext.request.contextPath}/member/memberInfoModify.do';" >내 정보 수정</button>
				<button type="button" class="btn-QnA btn1  clicked" onclick="location.href='${pageContext.request.contextPath}/member/memberResign.do';">회원 탈퇴</button>
			</div>
			<div class="member-info">
				<div class="tab-name-area">
					<span> 회원 탈퇴 </span>
				</div>
				<div class="join-body">
					<form name="frm">
						<div class="error_text item_style" id="pwdmsg" style="display:none;">일치하지 않습니다. 다시 확인해주세요.</div>
						<div class="pass_text item_style" id="pwdmsg2" style="display:none;">확인되었습니다.</div>
						<div class="join-id">
							<input type="text" name="memberPwd" id="memberPwd" maxlength="30" placeholder=" 비밀번호를 입력하세요">
							<input type="button" class="btn" id="btn" value="확인" onclick="PwdCheck();">
							<input type="hidden" name="pwdYN" id="pwdYN" value="N">
						</div>	
						<div class="join-btn">
						<div class="error_text item_style" id="checkmsg" style="display:none;">작성되지 않은 부분이 있습니다. 다시 확인해주세요</div>
						<div class="error_text item_style" id="checkmsg2" style="display:none;">비밀번호가 확인되지 않았습니다. 비밀번호 작성 후 확인버튼을 눌러주세요.</div>
							<input type="button" class="btn" value="회원탈퇴" onclick="Resigncheck();">
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
	<script>
		function PwdCheck(){
			var pwd = document.frm.memberPwd.value;
			$.ajax({
				type : "post",
				url : "${pageContext.request.contextPath}/member/Pwdcheck.do",
	// 			url : "./getMemberinfo.jsp",
				data : {"currentPwd":pwd,"mbno":${mbno}},
				dataType : "json",
				success : function(data){
					if(data.value == 1){
						document.getElementById("pwdmsg").style.display = "none";
						document.getElementById("pwdmsg2").style.display = "";
						document.getElementById("pwdYN").value = "Y";
					}else{
	// 					alert("사용할 수 없는 아이디입니다.");
						document.getElementById("pwdmsg").style.display = "";
						document.getElementById("pwdmsg2").style.display = "none";
						document.getElementById("pwdYN").value = "N";
					}
				},
				error : function(){
					alert("실패");
				}
			});
			
		}
		function Resigncheck(){
			var fm = document.frm;
			document.getElementById("pwdmsg").style.display = "none";
			document.getElementById("checkmsg").style.display = "none";
			if(fm.memberPwd.value ==""){
				fm.memberPwd.focus();
				document.getElementById("checkmsg").style.display = "";
				return;
			}else if ($("#pwdYN").val() == "N"){
				document.getElementById("checkmsg2").style.display = "";
				fm.currentPwd.focus();
				return;	
			}else if ($("#pwdck").val() != $("#currentPwd").val()){
				document.getElementById("checkmsg3").style.display = "";
				fm.currentPwd.focus();
				return;	
			}else if ($("#nameYN").val() == "N"){
				document.getElementById("checkmsg2").style.display = "";
				fm.memberName.focus();
				return;	
			}
			var result = confirm("회원 탈퇴를 진행하시겠습니까? 탈퇴에 성공하면 복구하지 못합니다.")
			if(result == true){
				fm.action = "${pageContext.request.contextPath}/member/memberResignAction.do";
				fm.method = "post";
				fm.submit();
				return;
			}else{
				return;
			}
		}
	</script>
	<jsp:include page="../source/include/footer.jsp"/>
</body>
</html>