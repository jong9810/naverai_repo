package chatbot;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class ChatbotController {
	
	@Autowired
	@Qualifier("chatbotservice")
	ChatbotServiceImpl service;

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
	// 기본 답면 분석한 뷰
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
	
}
