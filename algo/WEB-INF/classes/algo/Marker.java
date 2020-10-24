package algo;

import java.io.*;
import java.util.*;

public class Marker {
	private static final String fileDirFormat = "algo/run/%d/%s/%d";

	public static String Marking(int userNumber, int resultNumber, int limitTime) {
		Scanner scanner_output =  null, scanner_answer = null, scanner_time = null;
		
		String fileDir_output = String.format(fileDirFormat, userNumber, "output", resultNumber);
		String fileDir_answer = String.format(fileDirFormat, userNumber, "answer", resultNumber);
		String fileDir_errput = String.format(fileDirFormat, userNumber, "errput", resultNumber);
		String fileDir_time = String.format(fileDirFormat, userNumber, "time", resultNumber);
		
		long time=0;
		try {
			// 런타임 에러 검사
			File errputFile = new File(fileDir_errput);
			if (errputFile.length() > 0){
				String result="";
				try{
						FileReader FR = new FileReader(errputFile);
						BufferedReader data = new BufferedReader(FR);
					
						while(true){
							String s = data.readLine();
							if(s == null) break;
							result+=s+"<br>";
						}
						result = result.substring(0, result.lastIndexOf("<br>"));
						result = result.replace(" ", "&nbsp");
				} catch( IOException e ) {
						result="";
				}
				return "런타임 에러<br>" + result;
			}
			
			// 시간 검사
			scanner_time = new Scanner(new File(fileDir_time));
			time = scanner_time.nextLong();
			if (time > limitTime*1000)
				return "시간 초과 <small>("+time+"ms)</small>";

			// 결과값 검사
			scanner_output = new Scanner(new File(fileDir_output));
			scanner_answer = new Scanner(new File(fileDir_answer));
			while ( scanner_output.hasNext() && scanner_answer.hasNext() ) {
				String str_output = scanner_output.next();
				String str_answer = scanner_answer.next();

				if (!str_output.equals(str_answer))
					return "틀렸습니다 <small>("+time+"ms)</small>";
			}

			if ( scanner_output.hasNext() || scanner_answer.hasNext() )
				return "틀렸습니다 <small>("+time+"ms)</small>";
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try { if (scanner_output != null) scanner_output.close(); } catch (Throwable ignore) {}
			try { if (scanner_answer != null) scanner_answer.close(); } catch (Throwable ignore) {}
			try { if (scanner_time != null) scanner_time.close(); } catch (Throwable ignore) {}
		}
		
		return "맞았습니다 <small>("+time+"ms)</small>";
	}

	public static String Print(int userNumber, int resultNumber, int limitTime) {
		Scanner scanner_time = null;
		String result = "";
		
		String fileDir_output = String.format(fileDirFormat, userNumber, "output", resultNumber);
		String fileDir_errput = String.format(fileDirFormat, userNumber, "errput", resultNumber);
		String fileDir_time = String.format(fileDirFormat, userNumber, "time", resultNumber);
		
		long time=0;
		try {
			// 런타임 에러 검사
			File errputFile = new File(fileDir_errput);
			if (errputFile.length() > 0){
				result="";
				try{
						FileReader FR = new FileReader(errputFile);
						BufferedReader data = new BufferedReader(FR);
					
						while(true){
							String s = data.readLine();
							if(s == null) break;
							result+=s+"<br>";
						}
						result = result.substring(0, result.lastIndexOf("<br>"));
						result = result.replace(" ", "&nbsp");
				} catch( IOException e ) {
						result="";
				}
				return "런타임 에러<br>"+result;
			}
			
			// 시간 검사
			scanner_time = new Scanner(new File(fileDir_time));
			time = scanner_time.nextLong();
			if (time > limitTime*1000)
				return "시간 초과 <small>("+time+"ms)";

			// 결과값 출력
			FileReader output = new FileReader(new File(fileDir_output));
			BufferedReader data = new BufferedReader(output);
			while ( true ){
				String s = data.readLine();
				if( s == null) break;
				result += s + "<br>";
			}
			result = result.substring(0, result.lastIndexOf("<br>"));
			result = result.replace(" ", "&nbsp");

		} catch (IOException e) {
			result = "Error 관리자에게 문의해주세요.";
		} finally {
			try { if (scanner_time != null) scanner_time.close(); } catch (Throwable ignore) {}
		}
		
		if (result.equals("whoami"))
			result = "made by 민성, 현 from K.knock<br>힘들었지 현아..ㅜㅜ 수고했다 껄껄<br>고생많으셨습니다 횽님 ㅠㅠ 이제 좀 주무세욥!";
		return result+" <small>("+time+"ms)</small>";
	}
}
