<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link href="../source/css/gallery/galleryContentsInclude.css" type="text/css" rel="stylesheet">
<!-- Link Swiper's CSS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@10/swiper-bundle.min.css" />

<script type="text/javascript" src="http://code.jquery.com/jquery-1.11.3.min.js"></script>

<div class="contents-area">
	<div class="div-photo">
		<div class="md-div-name-area">
			<div class="md-div-nickname">${bv.mbname}</div>
			<c:if test="${bv.localPeople eq 'Y'}">
				<div class="md-div-mark"></div>
			</c:if>
		</div>
		<div class="photo-area">
			<div class="swiper mySwiper" style="height: 100%;">
				<div class="swiper-wrapper">
					<c:forEach var="images" items="${bv.bdFilename}">
						<div class="swiper-slide">
							<img class="cont-img" src="${pageContext.request.contextPath}/source/galleryImages/${images}">
						</div>
					</c:forEach>
				</div>
				<div class="swiper-button-next" style="color: white;"></div>
				<div class="swiper-button-prev" style="color: white;"></div>
				<div class="swiper-pagination"></div>
			</div>
		</div>
	</div>
	<div class="div-contents">
		<div class="div-title">
			<div class="md-title-area">
				<span class="md-title-span">${bv.bdtitle}</span>
			</div>
			<div class="md-like-area">
				<c:choose>
					<c:when test="${bv.bdLikeYN == 'Y'}">
						<label for="input-like" class="like-button">♥</label>
						<input type="button" id="input-like" class="input-like" name="btn" value="${bv.bdno}">
					</c:when>
					<c:otherwise>
						<label for="input-like" class="like-button">♡</label>
						<input type="button" id="input-like" class="input-like" name="btn" value="${bv.bdno}">
					</c:otherwise>
				</c:choose>
			</div>
		</div>
		<div class="div-content">
			<div class="content-area">
				${bv.bdcont}
			</div>
			<div class="tag-area">
				${bv.bdtag}
			</div>
		</div>
		
		<!-- 댓글 작성 영역 시작-->
		<div class="div-comment-write">
			<div class="comment-write-area">
				<textarea id="input-comment" name="cmcont" class="input-comment" placeholder="댓글을 작성해주세요."></textarea>
				<!-- <input type="text" id="input-comment" name="cmcont" class="input-comment" placeholder="댓글을 작성해주세요."> -->
			</div>
			<div class="comment-write-btn-area">
				<button class="btn-img"></button>
			</div>
		</div>
		<!-- 댓글 작성 영역 끝 -->
		
		<!-- 댓글 리스트 영역 시작-->
		<div class="div-commentList">
			
		</div>
		<!-- 댓글 리스트 영역 끝-->
		
		<div class="div-bottom">
			<c:if test="${mbno eq bv.mbno}">
				<button type="button" class="modi-btn" onclick="location.href='${pageContext.request.contextPath}/board/galleryModify.do?bdno=${bv.bdno}';" >수정</button>
				<button type="button" class="del-btn" onclick="">삭제</button>
				<button type="button" class="popupBtn">팝</button>
			</c:if>
			<button type="button" class="rpt-btn" onclick='boardReport(${bv.bdno})'>&#x1F6A8;</button>
		</div>
		
	</div>
</div>

<!-- 모달 팝업 영역 -->
	<div id="modalWrap" class="modalWrap">
		<div id="modalBody" class="modalBody">
			<span id="closeBtn">&times;</span>
			<div id="modal-include">
				
			</div>
		</div>
	</div>

<script src="https://cdn.jsdelivr.net/npm/swiper@10/swiper-bundle.min.js"></script>
<script>
	var swiper = new Swiper(".mySwiper", {
		spaceBetween: 30,
		centeredSlides: true,
		autoHeight : true,
		slidesPerView: 1,
		pagination: {
			el: ".swiper-pagination",
			clickable: true,
		},
		navigation: {
			nextEl: ".swiper-button-next",
			prevEl: ".swiper-button-prev",
		},
	});	
	
		
	
// 	$(document).ready(function(){
		
		//좋아요 기능
		$(".like-button").on("click", function(){
			
			let mbno = "${mbno}";
			let bdno = $(this).siblings('input').val();
			
			event.preventDefault();
			
			if(!mbno){
				if(confirm("로그인이 필요한 기능입니다.\n\n로그인 하시겠습니까?")){
					location.href = "${pageContext.request.contextPath}/member/memberLogin.do";
				}else{
					return;
				}
			}else{
				let currentLike = $(this);
					
				if(currentLike.text() === "♡") {
				
					$.ajax({
						type : "post",
						url : "${pageContext.request.contextPath}/board/boardLikeUpdate.do",
						data : {"bdno" : bdno},
						dataType : "json",
						cache : false,
						success : function(data){
							if(data.value == 1){
								currentLike.text("♥");
								$("#like-num"+bdno).siblings().text("♥");
							}else{
								alert(data.value + "좋아요 추가 에러");
							}
						},
						error : function(data){
							alert("추가 에러");
						}
					});
					
				}else{
					$.ajax({
						type : "post",
						url : "${pageContext.request.contextPath}/board/boardLikeUpdate.do",
						data : {"bdno" : bdno},
						dataType : "json",
						cache : false,
						success : function(data){
							if(data.value == 1){
								currentLike.text("♡");
								$("#like-num"+bdno).siblings().text("♡");
							}else{
								alert(data.value + "좋아요 취소 에러");
							}							
						},
						error : function(){
							alert("취소 에러");
						}
					});					
				}
			}
		});
		
		//글쓰기 버튼 시 댓글 등록 후 댓글목록 다시 불러옴
		$(".btn-img").on("click", function(event){
			
			event.preventDefault();
			
			let inputComment = $("#input-comment");
			
			let mbno = "${mbno}";
			let bdno = "${bv.bdno}";
			let cmcont = inputComment.val();
			
			if(mbno == null || mbno == ""){
				if(confirm("로그인이 필요한 기능입니다.\n\n로그인 하시겠습니까?")){
					location.href = "${pageContext.request.contextPath}/member/memberLogin.do";
				}else{
					return;
				}
			}else if(inputComment.val() == ""){
				alert("내용을 입력해주세요");
				inputComment.focus();
				return;
			}else{
				$.ajax({
					type : "post",
					url : "${pageContext.request.contextPath}/comment/commentWrite.do",
					data : {"mbno" : mbno, "bdno" : bdno, "cmcont" : cmcont},
					dataType : "json",
					cache : false,
					success : function(data){
						if(data.value == 1){
							if(data.value2 == 1) {
								alert("포인트가 적립되었습니다.");
							}
							commentListLoad();
							inputComment.val("");
						}
					},
					error : function(){
						alert("글등록 에러");
						return;
					}
				});
			}
		});
		
		//로그인 없이 댓글 입력칸 클릭 시
		$("#input-comment").on("click", function(event){
			
			event.preventDefault();
			
			let mbno = "${mbno}";
			
			if(mbno == null || mbno == ""){
				if(confirm("로그인이 필요한 기능입니다.\n\n로그인 하시겠습니까?")){
					location.href = "${pageContext.request.contextPath}/member/memberLogin.do";
				}else{
					return;
				}
			}
		});
		
		//띄운 모달 안의 글 삭제 버튼
		$(".del-btn").on("click", function() {
			
			if (confirm('정말 삭제하시겠습니까?')) {
				
				let bdno = "${bv.bdno}";
			
				$.ajax({
					type: "POST",
					url: "${pageContext.request.contextPath}/board/galleryDeleteAction.do",
					data: {"bdno" : bdno},
					dataType: "json",
					success: function(response) {
						if (response.success) {
							console.log(response);
							alert("삭제되었습니다.");
							//debugger;
							location.href = "${pageContext.request.contextPath}/board/galleryList.do";
						}
					},
					error: function(request, status, error) {
						alert("code : "+request.status+"\n"+"message : " +request.responseText+"\n"+"error : "+ error);
					}
				});
				
			}else{
				return;
			}
		});
		
		/* //게시글 신고 버튼
		$(".rpt-btn").on("click", function() {
			
			if (confirm('정말 신고하시겠습니까?')) {
				
				let bdno = "${bv.bdno}";
				let mbno2 = "${bv.mbno}";
				
				$.ajax({
					type: "POST",
					url: "${pageContext.request.contextPath}/report/reportAction.do",
					data: {"bdno" : bdno, "mbno2" : mbno2},
					dataType: "json",
					success: function(response) {
						if (response.success) {
							alert("신고되었습니다.");
							location.href = "${pageContext.request.contextPath}/board/galleryList.do";
						}
					},
					error: function(request, status, error) {
						alert("code : "+request.status+"\n"+"message : " +request.responseText+"\n"+"error : "+ error);
					}
				});
				
			}else{
				return;
			}
		}); */
		
		
// 	});
	
	function commentListLoad(){
		
		let bdno = "${bv.bdno}";
		
		$.ajax({
			type : "post",
			url : "${pageContext.request.contextPath}/comment/commentList.do",
			data : {"bdno" : bdno},
			dataType : "json",
			cache : false,
			success : function(data){
				createCommentList(data);
			},
			error : function(){
				alert("commentListLoad 에러");
				return;
			}
			
		});
	}
	commentListLoad();
	
	//화면 로드 시 bdno들고가서 bdno에 맞는 commentList 불러와서 화면에 그림
	function createCommentList(data){
		event.preventDefault();
		let str = "";
		let mbno = "${mbno}";
		
		if(data.length == 0){
			$(".div-commentList").html(str);
			return;
		}
		$(data).each(function(index){
			
			if(mbno == this.mbno){
				
				str += "<div id='comment-area"+this.cmno+"' class='comment-area'>"
					+		"<div class='comment-id'>"
					+			"<span class='span-nick'>"+this.mbname+"</span>"
					+		"</div>"
					+		"<div class='comment-cont'>"
					+			"<span class='span-cont'>"+this.cmcont+"</span>"
					+		"</div>"
					+		"<div class='comment-date'>"
					+			"<span class='span-date'>"+this.cmdate+"</span>"
					+		"</div>"
					+		"<div class='comment-btn'>"
					+			"<button type='button' class='btn-delete' onclick='commentDelete("+this.cmno+")'>삭제</button>"
					+			"<button type='button' class='rpt-btn' onclick='commentReport("+this.cmno+")'>&#x1F6A8;</button>"	
					+		"</div>"
					+	"</div>";			//onclick='commentDelete("+this.cmno+")'
			}else{
				str += "<div class='comment-area' id='comment-area"+this.cmno+"'>"
					+		"<div class='comment-id'>"
					+			"<span class='span-nick'>"+this.mbname+"</span>"
					+		"</div>"
					+		"<div class='comment-cont'>"
					+			"<span class='span-cont'>"+this.cmcont+"</span>"
					+		"</div>"
					+		"<div class='comment-date'>"
					+			"<span class='span-date'>"+this.cmdate+"</span>"
					+		"</div>"
					+		"<div class='comment-btn'>"
					+			"<button type='button' class='rpt-btn' onclick='commentReport("+this.cmno+")'>&#x1F6A8;</button>"	
					+		"</div>"
					+	"</div>";
			}
			//+			"<button type='button' class='btn-modify' onclick=''>수정</button>"
			$(".div-commentList").html(str);
			
			return;
		});
	}
	
	function commentDelete(idx){
		
		event.preventDefault();
		event.stopPropagation()
		
		let cmno = idx;
		
 		if(confirm("해당 댓글을 삭제하시겠습니까?")){
			$.ajax({
				type : "post",
				url : "${pageContext.request.contextPath}/comment/commentDelete.do",
				data : {"cmno" : cmno},
				dataType : "json",
				cache : false,
				success : function(data){
					if(data.value == 1){
						alert("해당 댓글이 삭제되었습니다.");
						commentListLoad();
					}
				},
				error : function(){
					alert("삭제 에러");
					return;
				}
			});
		}else{
			return;
		}
	}
	
	/* function commentReport(idx){
		
		event.preventDefault();
		event.stopPropagation()
		
		let cmno = idx;
		let mbno2 = "${bv.mbno}";
		
		if(confirm("신고 하시겠습니까?")){
			$.ajax({
				type : "post",
				url : "${pageContext.request.contextPath}/report/reportAction.do",
				data : {"cmno" : cmno, "mbno2" : mbno2},
				dataType : "json",
				cache : false,
				success : function(data){
					if(data.value == 1){
						alert("신고되었습니다.");
						commentListLoad();
					}
				},
				error : function(){
					alert("신고 에러");
					return;
				}
			});
		}else{
			return;
		}
		
	} */
	
	function boardReport(bdno){
		
		var url="${pageContext.request.contextPath}/report/reportPopup.do?no="+bdno+"&cate=bdno";

		window.open(url,'_blank','width=500 height=600');
	}
	
	function commentReport(cmno){
		
		var url="${pageContext.request.contextPath}/report/reportPopup.do?no="+cmno+"&cate=cmno";

		window.open(url,'_blank','width=500 height=600');
	}
	

	/* 모달 팝업 스크립트 */
	const popup = document.querySelectorAll('.popupBtn');
	const modal = document.getElementById('modalWrap');
	const closeBtn = document.getElementById('closeBtn');
		
	//모달 영역 밖 클릭 시 모달 닫음
	window.onclick = function(e){
		if(e.target.classList.contains("modalWrap")){
			document.querySelector("#modalWrap").style.display = "none";
		}
	}
	
	//X버튼 클릭 시 모달 닫음
	closeBtn.onclick = function() {
		modal.style.display = 'none';
	}
	
	//제이쿼리 영역

		
		//글 클릭 시 상세보기 페이지 모달로 띄워주는 함수
		$(".popupBtn").on("click", function(){
			event.preventDefault();
			let bdno = $(this).val();
			
			$.ajax({
				type : "get",
				url : "${pageContext.request.contextPath}/report/reportTest.do",
				dataType : "html",
				cachce : false,
				success : function(){
					$("#modal-include").html();
					$("#modalWrap").css('display', 'flex');
				},
				error : function(){
					alert("popupBtn 에러");
				}
			});
		});
	
	
	
</script>