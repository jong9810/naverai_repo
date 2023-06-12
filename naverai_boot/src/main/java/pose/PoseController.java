package pose;

import java.io.File;
import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.example.ai.MyNaverInform;
import com.example.ai.NaverService;

@Controller
public class PoseController {
	
	@Autowired
	@Qualifier("poseservice")
	NaverService service;
	
	@RequestMapping("/poseinput")
	public ModelAndView poseinput() {
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
		mv.setViewName("poseinput");
		return mv;
	}
	
	@RequestMapping("/poseresult")
	public ModelAndView poseresult(String image) {
		String poseresult = service.test(image);
		ModelAndView mv = new ModelAndView();
		mv.addObject("poseresult", poseresult);
		mv.setViewName("poseresult");
		return mv;
	}
}
