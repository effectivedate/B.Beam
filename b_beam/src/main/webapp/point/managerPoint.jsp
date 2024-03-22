<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자페이지</title>
<link rel="stylesheet" type="text/css" href="../source/css/point/managerPoint.css">
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
	

<script>
$(document).ready(function(){
    $(".tab a").click(function(e){
        e.preventDefault();
        var tabID = $(this).attr('href'); // 클릭된 탭의 ID를 가져옵니다.
        $(".tab li").removeClass('is_on'); // 모든 탭의 활성 클래스를 제거합니다.
        $(this).parent().addClass('is_on'); // 현재 선택된 탭에 활성 클래스를 추가합니다.
        $(".tabContent").hide(); // 모든 탭 컨텐츠를 숨깁니다.
        $(tabID).show(); // 선택된 탭의 컨텐츠를 표시합니다.
    });
});
</script>

</head>
<body>


<jsp:include page="../source/include/header.jsp"/>
<jsp:include page="../source/include/managerNavi.jsp"/>


		<div id="tab1" class="tabContent">
			<div class="search-bar">
				<table>
			    <tr>
			        <th>아이디 검색</th>
			        <td>
			            <input type="text" id="keyword" placeholder="검색어를 입력하세요">
			        </td>
			        <td>
			            <button type="button" id="search-button">검색</button>
			        </td>
			    </tr>
				</table>
			</div>
			<table class="point-table">
			    <thead>
			        <tr>
			            <th id="pointNum">유저번호</th>
			            <th id="mbid">아이디</th>
			            <th id="breed">유형</th>
			            <th id="useName">닉네임</th>
			            <th id="point">총획득포인트/보유포인트</th>
			            <th id="clearYn">포인트 부여</th>
			        </tr>
			    </thead>
			    <tbody>
					<c:forEach var="i" begin="1" end="5" step="1">
			         <tr>
			            <td>${i}</td>
			            <td>리뷰</td>
			            <td>욕설</td>
			            <td>맥그리거</td>
			            <td>너 아빠없지?</td>
			             <td>
			             <input type="text" id="setPoint${i}" placeholder="포인트입력">
			             <button type="button">부여</button>
			            </td>
			        </tr>
			       </c:forEach>
			        <!-- 추가적인 게시물 -->
			    </tbody>
			</table>
					
				
					
		</div>
				<div class="pagination">
				    <a href="#" class="arrow">◀</a>
				    <a href="#" class="page">1</a>
				    <a href="#" class="page">2</a>
				    <a href="#" class="page">3</a>
				    <a href="#" class="arrow">▶</a>
				</div>


<div id="tab2" class="tabContent" style="display: none;">
	이곳에 1:1문의가 들어갈거에요
</div>

<div id="tab3" class="tabContent" style="display: none;">
	공지사항
</div>

<div id="tab4" class="tabContent" style="display: none;">
		자주묻는질문 
	</div>














<script>
</script>















<jsp:include page="../source/include/footer.jsp"/>
</body>
</html>