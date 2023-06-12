package mymapping;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.ai.MyNaverInform;
import com.example.ai.NaverService;

@Controller
public class MapController {
	
	@Autowired
	@Qualifier("mapservice")
	NaverService service1;
	
	@Autowired
	@Qualifier("ttsservice")
	NaverService service2;
	
	@GetMapping("/myinput")
	public String myinput() {
		return "mymapping/input";
	}
	
	// 2. ajax 사용 O
	@RequestMapping("/myoutput")
	@ResponseBody
	public String myoutput(String question) throws IOException {
		String answer = service1.test(question);
		
		String txtfilename = "mymapping.txt";
		File f = new File(MyNaverInform.path + txtfilename);
		FileWriter fw = new FileWriter(f, false);
		fw.write(answer);
		fw.flush();
		fw.close();
		
		String mp3filename = service2.test(txtfilename);
		
		return "{\"mp3filename\": \"" + mp3filename + "\", \"answer\": \"" + answer + "\"}";
	}
	
	/*
	// 1. ajax 사용 X
	@RequestMapping("/myoutput") 
	public ModelAndView myoutput(String question) throws IOException {
		String answer = service1.test(question);
		
		String txtfilename = "mymapping.txt";
		File f = new File(MyNaverInform.path + txtfilename);
		FileWriter fw = new FileWriter(f, false);
		fw.write(answer);
		fw.flush();
		fw.close();
		
		String mp3filename = service2.test(txtfilename);
		
		ModelAndView mv = new ModelAndView();
		mv.addObject("answer", answer);
		mv.addObject("mp3filename", mp3filename);
		mv.setViewName("mymapping/output");
		return mv;
	}
	*/
}
