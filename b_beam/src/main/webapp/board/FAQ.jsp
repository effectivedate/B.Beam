<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- <%@ page import="app.domain.*" %> --%>
<%-- <%@ page import="java.util.ArrayList" %> --%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>고객지원</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/source/css/board/FAQ.css">
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
</head>
<body>

	<!-- header -->
	<jsp:include page="../source/include/header.jsp"/>
<div class="container">
	<div class="container-title">
		<h1>고객지원</h1>
	</div>
	<div class="page-inner">
	<div class="contents-area">
		<div class="btn-area2">
			<button type="button" class="btn-Notice" onclick="location.href='${pageContext.request.contextPath}/board/noticeList.do'">공지사항</button>
			<button type="button" class="btn-FAQ">자주 묻는 질문</button>
		</div>
		<div class="qna-contents">
			<div class="list-area">
				<c:forEach var="bv" items="${alist}" varStatus="status">
					<div class="QnA-item">
						<h3 class="QnA-title">Q.${bv.bdtitle }</h3>
						<div class="QnA-Answer">
							<p>${bv.bdcont }</p>
						</div>
						<!-- <i class="fa-solid fa-chevron-down"></i> -->
						<button type="button" class="QnA-toggle">
							<i class="fas fa-chevron-down"></i>
							<i class="fas fa-chevron-up"></i>
						</button>	
					</div>
					<div style="display: flex; justify-content: flex-end;">
						<c:choose>
						<c:when test="${not empty manager}">
							<button id="btn-modify" class="btn-write" onclick="location.href='${pageContext.request.contextPath}/board/FAQModify.do?bdno=${bv.bdno}'">수정</button>
							<button id="btn-delete" class="btn-write" onclick="FAQDelete(${bv.bdno})" >삭제</button>
						</c:when>
						<c:otherwise>
						</c:otherwise>
						</c:choose>
					</div>
				</c:forEach>
			</div>	
		</div>
		<div class="btn-area2">
			<c:choose>
				<c:when test="${not empty manager}">
					<button id="btn-write" class="btn-write">자주 묻는 질문 등록</button>
				</c:when>
				<c:otherwise>
				</c:otherwise>
			</c:choose>
		</div>
		<div class="pagination-area">
			<table class="page-table">
				<tr>
					<c:if test="${pm.prev}">
						<td>
							<a class="page-num" href="${pageContext.request.contextPath}/board/FAQ.do?page=${pm.startPage - 1}">◀</a>
						</td>	
					</c:if>
					<c:forEach var="i" begin="${pm.startPage}" end="${pm.endPage}" step="1">
						<c:choose>
							<c:when test="${pm.scri.page  == i}">			
								<td>
									<a class="page-num currentPageNum" href="${pageContext.request.contextPath}/board/FAQ.do?page=${i}">${i}</a>
								</td>
							</c:when>
							<c:otherwise>
								<td>
									<a class="page-num" href="${pageContext.request.contextPath}/board/FAQ.do?page=${i}">${i}</a>
								</td>
							</c:otherwise>
						</c:choose>
					</c:forEach>
					<c:if test="${pm.next && pm.endPage > 0}">
						<td>
							<a href="${pageContext.request.contextPath}/board/FAQ.do?page=${pm.endPage + 1}">▶</a>
						</td>
					</c:if>
				</tr>
			</table>
		</div>
	</div>
</div>
</div>
	<!-- footer -->
	<jsp:include page="../source/include/footer.jsp"/>
	
</body>
<script type="text/javascript">
	$(document).ready(function(){
		
		$("#btn-write").on("click", function(){
			location.href = "${pageContext.request.contextPath}/board/FAQWrite.do";
		});
		
	});
	/* 	//상단 메뉴 바 클릭 시 색상변화, 클릭 감지 이벤트 리스너 달아줌
		var btn = document.querySelectorAll(".btn");
		
		function handleClick1(e){
			for(let i = 0; i < btn.length; i++){
				btn[i].classList.remove("clicked2");
			}
			e.target.classList.add("clicked2");
		}
		function init1(){
			for(let i = 0; i < btn.length; i++){
				btn[i].addEventListener("click", handleClick1);
				if(i == (btn.length - 1)){
					btn[i].classList.add("clicked2");
				}
			}
		}
		init1(); */
		
		//문의내역 & 문의하기 클릭 시 색상변화, 클릭 감지 이벤트 리스너 달아줌
		var btn1 = document.querySelectorAll(".btn1");
		
		function handleClick2(event) {
			for (var i = 0; i < btn1.length; i++) {
				btn1[i].classList.remove("clicked");
			}
			event.target.classList.add("clicked");
		}

		function init2() {
			for (var i = 0; i < btn1.length; i++) {
				btn1[i].addEventListener("click", handleClick2);
			}
		}
		
		init2();
		
		//각 QnA 박스마다 클릭 감지 이벤트 리스너 달아줌
		//누르면 열리고 다시 누르면 닫히게 하는 코드
		const toggles = document.querySelectorAll(".QnA-item"); /* .QnA-toggle */
		
		toggles.forEach((toggle) => {
			toggle.addEventListener("click", () => {
				toggle.classList.toggle("active");
			})
		});
		
		function FAQDelete(idx) {
			event.preventDefault();
			event.stopPropagation()
			
			let bdno = idx;
			
			if(confirm("정말 삭제하시겠습니까?")){
				$.ajax({
					type : "post",
					url : "${pageContext.request.contextPath}/board/FAQDelete.do",
					data : {"bdno" : bdno},
					dataType : "json",
					cache : false,
					success : function(data){
						if(data.value == 1) {
							alert("삭제되었습니다.");
							location.reload();
						}
					},
					error : function() {
						alert("에러");
						return;
					}
				})
				
			}else {
				return;
			}
			
		}
		
		
</script>
</html>