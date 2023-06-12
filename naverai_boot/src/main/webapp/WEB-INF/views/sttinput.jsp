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
	String[] languages = {"Kor", "Eng", "Chn", "Jpn"};
	String[] language_names = {"한국어", "영어", "중국어", "일본어"};
%>

<form action="sttresult" method="get">
	언어선택 : 
	<% for (int i = 0; i < languages.length; i++) { %>
		<input type="radio" name="lang" value=<%=languages[i] %> /><%=language_names[i] %>
	<% } %>	
	<br/>
	mp3 파일 선택 : <select name="mp3file">
		<c:forEach items="${filelist}" var="onefile">
			<option value="${onefile}">${onefile}</option>
		</c:forEach>
	</select>
	<input type="submit" value="텍스트로변환요청" />
</form>

</body>
</html>