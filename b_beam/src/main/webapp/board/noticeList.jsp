<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- <%@ page import="app.domain.*" %> --%>
<%-- <%@ page import="java.util.ArrayList" %> --%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>고객지원</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/source/css/board/noticeList.css">
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
		<div class="content">
			<div class="btn-area">
				<button type="button" class="btn-Notice">공지사항</button>
				<button type="button" class="btn-FAQ" onclick="location.href='${pageContext.request.contextPath}/board/FAQ.do'">자주 묻는 질문</button>
			</div>
			<div class="table-area">
				<table class="content-table">
					<tr>
						<td class="td-head td-no">글 번호</td>
						<td class="td-head td-cate">분류</td>
						<td class="td-head td-sub">글 제목</td>
						<td class="td-head td-writer">작성자</td>
						<td class="td-head td-wdate">작성일</td>
					</tr>
					<c:forEach var="bv" items="${alist}" varStatus="status">
						<tr class="tr-body">
							<td class="td-body td-no">${bv.bdno}</td>
							<td class="td-body td-cate">${bv.bdcate}</td>
							<td class="td-body td-sub">
							<a href="${pageContext.request.contextPath}/board/notice.do?bdno=${bv.bdno}">${bv.bdtitle}</a>
							</td>
							<td class="td-body td-writer">${bv.mbname}</td>
							<td class="td-body td-wdate">${bv.bddate}</td>
						</tr>							
					</c:forEach>
				</table>
			</div>
			<div class="btn-area2">
				<c:choose>
					<c:when test="${not empty manager}">
						<button id="btn-write" class="btn-write">공지사항 등록</button>
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
							<a class="page-num" href="${pageContext.request.contextPath}/board/noticeList.do?page=${pm.startPage - 1}">◀</a>
						</td>	
					</c:if>
					<c:forEach var="i" begin="${pm.startPage}" end="${pm.endPage}" step="1">
						<c:choose>
							<c:when test="${pm.scri.page  == i}">			
								<td>
									<a class="page-num currentPageNum" href="${pageContext.request.contextPath}/board/noticeList.do?page=${i}">${i}</a>
								</td>
							</c:when>
							<c:otherwise>
								<td>
									<a class="page-num" href="${pageContext.request.contextPath}/board/noticeList.do?page=${i}">${i}</a>
								</td>
							</c:otherwise>
						</c:choose>
					</c:forEach>
					<c:if test="${pm.next && pm.endPage > 0}">
						<td>
							<a href="${pageContext.request.contextPath}/board/noticeList.do?page=${pm.endPage + 1}">▶</a>
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
			location.href = "${pageContext.request.contextPath}/board/noticeWrite.do";
		});
		
	});
</script>
</html>