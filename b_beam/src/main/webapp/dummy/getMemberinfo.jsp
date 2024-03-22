<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String CPwd = request.getParameter("currentPwd");
int value = 0;
if(CPwd != null && CPwd.equals("1234")){
	value = 1;
}
String str = "{\"value\":\""+value+"\"}";
out.print(str);

%>