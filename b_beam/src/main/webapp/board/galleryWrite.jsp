<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${sessionScope.mbno == null }">
	<script>alert('로그인 하세요.');location.href='${pageContext.request.contextPath}/member/memberLogin.do'</script>
</c:if>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<link href="../source/css/home.css" type="text/css" rel="stylesheet">
	<link href="../source/css/gallery/galleryWrite.css" type="text/css" rel="stylesheet">
	
</head>
<body>
	<jsp:include page="../source/include/header.jsp"/>
	<div class="wrap">
		<div class="gallery">
			<h1>GALLERY</h1>
		</div>
		<div class="container">
			<div class="inner-table">
				<div>
					<label id="back-btn" for="input-back">뒤로가기</label>
					<input type="button" id="input-back" name="btn" style="display:none;" onclick="location.href='${pageContext.request.contextPath}/board/galleryList.do';">
				</div>
				<form name="frm">
					<table class="table-cont">
						<tr style="height:20px;">
							<td>
								<!-- 사진파일 업로드 미리보기 -->
								<div class="upload-box">
									<div id="drop-file" class="drag-file">
										<img src="https://img.icons8.com/pastel-glyph/2x/image-file.png" alt="파일 아이콘" class="image">
										<p class="message">Drag files to upload</p>
										<!-- <img src="" alt="미리보기 이미지" class="preview"> -->
										<div id="previews" class="previews"></div>
									</div>
								</div>
								<!-- 사진 업로드 버튼 -->
								<div class="upload-btn">
									<label class="file-label" for="chooseFile">사진 선택</label>
									<input class="file" id="chooseFile" name="bdglname" multiple
										type="file" 
										onchange="if(checkFileCount(this)) { dropFile.handleFiles(this.files); }"
										accept="image/png, image/jpeg, image/gif">
								</div>
								<!-- 파일 목록을 나타낼 영역 -->
								<!-- <div id="files" class="file-list"></div> -->
							</td>
						</tr>
						<tr style="height:30px;">
							<td >
								<input type="text" id="input-bdtitle" name="bdtitle" placeholder=" 제목을 입력하세요.">
							</td>
						</tr>
						<tr style="height:30px;">
							<td >
								<input type="text" id="input-bdtitle" name="bdtag" placeholder=" 태그를 입력하세요.">
							</td>
						</tr>
						<tr style="height:200px;">
							<td>
								<textarea id="input-bdcont" name="bdcont" placeholder="내용을 입력해주세요."></textarea>
							</td>
						</tr>
						<tr style="height:20px;">
							<td class="write-btn">
								<div class="write-btn">
									<label id="write-label" for="input-write">글쓰기</label>
									<input type="button" id="input-write" name="btn" style="display:none;" onclick="check();">
								</div>
							</td>
						</tr>
					</table>
				</form>
			</div>
		</div>
	</div>
	<jsp:include page="../source/include/footer.jsp"/>
	
	
	
	<!-- 사진파일 업로드 -->
	<script type="text/javascript">
		

	function DropFile(dropAreaId, fileListId) {
		let dropArea = document.getElementById(dropAreaId);
		let fileList = document.getElementById(fileListId);
		let files = [];
		/* 기본 이벤트 막기 */
		function preventDefaults(e) {
			e.preventDefault();
			e.stopPropagation();
		}
		/* 드래그해서 상자로 가져갔을 때 상자 하이라이트 */
		function highlight(e) {
			preventDefaults(e);
			dropArea.classList.add("highlight");
		}

		function unhighlight(e) {
			preventDefaults(e);
			dropArea.classList.remove("highlight");
		}

		function handleDrop(e) {
			unhighlight(e);
			let dt = e.dataTransfer;
			let files = dt.files;
			console.log(files);
			handleFiles(files);

			const fileList = document.getElementById(fileListId);
			if (fileList) {
				fileList.scrollTo({ top: fileList.scrollHeight });
			}
		}

		function handleFiles(selectedFiles) {

			// 최대 허용 파일 갯수 확인
			var maxFileCount = 5;
			
			// 현재 이미 미리보기된 파일 갯수 확인
			var previewedFileCount = document.getElementById('previews').childElementCount;
			
			// 미리보기 이미지를 담을 영역 선택
			let previews = document.getElementById('previews');
		
			// 추가될 파일 수 확인
			var remainingFiles = maxFileCount - previewedFileCount;
			
			// 여러 번 파일을 선택할 때 기존 배열에 추가
			if (files.length < maxFileCount) {
			files.push(...selectedFiles);
			}else {
				alert("최대 " + maxFileCount + "개의 파일만 업로드할 수 있습니다.");
			}

			files.slice(0, remainingFiles).forEach(previewFile);
		}

		function previewFile(file) {
			console.log(file);
			renderFile(file);
		}

		function renderFile(file) {
			let reader = new FileReader();
			reader.readAsDataURL(file);
			reader.onloadend = function () {
				// 미리보기 이미지를 담을 영역 선택
				let previews = document.getElementById('previews');
	
				// 새로운 이미지 생성
				let img = document.createElement('img');
				img.src = reader.result;
				img.style.display = "block";
				previews.appendChild(img);
					
				// 미리보기 이미지가 추가되면 다른 요소들을 숨김
				let dropFile = document.getElementById('drop-file');
				let message = dropFile.querySelector('.message');
				let fileIcon = dropFile.querySelector('.image');
	
				dropFile.classList.add('image-added');
				message.style.display = "none";
				fileIcon.style.display = "none"; // 이미지를 숨김
				
				// 미리보기된 파일 목록을 fileList에 추가
				//let fileListItem = document.createElement('div');
				//fileListItem.textContent = file.name;
				//fileList.appendChild(fileListItem);
			};
		}

		dropArea.addEventListener("dragenter", highlight, false);
		dropArea.addEventListener("dragover", highlight, false);
		dropArea.addEventListener("dragleave", unhighlight, false);
		dropArea.addEventListener("drop", handleDrop, false);

		return {
			handleFiles
		};
	}

	const dropFile = new DropFile("drop-file", "files");

	
	</script>
	
	<script>
		function checkFileCount(input) {
			// 허용할 최대 파일 갯수
			var maxFileCount = 5; 
			//기존 추가된 파일 갯수
			var attFileCount = document.querySelectorAll('#chooseFile').length;
			
			// 추가로 첨부 가능한 파일 갯수
			var remainFileCount = maxFileCount - attFileCount;
			
			// 현재 선택된 파일 수 확인
			var selectedFileCount = input.files.length;
			
			console.log(attFileCount);
			console.log(remainFileCount);
			console.log(selectedFileCount);
			// 최대 허용 파일 갯수를 초과하는 경우
			if (selectedFileCount > maxFileCount) {
				alert("최대 " + maxFileCount + "개의 파일만 업로드할 수 있습니다.");
				console.log(input.files);
				
				 // 파일 input의 값을 초기화
				input.value = ""; 
				
				return false;
			}else{
				console.log(input.files);
				return true;
			}
		}
	
		function check()
		{
			var fm = document.frm;	

			if(fm.bdtitle.value=="")
			{
				alert("제목을 입력하세요");
				fm.bdtitle.focuse();
				return;
			}else if(fm.bdcont.value=="")
			{
				alert("내용을 입력하세요");
				fm.bdcont.focus();
				return;
			}else {
				var files = document.getElementById("chooseFile").files;
				
				console.log(files);
				//debugger;
				if (files.length === 0) {
					alert("사진을 첨부해주세요");
					return;
				}
			}
			
			
			fm.action = "${pageContext.request.contextPath}/board/galleryWriteAction.do";	
			fm.method = "post";					
			fm.enctype="multipart/form-data";
			fm.submit();						
			return;
		}
	</script>
	
</body>
</html>