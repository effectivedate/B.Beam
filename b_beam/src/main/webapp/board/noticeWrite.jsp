<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항 등록</title>
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/source/css/board/noticeWrite.css">
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
			<div class="write-area">
				<form id="form" class="form" name="frm">
					<div class="div-sub">
						<input type="text" class="input-sub" name="bdtitle" placeholder="제목">
					</div>
					<div class="div-content">
						<textarea class="textarea-content" name="bdcont" placeholder="내용"></textarea>
					</div>
					<!-- <div class="div-file">
						<label for="input-file" class="label-file">
							파일 선택<input type="file" id="input-file" class="input-file" multiple="multiple">	
						</label>
					</div> -->
				</form>
			</div>
			<div class="btn-area">
				<button id="btn-write" class="btn btn-write">등록</button>
				<button id="btn-cancel" class="btn btn-cancel">취소</button>
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
			var fm = document.frm;	

			if(fm.bdtitle.value=="") {
				alert("제목을 입력하세요");
				fm.bdtitle.focuse();
				return;
			} else if(fm.bdcont.value=="") {
				alert("내용을 입력하세요");
				fm.bdcont.focus();
				return;
			}
			
			fm.action = "${pageContext.request.contextPath}/board/noticeWriteAction.do";	
			fm.method = "post";					
			//fm.enctype="multipart/form-data";
			fm.submit();						
			return;
		});
		
		$("#btn-cancel").on("click", function(){
			location.href = "${pageContext.request.contextPath}/board/noticeList.do";
		});
	});
</script>
</html>