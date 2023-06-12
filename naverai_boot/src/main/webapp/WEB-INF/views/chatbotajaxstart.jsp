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
	$("input:button").on("click", function() {
		$("#response").append("질문 : " + $("#request").val() + "<br/>");
		$.ajax({
			url: "/chatbotajaxprocess",
			data: { "request": $("#request").val(), "event": $(this).val() },
			type: "get",
			dataType: "json",
			success: function(response) {
				let description = response.bubbles[0].data.description;
				$("#response").append("답변 : " + description + "<br/>");
			},
			error: function(error) { alert(error) },
		}); // ajax
		
	}); // input on
});
</script>
</head>
<body>
질문 : <input type="text" id="request"/>
<input id="send-btn" type="button" value="답변"/>
<input id="open-btn" type="button" value="웰컴메시지"/>
<br/>
대화내용
<div id="response" style="border: 2px solid aqua"></div>

</body>
</html>