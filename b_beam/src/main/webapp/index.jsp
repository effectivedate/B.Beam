<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="app.dao.ContentsDao" %>
<%@ page import="app.domain.ContentsVo" %>
<%@ page import="java.util.ArrayList" %>
<%
ContentsDao cd = new ContentsDao();
int i = 3;
ArrayList<ContentsVo> todaylist = cd.getIndexTodayRanking(i);
ArrayList<ContentsVo> ratinglist = cd.getIndexRatingRanking(i);
ArrayList<ContentsVo> viewlist = cd.getViewRanking(i);

ArrayList<ContentsVo> festalist = cd.ContentsFestivalList();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
	<title>Home</title>
	<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1" />
	<!-- Link Swiper's CSS -->
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@10/swiper-bundle.min.css" />
	<link href="./source/css/home.css" type="text/css" rel="stylesheet">
	<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
</head>
<body>
	<jsp:include page="source/include/header.jsp"/>
	<!-- Swiper -->
	<div class="swiper mySwiper">
		<div class="swiper-wrapper">
			<div class="swiper-slide">
				<img src="https://tour.jeonju.go.kr/upload_data/popup/banner/169563461262747.jpg">
				<div class="slide-text">
					<h1>동아시아 문화도시 전주</h1>
					<p>천년 문화도시, 전주의 자부심을 만나다 </p>
				</div>
			</div>
			<div class="swiper-slide" onclick="contentsDetail('147684');">
				<img src="https://tour.jeonju.go.kr/upload_data/popup/banner/169563465074570.jpg">
				<div class="slide-text">
					<h1>가장 한국적인 도시 전주</h1>
					<p>전주 향교</p>
				</div>
			</div>
			<div class="swiper-slide" onclick="contentsDetail('264284');">
				<img src="	https://tour.jeonju.go.kr/upload_data/popup/banner/169563475042182.jpg">
				<div class="slide-text">
					<h1>가장 한국적인 도시 전주</h1>
					<p>전주 한옥마을</p>
				</div>
			</div>
			<%for(int j = 0; j < festalist.size(); j++){%>
			<div class="swiper-slide" onclick="contentsDetail('<%=festalist.get(j).getContentid()%>');">
				<img src="<%=festalist.get(j).getFirstimage()%>">
				<div class="slide-text">
					<h1><%=festalist.get(j).getTitle()%></h1>
					<p><%=festalist.get(j).getContentdate()%>~<%=festalist.get(j).getContentdatem()%></p>
				</div>
			</div>
			<%} %>
		</div>
		<div class="swiper-button-next" style="color: white; text-shadow: -1px -1px 0 black, 1px -1px 0 black, -1px 1px 0 black, 1px 1px 0 black;"></div>
		<div class="swiper-button-prev" style="color: white; text-shadow: -1px -1px 0 black, 1px -1px 0 black, -1px 1px 0 black, 1px 1px 0 black;"></div>
		<div class="swiper-pagination"></div>
	</div>
  
	<div class="main-search">
		<div class="search-wrap">
			<input type="text" id="title" name="keyword" placeholder="찾고싶은 '관광데이터'명을 입력하세요." title="찾고싶은 '관광데이터'명을 입력하세요.">
			<button type="button" name="sbt" onclick="goDetails()">검색</button>
		</div>
	</div>
  
  
	<!-- top3 탭 -->

	<div class="container">
		<ul class="tab">
			<li class="is_on">
			<a onclick="tabSwitch(1)" class="btn">조회수 top3</a>
			</li>
			<li>
			<a onclick="tabSwitch(2)" class="btn">별점 top3</a>
			</li>
			<li>
			<a onclick="tabSwitch(3)" class="btn">오늘의 top3</a>
			</li>
		</ul>
		<div class="cont_area">
			<div class="cont" id="tab1">
				<div class="top_list">
				<%if(viewlist.size() == 0){ %>
					<p>조회수 top3가 없습니다!</p>
					<%}else{ %>
						<ul>
						<%for(ContentsVo cv:viewlist){ %>
						<li onclick="location.href='${pageContext.request.contextPath}/contents/contentsDetail.do?contentid=<%=cv.getContentid()%>'">
							<%if(cv.getFirstimage()!=null&&!cv.getFirstimage().equals("")){ %>					
									<img src="<%=cv.getFirstimage()%>">
							<%}else{ %>				
									<img src="./source/images/notFound.png">
								<%} %>
							<div class="top_title"><h1><%=cv.getTitle()%></h1> <span> <%=cv.getContentsView()%></span></div>
						</li>
						<%}if(viewlist.size()!=3){
							for(int j = 0; j < (3 - viewlist.size());j++){%>
							<li>
									<img src="./source/images/notFound.png">
							</li>
						<%}
						}%>
<!-- 						<li> -->
<!-- 							<img src="https://tour.jeonju.go.kr/upload_data/board_data/BBS_0000030/168422136222553.jpg"> -->
<!-- 						</li> -->
<!-- 						<li style="padding: 0 10px;"> -->
<!-- 							<img src="https://tour.jeonju.go.kr/upload_data/jeonju/RE_0000370/169889322046365.jpg"> -->
<!-- 						</li> -->
<!-- 						<li> -->
<!-- 							<img src="https://tour.jeonju.go.kr/upload_data/board_data/BBS_0000003/169759351474895.jpg"> -->
<!-- 						</li> -->
					</ul>
					<%}%>
				
				</div>
			</div>
			<div class="cont" id="tab2">
				<div class="top_list">
				
					<%if(ratinglist.size() == 0){ %>
					<p>별점 top3가 없습니다!</p>
					<%}else{ %>
						<ul>
						<%for(ContentsVo cv:ratinglist){ %>
						<li onclick="location.href='${pageContext.request.contextPath}/contents/contentsDetail.do?contentid=<%=cv.getContentid()%>'">
							<%if(cv.getFirstimage()!=null&&!cv.getFirstimage().equals("")){ %>					
									<img src="<%=cv.getFirstimage()%>">
							<%}else{ %>				
									<img src="./source/images/notFound.png">
								<%} %>
							<div class="top_title"><h1><%=cv.getTitle()%></h1> <span> <%=cv.getContentRating()/100%></span></div>
						</li>
						<%}if(ratinglist.size()!=3){
							for(int j = 0; j < (3 - ratinglist.size());j++){%>
							<li>
									<img src="./source/images/notFound.png">
							</li>
						<%}
						}%>
<!-- 						<li> -->
<!-- 							<img src="https://tour.jeonju.go.kr/upload_data/board_data/BBS_0000030/168422136222553.jpg"> -->
<!-- 						</li> -->
<!-- 						<li style="padding: 0 10px;"> -->
<!-- 							<img src="https://tour.jeonju.go.kr/upload_data/jeonju/RE_0000370/169889322046365.jpg"> -->
<!-- 						</li> -->
<!-- 						<li> -->
<!-- 							<img src="https://tour.jeonju.go.kr/upload_data/board_data/BBS_0000003/169759351474895.jpg"> -->
<!-- 						</li> -->
					</ul>
					<%}%>
					
				</div>
			</div>
			<div class="cont" id="tab3">
				<div class="top_list">
				<%if(todaylist.size() == 0){ %>
					<p>오늘의 top3가 없습니다!</p>
					<%}else{ %>
						<ul>
						<%for(ContentsVo cv:todaylist){ %>
						<li onclick="location.href='${pageContext.request.contextPath}/contents/contentsDetail.do?contentid=<%=cv.getContentid()%>'">
							<%if(cv.getFirstimage()!=null&&!cv.getFirstimage().equals("")){ %>					
									<img src="<%=cv.getFirstimage()%>">
							<%}else{ %>				
									<img src="./source/images/notFound.png">
								<%} %>
							<div class="top_title"><h1><%=cv.getTitle()%> <span> <%=cv.getContentLikeCnt()%></span></h1></div>
						</li>
						<%}if(todaylist.size()!=3){
							for(int j = 0; j < (3 -todaylist.size());j++){%>
							<li>
									<img src="./source/images/notFound.png">
							</li>
						<%}
						}%>
<!-- 						<li> -->
<!-- 							<img src="https://tour.jeonju.go.kr/upload_data/board_data/BBS_0000030/168422136222553.jpg"> -->
<!-- 						</li> -->
<!-- 						<li style="padding: 0 10px;"> -->
<!-- 							<img src="https://tour.jeonju.go.kr/upload_data/jeonju/RE_0000370/169889322046365.jpg"> -->
<!-- 						</li> -->
<!-- 						<li> -->
<!-- 							<img src="https://tour.jeonju.go.kr/upload_data/board_data/BBS_0000003/169759351474895.jpg"> -->
<!-- 						</li> -->
					</ul>
					<%}%>
				</div>
			</div>
		</div>
		<div class="top-more">
			<input type="button" name="btn" value="더보기" onclick="location.href='${pageContext.request.contextPath}/contents/contentsRanking.do';">
		</div>
	</div>
	
	<jsp:include page="source/include/footer.jsp"/>
	
	
	 <!-- Swiper JS -->
	<script src="https://cdn.jsdelivr.net/npm/swiper@10/swiper-bundle.min.js"></script>

	<script>
	function goDetails() {
		var keyword = document.querySelector("#title").value.trim().toLowerCase();
		if (keyword.length >= 2) {
			// 파라미터값을 가져옴
			var url = new URL(window.location.href);
			var urlParams = url.searchParams;
			// 파라미터 서치값 추출
			var contenttypeid = urlParams.get("contenttypeid");
			var page = urlParams.get("page")
			// 파라미터 서치값의 키워드값을 검색한 값으로 변경, 페이지는 1페이지로 변경, 컨텐츠타입는 변경 x
			urlParams.set("keyword",keyword);
			urlParams.set("page","1");
			var newParams = encodeURI(urlParams);
			// 해당 컨텐츠리스트로 이동
			location.href="${pageContext.request.contextPath}/contents/contentsList.do?"+newParams;
		} else {
			alert("검색어는 2자 이상 입력하셔야 합니다.");
		}
	}
	document.querySelector("button[name='sbt']").addEventListener("click", function () {
		goDetails();
	});

	document.querySelector("input[name='keyword']").addEventListener("keypress", function (event) {
	    if (event.key === 'Enter') {
	        event.preventDefault(); // 기본 엔터 동작 방지
	        goDetails();
	    }
	});

	</script>

	<script>
	
		var swiper = new Swiper(".mySwiper", {
			spaceBetween: 30,
			centeredSlides: true,
			autoplay: {
				delay: 2500,
				disableOnInteraction: false,
			},
			pagination: {
				el: ".swiper-pagination",
				clickable: true,
			},
			navigation: {
				nextEl: ".swiper-button-next",
				prevEl: ".swiper-button-prev",
			},
		});
	</script> 
	<script>
	window.onlaod=tabSwitch(1);
	function tabSwitch(e){
		if(e==1){
			$('#tab1').css('display','');
			$('#tab2').css('display','none');
			$('#tab3').css('display','none');
		}else if(e==2){
			$('#tab1').css('display','none');
			$('#tab2').css('display','');
			$('#tab3').css('display','none');
		}else if(e==3){
			$('#tab1').css('display','none');
			$('#tab2').css('display','none');
			$('#tab3').css('display','');
			relayout();
			resizeMap();
		}
	}
	function contentsDetail(e){
		location.href='${pageContext.request.contextPath}/contents/contentsDetail.do?contentid='+e;
	}
	</script>
</body>
</html>