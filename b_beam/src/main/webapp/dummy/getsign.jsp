<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String authNumber = (String)session.getAttribute("MAIL_NUMBER");
	if(authNumber == null) authNumber = "";
	String str = "{\"authNumber\" : \""+ authNumber +"\"}";
	out.print(str);
%>
