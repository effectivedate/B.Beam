<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String email = request.getParameter("memberEmail");
	// email를 받아서 일치값이 있는지 찾아봄
	// 없다면 value값을 0으로 보냄
	// 있다면 value값 1, memberId : id값을 보냄
	// 이때 id값은 첫 두글자 글자와, 마지막 두글자를 제외하고 나머지는 *로 만들어서 보냄
	int value = 0;
	String memberId = "";
	String star = "";
	if(email.equals("kangsinu@naver.com")){
		value = 1;
		memberId = "kangsinu";
		for(int i=0; i < (memberId.length() - 4);i++){
			star += "*";
		}
	}
	
	memberId = memberId.substring(0, 2) + star +  memberId.substring(memberId.length()-2, memberId.length());
	String str = "{\"value\" : \""+ value +"\",\"memberId\":\""+memberId+"\"}";
	out.print(str);
%>
