<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${empty manager || manager eq null || manager eq '' || manager ne 'M'}">
	<script type="text/javascript">
		alert("접근 권한이 없습니다.");
		location.href = "${pageContext.request.contextPath}/member/memberLogin.do";
	</script>
</c:if>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 페이지-신고내역</title>
<link rel="stylesheet" type="text/css" href="../source/css/report.css">
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
</head>
<body>

	<jsp:include page="../source/include/header.jsp"/>
			
	<div class="container">
		
		<div class="container-title">
			<h1>REPORT</h1>
		</div>
			
		<div class="m-navi">
			<div class="report-tap tap clicked" onclick="mNavi(0)">신고내역</div>
			<div class="QnA-tap tap" onclick="mNavi(1)">1:1 문의내역</div>
			<div class="notice-tap tap" onclick="mNavi(2)">공지사항</div>
			<div class="FAQ-tap tap" onclick="mNavi(3)">자주하는 질문</div>
		</div>
		
		<div class="tabContent">
		
			<table class="report-table">
				<tr>
					<td class="td-cate delCheck td-label">
						<label for="selectAll" class="label-selectAll">
							<input type="checkbox" id="selectAll" class="selectAll">
						</label>
					</td>
					<td class="td-cate reportNum">신고번호</td>
					<td class="td-cate reportCnt">누적신고</td>
					<td class="td-cate sort">분류</td>
					<td class="td-cate reportedBdno">원글 번호</td>
					<td class="td-cate type">유형</td>
					<td class="td-cate userName">닉네임</td>
					<td class="td-cate content">내용</td>
					<td class="td-cate pntYN">패널티 여부</td>
					<td class="td-cate clearYN">글삭제 여부</td>
				</tr>
				<c:forEach var="rp" items="${alist}" varStatus="idx">
					<tr>
						<td class="delCheck">
							<input type="checkbox" class="deleteBox" value="${rp.rpno}">
						</td>
						<td class="reportNum">${rp.rpno}</td>
						<td class="reportCnt">
							<c:choose>
								<c:when test="${rp.rvno ne ''}">
									${rp.rvno_count}
								</c:when>
								<c:when test="${rp.bdno ne ''}">
									${rp.bdno_count}
								</c:when>
								<c:when test="${rp.cmno ne ''}">
									${rp.cmno_count}
								</c:when>
							</c:choose>
						</td>
						<td class="sort">
							<c:choose>
								<c:when test="${rp.rvno ne ''}">
									리뷰
								</c:when>
								<c:when test="${rp.bdno ne ''}">
									갤러리
								</c:when>
								<c:when test="${rp.cmno ne ''}">
									댓글
								</c:when>
							</c:choose>
						</td>
						<td class="reportedBdno">
							<c:choose>
								<c:when test="${rp.rvno ne ''}">
									<input type="text" value="${rp.rvno}" class="rptNum" readonly>
								</c:when>
								<c:when test="${rp.bdno ne ''}">
									<input type="text" value="${rp.bdno}" class="rptNum" readonly>
								</c:when>
								<c:when test="${rp.cmno ne ''}">
									<input type="text" value="${rp.cmno}" class="rptNum" readonly>
								</c:when>
							</c:choose>						
						</td>
						<td class="type">
							<c:choose>
								<c:when test="${rp.rpcate eq 'F' || rp.rpcate eq 'V'}">
									폭언 / 욕설
								</c:when>
								<c:when test="${rp.rpcate eq 'A'}">
									광고
								</c:when>
								<c:when test="${rp.rpcate eq 'P'}">
									음란물
								</c:when>
							</c:choose>						
						</td>
						<td class="userName">
							<c:choose>
								<c:when test="${rp.penaltyVo.pndelyn eq 'N' || rp.penaltyVo.pndelyn eq null || rp.penaltyVo.pndelyn eq ''}">
									<button class="userId" value="${rp.rpno}" onclick="penaltyCancel(${rp.rpno})">${rp.mbname}</button>
								</c:when>
								<c:otherwise>
									<button class="getPenalty" value="${rp.rpno}">${rp.mbname}</button>
								</c:otherwise>
							</c:choose>
						</td>
						<td class="content">
							<c:choose>
								<c:when test="${rp.rvno ne ''}">
								<c:if test="${empty rp.reviewVo.rvcont}">
									<button onclick='location.href="${pageContext.request.contextPath}/contents/contentsDetail.do?contentid=${rp.reviewVo.contentid}&reviewNo=${rp.rvno}"'>이동</button>
								</c:if>
									<a href="${pageContext.request.contextPath}/contents/contentsDetail.do?contentid=${rp.reviewVo.contentid}&reviewNo=${rp.rvno}">
										${rp.reviewVo.rvcont}
									</a>
								</c:when>
								<c:when test="${rp.bdno ne ''}">
									<a href="${pageContext.request.contextPath}/board/galleryContentsInclude.do?bdno=${rp.bdno}">
										${rp.bdcont}
									</a>
								</c:when>
								<c:when test="${rp.cmno ne ''}">
									<a href="${pageContext.request.contextPath}/board/galleryContentsInclude.do?bdno=${rp.commnetVo.bdno}">
										${rp.commnetVo.cmcont}
									</a>
								</c:when>
							</c:choose>	
						</td>
						<td class="pntYN">
							<c:choose>
								<c:when test="${rp.penaltyVo.pndelyn eq 'N'}">
									허위 신고(제재하지 않음)
								</c:when>
								<c:when test="${rp.penaltyVo.pndelyn eq 'W'}">
									일주일 정지
								</c:when>
								<c:when test="${rp.penaltyVo.pndelyn eq 'M'}">
									30일 정지
								</c:when>
								<c:when test="${rp.penaltyVo.pndelyn eq 'S'}">
									영구 정지
								</c:when>
								<c:otherwise>
									패널티 미부여 상태
								</c:otherwise>
							</c:choose>						
						</td>
						<td class="clearYN">
							<c:choose>
								<c:when test="${rp.rpdelyn eq 'N'}">
									<span class="span-N"></span>
								</c:when>
								<c:otherwise>
									<span class="span-Y">삭제됨</span>
								</c:otherwise>
							</c:choose>
						</td>
					</tr>
				</c:forEach>
			</table>
		</div>
		<div class="div-Btn-area">
			<button class="reportedBoardDelete btn" onclick="reportedBoardDeleteUpdate('Y')">글 삭제하기</button>
			<button class="reportedBoardDeleteCancel btn" onclick="reportedBoardDeleteUpdate('N')">글 삭제취소</button>
		</div>
	</div>
	
	<!-- 모달 영역 -->
	<div id="myModal" class="modalFrame dp-none">
		<div class="modalBody">
			<span class="closeBtn">&times;</span>
			<div class="modalContents">
			
			</div>
		</div>
	</div>
	<!-- 모달 영역 -->
	
	<jsp:include page="../source/include/footer.jsp"/>
	
<script>
	
	//상단 메뉴 바 클릭 시 색상변화, 클릭 감지 이벤트 리스너 달아줌
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
	
	//전체선택 or 해제 버튼
	var selectAllBtn = document.querySelector("#selectAll");
	
	selectAllBtn.addEventListener("click", function(){
		var isChecked = selectAllBtn.checked;
		var deleteBox = document.querySelectorAll(".deleteBox");
		if(isChecked){
			for(let i = 0; i < deleteBox.length; i++){
				deleteBox[i].checked = true;
			}
		}else{
			for(let i = 0; i < deleteBox.length; i++){
				deleteBox[i].checked = false;
			}
		}
	});
	
	let checkBoxes = document.querySelectorAll(".deleteBox");
	for(let checkBox of checkBoxes){
		checkBox.addEventListener("click", function(){
			let totalCount = checkBoxes.length;
			let checkedCount = document.querySelectorAll(".deleteBox:checked").length;
			if(totalCount == checkedCount){
				selectAllBtn.checked = true;
			}else{
				selectAllBtn.checked = false;
			}
		});
	}
	

	$(document).ready(function() {
		
		// 삭제 버튼 클릭 시
		$(".deleteBtn").on("click", function() {
			var checkboxes = $(".deleteBox:checked");
			if (checkboxes.length === 0) {
				alert("삭제할 글을 선택하세요");
			}else{
				var confirmDelete = confirm("삭제된 글은 복구가 어렵습니다.\n\n정말 삭제하시겠습니까?");
				if (confirmDelete) {
					
				}else{
					return;
				}
			}
		});
		
		// 사용자 ID 클릭 시 모달 표시
		$(".userId, .getPenalty").on("click", function(event) {
			
			let rpno = $(this).val();
			
			$.ajax({
				type : "post",
				url : "${pageContext.request.contextPath}/report/selectReportedUser.do",
				data : {"rpno" : rpno},
				dataType : "json",
				cache : false,
				success : function(data){
					penaltyPageMaker(data);
				},
				error : function(){
					alert("에러");
				}
			});
			
		});
		
		// 완료, 취소 버튼 클릭 시 모달 닫기
		$(".closeBtn").on("click", function() {
			var modal = $('#myModal');
			modal.removeClass("dp-flex");
			modal.addClass("dp-none");
		});
		
		
	});
	
	//신고목록에서 신고된 원본글 삭제 & 삭제취소
	function reportedBoardDeleteUpdate(YN){
		
		let delYN = YN;
		
		let rpno = $(".deleteBox:checked");
		let rpnoArr = [];	//rpno들을 담는 배열
		let reportedBoardNum = [];
		reportedBoardNum = $(".deleteBox:checked").parent(".delCheck").siblings(".reportedBdno").children(".rptNum");
		let reportedBoardNumArr = [];	//신고된 글들의 번호를 담는 배열
		
		if(rpno.length == 0){
			alert("삭제할 글을 선택해주세요");
			return;
		}else{
			
			$(rpno).each(function(){
				rpnoArr.push($(this).val());
			});
			
			for (var i = 0; i < reportedBoardNum.length; i++) {
				reportedBoardNumArr.push(reportedBoardNum[i].value);
				console.log(reportedBoardNumArr[i]);
			}			
			
			$.ajax({
				type : "post",
				url : "${pageContext.request.contextPath}/report/reportedBoardDeleteUpdate.do",
				traditional : true,
				data : {"delYN" : delYN,
						"rpnoArr" : JSON.stringify(rpnoArr),
						"reportedBoardNumArr" : JSON.stringify(reportedBoardNumArr)},
				dataType : "json",
				cache : false,
				success : function(data){
					if(data.value != 0){
						if(delYN == 'Y'){
							alert(data.value + " 개의 글이 삭제 됐습니다.");
							location.reload();
						}else{
							alert(data.value + " 개의 글이 삭제 취소 됐습니다.");
							location.reload();
						}
					}else if(data.value == 0){
						alert("삭제된 글이 없습니다.");
					}
				},
				error : function(){
					alert("삭제 에러");
				}
			});
		}
	}
	
	
	//모달 영역 밖 클릭 시 모달 닫음
	window.onclick = function(e){
		if(e.target.classList.contains("modalFrame")){
			var modal = $('#myModal');
			modal.removeClass("dp-flex");
			modal.addClass("dp-none");
		}
	}
	
	function penaltyPageMaker(data){
		
		let str = "";
		if(data.length == 0){
			return;
		}
		$(data).each(function(){
			str += "<h2>사용자 정보</h2>"
				+  "<p>신고번호 : <span id='rpno'>"+this.rpno+"</span></p>"
				+  "<p>닉네임 : <span id='userId'>"+this.mbname+"</span></p>"
				+  "<p>Email: <span id='userEmail'>"+this.mbemail+"</span></p>"
				+  "<h2>패널티 선택</h2>"
				+  "<select class='penaltySelect'>"
				+  "	<option value='' selected>패널티 부여 취소</option>"
				+  "	<option value='N'>허위신고 처리</option>"
				+  "	<option value='W'>이용정지(7일)</option>"
				+  "	<option value='M'>이용정지(30일)</option>"
				+  "	<option value='S'>이용정지(영구)</option>"
				+  "</select>"
				+  "<div>"
				+  "	<button class='penaltyInsertBtn' onclick='penaltyInsert("+this.mbno2+")'>완료</button>"
				+  "	<button class='cancelBtn' onclick='penaltyCancel()'>취소</button>"
				+  "</div>";
		});
		
		$(".modalContents").html(str);
		
		var modal = $('#myModal');
		if (modal.hasClass("dp-none")) {
			modal.removeClass("dp-none");
			modal.addClass("dp-flex");
		} 
		else {
			modal.removeClass("dp-flex");
			modal.addClass("dp-none");
		}		
	}
	
	//모달창에서 특정 유저에게 패널티를 부여함
	function penaltyInsert(data){
		
		let rpno = $("span#rpno").text();
		let mbno2 = data;
		let pndelyn = $(".penaltySelect option:selected").val();
		location.href= "${pageContext.request.contextPath}/report/penaltyUpdate.do?rpno="+rpno+"&mbno2="+mbno2+"&pndelyn="+pndelyn+"";
	}
	
	function penaltyCancel(){
		var modal = $('#myModal');
		modal.removeClass("dp-flex");
		modal.addClass("dp-none");
	}
		

	
</script>
</body>
</html>