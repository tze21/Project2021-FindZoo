<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="./resources/css/bootstrap.min.css" type="text/css">
<style type="text/css">
	a {
		color: black;
		text-decoration: none;
	}
	a:hover {
		font-weight: bold;
		color: #325d88;
		text-decoration: underline;
	}
	
	/* 폰트 적용 */
	@font-face {
		font-family: 'GmarketSansMedium';
		src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_2001@1.1/GmarketSansMedium.woff') format('woff');
		font-weight: normal;
		font-style: normal;
	}
	* {
		font-family: 'GmarketSansMedium';
		font-weight: lighter;
	}
	
	/* 내 정보 상세 조회 */
	#deleteChangeInfo-container {
		display: flex;
		position: absolute;
		width: 70%;
		margin: 15%;
		margin-top: 20px;
		margin-bottom: 20px;
		border: 1px solid black;
		z-index: -1;
	}
	
	#deleteChangeInfo-container #sidebar{
		width: 20%;
		margin: 10px;
		border: 1px solid black;
	}
	
	#deleteChangeInfo-container #input-container {
		float: right;
		margin: 10px;
		padding: 20px;
		border: 1px solid black;
	}
</style>
<script type="text/javascript" src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script type="text/javascript">
	$(function(){
		$("#deleteChangeInfoForm").submit(function(){
			var member_num = $("#member_num").val();
			var member_pwd = $("#member_pwd").val();
			var db_pwd = $("#db_pwd").val();
			if(member_pwd != db_pwd) {
				alert("기존 비밀번호가 올바르지 않습니다. 다시 입력해 주세요.");
				$("#member_pwd").val("").select();
				return false;
			}else {
				// 만약 회원번호 1번의 id가 'hong', pwd가 '1234', 닉네임이 '길동이'라면 
				// 순서대로 'deletedMember1', 'deletedMember1', ''으로 변경된다.
				// SMS 알림서비스는 무조건 '비동의'로 하여 탈퇴 후에도 문자가 전송되는 일이 없게끔 한다.
				$("#member_id").val("deletedMember"+$("#member_num").val());
				$("#member_pwd").val("deletedMember"+$("#member_num").val());
				$("#member_nick").val("");
				$("#member_sms").val("비동의");
				confirmDeleteChangeInfo(member_num, member_pwd);
			}
		})
	})
	
	// 회원 탈퇴 확인
	function confirmDeleteChangeInfo(member_num, member_pwd){
		if(confirm("정말 탈퇴하시겠습니까?")) {		
			location.href = "deleteChangeInfo.do?member_num="+member_num+"&member_pwd"+member_pwd;
		}
	} 
</script>
</head>
<body>
	<div id="deleteChangeInfo-container">
		<aside id="sidebar">
			<div class="list-group">
				<%-- class에 active를 지워야 모달 창 열었을 때 bgLayer가 적용된다. --%>
				<a href="myInfo.do?member_num=${mb.member_num}" class="list-group-item list-group-item-action">내 정보</a>
				<a href="myNote.do?member_num=${mb.member_num}" class="list-group-item list-group-item-action">쪽지함</a>
				<a href="memberBoard.do?pageNum=1&member_num=${mb.member_num}" class="list-group-item list-group-item-action">내 게시글</a>
				<a href="#" class="list-group-item list-group-item-action">내 댓글</a>
			</div>
		</aside>
		<article id="input-container">
			<h2>회원 탈퇴</h2>
			<hr>
			<p>
			탈퇴 후에도 각 게시판에 올린 게시글 및 댓글은 자동으로 삭제되지 않습니다. <br>
			삭제를 원하는 게시글이나 댓글이 있다면 반드시 탈퇴 전 삭제하시기 바랍니다. <br>
			탈퇴 후에는 회원정보가 삭제되어 본인 여부를 확인할 수 있는 방법이 없으므로 <br>
			게시글 및 댓글을 임의로 삭제해드릴 수 없습니다. <br>
			</p>
			<form action="deleteChangeInfo.do" id="deleteChangeInfoForm" method="post">
				* 확인 후 hidden 값으로 변경<br>
				회원번호 <input type="text" id="member_num" name="member_num" value="${mb.member_num }" readonly><br>
				아이디 <input type="text" id="member_id" name="member_id" value="${mb.member_id }" readonly><br>
				DB비번 <input type="text" id="db_pwd" name="db_pwd" value="${mb.member_pwd }" readonly><br>
				닉네임 <input type="text" id="member_nick" name="member_nick" value="${mb.member_nick }" readonly><br>
				로그인 방식 <input type="text" id="member_sms" name="member_sms" value="${mb.member_sms }" readonly><br>
				비밀번호: <input type="password" id="member_pwd" name="member_pwd"><br>
				<input type="submit" value="회원 탈퇴">
				<input type="button" value="돌아가기" onclick="location.href='myInfo.do?member_num=${mb.member_num }'"><br>
			</form>
		</article>
	</div>
</body>
</html>