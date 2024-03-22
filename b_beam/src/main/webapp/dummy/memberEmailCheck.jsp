<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="app.dao.MemberDao" %>
<%@ page import="app.util.MailSender" %>
<%@page import="java.util.Random"%>
<%
String Email = request.getParameter("memberEmail");
MemberDao md = new MemberDao();
int value = 0;
Random random = new Random();
String authNumber = "";

for(int i=0; i < 6; i++)
{
	authNumber += random.nextInt(10);			
}
MailSender mail = new MailSender();

value = md.memberEmailCheck(Email);
String str = "{\"value\":\""+value+"\"}";
if(value==0){
	String title = "회원가입 인증 메일입니다.";
	String body  = "인증번호 : " + authNumber;
	if(mail.MailSend(Email, title, body)){
		session.removeAttribute("MAIL_NUMBER");
		session.setAttribute("MAIL_NUMBER", authNumber);
		System.out.println("send mail ok");
	}
}
out.print(str);
%>