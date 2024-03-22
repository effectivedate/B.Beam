<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="app.domain.PointVo" %>
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
				<button type="button" class="btn-QnAList btn1 clicked">내 포인트</button>
			</div>
			<div class="member-info">
				<div class="login-body">
					<div>
						<h3>보유중인 포인트</h3>
					</div>
					<table class="info-cont" id="info-point">
						<tr>
							<td>
								잔여포인트 : ${pv.rmpt} p
							</td>
						</tr>
					</table>
				</div>
				<div class="join-body">
					<form name="frm">
						<div>
							<h3>전주사랑상품권 교환</h3>
						</div>
						<div class="join-id">
							<input type="text" name="exc-point" id="exc-point" maxlength="30" placeholder=" 교환할 포인트를 입력해주세요">
						</div>	
						<div style="color: #6d6b70;">
							＊10000p단위로 교환 가능합니다.
						</div>
						<div class="join-btn">
							<input type="button" class="point-btn" name="btn" value="신청하기">
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
	<jsp:include page="../source/include/footer.jsp"/>
</body>

	<script>
		
	$(".point-btn").on("click", function() {
		if (confirm('정말 사용하시겠습니까?')) {
			
			// 넘길값 mbno 입력한 포인트값
			let mbno = "${pv.mbno}";
			var ptpt = parseInt($('#exc-point').val());
			let rmpt = parseInt("${pv.rmpt}");
			
			if (ptpt%10000 != 0) {
				alert("10000p 단위로 교환 가능합니다.");
				return;
			}
			
			if (ptpt > rmpt) {
				alert("입력한 포인트가 현재 남아있는 포인트보다 많습니다.");
				return;
			}
			
			console.log("mbno :"  + mbno);
			console.log("ptpt :" + ptpt);
			console.log("rmpt :" + rmpt);
			
			$.ajax({
				type: "POST",
				url: "${pageContext.request.contextPath}/point/usePointAction.do",
				data: {"mbno" : mbno, "ptpt" : ptpt},
				dataType: "json",
				success: function(response) {
					console.log(response);
					if (response.success) {
						alert("포인트를 사용하였습니다.");
						location.href = "${pageContext.request.contextPath}/point/memberPoint.do";
					}
				},
				error: function(jqXHR, textStatus, errorThrown) {
					console.log(jqXHR, textStatus, errorThrown);  // 디버깅을 위한 출력
					alert("에러가 발생했습니다. 자세한 내용은 콘솔을 확인해주세요.");
				}
			});
			
		}else{
			return;
		}
	});
	
	
	
	</script>

</html>


