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
	let $audio = document.getElementById("tts");
	
	// input type button을 클릭했을 경우
	$("input:button").on("click", function() {
		
		// 웰컴메시지가 아닌 경우 질문을 response div 태그에 추가
		if ($(this).val() !== "웰컴메시지") {
			$("#response").append("질문 : " + $("#request").val() + "<br/>");
		}
		
		// ajax 통신
		$.ajax({
			url: "/chatbotajaxprocess",
			data: { "request": $("#request").val(), "event": $(this).val() },
			type: "get",
			dataType: "json",
			success: function(response) {
				let bubbles = response.bubbles;
				for (let i = 0; i < bubbles.length; i++) {
					if (bubbles[i].type === "text") {
						// 1) 기본 답변(텍스트 / 텍스트 + url)
						$("#response").append("기본 답변 : " + bubbles[i].data.description + "<br/>");
						if (bubbles[i].data.url != null) {
							$("#response").append("<a href=" + bubbles[i].data.url + ">" + bubbles[i].data.url + "</a><br/>")
						}
						
						// chatbot 답변을 음성으로 바꿈
						$.ajax({
							url: "/chatbottts",
							data: { "text": bubbles[i].data.description },
							type: "get",
							dataType: "json",
							success: function(response) {
								$audio.src = "/naverimages/" + response.mp3;
								$audio.play();
							},
							error: function(jqXHR, textStatus, errorThrown) { 
								alert(textStatus + "\n" + errorThrown + "\n" + 
										"jqXHR.status : " + jqXHR.status + "\n" + 
										"jqXHR.statusText : " + jqXHR.statusText + "\n" + 
										"jqXHR.responseText : " + jqXHR.responseText + "\n" + 
										"jqXHR.readyState : " + jqXHR.readyState); 
							},
						}); // ajax
						
						/////////////////
						// 피자 주문 시작 //
						/////////////////
						let order_reply = bubbles[i].data.description;
						// 콤비네이션피자 (소) 주문하셨습니다. 0102580258 으로 연락드리겠습니다. 감사합니다.
						if (order_reply.indexOf("주문하") >= 0) {
							let split_result = order_reply.split(" ");
							let kind = split_result[0];
							let size = split_result[1];
							let phone = split_result[3];
							
							let kinds = ["파인애플피자", "콤비네이션피자", "포테이토피자"];
							let prices = [12000, 10000, 11000];
							let sizes = ["(특대)", "(대)", "(중)", "(소)"];
							// 사이즈별 추가금
							// 소 : 기본 가격, 중 : +2000, 대 : +5000, 특대 : +10000
							let extras = [10000, 5000, 2000, 0];
							let totalPrice = 0;
							for (let j in kinds) {
								if (kinds[j] === kind) {
									totalPrice = prices[j];
									break;
								}
							}
							for (let j in sizes) {
								if (size === sizes[j]) {
									totalPrice += extras[j];
									break;
								}
							}
							$("#response").append("총 지불 가격 : " + totalPrice + "<br/>");
							
							// 피자 주문 정보를 db에 저장하기 위해 요청
							$.ajax({
								url: "/pizzaorder",
								data: {"kind": kind, "size": size, "phone": phone, "price": totalPrice}, 
								type: "get", 
								dataType: "json",
								success: function(response) {
									$("#response").append(response.result + "<br/>");
								}, // success
								error: function(jqXHR, textStatus, errorThrown) { 
									alert(textStatus + "\n" + errorThrown + "\n" + 
											"jqXHR.status : " + jqXHR.status + "\n" + 
											"jqXHR.statusText : " + jqXHR.statusText + "\n" + 
											"jqXHR.responseText : " + jqXHR.responseText + "\n" + 
											"jqXHR.readyState : " + jqXHR.readyState); 
								}, // error
							}); // ajax
						}
						/////////////////
						// 피자 주문 종료 //
						/////////////////
						
						
					} else if (bubbles[i].type === "template") {
						let contentTable = bubbles[i].data.contentTable;
						if (bubbles[i].data.cover.type === "image") {
							// 2) 이미지 답변(이미지 + url)
							let imageUrl = bubbles[i].data.cover.data.imageUrl;
							$("#response").append("<img src=" + imageUrl + " width='200' height='200' /><br/>");
							for (let c in contentTable) {
								for (let d in contentTable[c]) {
									let link = contentTable[c][d].data.title;
									let url = contentTable[c][d].data.data.action.data.url;
									$("#response").append("<a href=" + url + ">" + link + "</a><br/>");
								}
							}
							
						} else if (bubbles[i].data.cover.type === "text") {
							// 3) 멀티링크 답변(url 여러개)
							$("#response").append("멀티링크 답변 : " + bubbles[i].data.cover.data.description);
							$("#response").append("<ul>");
							for (let c in contentTable) {
								for (let d in contentTable[c]) {
									let link = contentTable[c][d].data.title;
									let url = contentTable[c][d].data.data.action.data.url;
									$("#response").append("<li><a href=" + url + ">" + link + "</a></li>");
								}
							}
							$("#response").append("</ul>");
						} // if-elfse if
					} // if-else if
				} // for i
			}, // success
			error: function(jqXHR, textStatus, errorThrown) { 
				alert(textStatus + "\n" + errorThrown + "\n" + 
						"jqXHR.status : " + jqXHR.status + "\n" + 
						"jqXHR.statusText : " + jqXHR.statusText + "\n" + 
						"jqXHR.responseText : " + jqXHR.responseText + "\n" + 
						"jqXHR.readyState : " + jqXHR.readyState); 
			},
		}); // ajax
		// input type="button"을 클릭하면 입력되어 있던 값 삭제
		$("#request").val("");
	}); // input on
	
	
	// #request input 태그에 질문 입력하고 엔터치면 답변 클릭 이벤트 동작
	$("#request").on("keydown", function(e) {
		if (e.keyCode === 13) {
			$("#send-btn").trigger("click");
		}
	}); // request on
	
	
	
}); // ready
</script>
</head>
<body>
질문 : <input type="text" id="request"/>
<input id="send-btn" type="button" value="답변"/>
<input id="open-btn" type="button" value="웰컴메시지"/>
<button id="record">음성질문 녹음시작</button>
<button id="stop">음성질문 녹음종료</button>
<div id="sound"></div>
<br/>
대화내용 : 
<div id="response" style="border: 2px solid aqua"></div>
음성답변 : <audio id="tts" controls></audio>

<!-- 사용자가 질문 녹음하고 답변 음성으로 받아내는 로직 -->
<script>
let $record = document.getElementById("record");
let $stop = document.getElementById("stop");
let $sound = document.getElementById("sound");

// 브라우저 녹음기나 카메라 사용할 때 지원 여부를 확인하기
let constraint = null;
if (navigator.mediaDevices) {
	console.log("녹음기, 카메라 지원 가능");
	constraint = {"audio": true}; // 녹음기 활성화
}

// 이진 데이터(BLOB) : Binary Large OBject, 이진수를 모아놓은 데이터
// 녹음 시작 - blob 객체 - 녹음 종료 - 
let chunks = [];
navigator.mediaDevices
		.getUserMedia(constraint) // 녹음기 활성화
		.then(function(stream) {
			
				let mediaRecorder = new MediaRecorder(stream); // 녹음기 준비
				$record.onclick = function() {
					mediaRecorder.start();
					$record.style.color = "red";
					$record.style.backgroundColor = "blue";
				}; // record onclick
				
				$stop.onclick = function() {
					mediaRecorder.stop();
					$record.style.color = "";
					$record.style.backgroundColor = "";
				}; // stop onclick
				
				// 녹음 시작 상태이면 chunks에 녹음 데이터 저장
				mediaRecorder.ondataavailable = function(d) {
					chunks.push(d.data);
				}; // ondataavailable

				// 녹음 정지 상태가 되면 chunks -> blob -> mpe로 변환
				mediaRecorder.onstop = function() {
					// div 태그 안에 auido 태그 추가
					let $audio = document.createElement("audio");
					$audio.setAttribute("controls", "controls");
					$audio.controls = true;
					$sound.replaceChildren($audio);
					$sound.appendChild($audio);
					
					// 녹음 데이터를 mp3 데이터로 변환하여 audio 태그 src에 추가
					let blob = new Blob(chunks, {"type": "audio/mp3"}); 
					let mp3url = URL.createObjectURL(blob);
					$audio.src = mp3url;
					
					// 다음 녹음을 위해 chunks 배열 초기화
					chunks = [];
					
					//let a = document.createElement("a");
					//a.href = mp3url;
					//a.innerHTML = "파일로 저장";
					//$sound.appendChild(a);
					//a.download = "a.mp3"; // 파일 이름을 변경(다운로드 경로는 수정 불가)
					
					// 스프링부트 서버로 a.mp3 전송(ajax)
					// FormData 객체 필요
					let formData = new FormData();
					formData.append("file1", blob, "a.mp3"); // form에 파일 전송하는 것처럼 동작
					$.ajax({
						url: "/mp3upload",
						// 파일 전송할 때 아래 4줄 코드 형식
						data: formData,
						type: "post",
						processData: false, 
						contentType: false, 
						success : function(response) {
							$.ajax({
								url: "/chatbotstt",
								data: { "mp3file": "a.mp3" },
								type: "get",
								dataType: "json",
								success: function(response) {
									$("#request").val(response.text);
									$("#send-btn").trigger("click");
								},
								error: function(jqXHR, textStatus, errorThrown) { 
									alert(textStatus + "\n" + errorThrown + "\n" + 
											"jqXHR.status : " + jqXHR.status + "\n" + 
											"jqXHR.statusText : " + jqXHR.statusText + "\n" + 
											"jqXHR.responseText : " + jqXHR.responseText + "\n" + 
											"jqXHR.readyState : " + jqXHR.readyState); 
								},
							}); // ajax
						},
						error: function(jqXHR, textStatus, errorThrown) { 
							alert(textStatus + "\n" + errorThrown + "\n" + 
									"jqXHR.status : " + jqXHR.status + "\n" + 
									"jqXHR.statusText : " + jqXHR.statusText + "\n" + 
									"jqXHR.responseText : " + jqXHR.responseText + "\n" + 
									"jqXHR.readyState : " + jqXHR.readyState); 
						},
					}); // ajax
					
				}; // onstop
				
		}) // then
		.catch(function(err) {
			console.log("오류발생 : " + err);
		}); // catch
		
</script>

<!-- 글씨가 있는 이미지를 업로드하면 OCR로 글자 인식해서 질문하기 -->
</body>
</html>