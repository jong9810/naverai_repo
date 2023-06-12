<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
<script src="/js/jquery-3.6.4.min.js"></script>
<script>
$(document).ready(function() {
	$("#input-btn").on("click", function() {
		$.ajax({
			url: "/myoutput",
			type: "get",
			data: {"question": $("#question").val()},
			dataType: "json", // 응답으로 받을 데이터 타입
			success: function(response) {
				$("#txt-response").html(response.answer);
				$("#mp3-response").attr("src", "/naverimages/" + response.mp3filename);
				$("#mp3-response")[0].play();
				$("#question").focus();
			},
			error: function(e) {
				alert(e);
			},
		}); //ajax
	}); //on
	
	$("#question").on("keydown", function(e){
		if (e.key == "Enter") {
			$("#input-btn").trigger("click");
		}
	}); //on
}); //ready
</script>
</head>
<body>
<!-- 1. ajax 사용 X -->
<!-- <form action="/myoutput" method="get">
	<input type="text" name="question" placeholder="질문을 입력하세요."/>
	<input type="submit" value="대화" />
</form> -->

<!-- 2. ajax 사용 O -->
<input id="question" type="text" name="question" placeholder="질문을 입력하세요." autofocus/>
<input id="input-btn" type="button" value="대화" />
<h3>답변(텍스트)</h3>
<div id="txt-response"></div>
<audio id="mp3-response" controls></audio>
</body>
</html>