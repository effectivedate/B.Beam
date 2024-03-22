<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="app.dao.MemberDao" %>
<%
String id = request.getParameter("memberId");
MemberDao md = new MemberDao();
int value = 0;
value = md.memberIdCheck(id);
System.out.println(value);
String str = "{\"value\":\""+value+"\"}";
out.print(str);
%>