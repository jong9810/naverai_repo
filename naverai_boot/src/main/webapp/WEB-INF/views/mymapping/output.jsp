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
	// 답변 mp3 파일 실행
	document.querySelector("#answer").play();
});
</script>
</head>
<body>
<h3>답변(텍스트) : ${answer}</h3>
<audio id="answer" src="/naverimages/${mp3filename}"></audio>

</body>
</html>