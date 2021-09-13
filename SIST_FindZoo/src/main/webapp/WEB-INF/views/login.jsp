<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<script type="text/javascript" src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script type="text/javascript">
/*
function findId(){
	 var member_id = $("#member_id").val();
	 var member_name = 
	 $.ajax({
			url : '${pageContext.request.contextPath}/user/idCheck?member_id='+ member_id,
			type : 'get',
			success : function(data) {
				 if(data == 409){
					 alert("이미 등록된 아이디입니다.");
					 $("#member_id").val("");
					 return false;
				 }else{
					 alert("사용 가능한 아이디입니다.");
				 }
			}
	 })
	 
}
*/

function goFindId(){
	
	location.href="/views/find_id.jsp";
}
</script>
</head>
<body>
	<h2>로그인</h2>
	<hr>
	<form action="login.do" method="post">
		아이디 : <input type="text" name="member_id"><br>
		암호 : <input type="password" name="member_pwd"><br>
		<input type="submit" value="로그인">
		<a href="join.jsp">회원가입</a>
		<input type="button" id="find-id" onclick="goFindId();" value="아이디 찾기">
		<button type="button" id="find-id" onclick="location=windows.open('find_pwd.jsp')">비밀번호 찾기</button>
	</form>
</body>
</html>