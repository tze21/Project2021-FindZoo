<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>찾아요!</title>
<link rel="stylesheet" href="./resources/css/bootstrap.min.css" type="text/css">
<style type="text/css">
	@font-face {
	    font-family: 'GmarketSansMedium';
	    src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_2001@1.1/GmarketSansMedium.woff') format('woff');
	    font-weight: normal;
	    font-style: normal;
	}

	*{
		font-family: 'GmarketSansMedium';
		font-weight: lighter;
	}
	
	a{
		color: black;
		text-decoration: none;
	}
	
	a:hover{
		font-weight: bold;
		color: #325d88;
		text-decoration: underline;
	}
	
	img{
		border: 1px dashed #D3D3D3;
		width: 70%;
		height: 350px;
	}
	
	button{
		margin-right: 1%;
	}
	
	#slide_and_map{
		text-align: center;
		display: flex;
		justify-content: center;
		width: 100%;
	}
	
	#find-container{
		display: flex;
		justify-content: center;
	}
	
	#content{
		display: inline-block;
		width: 70%;
		margin-top: 2%;
		margin-bottom: 2%;
	}
	
	#member_modal{
		position: absolute;
		display: none;
		width: 8%;
		height: 10%;
		text-align: center;
		background-color: white;
		border: 1px black solid;
		overflow: hidden;
		font-size : 12px;
	}
	
	#member_act{
		width: 100%;
		height: 100%;
	}
</style>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=589c052a30900321432ed77b38231404&libraries=services"></script>
<script type="text/javascript" src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
<script src="https://unpkg.com/@popperjs/core@2/dist/umd/popper.js"></script>
<script type="text/javascript">
	var myCarousel = document.querySelector('#myCarousel');
	var carousel = new bootstrap.Carousel(myCarousel);

	function confirmFindDelete(board_num){
		var re = confirm("정말 삭제하시겠습니까?");
		if(re){
			location.href="deleteFind.do?board_num="+board_num;
		}
	}
	
	// Textarea 크기에 따라 창을 수정해주는 함수
	function resize(obj) {
		  obj.style.height = "1px";
		  obj.style.height = (12+obj.scrollHeight)+"px";
	}
	
	// 쪽지 보내기 팝업창을 띄운다.
	function sendNewNote(member_num) {
		var popupX = (document.body.offsetWidth/2)-200;
		var popupY = (window.screen.height/2)-180;
		window.open("/member/sendNewNote.do?member_num="+member_num, "_blank", "width=500, height=470, left="+popupX+", top="+popupY);
	}
	
	$(function() {
		
		// 글 내용의 길이에 따라 스크롤을 사용하지 않고 내용 출력
		var ta = $("#ta");
	    if (ta) {
	        ta.each(function(){
	            $(this).height(this.scrollHeight);
	        });
	    }
		
		// 멤버 닉네임 클릭 시
		$('.member_nick').click(function(e) {
			let member_num = $(this).attr("member_num");
			$('#member_board').attr("href", "memberBoard.do?member_num="+member_num);
			$('#send_new_note').attr("href", "window.open('/member/sendNewNote.do?member_num='+member_num, '_blank', 'width=420, height=370, left='+popupX+', top='+popupY)");
			
			var divLeft = e.pageX;
			var divTop = e.pageY;
			
			console.log(divLeft, divTop);
			
			$('#member_modal').css({
				"top": divTop,
				"left": divLeft,
				"position": "absolute"
			}).show();
			return false;
		});

		// 모달 창 바깥 클릭 시
		$(document).mouseup(function (e){
			var member_modal = $("#member_modal");
			if(member_modal.has(e.target).length === 0){
				member_modal.hide();
			}
		});
		
		// 비로그인 시 회원 닉네임 클릭 시 알람 팝업 출력
		$('.login_pls_alert').click(function(e){
			alert("로그인이 필요합니다!");
		});
	});
</script>
</head>
<body>
<jsp:include page="findZoo_Header.jsp"/>
	<div id="find-container">
		<div id="content">
			<h4>${ f.title }</h4>
			<hr>
			<c:if test="${ member_num eq 0 }">
				<a href="#a" class="login_pls_alert">${ f.member_nick }</a>&nbsp;|&nbsp;
			</c:if>
			<c:if test="${ member_num ne 0 }">
				<a class="member_nick" href="#a" member_num=${ f.member_num }>${ f.member_nick }</a>&nbsp;|&nbsp;
			</c:if>
			<h6 style="display: inline-block;">
				<fmt:formatDate value="${ f.bdate }" pattern="yyyy-MM-dd hh:mm:ss" />
			</h6>
			<h6 style="float: right;">조회수 : ${ f.views }</h6>
			<hr>
			<div id="slide_and_map">
				<div id="carouselExampleIndicators" class="carousel slide" data-bs-ride="carousel" style="width: 50%; border: 1px dashed #D3D3D3; margin-right: 5%;">
					<div class="carousel-indicators">
					    <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide 1"></button>
					    <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="1" aria-label="Slide 2"></button>
					    <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="2" aria-label="Slide 3"></button>
					</div>
					<div class="carousel-inner" style="background-color: #D3D3D3;">
					    <div class="carousel-item active">
						    <c:if test="${ f.picture_fname1 ne 'default.jpg'}">
								<img src="${pageContext.request.contextPath}/resources/img/${ f.picture_fname1 }">
							</c:if>
							<c:if test="${ f.picture_fname1 eq 'default.jpg'}">
								<img src="${pageContext.request.contextPath}/resources/systems/${ f.picture_fname1 }">
							</c:if>
					    </div>
					    <div class="carousel-item">
							<c:if test="${ f.picture_fname2 ne 'default.jpg'}">
								<img src="${pageContext.request.contextPath}/resources/img/${ f.picture_fname2 }">
							</c:if>
							<c:if test="${ f.picture_fname2 eq 'default.jpg'}">
								<img src="${pageContext.request.contextPath}/resources/systems/${ f.picture_fname2 }">
							</c:if>
					    </div>
					    <div class="carousel-item">
						    <c:if test="${ f.picture_fname3 ne 'default.jpg'}">
								<img src="${pageContext.request.contextPath}/resources/img/${ f.picture_fname3 }">
							</c:if>
							<c:if test="${ f.picture_fname3 eq 'default.jpg'}">
								<img src="${pageContext.request.contextPath}/resources/systems/${ f.picture_fname3 }">
							</c:if>
					    </div>
					</div>
					<button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide="prev">
					    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
					    <span class="visually-hidden">Previous</span>
					</button>
					<button class="carousel-control-next" type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide="next">
					    <span class="carousel-control-next-icon" aria-hidden="true"></span>
					    <span class="visually-hidden">Next</span>
					</button>
				</div>
				<p style="margin-top: -12px">
					<em class="link">
						<a href="javascript:void(0);" onclick="window.open('http://fiy.daum.net/fiy/map/CsGeneral.daum', '_blank', 'width=981, height=650')"></a>
					</em>
				</p>
				<div id="map" style="width: 40%; height: 350px; border: 1px dashed #D3D3D3;"></div>
				<input type="hidden" id="find_lost_loc" name="find_lost_loc" value="${f.find_lost_loc}">
				<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=589c052a30900321432ed77b38231404&libraries=services"></script>
				<script>
					var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
			   		 mapOption = {
			       		 center: new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
			      		  level: 3 // 지도의 확대 레벨
			  		  };  
			
					// 지도를 생성합니다    
					var map = new kakao.maps.Map(mapContainer, mapOption); 
					
					// 주소-좌표 변환 객체를 생성합니다
					var geocoder = new kakao.maps.services.Geocoder();
					
					var input_addr = "";
					var find_lost_loc = "${f.find_lost_loc}";
					console.log(find_lost_loc);
					input_addr = find_lost_loc;
					document.getElementById("find_lost_loc").value = input_addr;
					// 주소로 좌표를 검색합니다
					geocoder.addressSearch(input_addr, function(result, status) {
					
					    // 정상적으로 검색이 완료됐으면 
					     if (status === kakao.maps.services.Status.OK) {
					
					        var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
					
					        // 결과값으로 받은 위치를 마커로 표시합니다
					        var marker = new kakao.maps.Marker({
					            map: map,
					            position: coords
					        });
					
					        // 인포윈도우로 장소에 대한 설명을 표시합니다
					        var infowindow = new kakao.maps.InfoWindow({
					            content: '<div style="width:150px;text-align:center;padding:6px 0;">'+input_addr+'</div>'
					        });
					        infowindow.open(map, marker);
					
					        // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
					        map.setCenter(coords);
					    } 
					});    
				</script>
			</div>
			<hr>
			<table border="1px solid #D3D3D3;" class="table table-hover" style="text-align: center;">
				<tbody>
					<tr>
						<td>동물종</td>
						<td>${f.find_pet }</td>
					</tr>
					<tr>
						<td>실종날짜</td>
						<td><fmt:parseDate var="strToDate" value="${f.find_lost_date }" pattern="yyyy-MM-dd HH:mm:ss"/><fmt:formatDate var="dateToStr" value="${strToDate }" pattern="yyyy년 MM월 dd일"/><c:out value="${dateToStr }"/><br></td>
					</tr>
					<tr>
						<td>실종장소</td>
						<td>${f.find_lost_loc}</td>
					</tr>
					<tr>
						<td>사례금</td>
						<td><fmt:formatNumber value="${ f.find_reward }" pattern="#,###,###"/>원</td>
					</tr>
				</tbody>
			</table>
			<hr>
			<textarea id="ta" readonly="readonly" style="width: 100%; outline: none; border: none;">${ f.content }</textarea><br>
			<hr>
			<br>
			<button class="btn btn-primary" onclick="location.href='find.do'"style="float: left;">목록</button>
			<c:if test="${ member_num ne 0 and member_num eq f.member_num }">
				<button class="btn btn-primary" onclick="location.href='/member/updateFind.do?board_num=${ f.board_num }'"style="float: right;">수정</button>
				<button class="btn btn-primary" onclick="confirmFindDelete(${ f.board_num })" style="float: right;">삭제</button>
			</c:if>
			
		<div class="modal" id="member_modal">
		<table class="table table-hover" id="member_act">
			<tr>
				<td><a id="member_info">회원 정보 보기</a></td>
			</tr>
			<tr>
				<td><a href="#" onclick="sendNewNote(${f.member_num})">쪽지 보내기</a></td>
			</tr>
		</table>
		</div>
	</div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-/bQdsTh/da6pkI1MST/rWKFNjaCP5gBSY4sEBT38Q/9RBh9AH40zEOg7Hlq2THRZ" crossorigin="anonymous"></script>	
<jsp:include page="findZoo_Footer.jsp"/>
</body>
</html>