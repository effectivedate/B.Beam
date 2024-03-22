<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>리스트 페이지</title>
<link rel="stylesheet" type="text/css" href="../source/css/contents/contentsR.css">
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
	


</head>
</head>
<body>

<jsp:include page="../source/include/header.jsp"/>
<div class="container">
	<div class="container-title">
		<h1>
			랭킹 Top10
		</h1>
	</div>
	<div class="rankcontainer">
		<div class="rankingbox">
			<div class="contentsbox rank">
				<h3 class="ranktitle">
					조회수 Top10
				</h3>
				<c:forEach var="cv" items="${vcList}">
				    <button type="button" class="listbutton rank" id="vcButton${cv.contentid}" onclick="ContentsDetail(${cv.contentid})">
				        <div class="contents-info rank">
					        <c:choose>
					    		<c:when test="${not empty cv.firstimage}">
					            	<img src="${cv.firstimage}">
					            </c:when>
					            <c:otherwise>
					            	<img src="../source/images/notFound.png">
					            </c:otherwise>
					        </c:choose>
				            <div class="contents-title rank">${cv.title}<span class="cvrk">(${cv.contentsView})</span></div>
				        </div>
				    </button>
			    </c:forEach>
			</div>	
			<div class="contentsbox rank">
				<h3 class="ranktitle">
					리뷰 Top10
				</h3>
				<c:forEach var="cv" items="${rcList}">
				    <button type="button" class="listbutton rank" id="rcButton${cv.contentid}" onclick="ContentsDetail(${cv.contentid})">
				        <div class="contents-info rank">
				            <c:choose>
					    		<c:when test="${not empty cv.firstimage}">
					            	<img src="${cv.firstimage}">
					            </c:when>
					            <c:otherwise>
					            	<img src="../source/images/notFound.png">
					           </c:otherwise>
					        </c:choose>
				            <div class="contents-title rank">${cv.title}<span class="rcrk">(${cv.contentReviewCnt})</span></div>
				        </div>
				    </button>
			    </c:forEach>
			</div>	
			<div class="contentsbox rank">
				<h3 class="ranktitle">
					즐겨찾기 Top10
				</h3>
				<c:forEach var="cv" items="${bcList}">
				    <button type="button" class="listbutton rank" id="bcButton${cv.contentid}" onclick="ContentsDetail(${cv.contentid})">
				        <div class="contents-info rank">
				            <c:choose>
					    		<c:when test="${not empty cv.firstimage}">
					            	<img src="${cv.firstimage}">
					            </c:when>
					            <c:otherwise>
					            	<img src="../source/images/notFound.png">
					            </c:otherwise>
					        </c:choose>
				            <div class="contents-title rank">${cv.title}<span class="bcrk">(${cv.contentLikeCnt})</span></div>
				        </div>
				    </button>
			    </c:forEach>
			</div>	
			<div class="contentsbox rank">
				<h3 class="ranktitle">
					평점 Top10
				</h3>
				<c:forEach var="cv" items="${rtList}" varStatus="status">
				    <button type="button" class="listbutton rank" id="rvButton${cv.contentid}" onclick="ContentsDetail(${cv.contentid})">
				        <div class="contents-info rank">
				        	<c:choose>
					    		<c:when test="${not empty cv.firstimage}">
					            	<img src="${cv.firstimage}">
					            </c:when>
					            <c:otherwise>
					            	<img src="../source/images/notFound.png">
					            </c:otherwise>
					        </c:choose>
				            <div class="contents-title rank">${cv.title}<div class="ratingContainer" id="rc${status.index}"></div></div>
				        </div>
				    </button>
			    </c:forEach>
			</div>	
		</div>
	</div>
</div>
<jsp:include page="../source/include/footer.jsp"/>
<script>
function ContentsDetail(e){
	// 해당 컨텐츠리스트로 이동
	location.href="${pageContext.request.contextPath}/contents/contentsDetail.do?contentid="+e;
}
function ContentsDetailReview(e,r){
	// 해당 컨텐츠리스트로 이동
	location.href="${pageContext.request.contextPath}/contents/contentsDetail.do?contentid="+e+"&reviewNo="+r;
}
const valueArray = [];
<c:forEach var='cv' items='${rtList}'>
	valueArray.push('${cv.contentRating}');
</c:forEach>
//	console.log(valueArray);
// 별점을 생성하는 함수
function createStars(rating) {
const maxStars = 5;
	var ratingDouble = (rating / 100);
	// 채워진 별과 빈 별을 조합한 문자열 생성
	let starsString = '★'.repeat(Math.floor(ratingDouble));
	starsString += '☆'.repeat(maxStars - Math.floor(ratingDouble));
	let ratingString = '  '+ratingDouble + '/5 '+ starsString;
//		console.log(ratingString);
	return ratingString;
}

// 별점을 생성하고 표시
function setRating(data){
	for(let i = 0; i < data.length; i++){
		$('#rc'+i).append(createStars(data[i]));
	}
}

setRating(valueArray);

</script>
</body>
</html>