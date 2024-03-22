<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
</head>
<body>
	<jsp:include page="../source/include/header.jsp"/>
	<div class="wrap">
		<div class="container">
			<table class="wrap-conttable">
				<tr>
					<td>
						<div class="inner-conttable">
							<table class="conttable-cont">
								<tr>
									<td colspan="2" style="padding: 5px 0 5px 5px;">닉네임</td>
								</tr>
								<tr>
									<td colspan="2"><img src="../source/images/testimg.png" id="cont-img"></td>
								</tr>
								</table>
								<table>
								<tr>
									<td style="border-bottom:0; padding: 5px 0 3px 15px;">전주 한옥마을 야경</td>
									<td class="like" style="border-bottom:0; padding-right: 7px;">♥</td>
								</tr>
								<tr>
									<td colspan="2" style="border: 0; color:#567ff2">
										#전주 #한옥마을 #야경
									</td>
								</tr>
								<tr>
									<td class="comment-area" colspan="2" style="border-bottom:0;"> 
										<div>
											<input type="text" id="comment-write" placeholder="댓글을 작성해주세요.">
										</div>
										<div style="width: 20px;">
											<label class="write-btn" for="comment-btn">
												<img src="../source/images/commentbtn.png" id="btn-img">
											</label>
											<input type="button" id="comment-btn" value="작성">
										</div>
									</td>
								</tr>
								<tr>
									<td class="comment-area" colspan="2" style="border-bottom:0;"> 
										<div class="comment-id">
											<span>닉네임</span>
										</div>
										<div class="comment-cont">
											댓글을 작성하였습니다.댓글을 작성하였습니다.댓글을 작성하였습니다.댓글을 작성하였습니다.댓글을 작성하였습니다.댓글을 작성하였습니다.
										</div>
										<div class="comment-date">
											2023.11.06
										</div>
										<div>
											<button type="button" style="margin-top: -4px	;" onclick="">&#x1F6A8;</button>
										</div>
									</td>
									<td class="comment-area" colspan="2" style="border-bottom:0;"> 
										<div class="comment-id">
											<span>닉네임</span>
										</div>
										<div class="comment-cont">
											댓글을 작성하였습니다.
										</div>
										<div class="comment-date">
											2023.11.06
										</div>
										<div>
											<button type="button" style="margin-top: -4px	;" onclick="">&#x1F6A8;</button>
										</div>
									</td>
									<td class="comment-area" colspan="2" style="border-bottom:0;"> 
										<div class="comment-id">
											<span>닉네임</span>
										</div>
										<div class="comment-cont">
											댓글을 작성하였습니다.
										</div>
										<div class="comment-date">
											2023.11.06
										</div>
										<div>
											<button type="button" style="margin-top: -4px	;" onclick="">&#x1F6A8;</button>
										</div>
									</td>
									<td class="comment-area" colspan="2" style="border-bottom:0;"> 
										<div class="comment-id">
											<span>닉네임</span>
										</div>
										<div class="comment-cont">
											댓글을 작성하였습니다.
										</div>
										<div class="comment-date">
											2023.11.06
										</div>
										<div>
											<button type="button" style="margin-top: -4px	;" onclick="">&#x1F6A8;</button>
										</div>
									</td>
									<td class="comment-area" colspan="2" style="border-bottom:0;"> 
										<div class="comment-id">
											<span>닉네임</span>
										</div>
										<div class="comment-cont">
											댓글을 작성하였습니다.
										</div>
										<div class="comment-date">
											2023.11.06
										</div>
										<div>
											<button type="button" style="margin-top: -4px	;" onclick="">&#x1F6A8;</button>
										</div>
									</td>
									
								</tr>
								<tr>
									<td colspan=3 class="bottom-btn">
										<button type="button" onclick="">수정</button>
										<button type="button" onclick="">삭제</button>
										<button type="button" onclick="">&#x1F6A8;</button>
									</td>
								</tr>
							</table>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<jsp:include page="../source/include/footer.jsp"/>
</body>
</html>