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
<script src="/js/jquery-3.6.4.min.js"></script>
<script>
$(document).ready(function() {
	//
});
</script>
</head>
<body>
<h3>${faceresult}</h3>
<!-- 자바 언어 String에서 자바스크립트 json으로 변환이 필요하다. -->
<!-- pom.xml에 dependency 추가한다. -->
<!-- 
{
"info":{
	"size":{"width":195,"height":259},
	"faceCount":1
},
"faces":[
	{"celebrity":{"value":"수지","confidence":0.86414}}
]}
 -->
<%
	String faceresult = (String) request.getAttribute("faceresult");
	JSONObject total = new JSONObject(faceresult);
	JSONObject info = (JSONObject) total.get("info");
	int faceCount = (int) info.get("faceCount");
	
	out.println("<h3>총 " + faceCount + "명의 얼굴을 찾았습니다.</h3>");

	JSONArray faces = (JSONArray) total.get("faces");
	for (int i = 0; i < faces.length(); i++) {
		JSONObject oneFace = (JSONObject) faces.get(i);
		JSONObject celebrity = (JSONObject) oneFace.get("celebrity");
		String name = (String) celebrity.get("value");
		BigDecimal confidence = (BigDecimal) celebrity.get("confidence");
		double confidenceDouble = confidence.doubleValue();
		
		if (confidenceDouble < 0.7) continue;
		out.println("<h3>" + name + " 유명인을 " + Math.round(confidenceDouble * 100) + " 퍼센트로 닮았습니다.</h3>");
	}
%>


</body>
</html>