package ocr;

import java.io.File;
import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.example.ai.MyNaverInform;
import com.example.ai.NaverService;

@Controller
public class OCRController {
	
	@Autowired
	@Qualifier("ocrservice")
	NaverService service;
	
	@RequestMapping("/ocrinput")
	public ModelAndView ocrinput() {
		File f = new File(MyNaverInform.path); // 파일 or 디렉토리 정보
		String[] filelist = f.list();
		String[] file_ext = {"jpg", "gif", "png", "jfif"};
		ArrayList<String> newfilelist = new ArrayList<>();
		for (String onefile : filelist) {
			String myext = onefile.substring(onefile.lastIndexOf(".") + 1);
			for (String imgext : file_ext) {
				if (myext.equals(imgext)) {
					newfilelist.add(onefile);
					break;
				}
			}
		}
		ModelAndView mv = new ModelAndView();
		mv.addObject("filelist", newfilelist);
		mv.setViewName("ocrinput");
		return mv;
	}
	
	@RequestMapping("/ocrresult")
	public ModelAndView ocrresult(@RequestParam("image") String img) {
		String ocrresult = service.test(img);
		ModelAndView mv = new ModelAndView();
		mv.addObject("ocrresult", ocrresult);
		mv.setViewName("ocrresult");
		return mv;
	}
}
