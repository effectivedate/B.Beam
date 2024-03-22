<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="app.util.*" %>
<%@page import="java.util.Random"%>
<%
	String id = request.getParameter("memberId");	
	String email = request.getParameter("memberEmail");
	// id, email를 받아서 일치값이 있는지 찾아봄
	// 없다면 value값을 0으로 보냄
	// 있다면 value값 1을 보내고, 해당 비밀번호를 바꾸는 페이지 링크의 이메일을 보냄
	
	int value = 0;
	if(email.equals("sinukang333@gmail.com")&&id.equals("sinukang321")){
		value = 1;
		MailSender mail = new MailSender();
		TempPwd tp = new TempPwd();
		
		String title = "비밀번호 찾기 관련 메일입니다.";
		String body  = "임시 비밀번호 : " + tp.getTempPassword();
		if(mail.MailSend(email, title, body)){
			System.out.println("send mail ok");
	
		}
	}
	
	
	String str = "{\"value\":\""+value+"\"}";
	out.print(str);
%>
