<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head> 
<meta charset="UTF-8">
<title>Insert title here</title>
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
	
	#deal-container{
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
	<div id="deal-container">
		<div id="content">
			<h4>거래게시판 글 작성</h4>
			<hr> 
			<form class="form-group" action="insertDeal.do" method="post" enctype="multipart/form-data">
				<label class="form-label mt-4">제목</label>
				<input class="form-control" type="text" name="title" style="width: 100%;">
				<label class="form-label mt-4">가격</label>
				<input class="form-control" type="number" name="deal_price" style="width: 50%;">
				<label class="form-label mt-4">내용</label>
				<textarea class="form-control" rows="15" name="content" style="width: 100%;"></textarea>
				<label class="form-label mt-4">사진</label>
				<input class="form-control" type="file" name="picture_file"><br>
				<div id="btn">
					<input class="btn btn-primary" type="submit" value="작성">
					<input class="btn btn-primary" type="reset" value="초기화">
				</div>
			</form>
		</div>
	</div>
</body>
</html>