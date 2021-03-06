<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head> 
<meta charset="UTF-8">
<title>거래 게시판</title>
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
	
	#free-container{
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
	<div id="deal-container">
		<div id="content">
			<h4>거래 게시판 글 수정</h4>
			<hr> 
			<form class="form-group" action="updateDeal.do" method="post" enctype="multipart/form-data">
				<input type="hidden" name="board_num" value="${ d.board_num }">
				<input type="hidden" name="picture_fname" value="${ d.picture_fname }">
				<label class="form-label mt-4">제목</label>
				<input class="form-control" type="text" name="title" value="${ d.title }" style="width: 100%;">
				<label class="form-label mt-4">가격</label>
				<input class="form-control" type="number" name="deal_price" value="${ d.deal_price }" style="width: 50%;">
				<label class="form-label mt-4">내용</label>
				<textarea class="form-control" rows="15" name="content" style="width: 100%;">${ d.content }</textarea>
				<label class="form-label mt-4">사진</label>
				<input class="form-control" type="file" name="picture_file" value="${ d.picture_fname }"><br>
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