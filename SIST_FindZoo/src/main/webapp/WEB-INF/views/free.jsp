<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>자유 게시판</title>
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
	
	table{
		border-right: none;
		border-left: none;
	}
	
	th{
		text-align: center;
	}
	
	#free-container{
		display: flex;
		justify-content: center;
	}
	
	#content{
		display: inline-block;
		width: 70%;
		margin-top: 2%;
	}
	
	#page{
		text-align: center;
		margin-top: 5%;
	}
	
	#search{
		text-align: center;
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
<script type="text/javascript" src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script type="text/javascript">
	function btn_start(){
		location.href = "free.do?pageNum=1";
	}
	
	function btn_end(totalPage){
		location.href = "free.do?pageNum="+totalPage;
	}
	
	function btn_prev(listStart, listEnd){
		if(listStart != 1){
			listEnd = listStart-1;
		}else{
			listStart = 1;
		}
		
		location.href = "free.do?pageNum="+listEnd;
	}
	
	function btn_next(listStart, listEnd, totalPage){
		if(listEnd != totalPage){
			listStart += 5;
			
			location.href = "free.do?pageNum="+listStart;
		}else{
			location.reload();
		}
	}
	
	// 검색창에 공백 입력 시 공백 자동 제거
	function noSpaceForm(obj) 
    {             
        var str_space = /\s/;               // 공백 체크
        
        if(str_space.exec(obj.value)) 
        {     // 공백 체크
            alert("검색어에는 공백을 사용할 수 없습니다.");
            obj.focus();
            obj.value = obj.value.replace(' ',''); // 공백제거
            return false;
        }
    }
	
	// 쪽지 보내기 팝업창을 띄운다.
	function sendNewNote(member_num) {
		var popupX = (document.body.offsetWidth/2)-(800/2);
		var popupY = (window.screen.height/2)-(370/2);
		window.open("/member/sendNewNote.do?member_num="+member_num, "_blank", "width=420, height=370, left="+popupX+", top="+popupY);
	}
	
	$(function() {
		// 멤버 닉네임 클릭 시
		$('.member_nick').click(function(e) {
			let member_num = $(this).attr("member_num");
			$('#member_info').attr("href", "memberInfo.do?member_num="+member_num);
			$('#send_new_note').attr("href", "window.open('/member/sendNewNote.do?member_num='+member_num, '_blank', 'width=420, height=370, left='+popupX+', top='+popupY)");
			
			var divLeft = e.clientX;
			var divTop = e.clientY;
			
			console.log(divLeft, divTop);
			
			$('#member_modal').css({
				"top": divTop,
				"left": divLeft,
				"position": "absolute"
			}).show();
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
	<div id="free-container">
		<div id="content">
			<h2><a href="free.do">자유게시판</a></h2>
			<h6>(전체 게시글 수 : ${ totalRecord })</h6>
			<hr>
			<div id="board">
				<table border="1" class="table table-hover">
					<thead class="table-active">
						<tr>
							<th width="60%">제목</th>
							<th width="30%">작성자</th>
							<th width="10%">조회수</th>
						</tr>
					</thead>

					<tbody>
						<c:forEach var="f" items="${ list }">
							<tr>
								<td width="60%"><a
									href="detailFree.do?board_num=${ f.board_num }">${ f.title }</a>
								</td>
								<td width="30%">
										<c:if test="${ member_num eq 0 }">
										<a href="#a" class="login_pls_alert">${ f.member_nick }</a>
									</c:if>
									<c:if test="${ member_num ne 0 }">
										<a class="member_nick" href="#a" member_num=${ f.member_num }>${ f.member_nick }</a>
									</c:if>
								</td>
								<td width="10%">&nbsp;&nbsp;&nbsp;${ f.views }</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
				
				<button class="btn btn-primary" onclick="location.href='/member/insertFree.do'" style="float: right;">글쓰기</button>
			</div>

			<!-- 페이지 번호 -->
			<div id="page">
				<a href="#" onclick="btn_start()">≪</a>&nbsp; <a href="#"
					onclick="btn_prev(${ listStart }, ${ listEnd })">[이전]</a>&nbsp;
				<c:forEach var="i" begin="${ listStart }" end="${ listEnd }">
					<c:choose>
						<c:when test="${ pageNum eq i }">
							<a href="free.do?pageNum=${ i }"
								style="font-weight: bold; color: #325d88; text-decoration: underline;">[${ i }]</a>&nbsp;&nbsp;
						</c:when>
						<c:otherwise>
							<a href="free.do?pageNum=${ i }">[${ i }]</a>&nbsp;&nbsp;
						</c:otherwise>
					</c:choose>
				</c:forEach>
				<a href="#"
					onclick="btn_next(${ listStart }, ${ listEnd }, ${ totalPage })">[다음]</a>&nbsp;
				<a href="#" onclick="btn_end(${ totalPage })">≫</a>
			</div>

			<!-- 검색창 -->
			<div id="search">
				<form name="searchFree" method="get" action="searchFree.do">
					<input type="hidden" name="pageNum" value="1"> <select
						class="form-select" name="search_option"
						style="width: 10%; display: inline-block;">
						<option value="title"
							<c:if test="${map.search_option == 'title'}">selected</c:if>>제목</option>
						<option value="content"
							<c:if test="${map.search_option == 'content'}">selected</c:if>>내용</option>
						<option value="member_nick"
							<c:if test="${map.search_option == 'member_nick'}">selected</c:if>>작성자</option>
						<option value="all"
							<c:if test="${map.search_option == 'all'}">selected</c:if>>전체</option>
					</select> <input class="form-control" name="keyword" value="${map.keyword}"
						onkeyup="noSpaceForm(this);" onchange="noSpaceForm(this);"
						required="required" style="width: 40%; display: inline-block;">
					<input class="btn btn-primary" type="submit" value="검색">
				</form>
			</div>
		</div>
	</div>

	<div class="modal" id="member_modal">
		<table class="table table-hover" id="member_act">
			<tr>
				<td><a id="member_info">회원 정보 보기</a></td>
			</tr>
			<tr>
				<td><a href="#" onclick="sendNewNote(${member_num})">쪽지 보내기</a></td>
			</tr>
		</table>
	</div>
	<jsp:include page="findZoo_Footer.jsp"/>
</body>
</html>