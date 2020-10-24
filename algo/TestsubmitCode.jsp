<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="algo.Helper"%>
<%@ page import="algo.Compiler"%>
<%@ page import="algo.Executer"%>
<%@ page import="algo.Marker"%>
<%@ page import="java.sql.*"%>
<%@ page import="algo.Util"%>
<%@ page import="algo.DBUtil"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="org.json.simple.parser.JSONParser"%>
<%@ page import="java.util.*"%>

<%
//	String name = (String)session.getAttribute("name");
//	if(name == null) return;
//	String studentId = (String)session.getAttribute("studentId");
//	if (studentId == null) return ;
	
	String name = "testData";
	String deadline=null;
	boolean datecheck=true;
	int limitTime = 2;
	
	JSONObject resultObj = new JSONObject();
	JSONObject resultMainObj = new JSONObject();
	JSONArray resultArray = new JSONArray();
	ArrayList<String> inputDataArray = new ArrayList<String>();
	
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
		return ;
	}
	
	JSONParser jsonParser = new JSONParser();
	JSONObject paramObj = (JSONObject)jsonParser.parse(jsonParam);

	String probNumberString = (String)paramObj.get("probNumber");
	String language = (String)paramObj.get("lang");
	String code = (String)paramObj.get("code");
	String mode = (String)paramObj.get("mode");
	String studentId = (String)paramObj.get("id");
	JSONArray inputData = (JSONArray)paramObj.get("inputData");
	
	if (probNumberString == null || language == null || code == null || mode == null) {
		resultObj.put("result", "잘못된 파라미터입니다.2");
		resultArray.add(0, resultObj);
		resultMainObj.put("result", resultArray);
		out.print(resultMainObj);
		out.close();
		return ;
	}
	int probNumber = new Integer(probNumberString).intValue();

	// 실행일 경우 입력 데이터 파싱
	if (mode.equals("prac")) {
		if(inputData != null) {
			for (int i = 0; i < inputData.size(); i++) {
				JSONObject inputDataObj = (JSONObject)inputData.get(i);
				inputDataArray.add((String)inputDataObj.get("value"));
			}
		}
		else
			inputDataArray.add("");
	}
	//해쉬값 찾다
	String probHash=null;
	
	Connection conn = DBUtil.getMySqlConnection();

    String sql = "select * from question where questionId=?";
    PreparedStatement pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, probNumber);
    ResultSet rs =  pstmt.executeQuery();
	
	if(rs == null)
		return;
	
	if (rs != null && rs.next()){
		probHash = rs.getString("probHash");
		deadline = rs.getString("deadline");
		limitTime = rs.getInt("time");
	}
	java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String today = formatter.format(new java.util.Date());
	
	if(deadline!=null && deadline.compareTo(today)<0)
		datecheck=false;
	
	DBUtil.close(rs);
	DBUtil.close(pstmt);
	
	/***********확장자 부분 ********************/
	String ext=null;
	
	if (language.equals("Java"))
		ext = ".java";
	else if (language.equals("C++"))
		ext = ".cpp";
	else if (language.equals("C"))
		ext = ".c";
	else if (language.equals("Python2"))
		ext = ".py2";
	else if (language.equals("Python3"))
		ext = ".py3";
	else{
		DBUtil.close(conn);
		return;
	}
	/*******************************/
	
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
		
		DBUtil.close(conn);
		return ;
	}
	int userNumber = new Integer(userNumber_str).intValue();
	*/
	int userNumber = new Integer(studentId).intValue();
	// TODO: DB에서 sourceNumber를 얻어야 됨
	int sourceNumber = probNumber;
	//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
	// 준비
	boolean bCreated = false;
	
	if(mode.equals("submit") && datecheck)
		Helper.Savesubmit(userNumber, sourceNumber, code, ext);
	else
		Helper.Saveprac(userNumber, sourceNumber, code, ext);
	
	if (mode.equals("prac"))
		bCreated = Helper.Create(userNumber, sourceNumber, language, inputDataArray, ext);
	else if (mode.equals("submit"))
		bCreated = Helper.Create(userNumber, probHash, sourceNumber, language, ext, datecheck);
		
	

	
	if (!bCreated) {
		resultObj.put("result", "잠시 후 다시 시도해주세요.");
		resultArray.add(0, resultObj);
		resultMainObj.put("result", resultArray);
		out.print(resultMainObj);
		out.close();
		
		DBUtil.close(conn);
		return ;
	}

	int caseNum = Helper.getFileCnt(userNumber, "input");

	// 컴파일
	if (Compiler.Compile(sourceNumber, userNumber, language) != 1) {
		String errorStr = "컴파일 실패.";
		
		String res = Util.ReadFile(userNumber, "errput/compile");
		if (res != null){
			errorStr += "\r\n" + res;
			errorStr = errorStr.replace(" ", "&nbsp");
		}
			
		
		Helper.Remove(userNumber);
		
		if (mode.equals("submit") && datecheck) {
			// UserLog에 기록
			sql = "insert into userLog values(?, ?, ?, Now(), ?, 0, ?, ?, ?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, studentId);
			pstmt.setInt(2, probNumber);
			pstmt.setString(3, "CompileError");
			pstmt.setString(4, language);
			pstmt.setString(5, name);
			pstmt.setInt(6, 0);
			pstmt.setInt(7, caseNum);
			pstmt.executeUpdate();
			
			DBUtil.close(pstmt);
		}
		DBUtil.close(conn);
		
		// 출력
		resultObj.put("result", errorStr);
		resultArray.add(0, resultObj);
		resultMainObj.put("result", resultArray);
		out.print(resultMainObj);
		out.close();
		return ;
	}
	
	// 실행
	int execute_result;
	
	if ((execute_result = Executer.Execute(userNumber, language, limitTime, caseNum)) != 0) {
		String resultStr = "";
		if (execute_result == -1) {
			resultStr = "시간 초과";
			
			if (mode.equals("submit") && datecheck) {
				// UserLog에 기록
				sql = "insert into userLog values(?, ?, ?, Now(), ?, 0, ?, ?, ?)";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, studentId);
				pstmt.setInt(2, probNumber);
				pstmt.setString(3, "TimeOver");
				pstmt.setString(4, language);
				pstmt.setString(5, name);
				pstmt.setInt(6, 0);
				pstmt.setInt(7, caseNum);
				pstmt.executeUpdate();
				
				DBUtil.close(pstmt);
			}
		}
	
		Helper.Remove(userNumber);

		resultObj.put("result", resultStr);
		resultArray.add(0, resultObj);
		resultMainObj.put("result", resultArray);
		out.print(resultMainObj);	
		out.close();
		
		DBUtil.close(conn);
		return ;
	}

	// 결과

	if (mode.equals("prac")) {
		// 결과값 출력
		resultObj.put("result", "result");
		resultArray.add(0, resultObj);

		for (int i = 1; i <= caseNum; i++) {
			resultObj = new JSONObject();
			try{
				resultObj.put("result", Marker.Print(userNumber, i-1, limitTime));
			} catch (StringIndexOutOfBoundsException e){
				resultObj.put("result", "");
			}
			resultArray.add(i, resultObj);
		}
	}
	else if (mode.equals("submit")) {
		// 채점
		resultObj.put("result", "result");
		resultArray.add(0, resultObj);

		String result = "Complete";
		int completeNum = 0;
		
		for (int i = 1; i <= caseNum; i++) {
			String caseResult = Marker.Marking(userNumber, i-1, limitTime);
			if (caseResult.indexOf("맞았습니다") != -1)
				completeNum++;
			else
				result = "Failed";
			
			resultObj = new JSONObject();
			resultObj.put("result", caseResult);	
			resultArray.add(i, resultObj);
		}
		
		// UserLog에 기록
		if(datecheck){
			sql = "insert into userLog values(?, ?, ?, Now(), ?, 0, ?, ?, ?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, studentId);
			pstmt.setInt(2, probNumber);
			pstmt.setString(3, result);
			pstmt.setString(4, language);
			pstmt.setString(5, name);
			pstmt.setInt(6, completeNum);
			pstmt.setInt(7, caseNum);
			pstmt.executeUpdate();
		}
		DBUtil.close(pstmt);
		DBUtil.close(conn);
	}
	
	Helper.Remove(userNumber);
	
	resultMainObj.put("result", resultArray);
	System.out.println(resultMainObj);
	out.print(resultMainObj);
%>

