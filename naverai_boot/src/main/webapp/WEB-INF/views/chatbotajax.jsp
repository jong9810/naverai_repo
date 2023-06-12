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
	
	// input type button을 클릭했을 경우
	$("input:button").on("click", function() {
		
		// 웰컴메시지가 아닌 경우 질문을 response div 태그에 추가
		if ($(this).val() !== "웰컴메시지") {
			$("#response").append("질문 : " + $("#request").val() + "<br/>");
		}
		
		// ajax 통신
		$.ajax({
			url: "/chatbotajaxprocess",
			data: { "request": $("#request").val(), "event": $(this).val() },
			type: "get",
			dataType: "json",
			success: function(response) {
				let bubbles = response.bubbles;
				for (let i = 0; i < bubbles.length; i++) {
					if (bubbles[i].type === "text") {
						// 1) 기본 답변(텍스트 / 텍스트 + url)
						$("#response").append("기본 답변 : " + bubbles[i].data.description + "<br/>");
						if (bubbles[i].data.url != null) {
							$("#response").append("<a href=" + bubbles[i].data.url + ">" + bubbles[i].data.url + "</a><br/>")
						}
					} else if (bubbles[i].type === "template") {
						let contentTable = bubbles[i].data.contentTable;
						if (bubbles[i].data.cover.type === "image") {
							// 2) 이미지 답변(이미지 + url)
							let imageUrl = bubbles[i].data.cover.data.imageUrl;
							$("#response").append("<img src=" + imageUrl + " width='200' height='200' /><br/>");
							for (let c in contentTable) {
								for (let d in contentTable[c]) {
									let link = contentTable[c][d].data.title;
									let url = contentTable[c][d].data.data.action.data.url;
									$("#response").append("<a href=" + url + ">" + link + "</a><br/>");
								}
							}
							
						} else if (bubbles[i].data.cover.type === "text") {
							// 3) 멀티링크 답변(url 여러개)
							$("#response").append("멀티링크 답변 : " + bubbles[i].data.cover.data.description);
							$("#response").append("<ul>");
							for (let c in contentTable) {
								for (let d in contentTable[c]) {
									let link = contentTable[c][d].data.title;
									let url = contentTable[c][d].data.data.action.data.url;
									$("#response").append("<li><a href=" + url + ">" + link + "</a></li>");
								}
							}
							$("#response").append("</ul>");
						} // if-elfse if
					} // if-else if
				} // for i
			}, // success
			error: function(jqXHR, textStatus, errorThrown) { 
				alert(textStatus + "\n" + errorThrown + "\n" + 
						"jqXHR.status : " + jqXHR.status + "\n" + 
						"jqXHR.statusText : " + jqXHR.statusText + "\n" + 
						"jqXHR.responseText : " + jqXHR.responseText + "\n" + 
						"jqXHR.readyState : " + jqXHR.readyState); 
			},
		}); // ajax
	}); // input on
	
	
	// #request input 태그에 질문 입력하고 엔터치면 답변 클릭 이벤트 동작
	$("#request").on("keydown", function(e) {
		if (e.keyCode === 13) {
			$("#send-btn").trigger("click");
		}
	}); // request on
	
	
	
}); // ready
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