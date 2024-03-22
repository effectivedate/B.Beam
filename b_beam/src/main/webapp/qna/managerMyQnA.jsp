<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 페이지</title>
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/source/css/qna/managerMyQnA.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.14.0/css/all.min.css"
	integrity="sha512-1PKOgIY59xJ8Co8+NE6FZ+LOAZKjy+KY8iq0G4B3CyeY6wYHN3yt9PW0XpSriVlkMXe40PTKnXrLnZ9+fkDaog=="
	crossorigin="anonymous" />
</head>
<body>

	<!-- header -->
	<jsp:include page="../source/include/header.jsp" />

	<!-- page start -->
	<div class="container">
	
		<div class="container-title">
			<h1>ManagerMyQnA</h1>
		</div>
		
		<div class="m-navi">
			<div class="report-tap tap" onclick="mNavi(0)">신고내역</div>
			<div class="QnA-tap tap clicked" onclick="mNavi(1)">1:1 문의내역</div>
			<div class="notice-tap tap" onclick="mNavi(2)">공지사항</div>
			<div class="FAQ-tap tap" onclick="mNavi(3)">자주하는 질문</div>
		</div>		
		
		<div class="contents-area">
			<div class="list-area">
				<c:set var="j" value="6"></c:set>
				<c:forEach var="qv" items="${qna_alist}">
					<c:choose>
						<c:when test="${qv.ambno>0}">
							<div class="QnA-wrapper test${qv.qano}">
								<div class="answered-item">
									<h3 class="QnA-writer">${qv.qmbname}</h3>
									<h3 class="QnA-title">${qv.qtitle}</h3>
									<p class="QnA-Answer">${qv.qcont}</p>
									<!-- <i class="fa-solid fa-chevron-down"></i> -->
									<button type="button" class="QnA-toggle">
										<i class="fas fa-chevron-down"></i> <i
											class="fas fa-chevron-up"></i>
									</button>
									<div class="answer-area">
										<h3 class="answer-writer">${qv.ambname}</h3>
										<p id="acont${qv.qano}" class="answer-content">${qv.acont}</p>
									</div>
								</div>
							</div>
							<div class="Answered-btn-area test${qv.qano}">
								<button class="btn-Delete btn" onclick="deleteAnswer(${qv.qano})">답변삭제</button>
								<button class="btn-Modify btn" onclick="modifyAnswer(${qv.qano})">답변수정</button>
							</div>
						</c:when>
						<c:otherwise>
							<div class="QnA-wrapper test${qv.qano}">
								<div class="unanswered-item">
									<h3 class="QnA-writer">${qv.qmbname}</h3>
									<h3 class="QnA-title">${qv.qtitle}</h3>
									<p class="QnA-Answer">${qv.qcont}</p>
									
									<!-- <i class="fa-solid fa-chevron-down"></i> -->
									<button type="button" class="QnA-toggle">
										<i class="fas fa-chevron-down"></i> <i
											class="fas fa-chevron-up"></i>
									</button>
								</div>
							</div>
							<div class="unAnswered-btn-area test${qv.qano}">
								<button class="btn-Answer btn" onclick="writeAnswer(${qv.qano})">답변하기</button>
							</div>
						</c:otherwise>
					</c:choose>
				</c:forEach>
			</div>
			<!-- 글 작성 영역 -->
			<div class="write-area dp-none">
			    <div class="write-content">
			        <form id="form" class="form">
			            <div class="QnA-content">
			                <textarea id="content" name="bdcont" class="textarea-content" placeholder="내용을 입력해주세요"></textarea>
			            </div>
			        </form>
			        <div class="btn-area2">
			            <button type="button" id="write" class="btn-write btn2">등록</button>
			            <button type="button" id="cancel" class="btn-cancel btn2">취소</button>
			        </div>
			    </div>
			</div>
			
			<!-- 글 수정 영역 -->
			<div class="modify-area dp-none">
			    <div class="write-content">
			        <form id="modify-form" class="form">
			            <div class="QnA-content">
			                <textarea id="modify-content" name="modify-content" class="textarea-content"></textarea>
			            </div>
			        </form>
			        <div class="btn-area2">
			            <button type="button" id="modify-write" class="btn-write btn2">수정완료</button>
			            <button type="button" id="modify-cancel" class="btn-cancel btn2">취소</button>
			        </div>
			    </div>
			</div>
		</div>
		
	</div>

	<!-- footer -->
	<jsp:include page="../source/include/footer.jsp" />

<script type="text/javascript">
	$(document).ready(function() {
		$.ajax({
			url: '${pageContext.request.contextPath}/qna/managerMyQnA.do',
			type: 'POST',
			dataType: 'json',
			success: function(response) {
				location.reload();
			},
			error: function(xhr, status, error) {
			}
		});
	});

	var tap = document.querySelectorAll(".tap");

	function handleClick1(e){
		for(let i = 0; i < tap.length; i++){
			tap[i].classList.remove("clicked");
		}
		e.target.classList.add("clicked");
	}

	function init1(){
		for(let i = 0; i < tap.length; i++){
			tap[i].addEventListener("click", handleClick1);
		}
	}
	init1();
	
	//네비게이션 바 주소설정
	function mNavi(e){
		switch(e){
		case 0 : location.href="${pageContext.request.contextPath}/report/report.do"; break;
		case 1 : location.href="${pageContext.request.contextPath}/qna/managerMyQnA.do"; break;
		case 2 : location.href="${pageContext.request.contextPath}/board/noticeList.do"; break;
		case 3 : location.href="${pageContext.request.contextPath}/board/FAQ.do"; break;
		
		}
	}	

	const toggles = document.querySelectorAll(".QnA-wrapper");

	toggles.forEach((toggle) => {
		toggle.addEventListener("click", () => {
			const currentToggle = toggle;
			toggles.forEach((otherToggle) => {
				if (otherToggle !== currentToggle) {
					otherToggle.classList.remove("active");
				}
			});
			currentToggle.classList.toggle("active");
		});
	});

	// 답변글 작성  ----------------------------------------------------
	function writeAnswer(qano) {
		let item = document.querySelectorAll(".QnA-wrapper");
		document.querySelector(".unAnswered-btn-area.test" + qano).classList.add("active");
		for (let i = 0; i < item.length; i++) {
			if (item[i].classList.contains("test" + qano)) {
				document.querySelector(".write-area").classList.remove("dp-none");
				document.querySelector(".write-area").classList.add("dp-block");
			} else {
				item[i].classList.add("dp-none");
				item[i].classList.remove("active");
			}
		}
		window.currentQano = qano;
	}

	$("#write").on("click", function(){
		let content = $("#content");
		if(content.val() == null || content.val() == ""){
			alert("내용을 입력해주세요");
			content.focus();
		} else {
			$.ajax({
				url: '${pageContext.request.contextPath}/qna/mngWriteAction.do',
				type: 'POST',
				data: {
					'ambno': ${mbno},
					'qano': window.currentQano,
					'bdcont': content.val()
				},
				success: function(response) {
					alert('성공적으로 등록되었습니다.');
					location.reload();
				},
				error: function(xhr, status, error) {
					alert('오류가 발생했습니다. 다시 시도해주세요.');
				}
			});
		}
	});
	// 답변글 수정 ----------------------------------------------------
	function modifyAnswer(qano) {
// 		let item = document.querySelectorAll(".QnA-wrapper");
// 		document.querySelector(".Answered-btn-area.test" + qano).classList.add("active");
// 		for (let i = 0; i < item.length; i++) {
// 			if (item[i].classList.contains("test" + qano)) {
// 				document.querySelector(".modify-area").classList.remove("dp-none");
// 				document.querySelector(".modify-area").classList.add("dp-block");
// 			} else {
// 				item[i].classList.add("dp-none");
// 				item[i].classList.remove("active");
// 			}
// 		}
		let content = $("#modify-content");
		content.val($('#acont'+qano).html());
		let item = document.querySelectorAll(".QnA-wrapper");
		let currentSection = document.querySelector(".QnA-wrapper.test" + qano);
		currentSection.classList.toggle("active");
		item.forEach((otherSection) => {
			if (otherSection !== currentSection) {
				otherSection.classList.remove("active");
			}
		});
		document.querySelector(".Answered-btn-area.test" + qano).classList.add("active");
		item.forEach((otherSection) => {
			if (!otherSection.classList.contains("test" + qano)) {
				otherSection.classList.add("dp-none");
			}
		});
		document.querySelector(".modify-area").classList.remove("dp-none");
		document.querySelector(".modify-area").classList.add("dp-block");
		window.currentQano = qano;
	}

	$("#modify-write").on("click", function() {
		let content = $("#modify-content");
		if (content.val() == null || content.val() == "") {
			alert("내용을 입력해주세요");
			content.focus();
		} else {
			$.ajax({
				url: '${pageContext.request.contextPath}/qna/mngqnaModifyAction.do',
				type: 'POST',
				data: {
					'ambno': ${mbno},
					'qano': window.currentQano,
					'modify-content': content.val()
				},
				success: function(response) {
					alert('성공적으로 수정되었습니다.');
					location.reload();
				},
				error: function(xhr, status, error) {
					alert('오류가 발생했습니다. 다시 시도해주세요.');
				}
			});
		}
	});

	function deleteAnswer(qano) {
		if (confirm("정말로 답변을 삭제하시겠습니까?")) {
			$.ajax({
				url: '${pageContext.request.contextPath}/qna/mngqnaDeleteAction.do',
				type: 'POST',
				data: {'qano': qano},
				success: function (response) {
				alert('답변이 성공적으로 삭제되었습니다.');
					location.reload();
				},
				error: function (xhr, status, error) {
					alert('답변 삭제 중 오류가 발생했습니다. 다시 시도해주세요.');
				}
			});
		} else {
			return false;
		}
	}

	function cancel(){
		let item = document.querySelectorAll(".QnA-wrapper");
		let item2 = document.querySelectorAll(".Answered-btn-area");
		let btnAnswer = document.querySelectorAll(".QnA-wrapper + .unAnswered-btn-area");

		for (let i = 0; i < item.length; i++) {
			item[i].classList.remove("dp-none");
			item[i].classList.add("dp-block");
			document.querySelector(".write-area").classList.remove("dp-block");
			document.querySelector(".write-area").classList.add("dp-none");
			item[i].classList.remove("dp-none");
			item[i].classList.add("dp-block");
		}
		for (let i = 0; i < btnAnswer.length; i++) {
			if(btnAnswer[i].classList.contains("active")){
				btnAnswer[i].classList.remove("active");
			}
		}
	}
</script>







</body>
</html>