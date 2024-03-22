<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="app.dao.MemberDao" %>
<%
String nick = request.getParameter("memberName");
MemberDao md = new MemberDao();
int value = 0;
md.memberNicknameCheck(nick);
String str = "{\"value\":\""+value+"\"}";
out.print(str);
%>