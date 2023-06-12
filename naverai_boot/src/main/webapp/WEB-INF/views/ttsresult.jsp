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
<h3>${ttsresult} 파일에 저장했습니다.</h3>
<audio src="/naverimages/${ttsresult}" controls></audio>

</body>
</html>