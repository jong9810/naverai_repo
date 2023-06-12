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
<c:forEach items="${filelist}" var="filename">
	<h3>
		<a href="/ocrresult?image=${filename}">
			<img src="/naverimages/${filename}" width="100" height="100"/>
		</a>
		<a href="/ocrresult?image=${filename}">
			${filename}
		</a>
	</h3>
</c:forEach>

</body>
</html>