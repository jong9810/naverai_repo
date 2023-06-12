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
</script>
</head>
<body>
<h3>${faceresult2}</h3>
<%
	String faceresult2 = (String) request.getAttribute("faceresult2");
	JSONObject total = new JSONObject(faceresult2);
	JSONObject info = (JSONObject) total.get("info");
	int faceCount = (int) info.get("faceCount");
	JSONArray faces = (JSONArray) total.get("faces");
	out.println("<h3>총 " + faceCount + "명의 얼굴을 인식했습니다.</h3>");
	
	// 성별, 나이, 감정, 포즈
	for (int i = 0; i < faces.length(); i++) {
		JSONObject oneperson = (JSONObject) faces.get(i);
		// 성별
		JSONObject gender = (JSONObject) oneperson.get("gender");
		String genderValue = (String) gender.get("value");
		BigDecimal genderConf = (BigDecimal) gender.get("confidence");
		double genderConfDbl = genderConf.doubleValue();
		// 나이
		JSONObject age = (JSONObject) oneperson.get("age");
		String ageValue = (String) gender.get("value");
		// 감정
		JSONObject emotion = (JSONObject) oneperson.get("emotion");
		String emotionValue = (String) gender.get("value");
		// 포즈
		JSONObject pose = (JSONObject) oneperson.get("pose");
		String poseValue = (String) gender.get("value");
		
		out.println("<h3>" + (i+1) + "번째 얼굴의 성별 = " + genderValue + ", 정확도 = " + genderConfDbl + "</h3>");
		out.println("<h3>" + "나이 = " + ageValue + "</h3>");
		out.println("<h3>" + "감정 = " + emotionValue + "</h3>");
		out.println("<h3>" + "방향 = " + poseValue + "</h3>");
		
		oneperson.get("landmark");
		
		if (!oneperson.get("landmark").equals(null)) {
			JSONObject landmark = (JSONObject) oneperson.get("landmark");
			JSONObject nose = (JSONObject) landmark.get("nose");
			int noseX = (int) nose.get("x");
			int noseY = (int) nose.get("y");
			out.println("<h3>" + "코의 x좌표 = " + noseX + ", 코의 y좌표 = " + noseY + "</h3>");
		} else {
			out.println("<h3>눈코입 위치를 파악할 수 없습니다.</h3>");
		}
	}
	
%>

<canvas>
	
</canvas>
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