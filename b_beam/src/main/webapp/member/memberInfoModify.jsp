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
				<button type="button" class="btn-QnA btn1  clicked"  onclick="location.href='${pageContext.request.contextPath}/member/memberInfoModify.do';" >내 정보 수정</button>
				<button type="button" class="btn-QnA btn1" onclick="location.href='${pageContext.request.contextPath}/member/memberResign.do';">회원 탈퇴</button>
			</div>
			<div class="member-info">
				<div class="tab-name-area">
					<span> 회원 정보 수정 </span>
				</div>
				<div class="join-body">
					<form name="frm">
						<div class="error_text item_style" id="pwdmsg" style="display:none;">일치하지 않습니다. 다시 확인해주세요.</div>
						<div class="pass_text item_style" id="pwdmsg2" style="display:none;">비밀번호 확인되었습니다.</div>
						<div class="join-id">
							<input type="text" name="currentPwd" id="currentPwd" maxlength="30" placeholder=" 현재 비밀번호">
							<input type="button" class="infobtn" value="확인" onclick="PwdCheck()">
						<input type="hidden" name="pwdck" id="pwdck" value="">
						<input type="hidden" name="pwdYN" id="pwdYN" value="N">
						</div>	
						<div class="join-pwd">
							<input type="password" name="memberPwd" placeholder=" 변경 비밀번호">
						</div>
						<div class="error_text item_style" id="pwdmsg3" style="display:none;">일치하지 않습니다. 다시 확인해주세요.</div>
						<div class="join-pwd2">
							<input type="password" name="memberPwd2" placeholder=" 변경 비밀번호 확인">
						</div>
						<div class="error_text item_style" id="namemsg" style="display:none;">사용할 수 없는 닉네임 입니다. 다른 닉네임을 입력해 주세요.</div>
						<div class="pass_text item_style" id="namemsg2" style="display:none;">사용할 수 있는 닉네임 입니다.</div>
						<div class="error_text item_style" id="namemsg3" style="display:none;">특수문자를 제외한 최소2 최대6인 닉네임을 입력해주세요.</div>
						<div class="join-name">
							<input type="text" name="memberName" id="memberName" placeholder=" 닉네임">
							<input type="button" class="infobtn" value="중복확인" onclick="NickCheck()">
						<input type="hidden" name="nameck" id="nameck" value="">
						<input type="hidden" name="nameYN" id="nameYN" value="N">
						</div>
						<div class="error_text item_style" id="checkmsg" style="display:none;">작성되지 않은 부분이 있습니다. 다시 확인해주세요</div>
						<div class="error_text item_style" id="checkmsg2" style="display:none;">중복확인이 안된 부분이 있습니다. 다시 확인해주세요</div>
						<div class="error_text item_style" id="checkmsg3" style="display:none;">중복확인된 정보와 현재 작성된 정보가 다릅니다. 확인해주세요</div>
						<div class="join-btn">
							<input type="button" class="infobtn" value="수정하기" onclick="modicheck();">
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
	<jsp:include page="../source/include/footer.jsp"/>
	<script>
	function PwdCheck(){
		var pwd = document.frm.currentPwd.value;
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
					document.getElementById("pwdck").value = pwd;
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
	function NickCheck(){
		var nick = document.frm.memberName.value;
    	var reg = /^[a-z0-9가-힣][a-z0-9가-힣]{1,5}$/;
    	if(!reg.test(nick)){
			document.getElementById("namemsg").style.display = "none";
			document.getElementById("namemsg2").style.display = "none";
			document.getElementById("namemsg3").style.display = "";
			return;
		}
		$.ajax({
			type : "post",
			url : "${pageContext.request.contextPath}/member/memberNickCheck.do",
			data : {"memberName" : nick},
			dataType : "json",
			success : function(data){
				if(data.value == 0){
// 					alert("사용할 수 있는 닉네임입니다.");
					document.getElementById("namemsg").style.display = "none";
					document.getElementById("namemsg2").style.display = "";
					document.getElementById("namemsg3").style.display = "none";
					document.getElementById("nameck").value = nick;
					document.getElementById("nameYN").value = "Y";
				}else{
// 					alert("사용할 수 없는 닉네임입니다.");
					document.getElementById("namemsg").style.display = "";
					document.getElementById("namemsg2").style.display = "none";
					document.getElementById("namemsg3").style.display = "none";
					document.getElementById("nameYN").value = "N";
				}
			},
			error : function(){
				alert("실패2");
			}
		});
		
	}
	
	</script>
	
	<script>
	function modicheck(){
		var fm = document.frm;
		document.getElementById("pwdmsg3").style.display = "none";
		document.getElementById("checkmsg").style.display = "none";
		document.getElementById("checkmsg2").style.display = "none";
		document.getElementById("checkmsg3").style.display = "none";
		if(fm.currentPwd.value ==""){
			fm.currentPwd.focus();
			document.getElementById("checkmsg").style.display = "";
			return;
		}else if (fm.memberPwd.value ==""){
			fm.memberPwd.focus();
			document.getElementById("checkmsg").style.display = "";
			return;		
		}else if (fm.memberPwd2.value ==""){
			fm.memberPwd2.focus();
			document.getElementById("checkmsg").style.display = "";
			return;		
		}else if (fm.memberPwd.value != fm.memberPwd2.value){
			document.getElementById("checkmsg").style.display = "";
			document.getElementById("pwdmsg3").style.display = "";
			fm.memberPwd2.select();
			return;		
		}else if (fm.memberName.value ==""){
			document.getElementById("checkmsg").style.display = "";
			fm.memberName.focus();
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
		}else if ($("#nameck").val() != $("#memberName").val()){
			document.getElementById("checkmsg3").style.display = "";
			fm.memberName.focus();
			return;	
		}
		fm.action = "${pageContext.request.contextPath}/member/memberInfoModifyAction.do";
		fm.method = "post";
		fm.submit();
		return;
	}
	
	</script>
</body>
</html>