<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>1:1 문의</title>
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/source/css/qna/myQnA.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.14.0/css/all.min.css"
	integrity="sha512-1PKOgIY59xJ8Co8+NE6FZ+LOAZKjy+KY8iq0G4B3CyeY6wYHN3yt9PW0XpSriVlkMXe40PTKnXrLnZ9+fkDaog=="
	crossorigin="anonymous"/>
</head>
<body>

	<!-- header -->
	<jsp:include page="../source/include/header.jsp"/>	
	
	<!-- page start -->
	<div class="container">
		<div class="container-title">
			<h1>마이페이지</h1>
		</div>
			
		<!-- top menu tap -->
		<jsp:include page="../source/include/mypageNavi.jsp"/>
		
		<div class="contents-area">
			<div class="btn-area">
				<button type="button" class="btn-QnAList btn1 clicked">문의 내역</button>
				<button type="button" class="btn-QnA btn1">문의하기</button>
			</div>
			<div class="list-area">
				<c:set var="j" value="6"></c:set>
           	 	<c:forEach var="qv" items="${q_alist}">
					<c:choose>
						<c:when test="${qv.ambno==0}">	<!-- 미 답변 -->
							<div class="QnA-item">
								<h3 class="QnA-title" id="title${qv.qano}">${qv.qtitle}</h3>
								<p class="QnA-Answer" id="cont${qv.qano}">${qv.qcont}</p>
								<!-- <i class="fa-solid fa-chevron-down"></i> -->
								<button type="button" class="QnA-toggle">
									<i class="fas fa-chevron-down"></i>
									<i class="fas fa-chevron-up"></i>
								</button>						
							</div>
							<div class="unAnswered-btn-area test">
								<button class="btn-Delete btn" onclick="deleteAnswer(${qv.qano})">문의 삭제</button>
								<button class="btn-Modify btn" onclick="qModify(${qv.qano})">문의 수정</button>
							</div>						
						</c:when>					
						<c:otherwise>
							<div class="QnA-item answered">
								<h3 class="QnA-title">${qv.qtitle}</h3>
								<p class="QnA-Answer">${qv.qcont}</p>
								<!-- <i class="fa-solid fa-chevron-down"></i> -->
								<button type="button" class="QnA-toggle">
									<i class="fas fa-chevron-down"></i>
									<i class="fas fa-chevron-up"></i>
								</button>
								<div class="answer-area">
									<h3 class="answer-writer">${qv.ambname}</h3>
									<p class="answer-content">${qv.acont}</p>
								</div>
							</div>							
						</c:otherwise>
					</c:choose>
				</c:forEach>
			</div>
			<div class="write-area dp-none">
				<div class="write-content">
					<form id="form" class="form">
						<div class="QnA-sub">
							<input type="text" id="title" name="bdtitle" class="input-sup" placeholder="제목을 입력해주세요">
						</div>
						<div class="QnA-content">
							<textarea id="content" name="bdcont" class="textarea-content"  placeholder="내용을 입력해주세요"></textarea>
						</div>
					</form>
					<div class="btn-area2">
						<button type="button" id="write" class="btn-write btn2" >등록</button>
						<button type="button" id="cancel" class="btn-cancel btn2">취소</button>
					</div>
				</div>
			</div>
			<div class="modify-area dp-none">
				<div class="write-content">
					<form id="modify-form" class="form">
						<div class="QnA-sub">
							<input type="text" id="modify-title" name="modify-title" class="input-sup" >
						</div>
						<div class="QnA-content">
							<textarea id="modify-content" name="modify-content" class="textarea-content" ></textarea>
						</div>
					</form>
					<div class="btn-area2">
						<button type="button" id="modify-write" class="btn-write btn2" >등록</button>
						<button type="button" id="modify-cancel" class="btn-cancel btn2">취소</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<!-- footer -->
	<jsp:include page="../source/include/footer.jsp"/>
		
</body>
<script>
	function qModify(qano) {
		$(".list-area").addClass('dp-none');
		$(".modify-area").removeClass('dp-none');

		var qtitle = $('#title'+qano).html();
		var qcont = $('#cont'+qano).html();
		console.log(qtitle);
		console.log(qcont);

		$("#modify-title").val(qtitle);
		$("#modify-content").val(qcont);
		$("#modify-write").data("qano", qano);
	}
	 // 문의 수정 함수
	  function modifyAnswer(qano) {
			$.ajax({
			url: '${pageContext.request.contextPath}/qna/qnaModifyAction.do',
			type: 'POST',
			data: {
				'qano': qano,
				'modify-title': $("#modify-title").val(),
				'modify-content': $("#modify-content").val()
				},
			success: function(response) {

				$(".list-area").addClass('dp-none');
				$(".write-area").removeClass('dp-none');
			},
			error: function(xhr, status, error) {
				alert('오류가 발생했습니다. 다시 시도해주세요.');
			}
		});
	}
	
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
	
	function deleteAnswer(qano){
		
		if (confirm("삭제된 글은 복구할수 없습니다.정말 삭제하시겠습니까?")) {
			$.ajax({
				url: '${pageContext.request.contextPath}/qna/qnaDeleteAction.do',
				type: 'POST',
				data: {
					'qano': qano
				},
				success: function(response) {
					alert('qano : ' + qano + ' 번 삭제되었습니다.');
					location.reload(); 
				},
				error: function(xhr, status, error) {
					alert('오류가 발생했습니다. 다시 시도해주세요.');
					}
			});
		}
	}
	
	$(document).ready(function(){
		
		//문의내역 버튼 클릭 시 문의하기 대신 QnA 리스트 출력
		$(".btn-QnAList").on("click", function(){
			$(".list-area").removeClass('dp-none');
			$(".write-area").addClass('dp-none');
		});	
		
		//문의하기 버튼 클릭 시 문의내역 QnA 리스트 대신 글쓰기 출력
		$(".btn-QnA").on("click", function(){
			$(".list-area").addClass('dp-none');
			$(".write-area").removeClass('dp-none');
		});
		
		//문의하기 글 등록 성공시 페이지가 리로드 되며 업로드된 글 바로 불러오기 
		$("#write").on("click", function(){
			
			let title = $("#title");
			let content = $("#content");
			
			if(title.val() == null || title.val() == ""){
				
				alert("제목을 입력해주세요");
				title.focus();
				
			}else if(content.val() == null || content.val() == ""){
				
				alert("내용을 입력해주세요");
				content.focus();
				
			}else{
				 $.ajax({
					url: '${pageContext.request.contextPath}/qna/qnaWriteAction.do',
					type: 'POST', 
					data: {
						bdtitle: title.val(),
						bdcont: content.val()
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
		
		
		
		$("#modify-write").on("click", function(){
			let modifyTitle = $("#modify-title").val();
			let modifyContent = $("#modify-content").val();
			let currentQano = $("#modify-write").data("qano");
			
			if(modifyTitle == null || modifyTitle == ""){
			alert("제목을 입력해주세요");
			$("#modify-title").focus();
			} else if(modifyContent == null || modifyContent == ""){
				alert("내용을 입력해주세요");
				$("#modify-content").focus();
			} else {
				$.ajax({
					url: '${pageContext.request.contextPath}/qna/qnaModifyAction.do',
					type: 'POST',
					data: {
						'qano':currentQano,
						'modify-title': modifyTitle,
						'modify-content': modifyContent
					},
					success: function(response) {
						alert('성공적으로 등록되었습니다.');
						location.reload();
					},
					error: function(xhr, status, error) {
						alert('오류 발생했습니다. 다시 시도해주세요.');
					}
				});
			}
		});
		//취소 버튼 클릭 시 작성된 내용이 있으면 한번 확인 후 문의내역 버튼 클릭
		$("#cancel").on("click", function(){
			
			let title = $("#title");
			let content = $("#content");
			
			if(title.val() != ""){
				if(confirm("작성된 내용이 있습니다.\n취소하시면 내용이 전부 사라집니다.\n\n정말로 취소하시겠습니까?")){
					title.val("");
					content.val("");
					$(".btn-QnAList").trigger("click");
				}else{
					return;
				}
			}else if(content.val() != ""){
				if(confirm("작성된 내용이 있습니다.\n취소하시면 내용이 전부 사라집니다.\n\n정말로 취소하시겠습니까?")){
					title.val("");
					content.val("");
					$(".btn-QnAList").trigger("click");
				}else{
					return;
				}
			}else{
				title.val("");
				content.val("");
				$(".btn-QnAList").trigger("click");
			}

		});
		
	});

</script>
<script>
function check(){

	var fm = document.form; //문서객체안의 폼객체이름
	
	if (fm.bdtitle.value == "") {
	    alert("제목을 입력하세요");
	    fm.bdtitle.focus();
	    return;
	} else if (fm.bdcont.value == "") {
	    alert("내용을 입력하세요");
	    fm.bdcont.focus();
	    return;
	}	
	
	//처리하기위해 이동하는 주소
	fm.action ="<%=request.getContextPath()%>/qna/qnaWriteAction.do";  
	fm.method = "post";  //이동하는 방식  get 노출시킴 post 감추어서 전달
	fm.submit(); //전송시킴
	return;
}


</script>


</html>