package com.example.demo.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.example.demo.dao.MemberDao;
import com.example.demo.dao.NoteDao;
import com.example.demo.vo.MemberVo;
import com.example.demo.vo.NoteVo;

@Controller
public class NoteController {
	
	@Autowired
	private NoteDao dao;

	public void setDao(NoteDao dao) {
		this.dao = dao;
	}

	// 보낸 쪽지함
	@RequestMapping("/member/sendNoteList.do")
	public void sendNoteList(HttpSession session, Model model) {
		int note_sender_num = ((MemberVo)session.getAttribute("loginM")).getMember_num();
		model.addAttribute("list", dao.sendNoteList(note_sender_num));
	}

	// 받은 쪽지함
	@RequestMapping("/member/receiveNoteList.do")
	public void receiveNoteList(HttpSession session, Model model) {
		int note_receiver_num = ((MemberVo)session.getAttribute("loginM")).getMember_num();
		model.addAttribute("list", dao.receiveNoteList(note_receiver_num));
	}
	
	// 보낸 쪽지 내용 상세 조회 + 해당 쪽지를 받는 사람의 닉네임
	@RequestMapping("/member/detailSendNote.do")
	public void detailSendNote(int note_num, Model model) {
		model.addAttribute("nt", dao.detailSendNote(note_num));
	}
	
	// 받은 쪽지 내용 상세 조회 + 해당 쪽지를 보낸(답장시 쪽지를 받을) 사람의 닉네임
	@RequestMapping("/member/detailReceiveNote.do")
	public void detailReceiveNote(HttpSession session, int note_num, Model model) {
		int note_receiver_num = ((MemberVo)session.getAttribute("loginM")).getMember_num();
		model.addAttribute("nt", dao.detailReceiveNote(note_num));
		model.addAttribute("note_receiver_num", note_receiver_num);
	}
	
	// 받은 쪽지 답장
	@RequestMapping(value = "/member/sendReplyNote.do", method = RequestMethod.GET)
	public void sendReplyNoteForm(HttpSession session, int note_num, Model model) {
		int note_sender_num = ((MemberVo)session.getAttribute("loginM")).getMember_num();
		model.addAttribute("note_sender_num", note_sender_num);
		// 쪽지 답장시 필요한 값들을 전달
		model.addAttribute("nt", dao.detailReceiveNote(note_num));
	}
	@RequestMapping(value = "/member/sendReplyNote.do", method = RequestMethod.POST)
	public ModelAndView sendReplyNoteSubmit(NoteVo nt) {
		ModelAndView mav = new ModelAndView("redirect:/member/sendNoteList.do");
		int re = dao.sendReplyNote(nt);
		if(re != 1) {
			mav.addObject("msg", "쪽지 전송에 실패하였습니다.");
			mav.setViewName("error");
		}
		return mav;
	} 
	
	// 새로운 쪽지 보내기
	@RequestMapping(value = "/member/sendNewNote.do", method = RequestMethod.GET)
	public void sendNewNoteForm(HttpSession session, int member_num, Model model) {
		int note_sender_num = ((MemberVo)session.getAttribute("loginM")).getMember_num();
		int note_receiver_num = member_num;
		// 쪽지를 받는 사람의 멤버 닉네임을 가져옴
		String member_nick = dao.getMemberNick(member_num);
		NoteVo nt = new NoteVo();
		
		nt.setMember_nick(member_nick);
		nt.setMember_num(member_num);
		nt.setNote_receiver_num(note_receiver_num);
		nt.setNote_sender_num(note_sender_num);
		
		model.addAttribute("nt", nt);
	}
	@RequestMapping(value = "/member/sendNewNote.do", method = RequestMethod.POST)
	@ResponseBody public HashMap<String, String> sendNewNoteSubmit(Locale locale, Model model, HttpServletRequest request) {
HashMap<String, String> result = new HashMap <String,String>();
		
		int nsn = Integer.parseInt(request.getParameter("nsn"));
		int nrn = Integer.parseInt(request.getParameter("nrn"));
		String noteText = request.getParameter("noteText");
		
		NoteVo nt = new NoteVo();
		
		nt.setNote_receiver_num(nrn);
		nt.setNote_sender_num(nsn);
		nt.setNote_content(noteText);

		int re = dao.sendNewNote(nt);
		
		if ( re > 0) {
			String Msg = "성공";
			String Code = "1";
			
			result.put("Msg", Msg);
			result.put("Code", Code);
			
			return result;
		} else {
			String Msg = "실패";
			String Code = "0";
			
			result.put("Msg", Msg);
			result.put("Code", Code);
			
			return result;
		}
	}
	
	// 보낸 쪽지함에서 쪽지 선택 삭제시, 해당 쪽지의 note_send_visibility를 0으로 변경하여 보낸 쪽지함 목록에서 제외
	@RequestMapping(value = "/hideSendNoteArray.do", method = RequestMethod.POST)
	@ResponseBody
	public int hideSendNoteArray(@RequestParam(value = "checkedArr[]") List<String> chkArr, NoteVo nt) {
		int re = 0;
		int note_num = 0;
		for(String i : chkArr) {
			note_num = Integer.parseInt(i);
			nt.setNote_num(note_num);
			dao.hideSendNoteArray(note_num);
		}
		re = 1;
		return re;		
	}
	
	// 받은 쪽지함에서 쪽지 선택 삭제시, 해당 쪽지의 note_receive_visibility를 0으로 변경하여 받은 쪽지함 목록에서 제외
	@RequestMapping(value = "/hideReceiveNoteArray.do", method = RequestMethod.POST)
	@ResponseBody
	public int hideReceiveNoteArray(@RequestParam(value = "checkedArr[]") List<String> chkArr, NoteVo nt) {
		int re = 0;
		int note_num = 0;
		for(String i : chkArr) {
			note_num = Integer.parseInt(i);
			nt.setNote_num(note_num);
			dao.hideReceiveNoteArray(note_num);
		}
		re = 1;
		return re;		
	}

}