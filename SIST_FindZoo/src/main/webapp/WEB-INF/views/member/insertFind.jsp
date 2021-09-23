<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html> 
<html>
<head>
<meta charset="UTF-8">
<title>찾아요!</title>
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
	
	#find-container{
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
<script type="text/javascript" src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=589c052a30900321432ed77b38231404&libraries=services"></script>
<script type="text/javascript">
$(document).ready(function(){
	var addr1 = $("#addr1").val();
	var addr2 = $("#addr2").val();
	var find_lost_loc = addr1.concat(addr2);

	$("#find_lost_loc").val(find_lost_loc);
	console.log(find_lost_loc);
});

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
</script>
</head>
<body>
<jsp:include page="./findZoo_Header.jsp"/>
	<div id="find-container">
		<div id="content">
			<h4>찾아요게시판 글 작성</h4>
			<hr> 
			<form class="form-group" action="/member/insertFind.do" method="post" enctype="multipart/form-data">
				<label class="form-label mt-4">제목</label>
				<input class="form-control" type="text" name="title" required="required" style="width: 100%;">
				<label class="form-label mt-4">실종장소</label><br><input id="addr1" name="addr1" class="form-control" type="text" required="required" placeholder="주소검색" readonly="readonly" onclick="findAddr()" style="width: 30%; display: inline-block; margin-right: 1%;"><input type="hidden" id="addr2" name="addr2" placeholder="상세주소"><input id="post"  type="hidden" placeholder="우편번호" readonly="readonly"><input type="hidden" name="find_lost_loc" id="find_lost_loc"><button type="button" class="btn btn-primary" onclick="getAddr()" style="display: inline-block;">위치등록</button><br>
				<p style="margin-top:-12px">
			    	<em class="link">
			        	<a href="javascript:void(0);" onclick="window.open('http://fiy.daum.net/fiy/map/CsGeneral.daum', '_blank', 'width=981, height=650')"></a>
			   		</em>
				</p>
				<div id="map" style="width:50%;height:350px; border: 1px dashed #D3D3D3;"></div>
				<script>
					var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
					mapOption = {
						center : new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
						level : 3
					//지도의 확대 레벨 
					};
		
					// 지도를 생성합니다    
					var map = new kakao.maps.Map(mapContainer, mapOption);
		
					// 주소-좌표 변환 객체를 생성합니다
					var geocoder = new kakao.maps.services.Geocoder();
		
					var input_addr = "";
					// 사용자 입력 주소 값 hidden으로 가져오는 함수
					function getAddr() {
						var find_lost_loc = document.getElementById('addr1').value;
						console.log('가져온 텍스트', find_lost_loc);
						input_addr = find_lost_loc;
						document.getElementById("find_lost_loc").value = input_addr;
						// 주소로 좌표를 검색합니다
						// getAddr 함수 호출시마다 해당 addressSearch함수를 호출해줘야하므로 getAddr 함수안에서 사용함.
						geocoder.addressSearch(input_addr, function(result, status) {
		
									// 정상적으로 검색이 완료됐으면 
									if (status === kakao.maps.services.Status.OK) {
		
										var coords = new kakao.maps.LatLng(
												result[0].y, result[0].x);
		
										// 결과값으로 받은 위치를 마커로 표시합니다
										var marker = new kakao.maps.Marker({
											map : map,
											position : coords
										});
		
										// 인포윈도우로 장소에 대한 설명을 표시합니다
										var infowindow = new kakao.maps.InfoWindow(
												{
													content : '<div style="width:150px;text-align:center;padding:6px 0;">'+input_addr+'</div>'
												});
										infowindow.open(map, marker);
		
										// 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
										map.setCenter(coords);	
									}
							});
					}
				</script>
				<label class="form-label mt-4">실종날짜</label>
				<input class="form-control" type="date" name="find_lost_date" id="find_lost_date" style="width: 30%;">
				<label class="form-label mt-4">동물종</label><br>
				<label for="find_pet_dog">강아지</label>
				<input type="radio" class="form-check-input" name="find_pet" id="find_pet_dog" value="강아지" checked="checked">&nbsp;&nbsp;
				<label for="find_pet_cat">고양이</label>
				<input type="radio" class="form-check-input" name="find_pet" id="find_pet_cat" value="고양이">&nbsp;&nbsp;
				<label for="find_pet_etc">기타</label>
				<input type="radio" class="form-check-input" name="find_pet" id="find_pet_etc" value="기타"><br>
				<label class="form-label mt-4">사례금</label>
				<input class="form-control" type="number" name="find_reward" required="required" style="width: 15%;">
				<label class="form-label mt-4">내용</label>
				<textarea class="form-control" rows="15" name="content" required="required" style="width: 100%;"></textarea>
				<label class="form-label mt-4">대표사진</label>
				<input class="form-control" type="file" required="required" name="picture_file1"><br>
				<label class="form-label mt-4">추가사진</label>
				<input class="form-control" type="file" name="picture_file2"><br>
				<input class="form-control" type="file" name="picture_file3"><br>
				<div id="btn">
					<input class="btn btn-primary" type="submit" value="작성">
					<input class="btn btn-primary" type="reset" value="초기화">
				</div>
			</form>
		</div>
	</div>
<jsp:include page="../findZoo_Footer.jsp"/>
</body>
</html>