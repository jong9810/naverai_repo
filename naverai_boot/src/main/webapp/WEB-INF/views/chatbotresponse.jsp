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
	let json = JSON.parse('${response}');
	let desciption = json.bubbles[0].data.description;
	$("#second").html("답변내용 : " + desciption);
});
</script>
</head>
<body>
<h3>질문내용 : ${param.request}</h3>
<h3>답변내용(모두) : ${response}</h3>
<h3 id="second"></h3>

</body>
</html>