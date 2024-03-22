<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>컨텐츠 상세보기 페이지</title>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=d6eaf7ed9af48a5319b75a0937ac3096"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/ekko-lightbox/5.3.0/ekko-lightbox.min.css">
<link rel="stylesheet" type="text/css" href="../source/css/contents/bookmarkedContents.css">
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>

</head>
<body>

<jsp:include page="../source/include/header.jsp"/>
<div class="container">
	<div class="container-title">
		<h1>MyPage</h1>
	</div>
	<div class="page-inner">
		<jsp:include page="../source/include/mypageNavi.jsp"/>
		<div class="bookmarkedContents">
			<div class="btn-area">
				<button type="button" class="btn1 clicked">나의 즐겨찾기</button>
				<button type="button" class="btn1">나의 후기</button>
			</div>
			<div class="bookmarked">
				<header class="bookmarked-head">
					<strong class="bookmarked-title">총 <span class="bookmarked-cnt">${fn:length(bmList)}</span> 개</strong>
				</header>
				<div class="bookmarked-data">
					<div class="contents-map">
						<div id="map" style="width:100%;height:100%;border-radius:10px"></div>
					</div>
					<div class="bookmarked-list">
						<ul>
							<c:forEach var="cv" items="${bmList}" varStatus="status">
							<li class="bookmarked_li" id="bm_li${status.index}">
								<span id="bm_li_title${status.index}"><i class="marker"></i><strong class="contents-title">${cv.title}</strong></span>
								<div class="list-btn">
									<button class="btn" onclick="viewOverlayDetails(${status.index})">열기</button>
								</div>
								<input type="hidden" id="bm_li_firstimage${status.index}" value="${cv.firstimage}">
								<input type="hidden" id="bm_li_contentRating${status.index}" value="${cv.contentRating}">
								<input type="hidden" id="bm_li_contenttypeid${status.index}" value="${cv.contenttypeid}">
								<input type="hidden" id="bm_li_contentid${status.index}" value="${cv.contentid}">
							</li>
							</c:forEach>
<!-- 							<li class="detailview"> -->
<!-- 								<div class="detailimage"> -->
<!-- 									<img src="../source/images/duck4.jpg"> -->
<!-- 								</div> -->
<!-- 								<div> -->
<!-- 									<span><strong class="contents-title">전주덕진공원</strong></span> -->
<!-- 									<span class="contenttype_label"><span>관광지</span></span> -->
<!-- 									<div class="detail-grade"> -->
<!-- 										<span>★★★★☆</span><span>4.1/5.0</span> -->
<!-- 									</div> -->
<!-- 									<div class="detail-btn2"> -->
<!-- 										<button class="btn">즐찾해제</button> -->
<!-- 									</div>		 -->
<!-- 									<div class="detail-btn"> -->
<!-- 										<button class="btn">바로가기</button> -->
<!-- 									</div>		 -->
<!-- 								</div> -->
<!-- 							</li> -->
						</ul>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<jsp:include page="../source/include/footer.jsp"/>
<script>
	// 평점 값
	const valueArray = []
	<c:forEach var='cv' items='${bmList}'>
		valueArray.push('${cv.contentRating}');
	</c:forEach>
	console.log(valueArray);
	// 별점을 생성하는 함수
	function createStars(rating) {
	const maxStars = 5;
		var ratingDouble = (rating / 100);
		// 채워진 별과 빈 별을 조합한 문자열 생성
		let starsString = '★'.repeat(Math.floor(ratingDouble));
		starsString += '☆'.repeat(maxStars - Math.floor(ratingDouble));
		let ratingString = '  '+ratingDouble + '/5 '+ starsString;
		console.log(ratingString);
		return ratingString;
	}
	
	// 별점을 생성하고 표시
	function setRating(data){
		for(let i = 0; i < data.length; i++){
			$('#bm_li_contentRating'+i).val('');
			$('#bm_li_contentRating'+i).val(createStars(data[i]));
		}
	}
	
	setRating(valueArray);
	var container = document.getElementById('map'); //지도를 담을 영역의 DOM 레퍼런스
	var options = { //지도를 생성할 때 필요한 기본 옵션
		center: new kakao.maps.LatLng(35.8403598, 127.1325083), //지도의 중심좌표.
		level: 7 //지도의 레벨(확대, 축소 정도)
	};
	
	var map = new kakao.maps.Map(container, options); //지도 생성 및 객체 리턴

	var mapTypeControl = new kakao.maps.MapTypeControl();	//지도, 스카이뷰 버튼 추가
	map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
	
	var zoomControl = new kakao.maps.ZoomControl();		//확대, 축소 UI 추가
	map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);
	
	var positions = [
		<c:forEach items='${bmList}' var='cv'>
		{title: '${cv.title}',
		firstimage : '${cv.firstimage}',
		contenttypeid : '${cv.contenttypeid}',
		rating : '${cv.contentRating}',
		latlng: new kakao.maps.LatLng(${cv.mapy}, ${cv.mapx})	//${cv.mapy}, ${cv.mapx}
		},
		</c:forEach>
	];
	var bounds = new kakao.maps.LatLngBounds();
	var overlayArray = [];	//마커 클릭 시 띄울 오버레이들 담는 배열
	for (var i = 0; i < positions.length; i++) {	//데이터 개수만큼 반복문 돌면서 마커, 오버레이 생성
		var data = positions[i];
		displayMarker(data,i);
	}
	function displayMarker(data,e){
		
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

		var cate = '';
		switch(data.contenttypeid){
		case '12' :
			cate = '관광지';
			break;
		case '39' :
			cate = '음식점';
			break;
		case '14' :
			cate = '문화시설';
			break;
		case '32' :
			cate = '숙박';
			break;
		case '15' :
			cate = '축제 공연';
			break;
		default : 
			cate = '기타';
			break;
		}		  	
	  	var content = '<div class="mapwrap">';
		content+='	<div class="info">';
		content+='        <div class="title">';
		content+='            '+data.title+'';
		content+='            <div class="close" onclick="closeOverlay()" title="닫기"></div>';
		content+='        </div>';
		content+='        <div class="body">';
		content+='            <div class="img">';
		content+= '                <img src="';
        if(data.firstimage==''){
      	  content+='../source/images/notFound.png"';
      	  
        }else{
    	  content+=data.firstimage+'"';
        }
        content+='				 width="73" height="70">';
        content+='           </div>';
        content+='            <div class="desc">';
        content+='                <div class="ellipsis">타입 :'+cate+'</div>';
        content+='                <div class="jibun ellipsis">평점 :'+(data.rating/100)+'/5.00</div>';
        content+='            </div>';
        content+='        </div>';
        content+='    </div>';
        content+='</div>';
	    
	    overlay.setContent(content);	//만든 컨텐츠들을 overlay에 할당해줌

	    kakao.maps.event.addListener(marker, 'click', function() {	//클릭 시 오버레이 띄움
	    	viewOverlayDetails(e);
	    });		
		
		bounds.extend(data.latlng);
		overlayArray.push(overlay);
	}
	function openOverlay(e){
    	closeOverlay();
        overlayArray[e].setMap(map);
		map.panTo(positions[e].latlng);
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
// ---------------------- kakao맵 끝 ----------------------------------------
	function viewDetail(e){
// 		console.log($('#bm_li_contenttypeid'+e).val());
		var cate = '';
		switch($('#bm_li_contenttypeid'+e).val()){
		case '12' :
			cate = '관광지';
			break;
		case '39' :
			cate = '음식점';
			break;
		case '14' :
			cate = '문화시설';
			break;
		case '32' :
			cate = '숙박';
			break;
		case '15' :
			cate = '축제 공연';
			break;
		default : 
			cate = '기타';
			break;
		}
		$('li').remove('.detailview');
		$('.bookmarked_li').css('display','');
		var str = '';
		str	+='<li class="detailview">';
		str +='<div class="detailimage">';
		if($('#bm_li_firstimage'+e).val()==''){
			str += '<img src="../source/images/notFound.png">';
		}else{
			str +='<img src="'+$('#bm_li_firstimage'+e).val()+'">';
			
		}
		str +='</div>'
		str +='<div>';
		str +='<span><strong class="contents-title">'+$('#bm_li_title'+e).text()+'</strong></span>';
		str +='<span class="contenttype_label"><span>'+cate+'</span></span>';
		str +='<div class="detail-grade">';
		str +='<span>'+$('#bm_li_contentRating'+e).val()+'</span>';
		str +='</div>';
		str +='<div class="detail-btn2" >';
		str +='	<button class="btn" onclick="undoBookmark('+$('#bm_li_contentid'+e).val()+')">즐찾해제</button>';
		str +='</div>';
		str +='<div class="detail-btn">';
		str +='	<button class="btn" onclick="goDetail('+e+')">바로가기</button>';
		str +='</div>';
		str +='</div>';
		str +='</li>';
		$('#bm_li'+e).css('display','none');
		$('#bm_li'+e).after(str);
		
	}
	function viewOverlayDetails(e){
		viewDetail(e);
		openOverlay(e);
//     	scrollMove(e);
	}
	function scrollMove(e){
		var lcTop = $('#bm_li'+e).offset().top;
		$(".bookmarked-list").animate({scrollTop: lcTop},400);
		console.log(lcTop);
	}
	function goDetail(e){
		var contentid = $('#bm_li_contentid'+e).val();
		window.open('${pageContext.request.contextPath}/contents/contentsDetail.do?contentid='+contentid,
		'_blank');
	}
	function undoBookmark(e){
		// bookmark를 하는 함수
		if(confirm('해제하시면 현재 페이지에서 다시 불러올 수 없습니다. 정말 해제하시겠습니까?')){
			$.ajax({
				type:"post",
				url:"${pageContext.request.contextPath}/contents/undoBookmark.do",
				data:{"contentid":e},
				dataType:"json",
				success:function(data){
	// 				console.log(data);
					alert('삭제에 성공하였습니다.');
					location.href = location.href;
				},
				error:function(){
	// 				console.log("error");
				}
			});
			
		}
	}
	
<c:if test='${not empty bmList}'>
viewOverlayDetails(0);
</c:if>
</script>
</body>
</html>