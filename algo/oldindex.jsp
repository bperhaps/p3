<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="algo.Helper"%>
<%@ page import="algo.Compiler"%>
<%@ page import="algo.Executer"%>
<%@ page import="algo.Marker"%>

<!DOCTYPE html>
<head>
	<title>My JSP Examples</title>
	<link rel="stylesheet" type="text/css" href="lib/codemirror.css"/>
	<script type="text/javascript" src="lib/codemirror.js"></script>
	<script type="text/javascript" src="lib/clike.js"></script>
</head>
<body>
	<form name="mform" method="post" action="submitCode.jsp">
		userNumber : <input type="text" name="userNumber" value="0"> <br>
		probNumber : <input type="text" name="probNumber" value="0"> <br>
		sourceNumber : <input type="text" name="sourceNumber" value="0"> <br>
		language : <input type="text" name="language" value="Java"> <br>
		code : <textarea name="code" id="code"></textarea>
		<script>
			var textarea = document.getElementById('code');
			var editor = CodeMirror.fromTextArea(textarea, {
				lineNumbers: true,
				lineWrapping: true,
				mode: "text/x-csrc"
				/*x-c++src x-java*/
			});
		</script>
		<input type="submit" value="전송">
		<input type="hidden" name="check" value="check">
	</form>
</body>
<%
	if (request.getParameter("check") != null) {
		int userNumber = Integer.parseInt(request.getParameter("userNumber"));
		int probNumber = Integer.parseInt(request.getParameter("probNumber"));
		int sourceNumber = Integer.parseInt(request.getParameter("sourceNumber"));
		String language = request.getParameter("language");

		// 준비
		if (!Helper.Create(userNumber, probNumber, sourceNumber, language)) {
			out.print("잠시 후 다시 시도해주세요<br>");
			out.close();
		}
		
		// 컴파일
		if (Compiler.Compile(sourceNumber, language) != 1) {
			out.print("컴파일 실패<br>");
			
			String res = Helper.ReadFile(sourceNumber, "errput");
			if (res != null)
				out.print(res);
			
			Helper.Remove(sourceNumber);
			out.close();	
		}
		out.print("컴파일 성공<br>");
	
		// 실행 - 매개변수로 실행 시간 넣는 기능 있어야 할 수도 있음
		int execute_result;	
		if ((execute_result = Executer.Execute(sourceNumber, language)) != 0) {
			if (execute_result == -1)
				out.print("틀렸습니다<br>");
			else if (execute_result == -2)
				out.print("시간 초과<br>");
			else if (execute_result == -3) {
				out.print("런타임 에러<br>");

				String res = Helper.ReadFile(sourceNumber, "errput");
				if (res != null)
					out.print(res);
			}
			
			Helper.Remove(sourceNumber);
			
			out.close();
		}
		out.print("실행 성공<br>");
		
		// 채점
		if (Marker.Marking(sourceNumber) == false)
			out.print("틀렸습니다<br>");
		else
			out.print("맞았습니다<br>");
		
		Helper.Remove(sourceNumber);
	}
%>

