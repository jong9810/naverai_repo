package chatbot;

import java.io.File;
import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.example.ai.MyNaverInform;

@Controller
public class ChatbotController {
	
	@Autowired
	@Qualifier("chatbotservice")
	ChatbotServiceImpl service;
	
	@Autowired
	@Qualifier("chatbotttsservice")
	ChatbotTTSServiceImpl ttsservice;
	
	@Autowired
	@Qualifier("chatbotsttservice")
	ChatbotSTTServiceImpl sttservice;
	
	@Autowired
	@Qualifier("pizzaservice")
	PizzaServiceImpl pizzaservice;
	
	@RequestMapping("/chatbotrequest")
	public String chatbotrequest() {
		return "chatbotrequest";
	}
	
	// 1. ajax 사용 X
	@RequestMapping("/chatbotresponse")
	public ModelAndView chatbotresponse(String request, String event) {
		String response = null;
		if (event.equals("웰컴메시지")) {
			response = service.test(request, "open");
		} else if (event.equals("답변")) {
			response = service.test(request);
		}
		ModelAndView mv = new ModelAndView();
		mv.addObject("response", response); // json 형식 String
		mv.setViewName("chatbotresponse");
		return mv;
	}
	
	// 기본 답만 분석한 뷰
	@RequestMapping("/chatbotajaxstart")
	public String chatbotajaxstart() {
		return "chatbotajaxstart";
	}
	
	// 기본 + 이미지 + 멀티링크 답변 분석한 뷰
	@RequestMapping("/chatbotajax")
	public String chatbotajax() {
		return "chatbotajax";
	}
	
	@RequestMapping("/chatbotajaxprocess")
	@ResponseBody
	public String chatbotajaxprocess(String request, String event) {
		String response = null;
		if (event.equals("웰컴메시지")) {
			response = service.test(request, "open");
		} else {
			response = service.test(request, "send");
		}
		return response;
	}
	
	@RequestMapping("/chatbottts")
	@ResponseBody
	public String chatbottts(String text) { // 챗봇 답변
		String mp3 = ttsservice.test(text);
		return "{\"mp3\": \"" + mp3 + "\"}";
	}
	
	// 음성질문 서버로 업로드
	@PostMapping("/mp3upload")
	@ResponseBody
	public String mp3upload(MultipartFile file1) throws IOException {
		String uploadFile = file1.getOriginalFilename();
		String uploadPath = MyNaverInform.path;
		File saveFile = new File(uploadPath + uploadFile);
		file1.transferTo(saveFile);
		return "{\"result\": \"잘 받았습니다.\"}";
	}
	
	@RequestMapping("/chatbotstt")
	@ResponseBody
	public String chatbotstt(String mp3file) {
		String text = sttservice.test(mp3file);
		return  text;
	}
	
	@RequestMapping("/pizzaorder")
	@ResponseBody
	public String pizza(PizzaDTO dto) {
		int insertRow = pizzaservice.insertPizza(dto);
		String result = null;
		if (insertRow >= 1) {
			result = insertRow + "건의 주문이 접수되었습니다.";
		} else {
			result = "주문 접수 중 문제가 발생하였습니다. 다시 주문해주세요.";
		}
		return "{\"result\": \"" + result + "\"}";
	}
}
