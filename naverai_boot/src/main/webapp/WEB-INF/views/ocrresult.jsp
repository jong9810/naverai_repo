<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
<script src="/js/jquery-3.6.4.min.js"></script>
<!-- 모델을 json객체로 변환하는 게 번거롭다. -->
<!-- 따라서 java가 아닌 javascript로 json 객체를 다루면 편하다. -->
<script>
$(document).ready(function() {
	
	// JSON.parse() : String 데이터(json 형식)를 JSON 객체로 바꾸는 메서드
	// JSON.stringify() : JSON 객체를 문자열로 변환하는 메서드
	let json = JSON.parse('${ocrresult}');
	$("#output").html(JSON.stringify(json));
	
	let ocrimage = new Image();
	ocrimage.src = "/naverimages/${param.image}";
	
	let mycanvas = $("#ocrcanvas").get(0);
	mycanvas.width = ocrimage.width + 100;
	mycanvas.height = ocrimage.height + 100;
	let mycontext = mycanvas.getContext("2d");
	
	ocrimage.onload = function() {
		mycontext.drawImage(ocrimage, 50, 50, ocrimage.width, ocrimage.height);
		
		let fieldslist = json.images[0].fields;
		for (let i in fieldslist) {
			// 이미지에 포함된 단어를 출력
			$("#output2").append(fieldslist[i].inferText);
			if (fieldslist[i].lineBreak) {
				$("#output2").append("<br/>");
			} else {
				$("#output2").append("&nbsp;");
			}
			
			// 이미지에 포함된 단어에 박스 표시
			let x = fieldslist[i].boundingPoly.vertices[0].x; // 단어 시작점 x
			let y = fieldslist[i].boundingPoly.vertices[0].y; // 단어 시작점 y
			let width = fieldslist[i].boundingPoly.vertices[2].x - x; // 단어 가로 크기
			let height = fieldslist[i].boundingPoly.vertices[2].y - y; // 단어 세로 크기
			
			mycontext.strokeStyle = "blue";
			mycontext.linewidth = 3;
			mycontext.strokeRect(x + 50, y + 50, width, height);
			
		} // for i
		
	}; // ocrimage.onload
	
}); // ready
</script>
</head>
<body>
<div id="output" style="border: solid 2px orange"></div>
<div id="output2" style="border: solid 2px green"></div>
<canvas id="ocrcanvas" style="border: solid 2px pink"></canvas>
</body>
</html>
