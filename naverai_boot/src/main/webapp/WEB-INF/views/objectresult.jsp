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
	let json = JSON.parse('${objectresult}');
	$("#count").html("<h3>" + json.predictions[0].num_detections + "개의 사물 탐지</h3>")
	
	for (let i = 0; i < json.predictions[0].num_detections; i++){
		$("#names").append(
			json.predictions[0].detection_names[i] + "-" +
			parseInt(parseFloat(json.predictions[0].detection_scores[i]) * 100) + " 퍼센트<br/>");
			
		let x1 = json.predictions[0].detection_boxes[i][0];
		let y1 = json.predictions[0].detection_boxes[i][1];
		let x2 = json.predictions[0].detection_boxes[i][2];
		let y2 = json.predictions[0].detection_boxes[i][3];
		$("#boxes").append((i+1) + " : (x1, y1) = (" + x1 + ", " + y1 + "), (x2, y2) = (" + x2 + ", " + y2 + ")<br/>");
	} // for
	
	let mycanvas = document.getElementById("objectcanvas");
	let mycontext= mycanvas.getContext("2d");
	
	let faceimage = new Image();
	faceimage.src = "/naverimages/${param.image}";//url 통신 이미지 다운로드 시간 대기
	mycanvas.width = faceimage.width + 100;
	mycanvas.height = faceimage.height + 100;
	
	faceimage.onload = function(){
		mycontext.drawImage(faceimage, 50, 50, faceimage.width, faceimage.height);
		
		let colors = ["red", "orange", "yellow", "green", "blue", "navy", "purple", "cyan", "lime", "pink", "black", "white"];
		let boxes = json.predictions[0].detection_boxes; // 2차원 배열
		for (let i = 0; i < boxes.length; i++) {
			// 정확도 50%미만인 경우 표시하지 않기
			if (parseInt(parseFloat(json.predictions[0].detection_scores[i]) * 100) < 50) continue;
			/*
			// y와 x 좌표가 바뀐 것으로 추정됨
			let x1 = boxes[i][0] * faceimage.width;
			let y1 = boxes[i][1] * faceimage.height;
			let x2 = boxes[i][2] * faceimage.width;
			let y2 = boxes[i][3] * faceimage.height;
			*/
			let y1 = boxes[i][0] * faceimage.height + 50;
			let x1 = boxes[i][1] * faceimage.width + 50;
			let y2 = boxes[i][2] * faceimage.height + 50;
			let x2 = boxes[i][3] * faceimage.width + 50;
			
			// 사각형
			mycontext.lineWidth = 3;
			mycontext.strokeStyle = colors[i % colors.length];
			mycontext.strokeRect(x1, y1, x2 - x1, y2 - y1);
			
			// 텍스트
			mycontext.fillStyle = colors[i % colors.length];
			mycontext.font = "italic bold 20px Arial, sans-serif"; 
			mycontext.fillText(json.predictions[0].detection_names[i], x1, y1 - 5);
			
		} // for 
	} // faceimage onload
}); // ready
</script>
</head>
<body>
<h3>${objectresult}</h3>
<div id="count"></div>
<div id="names" style="border: 2px solid lime"></div>
<div id="boxes" style="border: 2px solid orange"></div>
<canvas id="objectcanvas" style="border: 2px solid pink"></canvas>
</body>
</html>
