<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="org.json.simple.parser.JSONParser"%>
<%@ page import="java.util.*"%>
<%@ page import="algo.FileControll"%>
<%@ page import="java.security.MessageDigest"%>
<%@ page import="java.text.*"%>
<%@page import="algo.DBUtil"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>

<%
if((String)session.getAttribute("isProfessor") == "true" || (String)session.getAttribute("isAdmin") == "true"){
} else return;
	String userName = (String)session.getAttribute("name");
	String studentId = (String)session.getAttribute("studentId");
	if (userName == null || studentId == null) return ;
	
	JSONObject resultObj = new JSONObject();
	
	//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
	// 파라미터 추출 및 확인
	String jsonParam = request.getParameter("jsonParam");
	if (jsonParam == null) {
		resultObj.put("result", "error - 잘못된 파라미터입니다.");
		out.print(resultObj);
		out.close();
		return ;
	}

	JSONParser jsonParser = new JSONParser();	
	JSONObject paramObj = (JSONObject)jsonParser.parse(jsonParam); 

	String context = (String)paramObj.get("context");
	String subject = (String)paramObj.get("subject");
	String no = (String)paramObj.get("no");
	if (context == "" || subject == "" || no == "") {
		resultObj.put("result", "error - 잘못된 파라미터입니다.");
		out.print(resultObj);
		out.close();
		return ;
	}
	
	// DB 연동
    Connection conn = DBUtil.getMySqlConnection();

    String sql = "update notice set subject=?, context=? ,date=NOW() where noticeNumber=?";
    PreparedStatement pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, subject);
	pstmt.setString(2, context);
	pstmt.setString(3, no);
    pstmt.executeUpdate();

	DBUtil.close(pstmt);
	DBUtil.close(conn);
	
	resultObj.put("result", "done");
	out.print(resultObj);
	out.close();
%>

