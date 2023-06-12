<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
</head>
<body>
<%
	String speakers[] = 
	{"mijin", "jinho", "clara", "matt", "shinji", "meimei", "liangliang", "jose",
			"carmen", "nnaomi", "nhajun", "ndain"};
	
	String[] speakerinforms = {
			"미진 : 한국어, 여성음색", "진호 : 한국어, 남성음색", 
			"클라라 : 영어, 여성 음색", "매트 : 영어, 남성 음색",
			"신지: 일본어, 남성 음색", "메이메이 : 중국어, 여성 음색",
			"량량 : 중국어, 남성 음색", "호세 : 스페인어, 남성 음색",
			"카르멘 : 스페인어, 여성 음색", 	"나오미 : 일본어, 여성 음색",
			"하준 : 한국어, 아동 음색 (남)", "다인 : 한국어, 아동음색 (여)"
			};
%>

<form action="ttsresult" method="get">
	음색 선택 : <br/>
	<% for (int i = 0; i < speakers.length; i++) { %>
		<input type="radio" name="speaker" value=<%=speakers[i] %> /><%=speakerinforms[i] %><br/>
	<% } %>	
	<br/>
	텍스트 파일 선택 : <select name="txtfile">
		<c:forEach items="${filelist}" var="onefile">
			<option value="${onefile}">${onefile}</option>
		</c:forEach>
	</select>
	<input type="submit" value="mp3변환요청" />
</form>

</body>
</html>