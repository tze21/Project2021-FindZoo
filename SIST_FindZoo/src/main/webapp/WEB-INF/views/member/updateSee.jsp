<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.example.demo.vo.SeeVo"%>
<%@page import="com.example.demo.dao.SeeDao"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<!DOCTYPE html>
<html>
<head> 
<meta charset="UTF-8">
<title>목격했어요!</title>
<script type="text/javascript" src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=589c052a30900321432ed77b38231404&libraries=services"></script>
<link rel="stylesheet" href="../resources/css/bootstrap.min.css" type="text/css">
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
	
	#see-container{
		display: flex;
		justify-content: center;
	}
	
	#content{
		display: inline-block;
		width: 70%;
		margin-top: 2%;
	}
	
	#btn{
		text-align: center;
		margin-bottom: 5%;
	}
	
</style>
</head>
<body>
<jsp:include page="./findZoo_Header.jsp"/>
	<div id="see-container">
		<div id="content">
			<h4>목격했어요! 글 수정</h4>
			<hr> 
			<form class="form-group" action="updateSee.do" method="post" enctype="multipart/form-data" onsubmit="fixLoc();">
				<input type="hidden" name="board_num" value="${ s.board_num }">
				<input type="hidden" name="picture_fname" value="${ s.picture_fname }">
				<label class="form-label mt-4">제목</label>
				<input class="form-control" type="text" name="title" value="${ s.title }" style="width: 100%;">
				<br>
				
				목격장소 : <span>${s.see_find_loc}</span><br>
				<input id="addr1" name="addr1" type="text" placeholder="목격장소 변경시 눌러주세요" readonly="readonly" onclick="findAddr()">
				<input type="hidden" id="addr2" name="addr2" placeholder="상세주소">
				<input id="post"  type="hidden" placeholder="우편번호" readonly="readonly"><button type="button" onclick="getAddr()">위치변경</button>
				<br><br>
				<input type="hidden" id="old_see_find_loc" name="old_see_find_loc" value="${s.see_find_loc }">
				
				<p style="margin-top: -12px">
					<em class="link"> <a href="javascript:void(0);"
						onclick="window.open('http://fiy.daum.net/fiy/map/CsGeneral.daum', '_blank', 'width=981, height=650')">
					</a>
					</em>
				</p>
				<div id="map" style="width: 60%; height: 400px;"></div>
		
				<script>
				
				$(document).ready(function(){
					var addr1 = $("#addr1").val();
					var addr2 = $("#addr2").val();
					var see_find_loc = addr1.concat(addr2);
				
					$("#see_find_loc").val(see_find_loc);
					console.log(see_find_loc);
				});
		
				
				// 다음 주소찾기api 활용 함수
				function findAddr() {
					new daum.Postcode({
						oncomplete : function(data) {
		
							console.log(data);
		
							// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
							// 도로명 주소의 노출 규칙에 따라 주소를 표시한다.
							// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
							var roadAddr = data.roadAddress; // 도로명 주소 변수
							var jibunAddr = data.jibunAddress; // 지번 주소 변수
							// 우편번호와 주소 정보를 해당 필드에 넣는다.
							document.getElementById('post').value = data.zonecode;
							if (roadAddr !== '') {
								document.getElementById("addr1").value = roadAddr;
							} else if (jibunAddr !== '') {
								document.getElementById("addr2").value = jibunAddr;
							}
						}
					}).open();
				}
				
				// 위치변경 버튼 클릭시 함수 실행
				function getAddr() {
					var new_input_addr = "";
					var new_see_find_loc = document.getElementById('addr1').value;
					console.log('가져온 텍스트', new_see_find_loc);
					document.getElementById("see_find_loc").value = new_see_find_loc;
					
					geocoder.addressSearch(new_see_find_loc,function(result, status) { // 정상적으로 검색이 완료됐으면 
						if (status === kakao.maps.services.Status.OK) { 
							var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
		
							// 결과값으로 받은 위치를 마커로 표시합니다
							var marker = new kakao.maps.Marker({
								map : map,
								position : coords
							});
		
							// 인포윈도우로 장소에 대한 설명을 표시합니다
							var infowindow = new kakao.maps.InfoWindow(
									{
										content : '<div style="width:150px;text-align:center;padding:6px 0;">'+ new_see_find_loc + '</div>'
									});
							infowindow.open(map, marker);
		
							// 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
							map.setCenter(coords);
						}
					});
				}
				
					var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
					mapOption = {
						center : new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
						level : 3
					// 지도의 확대 레벨
					};
		
					// 지도를 생성합니다    
					var map = new kakao.maps.Map(mapContainer, mapOption);
		
					// 주소-좌표 변환 객체를 생성합니다
					var geocoder = new kakao.maps.services.Geocoder();
					
					var input_addr = "";
					var old_see_find_loc = document.getElementById("old_see_find_loc").value;
					console.log(old_see_find_loc);
					input_addr = old_see_find_loc;
					
					// 주소로 좌표를 검색합니다
					// 아래는 위치변경을 안했을 시 기존 주소를 그대로 map에 찍어줌
					geocoder.addressSearch(input_addr,function(result, status) { // 정상적으로 검색이 완료됐으면 
						if (status === kakao.maps.services.Status.OK) { 
							var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
		
							// 결과값으로 받은 위치를 마커로 표시합니다
							var marker = new kakao.maps.Marker({
								map : map,
								position : coords
							});
		
							// 인포윈도우로 장소에 대한 설명을 표시합니다
							var infowindow = new kakao.maps.InfoWindow(
									{
										content : '<div style="width:150px;text-align:center;padding:6px 0;">'+ input_addr + '</div>'
									});
							infowindow.open(map, marker);
		
							// 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
							map.setCenter(coords);
						}
					});
					
					function fixLoc(){
						var old_see_find_loc = document.getElementById('old_see_find_loc').value;
						var see_find_loc = document.getElementById('see_find_loc').value;
						
						if(see_find_loc === ''){
							document.getElementById('see_find_loc').value = old_see_find_loc;
						}
					}
					
				</script>
				<input type="hidden" name="see_find_loc" id="see_find_loc" value="${s.see_find_loc }"><br>
						
				<fmt:parseDate var="strToDate" value="${s.see_find_date }" pattern="yyyy-MM-dd"/>
				<fmt:formatDate var="dateToStr" value="${strToDate }" pattern="yyyy년 MM월 dd일"/>
				목격날짜 : <c:out value="${dateToStr }"/>&nbsp;<input type="date" name="see_find_date" required="required"><br>
				목격동물 :
				<c:choose>
					<c:when test="${s.see_pet eq '강아지' }">
						<input type="radio" class="form-check-input" name="see_pet" id="see_pet_dog" value="강아지" checked="checked">
						<label for="see_pet_dog">강아지</label>
						<input type="radio" class="form-check-input" name="see_pet" id="see_pet_cat" value="고양이">
						<label for="see_pet_cat">고양이</label>
						<input type="radio" class="form-check-input" name="see_pet" id="see_pet_etc" value="기타">
						<label for="see_pet_etc">기타</label><br>
					</c:when>
					<c:when test="${s.see_pet eq '고양이' }">
						<input type="radio" class="form-check-input" name="see_pet" id="see_pet_dog" value="강아지">
						<label for="see_pet_dog">강아지</label>
						<input type="radio" class="form-check-input" name="see_pet" id="see_pet_cat" value="고양이" checked="checked">
						<label for="see_pet_cat">고양이</label>
						<input type="radio" class="form-check-input" name="see_pet" id="see_pet_etc" value="기타">
						<label for="see_pet_etc">기타</label><br>
					</c:when>
					<c:otherwise>
						<input type="radio" class="form-check-input" name="see_pet" id="see_pet_dog" value="강아지">
						<label for="see_pet_dog">강아지</label>
						<input type="radio" class="form-check-input" name="see_pet" id="see_pet_cat" value="고양이">
						<label for="see_pet_cat">고양이</label>
						<input type="radio" class="form-check-input" name="see_pet" id="see_pet_etc" value="기타" checked="checked">
						<label for="see_pet_etc">기타</label><br>
					</c:otherwise>
				</c:choose>
				
				<label class="form-label mt-4">내용</label>
				<textarea class="form-control" rows="15" name="content" style="width: 100%;">${ s.content }</textarea>
				<label class="form-label mt-4">사진</label>
				<input class="form-control" type="file" name="picture_file" value="${ s.picture_fname }"><br>
				<div id="btn">
					<input class="btn btn-primary" type="submit" value="수정">
					<input class="btn btn-primary" type="reset" value="초기화">
				</div>
			</form>
		</div>
	</div>
<jsp:include page="../findZoo_Footer.jsp"/>
</body>
</html>