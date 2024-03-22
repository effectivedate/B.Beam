<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%

pageContext.setAttribute("DT", "'"); 

pageContext.setAttribute("LF", "\n"); 

%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>컨텐츠 상세보기 페이지</title>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/ekko-lightbox/5.3.0/ekko-lightbox.min.css">
<link rel="stylesheet" type="text/css" href="../source/css/contents/contentsDetail.css">
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=d6eaf7ed9af48a5319b75a0937ac3096"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@10/swiper-bundle.min.css" />
<script src="https://cdn.jsdelivr.net/npm/swiper@10/swiper-bundle.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">


<script type="text/javascript">
//사진클릭시 메인,서브 이미지 교체 부분 스크립트 ----------------------------------------
document.addEventListener('DOMContentLoaded', function() {
	  const smallImages = document.querySelectorAll('.smallImage');
	  const bigImage = document.getElementById('bigImage');

	  smallImages.forEach((image) => {
	    image.addEventListener('click', function() {
	      bigImage.src = this.src;
	    });
	  });
	});
	

</script>	

</head>
<body>



<jsp:include page="../source/include/header.jsp"/>



<div class="container">

	<div class="container-title">
		<h1>DETAIL CONTENTS</h1>
	</div>
	<div class="contentsdetail">
		<div class="contents-visual">
			<div class="title-section">
		       	<p>${cv.title} </p>
		       	<span class="view">
		       	조회수 : <span id="viewcnt">${cv.contentsView}</span> 
		       	<br> 즐겨찾기수 : <span id="bmcnt">${cv.contentLikeCnt}</span>
		       	<div id="ratingContainer" style="display:flex;"></div>
		       	</span>
	      		 <div id="favorite" class="favorite"></div>
		   	</div>
		<%-- 		    	<c:choose> --%>
		<%-- 		    		<c:when test="${cv.contentLikeYN eq 'Y'}"> --%>
		<!-- 			       		 <span class="favorite-icon on">★</span> -->
		<%-- 			    	</c:when> --%>
		<%-- 			    	<c:otherwise> --%>
		<!-- 			       		 <span class="favorite-icon">☆</span> -->
		<%-- 			    	</c:otherwise> --%>
		<%-- 			    </c:choose> --%>
		   	<div class="main-image-section">
		   		<c:choose>
		    		<c:when test="${not empty cv.firstimage}">
		            	<img id="bigImage" src="${cv.firstimage}" alt="Main Image">
		            </c:when>
		            <c:otherwise>
		            	<img id="bigImage" src="../source/images/notFound.png" alt="Main Image">
		            </c:otherwise>
		        </c:choose>
			</div>
			<div class="small-images-section">
			<c:choose>
		    		<c:when test="${not empty cv.firstimage}">
		            	<img id="smallImage" src="${cv.firstimage}" alt="대표이미지">
		            </c:when>
		            <c:otherwise>
		            	<img id="smallImage" src="../source/images/notFound.png" alt="대표이미지">
		            </c:otherwise>
		        </c:choose>
<!-- 			    <img class="smallImage" src="../source/images/duck4.jpg" alt="Small Image"> -->
<!-- 				<img class="smallImage" src="../source/images/duck1.png" alt="Small Image"> -->
<!-- 				<img class="smallImage" src="../source/images/duck3.jpg" alt="Small Image"> -->
<!-- 				<img class="smallImage" src="../source/images/duck2.png" alt="Small Image"> -->
<!-- 				<img class="smallImage" src="../source/images/duck5.jpg" alt="Small Image"> -->
<!-- 				<img class="smallImage" src="../source/images/duck4.jpg" alt="Small Image"> -->
			</div>
		</div>
		
			
		<div class="tabBox">
			<ul class="info-tab">
				<li>
	    			<a onclick="tabSwitch(1)" class="btn" >기본정보</a>
				</li>
				  <li>
					<a onclick="tabSwitch(2)" class="btn" >이용안내</a>
				</li>
				  <li>
				   <a onclick="tabSwitch(3)" class="btn" >위치정보</a>
				</li>
			</ul>
		
			<div class="tab-content" id="tab1-Detail">
	           
	        </div>
			<div class="tab-content" id="tab2-Intro" style="display:none;">
				<table id="tab2-table">
				</table>
	        </div>
	        
			<div class="tab-content" id="tab3-Map" style="display:none;">
				<div id="map" style="width:100%; height:500px;"></div>
	       	</div>
		</div>
	</div>
			
	<div>
		<div class="reviewArea">
		   <p>방문자 후기 및 평가</p>
		   <div class="commentArea">
		    <c:choose>
		    	<c:when test="${empty mbno}">
		    <select id="ratingSelect" onclick='lgcheck();'>
		        <option value="0" disabled selected>별점을 선택하세요</option>
		    </select>
		    	</c:when>
		    	<c:otherwise>
		    <select id="ratingSelect">
		    
		        <option value="0" disabled selected>별점을 선택하세요</option>
		        <option value="1">★</option>
		        <option value="2">★★</option>
		        <option value="3">★★★</option>
		        <option value="4">★★★★</option>
		        <option value="5">★★★★★</option>
		    </select>
		    	</c:otherwise>
		    </c:choose>
		    <c:choose>
		    	<c:when test="${empty mbno}">
<textarea id="commentInput" placeholder="후기를 남겨주세요 (글자수 100자제한)" oninput="updateCharacterCount()" onclick="lgcheck();"></textarea>
		    	</c:when>
		    	<c:otherwise>
		    	   <textarea id="commentInput" placeholder="후기를 남겨주세요 (글자수 100자제한)" oninput="updateCharacterCount()"></textarea>
				    <div class="commentCnt">글자수 제한 <span>100</span>/100자</div>
		    	
		    	</c:otherwise>
		    </c:choose>
		   <c:choose>
		    	<c:when test="${empty mbno}">
		    <button class="commentBtn" onclick="lgcheck();">작성</button>
		    	</c:when>
		    	<c:otherwise>
		    <button class="commentBtn" onclick="reviewInsert()">작성</button>
		    	</c:otherwise>
		    </c:choose>
		    </div>
		 
<!-- 		    	<form id='Uploadfrm' method='post'> -->
				    <label for="imageUpload" class="custom-image-upload-button">
				        <i class="fas fa-camera"></i> 
				    </label>			    
				    <input type="file" id="imageUpload" accept="image/*" multiple>
<!-- 		    	</form> -->
			    
			    <div class="image-preview">

			        <img id="uploadedImage" alt="Uploaded Image" style="display: none;">
			        <button class="remove-image-button" style="display: none;" onclick="removeImagePreview()">X</button>
			    </div>
		</div>

<hr id="cutLine">		
		
		<div  class="commentArray">
			<h2>총<span id="cmtCnt">1766</span>건</h2>
			<button type="button"  id="1">인기순</button>
			<button type="button" id="2">최신순</button>
		</div>
		
		
			
		<div class="commentReply">
<!-- 			<table id="commentTable"> -->
<!-- 	        	<tr> -->
<!-- 	        		<th id="userId">피묻은각도기</th> -->
	        		
<!-- 	        		<th id="star">★★★★★</th> -->
	        		
<!-- 	        		<th id="text" rowspan="2">글내용이 출력됩니다 우측사진을 클릭하면 팝업창이 뜨게되고  사진이 여러장일때 화살표로 넘기면서 모두 확인가능합니다</th> -->
	        		
<!-- 	        		<th rowspan="2"> -->
<!-- 					    <div class="imageContainer"> -->
<!-- 		                    <img src="../source/images/duck4.jpg" class="commentImage"> -->
		                   
<!-- 		                </div> -->
<!-- 					</th> -->
							        		
		            
<!-- 		            <th> <button type="button" id="optBtn" onclick="">...</button></th> -->
<!-- 	        	<tr> -->
<!-- 	        		<th id="day" colspan="2">2024.11.06</th> -->
	        		
<!-- 	        		 <th id="up" type="button" class="likebtn"> -->
<!-- 		                 <button class="like-button" onclick="like(this)"> -->
<!-- 						    <i class="fas fa-heart"></i> -->
<!-- 						  </button> -->
<!-- 		                 <span id="likeCount">1104</span> -->
<!-- 		            </th> -->
		            
<!-- 	        	</tr> -->
	        	
<!-- 	    	</table> -->
	    	
<!-- 	    	<table id="commentTable"> -->
<!-- 	        	<tr> -->
<!-- 	        		<th id="userId">단단한점토</th> -->
	        		
<!-- 	        		<th id="star">★★★</th> -->
	        		
<!-- 	        		<th id="text" rowspan="2">글내용이 출력됩니다 우측사진을 클릭하면 팝업창이 뜨게되고  사진이 여러장일때 화살표로 넘기면서 모두 확인가능합니다</th> -->
	        		
<!-- 	        		<th rowspan="2"> -->
<!-- 					    <div class="imageContainer"> -->
<!-- 		                    <img src="../source/images/duck4.jpg" class="commentImage"> -->
		                   
<!-- 		                </div> -->
<!-- 					</th> -->
							        		
<!-- 		            <th> <button type="button" id="optBtn" onclick="">...</button></th> -->
<!-- 	        	<tr> -->
<!-- 	        		<th id="day" colspan="2">2024.11.03</th> -->
	        		
<!-- 	        		 <th id="up" type="button" class="likebtn"> -->
<!-- 		                 <button class="like-button" onclick="like(this)"> -->
<!-- 						    <i class="fas fa-heart"></i> -->
<!-- 						  </button> -->
<!-- 		                 <span id="likeCount">410</span> -->
<!-- 		            </th> -->
<!-- 	        	</tr> -->
<!-- 	    	</table> -->
<!-- 	    	<table id="commentTable"> -->
<!-- 	        	<tr> -->
<!-- 	        		<th id="userId">+12수수깡</th> -->
	        		
<!-- 	        		<th id="star">★★★★</th> -->
	        		
<!-- 	        		<th id="text" rowspan="2">글내용이 출력됩니다 우측사진을 클릭하면 팝업창이 뜨게되고  사진이 여러장일때 화살표로 넘기면서 모두 확인가능합니다글내용이 출력됩니다 우측사진을 클릭하면 팝업창이 뜨게되고  사진이 여러장일때 화살표로 넘기면서 모두 확인가능합니다글내용이 출력됩니다 우측사진을 클릭하면 팝업창이 뜨게되고  사진이 여러장일때 화살표로 넘기면서 모두 확인가능합니다글내용이 출력됩니다 우측사진을 클릭하면 팝업창이 뜨게되고  사진이 여러장일때 화살표로 넘기면서 모두 확인가능합니다</th> -->
	        		
<!-- 	        		<th rowspan="2"> -->
<!-- 					    <div class="imageContainer"> -->
<!-- 		                    <img src="../source/images/duck4.jpg" class="commentImage"> -->
		                   
<!-- 		                </div> -->
<!-- 					</th> -->
							        		
<!-- 		            <th> <button type="button" id="optBtn" onclick="">...</button></th> -->
<!-- 	        	<tr> -->
<!-- 	        		<th id="day" colspan="2">2024.11.06</th> -->
	        		
<!-- 	        		 <th id="up" type="button" class="likebtn"> -->
<!-- 		                 <button class="like-button" onclick="like(this)"> -->
<!-- 						    <i class="fas fa-heart"></i> -->
<!-- 						  </button> -->
<!-- 		                 <span id="likeCount">21</span> -->
<!-- 		            </th> -->
<!-- 	        	</tr> -->
<!-- 	    	</table> -->
		</div>
	</div>
</div>	

	<jsp:include page="../source/include/footer.jsp"/>
<div id="modalWrap" class="modalWrap">
	<div id="modalBody">
		<span id="closeBtn">&times;</span>
		<div class="contents-area">
			<div class="review-photo">
				<div class="swiper mySwiper" style="height: 100%;">
					<div class="swiper-wrapper">
						
					</div>
					<div class="swiper-button-next" style="color: white;"></div>
					<div class="swiper-button-prev" style="color: white;"></div>
					<div class="swiper-pagination"></div>
				</div>
			</div>
		</div>
	</div>
</div>
<script>
	var mapContainer = document.getElementById('map'), 						//지도를 담을 영역의 DOM 레퍼런스
		mapOption = { 														//지도를 생성할 때 필요한 기본 옵션
			center: new kakao.maps.LatLng(${cv.mapy}, ${cv.mapx}), 			//지도의 중심좌표.
			//draggable: false,												//드래그로 다른 위치로 변경하는 기능 비활성화
			level: 6 														//지도의 레벨(확대, 축소 정도)
		};
	
	var map = new kakao.maps.Map(mapContainer, mapOption); //지도 생성 및 객체 리턴
	var positions = [
		{title: '${cv.title}',	//${cv.title}
//			 content: 	"<div style='padding: 5px;'>"
//			 		  +		"<button type='button' onclick='closeOverlay()'>닫기</button>"
//					  +		"<a href='https://map.kakao.com/link/map/Hello World!,${cv.mapy}, ${cv.mapx}' class='a1' target='_blank'>큰 지도보기</a>"
//					  + 	"<a href='https://map.kakao.com/link/to/Hello World!,${cv.mapy}, ${cv.mapx}' class='a2' target='_blank'>길찾기</a>"
//					  + "</div>",
		 latlng: new kakao.maps.LatLng(${cv.mapy}, ${cv.mapx})	//${cv.mapy}, ${cv.mapx}
		}
	];
// 	var jsonlist = [];
// 	var jsonsize = Object.keys(${arylist}).length;
// 	for(let i = 0; i < jsonsize; i++){
// 		jsonlist.push(${arylist}[i]);
// 	}
	var bounds = new kakao.maps.LatLngBounds();
	var overlayArray = [];	//마커 클릭 시 띄울 오버레이들 담는 배열
	
	for (var i = 0; i < positions.length; i++) {	//데이터 개수만큼 반복문 돌면서 마커, 오버레이 생성
		var data = positions[i];
		displayMarker(data);
	}
	
	function displayMarker(data){
		
		var marker = new kakao.maps.Marker({	//좌표값을 지정해 마커 생성
			map : map,
			position : data.latlng,
			title : data.title,
			clickable : true
		});		
		
		var overlay = new kakao.maps.CustomOverlay({	//마커를 클릭하면 띄워줄 오버레이
			yAnchor: 3,
			position: marker.getPosition()
		});
	  	
	  	var content = '<div class="mapwrap">' + 
			          '    <div class="info">' + 
			          '        <div class="title">' + 
			          '            '+data.title+'' + 
			          '            <div class="close" onclick="closeOverlay()" title="닫기"></div>' + 
			          '        </div>' + 
			          '        <div class="body">' + 
			          '            <div class="img">' +
			          '                <img src="${contents.firstimage2}" width="73" height="70">' +
			          '           </div>' + 
			          '            <div class="desc">' + 
			          '                <div class="ellipsis">${contents.addr1}</div>' + 
			          '                <div class="jibun ellipsis">${contents.zipcode}</div>' + 
			          '                <div><a href="https://map.kakao.com/link/to/Hello World!,${cv.mapy},${cv.mapx}" class="a2" target="_blank">길찾기</a></div>' + 
			          '            </div>' + 
			          '        </div>' + 
			          '    </div>' +    
			          '</div>';
	    
	    overlay.setContent(content);	//만든 컨텐츠들을 overlay에 할당해줌

	    kakao.maps.event.addListener(marker, 'click', function() {	//클릭 시 오버레이 띄움
	    	closeOverlay();
	        overlay.setMap(map);
	    });		
		
		bounds.extend(data.latlng);
		overlayArray.push(overlay);
	}
	function setBounds() {
	    // LatLngBounds 객체에 추가된 좌표들을 기준으로 지도의 범위를 재설정합니다
	    // 이때 지도의 중심좌표와 레벨이 변경될 수 있습니다
	    map.setBounds(bounds);
	}
	
	function closeOverlay(){	//다른 마커 클릭 시 열려있는 다른 오버레이 닫아줌
		for (let i = 0; i < overlayArray.length; i++) {
			overlayArray[i].setMap(null);
		}
	}
	function makeOutListener(infowindow) {
	    return function() {
	        infowindow.close();
	    };
	}
	
	function setDraggable(draggable){
		map.setDraggable(draggable);
	}
	var mapTypeControl = new kakao.maps.MapTypeControl();	//지도, 스카이뷰 버튼 추가
	map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
	
	var zoomControl = new kakao.maps.ZoomControl();		//확대, 축소 UI 추가
	map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);
	function relayout() {    
	    
	    // 지도를 표시하는 div 크기를 변경한 이후 지도가 정상적으로 표출되지 않을 수도 있습니다
	    // 크기를 변경한 이후에는 반드시  map.relayout 함수를 호출해야 합니다 
	    // window의 resize 이벤트에 의한 크기변경은 map.relayout 함수가 자동으로 호출됩니다
	    map.relayout();
	}
	function resizeMap() {
	    var mapContainer = document.getElementById('map');            
	    // 이동할 위도 경도 위치를 생성합니다 
	    var moveLatLon = new kakao.maps.LatLng(${cv.mapy}, ${cv.mapx});
	    
	    // 지도 중심을 이동 시킵니다
	    map.setCenter(moveLatLon);
	}
</script>
<script>
function tabSwitch(e){
	if(e==1){
		$('#tab1-Detail').css('display','');
		$('#tab2-Intro').css('display','none');
		$('#tab3-Map').css('display','none');
	}else if(e==2){
		$('#tab1-Detail').css('display','none');
		$('#tab2-Intro').css('display','');
		$('#tab3-Map').css('display','none');
	}else if(e==3){
		$('#tab1-Detail').css('display','none');
		$('#tab2-Intro').css('display','none');
		$('#tab3-Map').css('display','');
		relayout();
		resizeMap();
	}
}
</script>
<script>
//이미지 업로드 파일 선택 + 선택된 파일 이미지를 미리보기할수있는 기능 -----------------------
// 이미지 하나 삭제하는부분까지 완료!!!! 그뒤에는 부탁합니다!!_--------------------
document.addEventListener('DOMContentLoaded', function() {
    const imageUpload = document.getElementById('imageUpload');
    const imagePreview = document.querySelector('.image-preview');

    imageUpload.addEventListener('change', function() {
        const files = imageUpload.files;

        for (let i = 0; i < files.length; i++) {
            const file = files[i];
            const reader = new FileReader();

            reader.onload = function(e) {
                const img = document.createElement('img');
                img.src = e.target.result;
                img.style.width = '60px';
                img.style.height = '80px';

                const imageDiv = document.createElement('div');
                imageDiv.classList.add('image-preview-item');
                imageDiv.appendChild(img);

                const closeButton = document.createElement('button');
                closeButton.classList.add('remove-image-button');
                closeButton.innerHTML = 'X';
//                 closeButton.id = 'rmbt'+i;
//                 closeButton.onclick = 'rmbt('+i+');';
                closeButton.onclick = function() {
                	const dataTransfer = new DataTransfer();
                	let files = $('#imageUpload')[0].files;
                	fileArray = Array.from(files);
                	fileArray.splice(i,1);
                	fileArray.forEach(file => {dataTransfer.items.add(file);});
                	$('#imageUpload')[0].files = dataTransfer.files;
                    imageDiv.remove(); // 클릭하여 이미지 미리보기 제거
                    console.log(i);
                };

                imageDiv.appendChild(closeButton);

                imagePreview.appendChild(imageDiv);
            };

            reader.readAsDataURL(file);
        }

		console.log($('#imageUpload')[0].files);
//         imageUpload.value = ''; // 파일 선택창 비우기
// 		console.log($('#imageUpload')[0].files);
    });
});
</script>



<script>
  // 글자 수 제한 및 카운트 업데이트 함수
  function updateCharacterCount() {
    const textarea = document.getElementById('commentInput');
    const characterCount = document.querySelector('.commentCnt span');
    const maxLength = 100; // 원하는 글자 수 제한을 여기에 설정하세요

    const currentLength = textarea.value.length;
    characterCount.textContent = currentLength;

    if (currentLength > maxLength) {
      textarea.value = textarea.value.substring(0, maxLength); // 초과된 글자 제한
    }
  }

  // 텍스트 영역에 입력이 발생할 때 이벤트 리스너 추가
  document.getElementById('commentInput').addEventListener('input', updateCharacterCount);

	
</script>
<script>
// 페이지 로딩시 즐겨찾기여부와 리뷰를 불러오기
getBookmark();
getImage();
getDetail();
getIntro();
//getReviewList();
	function getBookmark(){
		// 해당 컨텐츠가 사용자가 bookmark를 한 컨텐츠인지 구분해서 보여주는 함수
		
		$.ajax({
			type:"post",
			url:"${pageContext.request.contextPath}/contents/getBookmark.do",
			data:{"contentid":${param.contentid}},
			dataType:"json",
			success:function(data){
// 				console.log(data);
				if(data.value==1){// 북마크를 한 컨텐츠
					$('#favorite').html('<span class="favorite-icon on" onclick="undoBookmark();">★</span>')	
				}else if(data.value==0||data.value==2){// 북마크 하지 않은 컨텐츠 / 로그인을 하지 않았을 경우
					$('#favorite').html('<span class="favorite-icon" onclick="doBookmark();">☆</span>')	
				}
			},
			error:function(){
// 				console.log("error");
			}
		});
	}
	function doBookmark(){
		// bookmark를 하는 함수
		
		// 즐겨찾기 갯수 선언
		var bmcnt = parseInt($("#bmcnt").html());
		// 로그인 상태가 아니라면 로그인 페이지로 이동을 유도하는 
		if (${empty mbno}){
			var login = confirm("로그인을 해주세요");
			if(login){
				location.href="${pageContext.request.contextPath}/member/memberLogin.do"
			}
		}
		$.ajax({
			type:"post",
			url:"${pageContext.request.contextPath}/contents/doBookmark.do",
			data:{"contentid":${param.contentid}},
			dataType:"json",
			success:function(data){
// 				console.log(data);
					$('#favorite').html('<span class="favorite-icon on" onclick="undoBookmark();">★</span>');
					$("#bmcnt").html(bmcnt+1);
			},
			error:function(){
// 				console.log("error");
			}
		});
	}
	function undoBookmark(){
		// bookmark를 하는 함수
		
		// 즐겨찾기 갯수 선언
		var bmcnt = parseInt($("#bmcnt").html());
		
		$.ajax({
			type:"post",
			url:"${pageContext.request.contextPath}/contents/undoBookmark.do",
			data:{"contentid":${param.contentid}},
			dataType:"json",
			success:function(data){
// 				console.log(data);
					$('#favorite').html('<span class="favorite-icon" onclick="doBookmark();">☆</span>');
					$("#bmcnt").html(bmcnt-1);
			},
			error:function(){
// 				console.log("error");
			}
		});
	}
	function getImage(){
		var contentsImage = ${contentsImage};
		$.each(contentsImage,function(key,value){
// 			console.log(value.originimgurl);
// 			console.log(value.imgname);

			$('.small-images-section').append('<img class="smallImage" src="'+value.originimgurl+'" alt="'+value.imgname+'">')
		});
		if('${cv.contenttypeid}'=='39'){
			var menuImage = ${menuImage};
			$.each(menuImage,function(key,value){
				$('.small-images-section').append('<img class="smallImage" src="'+value.originimgurl+'" alt="'+value.imgname+'">')
			});
		}
	}
	function getDetail(){
		var ary = ['홈페이지','전화번호','주소','우편번호','개요'];
		var ary2 = ['${fn:replace(fn:replace(contents.homepage, LF, ''), DT, '')}','${contents.tel}','${contents.addr1}','${contents.zipcode}','${fn:replace(fn:replace(contents.overview, LF, ''), DT, '')}'];
		var ary3 = ['${not empty contents.homepage}','${not empty contents.tel}','${not empty contents.addr1}','${not empty contents.zipcode}','${not empty contents.overview}'];
		var table = '<table>';
		for(let i = 0; i < ary3.length; i++){
			if(ary3[i]=='false'){
				continue;
// 				console.log('거짓');
				
			}
			if(i==4){
				table  += '</table><br><h1>개요</h1><p>'+ary2[i]+'</p>';
// 				console.log('끝');
			}else{
				table  += '<tr><td>'+ary[i]+'</td><td>'+ary2[i]+'</td></tr>';
// 				console.log('i : ' + i);
			}
		}
		$('#tab1-Detail').html(table);
	}
	function getIntro(){
		var contentIntro = ${fn:replace(fn:replace(contentIntro, LF, ''), DT, '')};
		
// 		var ConversoinIntro = [];
		$.ajax({
			url : "${pageContext.request.contextPath}/source/json/ConversoinIntro.json",
			type : "get",
			datatype:"json",
			success : function(ConversoinIntro){
// 				console.log('접근성공');
// 				console.log(contentIntro);
// 				console.log(ConversoinIntro);
				var json = ConversoinIntro;
				$.each(contentIntro,function(key,value){
// 					console.log("key:"+key);
// 					console.log("키값이름:"+json[key]);
// 					console.log("밸류값:"+value);
					if(value==""||value==0||json[key]==undefined){
						return;
					}
					$('#tab2-table').append('<tr><td>'+json[key]+'</td><td>'+value+'</td></tr>');

				});
			},
			error:function(){
				alert('접근실패')
			}
		});
// 		fetch("${pageContext.request.contextPath}/source/json/ConversoinIntro.json")
// 		.then(function(response){
// 			return response.json();
// 		})
// 		.then(function(myJson){
// 			ConversoinIntro = JSON.stringify(myJson);
// // 			console.log(JSON.stringify(myJson));
// 		});
		
//		var table = '<table>';
//		for(let i = 0; i < ary3.length; i++){
//			if(ary3[i]=='false'){
//				continue;
//				console.log('거짓');
			
//			}
//			if(i==4){
//				table  += '</table><br><h1>개요</h1><p>'+ary2[i]+'</p>';
//				console.log('끝');
//			}else{
//				table  += '<tr><td>'+ary[i]+'</td><td>'+ary2[i]+'</td></tr>';
//				console.log('i : ' + i);
//			}
//		}
//		$('#tab1-Detail').html(table);
}

</script>
<script>
// 리뷰
getReview();
var locaBoolean = true;
// 리뷰 리스트를 부르는 함수
function getReview(){
	$.ajax({
		url : "${pageContext.request.contextPath}/review/reviewList.do",
		type : "get",
		data : {"contentid":${param.contentid}},
		datatype:"json",
		success : function(data){
// 			console.log('접근성공');
// 			console.log(data);
			setReview(data); 
			if(${not empty param.reviewNo}&&locaBoolean){
				var rvlocation = $('#commentTable${param.reviewNo}').offset().top;
				console.log(rvlocation);
				$("html").animate({scrollTop: rvlocation},400);
				locaBoolean = false;
//		 		window.scrollTo({top:rvlocation,behavior:'smooth'});
//		 		var commentTableid = document.getElementById('#commentTable${param.reviewNo}');
//		 		document.getElementById('#commentTable${param.reviewNo}').scrollIntoView({
//		 			behavior:"smooth",
//		 			block:"end",
//		 			inline:"nearest"
//		 		});
			}
		},
		error:function(){
			console.log('접근실패');
		}
	});
}
function setReview(data){
	var str='';
	var mbno='${mbno}';
	var json = JSON.parse(data);
// 	console.log(json);
	$.each(json,function(index,value){
// 		console.log(value.img);
		str+='<table id="commentTable'+value.no+'" class="commentTable">';
		str+='<tr><th id="userId'+value.no+'" class="userId">'+value.name+'</th>';
		str+='<th id="sta'+value.no+'r" class="star">';
		for(let i = 0; i < value.score;i++){
			str+='★'
		}
		str+='</th>';
		str+='<th id="text'+value.no+'" class="text" rowspan="2">'+value.cont+'</th>';
		str+='<th rowspan="2"><div class="imageContainer">';
		if(value.img.length != 0){
			str+='<button type="button" id="popupBtn'+value.no+'" class="popupBtn" value="'+value.no+'">';
			$.each(value.img, function(imgIndex, imgValue){
				str+='<input type="hidden" class="rv'+value.no+'" value="'+imgValue+'">'
			});
			str+='<img src="../source/reviewImages/'+value.img[0]+'" class="commentImage">';
			str+='</button>';
		}
		str+='</div></th>';
		str+='<th>';
		str+='<button type="button" class="rpt-btn" onclick="reviewReport('+value.no+')">&#x1F6A8;</button>';
		str+='</th>';
		str+='<th id="day'+value.no+'" class="day" colspan="2">'+value.date+'</th>';
		str+='<th id="up'+value.no+'" class="up" type="button" class="likebtn">';
		if(value.likeYN==null){
			str+='<button class="like-button" onclick="lgcheck();">';
		}else if(value.likeYN=='N'){
			str+='<button class="like-button" id="like'+value.no+'" onclick="like('+value.no+')">';
		}else{
			str+='<button class="like-button liked" id="like'+value.no+'" onclick="unlike('+value.no+')">';
		}
		str+='<i class="fas fa-heart"></i></button><span id="likeCount'+value.no+'">'+value.likeCnt+'</span>';
		if(mbno==value.mbno){
			str+='<button class="delete-button" onclick="reviewDelete('+value.no+')">삭제</button></th>';
			
		}
		str+='</tr>';
		str+='</table>';
	});
// 	console.log(str);
	$('.commentReply').html(str);
	$('#cmtCnt').html(json.length);
}
function lgcheck(){
	if(confirm("로그인이 필요한 기능입니다. 로그인 하시겠습니까?")){
		location.href="${pageContext.request.contextPath}/member/memberLogin.do"
	}else{
		return;
	}
}
function reviewInsert(){
	if(${empty mbno}){
		if(confirm("로그인이 필요한 기능입니다. 로그인 하시겠습니까?")){
			location.href="${pageContext.request.contextPath}/member/memberLogin.do"
		}else{
			return;
		}
	}else{
		if($('#ratingSelect').val()==null||$('#ratingSelect').val()=='0'){
			alert('리뷰작성시 별점은 필수입니다. 별점을 선택해주세요');
			return;
		}else{
			var review = {"contentid":${param.contentid},"rating":$('#ratingSelect').val()};
			if($('#commentInput').val()!=''){
				review.cont = $('#commentInput').val();
			}
// 			console.log(review);
// 			console.log($('#imageUpload')[0].files);
			$.ajax({
				url : "${pageContext.request.contextPath}/review/reviewInsert.do",
				type : "get",
				data : review,
				datatype:"json",
				success : function(data){
// 		 			console.log('접근성공');
		 			console.log(data.value);
		 			console.log(data.value2);
		 			ImageInsert(data.value);
		 			if(data.value2>0){
		 				alert("포인트가 적립되었습니다.");
		 			}
					getReview(); 
				},
				error:function(){
					console.log('접근실패');
				}
			});
		}
	
	}
}
function ImageInsert(e){
	// 폼 데이터를 보내기위한 가상 폼 생성
	var formData = new FormData();
	// 파일데이터
	let files = $('#imageUpload')[0].files;
	// 가상 폼에 파일데이터를 담음
	for(let i = 0; i < files.length; i++){
		formData.append("uploadFile",files[i]);
	}
// 	console.log(e);
	if(files.length = 0){
		return;
	}else{
		$.ajax({
			url : "${pageContext.request.contextPath}/review/ImageInsert.do",
			type : "POST",
			processData : false,
			contentType : false,
			data : formData,
			success : function(data){
// 	 			console.log('접근성공');
//	 			console.log(data);
// 				setReview(data); 
				location.replace(location.href);
			},
			error:function(){
				console.log('접근실패');
			}
		});
	}
}

function reviewDelete(e){
	if(${empty mbno}){
		if(confirm("로그인이 필요한 기능입니다. 로그인 하시겠습니까?")){
			location.href="${pageContext.request.contextPath}/member/memberLogin.do"
		}else{
			return;
		}
	}else{
		if(confirm("한번 삭제하면 복구할 수 없습니다. 정말 삭제하시겠습니까?")){
			$.ajax({
				url : "${pageContext.request.contextPath}/review/reviewDelete.do",
				type : "get",
				data : {"rvno":e},
				datatype:"json",
				success : function(data){
					alert('삭제되었습니다.');
					getReview();
				},
				error:function(){
					console.log('접근실패');
				}
			});
		}else{
			return;
		}
	}
}
//좋아요(👍) 버튼 클릭 시 색상을 변경하고 원래 상태로 전환하는 JavaScript 함수--------------
function like(e) {

	var lkCnt = parseInt($('#likeCount'+e).html());
	if(${empty mbno}){
		if(confirm("로그인이 필요한 기능입니다. 로그인 하시겠습니까?")){
			location.href="${pageContext.request.contextPath}/member/memberLogin.do"
		}else{
			return;
		}
	}else{
		$.ajax({
			type:"get",
			url:"${pageContext.request.contextPath}/review/dolike.do",
			data:{"rvno":e},
			dataType:"json",
			success:function(data){
//				console.log(data.value);
				if(data.value == 0){
					alert('오류');
				}else{
					$('#like'+e).toggleClass('liked');
					$('#like'+e).removeAttr('onclick');
					$('#like'+e).attr('onclick','unlike('+e+')');
					$('#likeCount'+e).html(lkCnt + 1);
				}
			},
			error:function(){
//				console.log("error");
			}
		});
	}
	
}
function unlike(e) {

	var lkCnt = $('#likeCount'+e).html();
	if(${empty mbno}){
		if(confirm("로그인이 필요한 기능입니다. 로그인 하시겠습니까?")){
			location.href="${pageContext.request.contextPath}/member/memberLogin.do"
		}else{
			return;
		}
	}else{
		$.ajax({
			type:"get",
			url:"${pageContext.request.contextPath}/review/undolike.do",
			data:{"rvno":e},
			dataType:"json",
			success:function(data){
//				console.log(data.value);
				if(data.value == 0){
					alert('오류');
				}else{
					$('#like'+e).toggleClass('liked');
					$('#like'+e).removeAttr('onclick');
					$('#like'+e).attr('onclick','like('+e+')');
					$('#likeCount'+e).html(lkCnt - 1);
				}
			},
			error:function(){
//				console.log("error");
			}
		});
	}
	
}
function reviewReport(e){
// 	var formName='rpForm'+e;
// 	var rpForm = $('form[name='+formName+']');
	var url="${pageContext.request.contextPath}/report/reportPopup.do?no="+e+"&cate=rvno";

	window.open(url,'_blank','width=500 height=600');
// 	rpForm.action = url;
// 	rpForm.method="post";
// 	rpForm.target="formName";
// 	rpForm.submit();

// 	if (confirm('정말 신고하시겠습니까?')) {
// 		console.log(e);
		
// 		$.ajax({
// 			type: "POST",
// 			url: "${pageContext.request.contextPath}/report/reportAction.do",
// 			data: {"rvno" : e, "mbno2" : m},
// 			dataType: "json",
// 			success: function(response) {
// 				if (response.success) {
// 					alert("신고되었습니다.");
// 				}
// 			},
// 			error: function(request, status, error) {
// 				alert("code : "+request.status+"\n"+"message : " +request.responseText+"\n"+"error : "+ error);
// 			}
// 		});
		
// 	}else{
// 		return;
// 	}
}
</script>
<script>

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
$(document).ready(function(){
	
	$(document).on("click",".popupBtn", function(){
// 		alert('클릭');
		let rvno = $(this).val();
		$('.swiper-wrapper').html('');
		var img = $('.rv'+rvno);
		var str = '';
		$.each(img,function(){
			console.log(this.value);
			str += '<div class="swiper-slide">';
			str += '<img class="cont-img" src="${pageContext.request.contextPath}/source/reviewImages/'+this.value+'">';
			str += '</div>';
		});
		$('.swiper-wrapper').html(str);
		$("#modalWrap").css('display', 'flex');
		
	});
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
});
</script>

<script>
	// 평점 값
	const ratingValue = parseFloat(${cv.contentRating}/ 100);
	// 별점을 생성하는 함수
	function createStars(rating) {
	const maxStars = 5;

		// 채워진 별과 빈 별을 조합한 문자열 생성
		let starsString = '★'.repeat(Math.floor(rating));
		starsString += '☆'.repeat(maxStars - Math.floor(rating));
		
		$('#ratingContainer').append(ratingValue + "/5")
		// 별점을 담은 div 요소 생성
		
		const ratingDiv = document.createElement('div');
		ratingDiv.textContent = starsString;

		return ratingDiv;
	}

	// 별점을 생성하고 표시
	const ratingContainer = document.getElementById('ratingContainer');
	if (ratingContainer) {
		ratingContainer.appendChild(createStars(ratingValue));
	}
</script>

</body>
</html>