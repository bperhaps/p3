<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="algo.Helper"%>
<%@ page import="algo.Compiler"%>
<%@ page import="algo.Executer"%>
<%@ page import="algo.Marker"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="org.json.simple.parser.JSONParser"%>

<%
	JSONObject resultObj = new JSONObject();
	JSONObject resultMainObj = new JSONObject();
	JSONArray resultArray = new JSONArray();
	
	
	String temp;

	//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
	// 파라미터 추출 및 확인
	String jsonParam = request.getParameter("jsonParam");
	if (jsonParam == null) {
		resultObj.put("result", "잘못된 파라미터입니다.1");
		resultArray.add(0, resultObj);
		resultMainObj.put("result", resultArray);
		out.print(resultMainObj);
		out.close();
	}

	JSONParser jsonParser = new JSONParser();	
	JSONObject paramObj = (JSONObject)jsonParser.parse(jsonParam);

	String probNumber_str = (String)paramObj.get("probNumber");
	String language = (String)paramObj.get("lang");
	String code = (String)paramObj.get("code");	
	
	if (probNumber_str == null || language == null || code == null) {
		resultObj.put("result", "잘못된 파라미터입니다.2");
		resultArray.add(0, resultObj);
		resultMainObj.put("result", resultArray);
		out.print(resultMainObj);
		out.close();
	}
	int probNumber = new Integer(probNumber_str).intValue();	

	//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
	// TODO: DB에서 해당 문제의 언어와 일치하는지 확인 해야됨
	// TODO: DB에서 해당 문제에 대한 권한 확인 해야됨
	/*
	String userNumber_str = (String)session.getAttribute("userNumber");
	if (userNumber_str == null) {
		resultObj.put("result", "로그인이 필요합니다.");
		resultArray.add(0, resultObj);
		resultMainObj.put("result", resultArray);
		out.print(resultMainObj);
		
		out.close();
	}
	int userNumber = new Integer(userNumber_str).intValue();
	*/
	int userNumber = 0;
	// TODO: DB에서 sourceNumber를 얻어야 됨
	int sourceNumber = 0;

	//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
	// 준비
	Helper.Save(userNumber, sourceNumber, code);
	
	if (!Helper.Create(userNumber, probNumber, sourceNumber, language)) {
		resultObj.put("result", "잠시 후 다시 시도해주세요.");
		resultArray.add(0, resultObj);
		resultMainObj.put("result", resultArray);
		out.print(resultMainObj);
		out.close();
	}
	
	// 컴파일
	if (Compiler.Compile(sourceNumber, userNumber, language) != 1) {
		String errorStr = "컴파일 실패.";
		
		String res = Helper.ReadFile(userNumber, "errput");
		if (res != null)
			errorStr += "<br>" + res;
		
		Helper.Remove(userNumber);
		
		resultObj.put("result", errorStr);
		resultArray.add(0, resultObj);
		resultMainObj.put("result", resultArray);
		out.print(resultMainObj);
		out.close();	
	}
	
	// 실행
	// TODO: 매개변수로 실행 시간 넣는 기능 있어야 할 수도 있음
	int execute_result;	
	
	if ((execute_result = Executer.Execute(userNumber, language)) != 0) {
		String resultStr = "";
		if (execute_result == -1)
			resultStr = "출력값이 없습니다.";
		else if (execute_result == -2)
			resultStr = "시간 초과";
		else if (execute_result == -3) {
			resultStr = "런타임 에러";

			String res = Helper.ReadFile(userNumber, "errput");
			if (res != null) {
				resultStr += "<br>" + res;
			}
		}	
	
		Helper.Remove(userNumber);
	
		resultObj.put("result", resultStr);
		resultArray.add(0, resultObj);
		resultMainObj.put("result", resultArray);
		out.print(resultMainObj);	
		out.close();
	}
	
	// 채점
	int fileCnt = Helper.getFileCnt(userNumber, "input");
	int test = Helper.getFileCnt(userNumber, "output");
	
	resultObj.put("result", "result");
	resultArray.add(resultObj);

	for(int i=1; i <= fileCnt ; i++){ 
		if (Marker.Marking(userNumber, i-1) == false){
			resultObj = new JSONObject();
			resultObj.put("result", "틀렸습니다");
		}
		else{
			resultObj = new JSONObject();
			resultObj.put("result", "맞았습니다");
		}
		
		resultArray.add(i, resultObj);
	}
	
	Helper.Remove(userNumber);
	
	resultMainObj.put("result", resultArray);
	out.print(resultMainObj);	
%>

