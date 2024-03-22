<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title>Insert title here</title>
	<link href="../source/css/member/memberJoin.css" type="text/css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>

</head>
<body>
	<div class="container">
		<div class="back-btn">
			<input type="button" id="inner-back-btn" name="btn" value="≪" onclick="location.href='${pageContext.request.contextPath}/member/memberLogin.do';">
		</div>
		<div class="join">
			<div class="join-logo">
				<h1 class="logo">
					<a class="svgLogo" href="../index.jsp">
						<img src="../source/images/logo4.png" width="250" height="130" alt="메인화면으로 이동">
					</a>
				</h1>
			</div>
			<div class="join-body">
				<form name="frm">
					<div class="join-id">
						<input type="text" name="memberId" id="memberId" maxlength="30" placeholder=" 아이디">
						<input type="button" name="btn1" id="btn1" value="아이디확인" onclick="IdCheck()">
						<input type="hidden" name="idck" id="idck" value="">
						<input type="hidden" name="idYN" id="idYN" value="N">
					</div>
					<div class="error_text item_style" id="idmsg" style="display:none;">사용할 수 없는 아이디 입니다. 다른 아이디를 입력해 주세요.</div>
					<div class="pass_text item_style" id="idmsg2" style="display:none;">사용할 수 있는 아이디 입니다.</div>
					<div class="error_text item_style" id="idmsg3" style="display:none;">최소4 최대12인 영문 소문자 숫자로 작성해주세요.</div>
					<div class="join-pwd">
						<input type="password" name="memberPwd" placeholder=" 비밀번호">
					</div>
					<div class="join-pwd2">
						<input type="password" name="memberPwd2" placeholder=" 비밀번호 확인">
					<div class="error_text item_style" id="pwdmsg" style="display:none;">일치하지 않습니다. 다시 확인해주세요.</div>
					</div>
					<div class="join-name">
						<input type="text" name="memberName" id="memberName" placeholder="닉네임">
						<input type="button" name="btn2" id="btn2" value="닉네임확인" onclick="NickCheck()">
						<input type="hidden" name="nameck" id="nameck" value="">
						<input type="hidden" name="nameYN" id="nameYN" value="N">
					</div>
					<div class="error_text item_style" id="namemsg" style="display:none;">사용할 수 없는 닉네임 입니다. 다른 닉네임을 입력해 주세요.</div>
					<div class="pass_text item_style" id="namemsg2" style="display:none;">사용할 수 있는 닉네임 입니다.</div>
					<div class="error_text item_style" id="namemsg3" style="display:none;">특수문자를 제외한 최소2 최대6인 닉네임을 입력해주세요.</div>
					<!-- 주소찾기 api -->
					<div class="kakao-address">
						<div id="address-btn-area">
						<input type="text" name="postcode" id="postcode" placeholder="우편번호">
						<input type="button" id="address-btn" onclick="DaumPostcode()" value="주소 찾기">
						</div>
						<input type="text" name="addr" id="addr" placeholder="주소">
						<div>
						<input type="text" name="detail_addr" id="detail_addr" placeholder="상세주소">
						<input type="text" name="extra_addr" id="extra_addr" placeholder="참고항목">
						</div>
					</div>
					<div class="join-email">
						<input type="email" name="memberEmail" id="memberEmail" placeholder=" bbeam@emali.com">
						<input type="button" name="btn0" id="btn0" value="인증번호발송" onclick="sendemail()">
						
					</div>
					<div class="error_text item_style" id="emailmsg" style="display:none;">사용할 수 없는 이메일 입니다. 다른 이메일을 입력해 주세요.</div>
					<div id="timer" style="color:red;"></div>
					<div id="checkemail"></div>
					<div class="email-certi" id="email-certi" style="display:none;">
						<input type="text" name="emailCertification" id="authentication" placeholder="인증번호">
						<input type="button" name="btn3" id="btn3" value="인증하기" onclick="emailConfirm()">
						<input type="hidden" name="emailck" id="emailck" value="">
						<input type="hidden" id="emailYN" value="N">
					</div>
					<div class="join-btn">
						<input type="button" name="btn" value="가입하기" onclick="check();">
					</div>
					<div class="error_text item_style" id="checkmsg" style="display:none;">작성되지 않은 부분이 있습니다. 다시 확인해주세요</div>
					<div class="error_text item_style" id="checkmsg2" style="display:none;">중복확인이 안된 부분이 있습니다. 다시 확인해주세요</div>
					<div class="error_text item_style" id="checkmsg3" style="display:none;">중복확인된 정보와 현재 작성된 정보가 다릅니다. 확인해주세요</div>
				</form>
			</div>
		</div>
	</div>
	
	<!-- 주소찾기 스크립트 -->
	<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script>
	    //본 예제에서는 도로명 주소 표기 방식에 대한 법령에 따라, 내려오는 데이터를 조합하여 올바른 주소를 구성하는 방법을 설명합니다.
	    function DaumPostcode() {
	        new daum.Postcode({
	            oncomplete: function(data) {
	            	// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                    // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                    // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                    var addr = ''; // 주소 변수
                    var extraAddr = ''; // 참고항목 변수

                    //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                    if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                        addr = data.roadAddress;
                    } else { // 사용자가 지번 주소를 선택했을 경우(J)
                        addr = data.jibunAddress;
                    }

                    // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
                    if(data.userSelectedType === 'R'){
                        // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                        // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                        if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                            extraAddr += data.bname;
                        }
                        // 건물명이 있고, 공동주택일 경우 추가한다.
                        if(data.buildingName !== '' && data.apartment === 'Y'){
                            extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                        }
                        // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                        if(extraAddr !== ''){
                            extraAddr = ' (' + extraAddr + ')';
                        }
                        // 조합된 참고항목을 해당 필드에 넣는다.
                        document.getElementById("extra_addr").value = extraAddr;
                    
                    } else {
                        document.getElementById("extra_addr").value = '';
                    }

                    // 우편번호와 주소 정보를 해당 필드에 넣는다.
                    document.getElementById('postcode').value = data.zonecode;
                    document.getElementById("addr").value = addr;
                    // 커서를 상세주소 필드로 이동한다.
                    document.getElementById("detail_addr").focus();
                }
            }).open();
        }
	</script>
	<script>
	function IdCheck(){
		var id = document.frm.memberId.value;
		var reg = /^[a-z0-9]{4,12}$/i;
		if(!reg.test(id)){
			document.getElementById("idmsg").style.display = "none";
			document.getElementById("idmsg2").style.display = "none";
			document.getElementById("idmsg3").style.display = "";
			return;
		}
		$.ajax({
			type : "post",
			url : "${pageContext.request.contextPath}/member/memberIdCheck.do",
			data : {"memberId" : id},
			dataType : "json",
			success : function(data){
				if(data.value == 0){
// 					alert("사용할 수 있는 아이디입니다.");
					document.getElementById("idmsg").style.display = "none";
					document.getElementById("idmsg2").style.display = "";
					document.getElementById("idmsg3").style.display = "none";
					document.getElementById("idck").value = id;
					document.getElementById("idYN").value = "Y";
				}else{
// 					alert("사용할 수 없는 아이디입니다.");
					document.getElementById("idmsg").style.display = "";
					document.getElementById("idmsg2").style.display = "none";
					document.getElementById("idmsg3").style.display = "none";
					document.getElementById("idYN").value = "N";
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
	function EmailCheck(){
		var email = document.frm.memberEmail.value;
		var reg = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
		if(!reg.test(email)){
			$("#checkemail").empty();
			document.getElementById("emailmsg").style.display = "";
			return;
		}
		$.ajax({
			type : "post",
			url : "${pageContext.request.contextPath}/member/memberEmailCheck.do",
			data : {"memberEmail" : email},
			dataType : "json",
			success : function(data){
				if(data.value == 0){
// 					alert("사용할 수 있는 이메일입니다.");
					document.getElementById("emailmsg").style.display = "none";
					document.getElementById("email-certi").style.display = "";
					document.getElementById("emailck").value = email;
					
					StartTimer();
				}else{
// 					alert("사용할 수 없는 이메일입니다.");
					$("#checkemail").empty();
					document.getElementById("emailmsg").style.display = "";
					document.getElementById("emailYN").value = "N";
				}
			},
			error : function(){
				alert("실패3");
			}
		});
		
	}
	
	</script>
	<script>
	function sendemail() {
		$("#checkemail").empty();
    	Is_Mail_Duplicated = false;
    	
    	ResetTimer();
    	    	
  		const btnElement 
  	    = document.getElementById('btn0');
  	  
  	 	btnElement.value = "인증번호 재전송";
  	  		
		$("#email-certi").css("display","none");
		$("#checkemail").html("메일을 발송 중입니다. 잠시만 기다려 주세요....");
		
		// ajax로 이메일 중복검사후 타이머 재생
		EmailCheck();
    }    
  	
  	
    var timer;
    var isRunning = false;
    
  	//타이머 초기화
  	function ResetTimer(){
  		isRunning = false;
  		clearInterval(this.timer);
  		display = document.querySelector('#timer');
  		display.textContent = "";
		Is_Mail_Duplicated = false;			
		$("#email-certi").css("display","none");  
		$("#checkemail").empty();
  	}
  	
  	//타이머 시작
  	function StartTimer(){
		//이메일 타이머 인증 구현
		var leftSec = 60 * 3,
		display = document.querySelector('#timer');
		$("#checkemail").empty();
		$("#checkemail").html("입력시간 내에 인증번호를 입력해주세요.");
		// 이미 타이머가 작동중이면 중지
		if (isRunning){
			clearInterval(this.timer);
		}
		startTimer(leftSec, display);
		
		function startTimer(count, display) {
			var minutes, seconds;
			timer = setInterval(function () {
				minutes = parseInt(count / 60, 10);
				seconds = parseInt(count % 60, 10);
				
				minutes = minutes < 10 ? "0" + minutes : minutes;
				seconds = seconds < 10 ? "0" + seconds : seconds;				
				display.textContent = minutes + ":" + seconds;

				// 타이머 끝
				if (--count < 0) 
				{
					clearInterval(timer);
					display.textContent = "";
					isRunning = false;
					$("#email-certi").css("display","none");
					$("#checkemail").empty();
					$("#checkemail").html("입력시간 초과입니다. 재전송 해주세요.");
					$("#checkemail").css("color","red");
					document.getElementById("emailYN").value = "N";
					//alert("입력시간 초과입니다. 재전송 해주세요.");
				}
			},1000);
			isRunning = true;
		}  		
  	}
  	//타이머 종료 함수
  	function endTimer(){
  		clearInterval(timer);
		$("#timer").empty();
		document.getElementById("emailYN").value = "Y";
  	}
  	
   	//확인을 클릭하면 이메일 인증을 비교하는 함수
   	function emailConfirm()	{
   		Is_Mail_Duplicated = false;
   		var AuthCode = $("#authentication").val();
   		if($("#authentication").val() == ""){
   			alert("인증번호를 입력하세요.");
   			return;
   		}else if($("#emailck").val() != $("#memberEmail").val()){
   			alert("발송된 이메일로 인증을 진행해주세요.");
   			return;
   		}
   		
		//Ajax로 이메일 중복검사
		$.ajax({
			type : "get",
			url: "${pageContext.request.contextPath}/member/getsign.do",
			dataType: "json",
			data:{"AuthCode":AuthCode},
			success : function(data) {
				if(data.value==1){
					Is_Mail_Duplicated = true;
					$("#checkemail").empty();
					$("#checkemail").html("인증번호가 일치 합니다.");
					$("#checkemail").css("color","blue");
					document.getElementById("emailYN").value = "Y";
					endTimer();
					
				}else{
					//alert("인증 번호가 일치하지 않습니다.");
					$("#checkemail").empty();
					$("#checkemail").html("인증번호가 일치 하지 않습니다.");
					$("#checkemail").css("color","red");
					document.getElementById("emailYN").value = "N";
				}
			},
			error : function(){
				console.log('오류');
			}
		});   		
   		
	}  	
	
	</script>
	<script>
	function check(){
		var fm = document.frm;
		document.getElementById("pwdmsg").style.display = "none";
		document.getElementById("checkmsg").style.display = "none";
		document.getElementById("checkmsg2").style.display = "none";
		document.getElementById("checkmsg3").style.display = "none";
		if(fm.memberId.value ==""){
			fm.memberId.focus();
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
			document.getElementById("pwdmsg").style.display = "";
			fm.memberPwd2.select();
			return;		
		}else if (fm.memberName.value ==""){
			document.getElementById("checkmsg").style.display = "";
			fm.memberName.focus();
			return;		
		}else if (fm.postcode.value ==""){
			document.getElementById("checkmsg").style.display = "";
			fm.postcode.focus();
			return;		
		}else if (fm.addr.value ==""){
			document.getElementById("checkmsg").style.display = "";
			fm.addr.focus();
			return;		
		}else if (fm.detail_addr.value ==""){
			document.getElementById("checkmsg").style.display = "";
			fm.detail_addr.focus();
			return;		
		}else if (fm.memberEmail.value ==""){
			document.getElementById("checkmsg").style.display = "";
			fm.memberEmail.focus();
			return;		
		}else if ($("#idYN").val() == "N"){
			document.getElementById("checkmsg2").style.display = "";
			fm.memberId.focus();
			return;	
		}else if ($("#idck").val() != $("#memberId").val()){
			document.getElementById("checkmsg3").style.display = "";
			fm.memberId.focus();
			return;	
		}else if ($("#nameYN").val() == "N"){
			document.getElementById("checkmsg2").style.display = "";
			fm.memberName.focus();
			return;	
		}else if ($("#nameck").val() != $("#memberName").val()){
			document.getElementById("checkmsg3").style.display = "";
			fm.memberName.focus();
			return;	
		}else if ($("#emailYN").val() == "N"){
			document.getElementById("checkmsg2").style.display = "";
			fm.memberEmail.focus();
			return;	
		}else if ($("#emailck").val() != $("#memberEmail").val()){
			document.getElementById("checkmsg3").style.display = "";
			fm.memberEmail.focus();
			return;	
		}
		fm.action = "${pageContext.request.contextPath}/member/memberJoinAction.do";
		fm.method = "post";
		fm.submit();
		return;
	}
	</script>
</body>
</html>