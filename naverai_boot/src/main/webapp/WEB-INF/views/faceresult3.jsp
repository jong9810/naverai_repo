<%@page import="java.math.BigDecimal"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
<script>
window.onload = function() {
	let mycanvas = document.getElementById("facecanvas");
	let mycontext = mycanvas.getContext("2d");
	
	let faceimage = new Image();
	faceimage.src="/naverimages/${param.image}"; //url 통신하여 이미지 다운로드(시간 걸림)
	
	faceimage.onload = function() {
		mycontext.drawImage(faceimage, 0, 0, faceimage.width, faceimage.height);
		
		<%
			String faceresult2 = (String) request.getAttribute("faceresult2");
			JSONObject total = new JSONObject(faceresult2);
			JSONObject info = (JSONObject) total.get("info");
			JSONObject size = (JSONObject) info.get("size");
			int width = (int) size.get("width");
			int height = (int) size.get("height");
			JSONArray faces = (JSONArray) total.get("faces");
			// 얼굴 크기(faces[i].roi.x, faces[i].roi.y, faces[i].roi.width, faces[i].roi.height)
			for (int i = 0; i < faces.length(); i++) {
				JSONObject oneperson = (JSONObject) faces.get(i);
				JSONObject roi = (JSONObject) oneperson.get("roi");
				int x = (int) roi.get("x");
				int y = (int) roi.get("y");
				int facewidth = (int) roi.get("width");
				int faceheight = (int) roi.get("height");
		%>
		
		mycontext.linewidth = 3;
		mycontext.strokeStyle = "pink";
		mycontext.strokeRect(<%=x %>, <%=y %>, <%=facewidth %>, <%=faceheight %>); //얼굴위치인식
		
		var copyimage = mycontext.getImageData(<%=x %>, <%=y %>, <%=facewidth %>, <%=faceheight %>);
		mycontext.putImageData(copyimage, <%=x%>, <%=y+100%>);
		
		mycontext.fillStyle = "orange";
		mycontext.fillRect(<%=x %>, <%=y %>, <%=facewidth %>, <%=faceheight %>); //모자이크처리
		
		<% } // for %>
	}; //faceimage.onload
	
	
}; //window.onload
</script>
</head>
<body>
<canvas id="facecanvas" width="<%=width %>" height="<%=height %>" style="border: 2px solid pink"></canvas>
</body>
</html>

<!-- 
{"info":{
	"size":{"width":284,"height":319},
	"faceCount":1
},
"faces":[{
	"roi":{"x":48,"y":78,"width":175,"height":175},
	"landmark":{
		"leftEye":{"x":91,"y":127},
		"rightEye":{"x":169,"y":135},
		"nose":{"x":121,"y":169},
		"leftMouth":{"x":84,"y":206},
		"rightMouth":{"x":168,"y":211}
	},
	"gender":{
		"value":"female",
		"confidence":0.999941
	},
	"age":{
		"value":"20~24",
		"confidence":0.877841
	},
	"emotion":{
		"value":"smile",
		"confidence":0.999755
	},
	"pose":{
		"value":"frontal_face",
		"confidence":0.999145
	}
}]}
 -->