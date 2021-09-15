package com.example.demo.controller;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.example.demo.dao.MemberDao;
import com.example.demo.vo.MemberVo;

@Controller
public class UserController {

	@Autowired
	private MemberDao dao;
	public void setDao(MemberDao dao) {
		this.dao = dao;
	}
	
	@RequestMapping(value = "/join.do", method = RequestMethod.GET)
	public void form() {
		
	}
	
	@RequestMapping(value = "/join.do", method = RequestMethod.POST)
	@ResponseBody
	public String submit(MemberVo m) {
		//ModelAndView mav = new ModelAndView("redirect:/main.do");  //main.do 아직 안만듬
		int re = dao.insert(m);
		String msg = "회원가입에 성공했습니다.";
		if(re != 1) {
			msg = "회원가입에 실패하였습니다.";
		}
		return msg;
	}
	
	@RequestMapping(value = "/login.do", method = RequestMethod.GET)
	public void loginForm() {
		
	}
	
	@RequestMapping(value = "/login.do", method = RequestMethod.POST)
	//@ResponseBody
	public ModelAndView loginSubmit(HttpSession session, String member_id, String member_pwd,HttpServletResponse response) throws Exception{
		ModelAndView mav = new ModelAndView();
		
		String msg = "";
		
		if(dao.isMember(member_id, member_pwd)) {
			MemberVo m = dao.loginMember(member_id);
			session.setAttribute("loginM", m);
			mav.setViewName("redirect:/main.do");
		}else {
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter out = response.getWriter();
			out.println("<script>alert('정보를 확인해주세요.'); </script>");
			out.flush();
			mav.setViewName("redirect:/login.do");
		}
		return mav;
	}
	
	@RequestMapping("/")
	public String main() {
		return "main";
	}
	
	@RequestMapping(value = "/user/idCheck", method = RequestMethod.GET)
	@ResponseBody
	public int idCheck(@RequestParam("member_id") String member_id) {

		return dao.idchk(member_id);
	
	}
	
	@RequestMapping(value = "/user/nickCheck", method = RequestMethod.GET)
	@ResponseBody
	public int nickCheck(@RequestParam("member_nick") String member_nick) {

		return dao.nickchk(member_nick);
	
	}
	
	@RequestMapping(value = "/user/findId", method = RequestMethod.GET)
	@ResponseBody
	public MemberVo findId(@RequestParam("member_name") String member_name,
							@RequestParam("member_phone") String member_phone) {

		return dao.findId(member_name, member_phone);
	
	}
	

}