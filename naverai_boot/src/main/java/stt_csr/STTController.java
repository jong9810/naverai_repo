package stt_csr;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.example.ai.MyNaverInform;
import com.example.ai.NaverService;

@Controller
public class STTController {
	
	@Autowired
	@Qualifier("sttservice")
	NaverService service; // speech to text
	
	// ai_images 파일리스트
	@RequestMapping("/sttinput")
	public ModelAndView sttinput() {
		File f = new File(MyNaverInform.path); // 파일 or 디렉토리 정보
		String[] filelist = f.list();
		// mp3, aac, ac3, ogg, flac, wav : 음성 파일
		String[] file_ext = {"mp3", "aac", "ac3", "ogg", "flac", "wav"};
		ArrayList<String> newfilelist = new ArrayList<>();
		for (String onefile : filelist) {
			String myext = onefile.substring(onefile.lastIndexOf(".") + 1);
			for (String soundext : file_ext) {
				if (myext.equals(soundext)) {
					newfilelist.add(onefile);
					break;
				}
			}
		}
		ModelAndView mv = new ModelAndView();
		mv.addObject("filelist", newfilelist);
		mv.setViewName("sttinput");
		return mv;
	}
	
	@RequestMapping("/sttresult")
	public ModelAndView sttresult(String mp3file, String lang) throws IOException {
		String sttresult = null;
		if (lang == null) {
			sttresult = service.test(mp3file);
		} else {
			sttresult = ((STTServiceImpl) service).test(mp3file, lang);
		}
		ModelAndView mv = new ModelAndView();
		mv.addObject("sttresult", sttresult);
		mv.setViewName("sttresult");
		
		// MyNaverInform.path 경로에 txt 파일로 저장하기
		// 저장하는 파일이름
		// 전달받은 파일이름 + 저장한 날짜, 시간으로 지정
		// (ex. a.mp3_20230609112123.txt)
		Date now = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
		String nowString = sdf.format(now);
		String filename = mp3file.substring(0, mp3file.lastIndexOf(".")) + "_" + nowString + ".txt";
		File file = new File(MyNaverInform.path + filename);
		FileWriter fw = new FileWriter(file, false);
		
		JSONObject sttresultJson = new JSONObject(sttresult);
		String fileContent = (String) sttresultJson.get("text");
		fw.write(fileContent + "\n");
		fw.flush();
		fw.close();
		
		return mv;
	}

}
