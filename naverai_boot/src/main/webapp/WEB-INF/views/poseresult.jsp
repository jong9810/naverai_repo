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
	let poseimage = new Image();
	poseimage.src = "/naverimages/${param.image}";
	
	let mycanvas = $("#posecanvas").get(0);
	mycanvas.width = poseimage.width + 100;
	mycanvas.height = poseimage.height + 100;
	let mycontext = mycanvas.getContext("2d");
	
	let json = JSON.parse('${poseresult}');
	
	poseimage.onload = function() {
		mycontext.drawImage(poseimage, 50, 50, poseimage.width, poseimage.height);
		if (json.predictions[0] == undefined) return;
		mycontext.textAlign = "center";
		mycontext.font = "italic bold 10px Arial, sans-serif";
		
		let bodyparts = ["코", "목", "오른쪽 어깨", "오른쪽 팔꿈치", 
			"오른쪽 손목", "왼쪽 어깨", "왼쪽 팔꿈치", "왼쪽 손목", "오른쪽 엉덩이",
			"오른쪽 무릎", "오른쪽 발목", "왼쪽 엉덩이", "왼쪽 무릎", 
			"왼쪽 발목", "오른쪽 눈", "왼쪽 눈", "오른쪽 귀", "왼쪽 귀"];
		
		let colorinforms = ['red', 'orange', 'yellow', "green","blue", "navy", "purple", "cyan", "lime", "pink", "black", "white", "gray", "lightgray"];
		
		for (let j = 0; j < json.predictions.length; j++) {
			for (let i = 0; i < 18; i++) {
				if (json.predictions[j][i] == null) continue;
				let x = json.predictions[j][i].x * poseimage.width + 50;
				let y = json.predictions[j][i].y * poseimage.height + 50;
				
				mycontext.fillStyle = colorinforms[i % colorinforms.length];
				mycontext.fillText(bodyparts[i], x, y);
			} //for
		}
	}; // poseimage.onload
	
	
	
}); // ready
</script>
</head>
<body>
<!-- <h3>${poseresult}</h3> -->
<div id="output" style="border: 2px sloid orange"></div>
<canvas id="posecanvas" style="border: 2px sloid silver"></canvas>
</body>
</html>
