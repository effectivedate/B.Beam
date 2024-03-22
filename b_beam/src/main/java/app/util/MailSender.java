package app.util;

import java.util.Properties;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class MailSender 
{
	private String user_email = "bbeam4124@gmail.com";
	private String user_pw = "qfkkumyxydzzmuml";
	private String MailServer = "smtp.gmail.com";   //메일서버
	private int MailPort = 465;	 //메일포트, TLS : 587, SSL:465
	
	
	public boolean MailSend(String to,String title,String body)
	{
		try
		{  
			Properties clsProp = System.getProperties();
			
			// 메일 서버 주소
			clsProp.put( "mail.smtp.host", MailServer );
			
			// 메일 서버 포트 번호
			clsProp.put( "mail.smtp.port", MailPort );			
			
			// 인증이 필요하면 아래와 같이 설정한다.
			clsProp.put("mail.smtp.auth", "true"); 
			clsProp.put("mail.smtp.ssl.enable", "true"); 
			clsProp.put("mail.smtp.ssl.trust", MailServer);			
			
			Session clsSession = Session.getDefaultInstance( clsProp, new Authenticator(){
					public PasswordAuthentication getPasswordAuthentication()
					{
						// 인증 아이디/비밀번호를 저장한다.
						return new PasswordAuthentication( user_email, user_pw );
					}
				} );
			
			MimeMessage clsMessage = new MimeMessage( clsSession );
			
			// 발신자 이메일 주소를 설정한다.
			clsMessage.setFrom( new InternetAddress( user_email ) );
			
			// 수신자 이메일 주소를 설정한다.
			clsMessage.addRecipient( Message.RecipientType.TO, new InternetAddress( to ) );
						
			// 제목을 저장한다.
			clsMessage.setSubject( title );
			
			// 메일 내용을 저장한다. 소스 코드를 euc-kr 로 작성하여서 charset 을 euckr 로 설정함.
			clsMessage.setContent( body , "text/plain;charset=euckr" );
						
			// 메일 전송
			Transport.send( clsMessage );
		}
		catch( Exception e )
		{
			e.printStackTrace();
			return false;
		}		
		return true;
	}
	
	
	public String getTempPassword(int length) {
		int index = 0;
		char[] charArr = new char[] { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z' };

		StringBuffer sb = new StringBuffer();

		for (int i = 0; i < length; i++) {
			index = (int) (charArr.length * Math.random());
			sb.append(charArr[index]);
		}

		return sb.toString();
	}
}