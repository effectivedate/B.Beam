<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<title>신고</title>
</head>
<body>
<div>
	<h2>신고</h2>
</div>
<div>
	<table>
		<tr>
			<td>피신고자</td>
			<td>${mv.mbname}</td>
		</tr>
		<tr>
			<td>신고게시판 분류</td>
			<td>
				<c:choose>
					<c:when test="${cate eq 'rvno'}">
						리뷰
					</c:when>
					<c:when test="${cate eq 'bdno'}">
						갤러리
					</c:when>
					<c:when test="${cate eq 'cmno'}">
						댓글
					</c:when>
				</c:choose>	
			</td>
		</tr>
		<tr>
			<td>신고종류</td>
			<td>
				<select id="rpcate">
					<option value="">분류를 선택해주세요</option>
					<option value="F">폭언/욕설</option>
					<option value="A">홍보/도박/외부사이트</option>
					<option value="P">외설/음란</option>
				</select>
			</td>
		</tr>
		<tr>
			<td>신고내용</td>
			<td><input type="text"></td>
		</tr>
	</table>
	<button onclick="rpt();">신고하기</button>
	<button onclick="window.close();">취소하기</button>
</div>
<script>
function rpt(){
	if($('#rpcate').val()==""){
		alert('신고종류를 선택해주세요!');
		return;
	}else{
		if (confirm('정말 신고하시겠습니까?')) {
			var rpcate = $('#rpcate').val();
			console.log(rpcate);
			
			$.ajax({
				type: "POST",
				url: "${pageContext.request.contextPath}/report/reportAction.do",
				data: {'${cate}':${no},'rpcate':rpcate,'mbno2':${mv.mbno},'mbno':${mbno}},
				dataType: "json",
				success: function(response) {
					if (response.success) {
						alert("신고되었습니다.");
						window.close();
					}
				},
				error: function(request, status, error) {
					alert("code : "+request.status+"\n"+"message : " +request.responseText+"\n"+"error : "+ error);
				}
			});
			
		}else{
			return;
		}
	}
	
}

</script>
</body>
</html>