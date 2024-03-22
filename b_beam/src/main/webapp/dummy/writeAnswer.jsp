<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 페이지</title>
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/source/css/qna/writeAnswer.css">
</head>
<body>

	<!-- header -->
	<jsp:include page="../source/include/header.jsp"/>
	
	<div class="container">
		<div class="page-inner">
			<jsp:include page="../source/include/managerNavi.jsp"/>
		</div>
	</div>
	
	
	<!-- footer -->
	<jsp:include page="../source/include/footer.jsp"/>

</body>
</html>