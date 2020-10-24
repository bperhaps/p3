<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="algo.DBUtil"%>
<%@ page import="algo.FileDownloader"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="org.json.simple.parser.JSONParser"%>

<%
	//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
	// 교수 및 관리자 권한 확인
	if((String)session.getAttribute("isProfessor") == "true" || (String)session.getAttribute("isAdmin") == "true");
	else return;
	
	//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
	// 파라미터 추출 및 확인
	JSONObject resultObj = new JSONObject();
	JSONObject resultMainObj = new JSONObject();
	JSONArray resultArray = new JSONArray();
	
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

	String questionIdString = (String)paramObj.get("questionId");
	JSONArray sourceDataArray_json = (JSONArray)paramObj.get("sourceData");
	
	if (questionIdString == null || sourceDataArray_json == null) {
		resultObj.put("result", "잘못된 파라미터입니다.2");
		resultArray.add(0, resultObj);
		resultMainObj.put("result", resultArray);
		out.print(resultMainObj);
		out.close();
		return ;
	}
	int questionId = new Integer(questionIdString).intValue();

	// Box 값 파싱
	ArrayList<String> sourceDataArray = new ArrayList<String>();
	for (int i = 0; i < sourceDataArray_json.size(); i++) {
		JSONObject sourceDataObj = (JSONObject)sourceDataArray_json.get(i);
		sourceDataArray.add((String)sourceDataObj.get("value"));
	}
	
	//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
	// 출제자 확인
	/*
	String studentId = (String)session.getAttribute("studentId");
	if (studentId == null) return;
	
	String sql_userId = "select userId from question where questionId=?";
	
	Connection conn = DBUtil.getMySqlConnection();
	PreparedStatement pstmt = conn.prepareStatement(sql_userId);
	pstmt.setInt(1, questionId);
	
	ResultSet rs = pstmt.executeQuery();
	
	if (rs == null || !rs.next()) {
		if (rs != null)
			DBUtil.close(rs);
		DBUtil.close(pstmt);
		DBUtil.close(conn);
		
		resultObj.put("result", "잘못된 요청입니다.");
		resultArray.add(0, resultObj);
		resultMainObj.put("result", resultArray);
		out.print(resultMainObj);
		out.close();
		return ;
	}
	
	String userId = rs.getString("userId");
	
	DBUtil.close(rs);
	DBUtil.close(pstmt);
	DBUtil.close(conn);
	
	if (!userId.equals(studentId)) {
		resultObj.put("result", "권한이 없습니다.");
		resultArray.add(0, resultObj);
		resultMainObj.put("result", resultArray);
		out.print(resultMainObj);
		out.close();
		return ;
	}
	*/
	
	//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
	// DB 조회
	/*
	String sql_userLog = "select userId, status, language from userLog where questionId=? and logNumber in (select max(logNumber) from userLog where questionId=? group by userId, language) order by userId";	

    pstmt = conn.prepareStatement(sql_userLog);
	pstmt.setInt(1, questionId);
	pstmt.setInt(2, questionId);
    rs = pstmt.executeQuery();
	
	if(rs == null) {
		DBUtil.close(pstmt);
		DBUtil.close(conn);
		return;
	}
	*/
	
	//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
	// 파일 다운로드
	FileDownloader fileDownloader = new FileDownloader();
	
	if (fileDownloader.ready(questionId, sourceDataArray)) {
		fileDownloader.download(response, request);
		fileDownloader.close();
	}
	
%>

