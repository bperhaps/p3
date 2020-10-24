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
	if((String)session.getAttribute("isProfessor") == "true" || (String)session.getAttribute("isAdmin") == "true");
	else return;
	
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
	
	String startTime = (String)paramObj.get("startTime");
	String endTime = (String)paramObj.get("endTime");
	String context = (String)paramObj.get("context");
	String subject = (String)paramObj.get("subject");
	String contestId = (String)paramObj.get("contestId");
	
	if (startTime == null || endTime == null || context == null || subject == null || contestId == null) {
		resultObj.put("result", "error - 잘못된 파라미터입니다.");
		out.print(resultObj);
		out.close();
		return ;
	}
	
	//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
	// 시간 설정
	java.text.SimpleDateFormat formatter=null;
	Date startDate = null;
	Date endDate = null;
	java.sql.Timestamp startDateSql = null;
	java.sql.Timestamp endDateSql = null;
	
	formatter = new SimpleDateFormat("yyyy-MM-dd'T'hh:mm:ss");
	startDate= (Date)formatter.parse(startTime);
	endDate = (Date)formatter.parse(endTime);
		
	startDateSql = new java.sql.Timestamp(startDate.getTime()+((long)1000*60*60*9));
	endDateSql = new java.sql.Timestamp(endDate.getTime()+((long)1000*60*60*9));
	
	//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
	// contest DB update
    Connection conn = DBUtil.getMySqlConnection();

    String sql = "update contest set subject=?, context=?, startTime=?, endTime=? where contestId=?";
    PreparedStatement pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, subject);
	pstmt.setString(2, context);
	pstmt.setTimestamp(3, startDateSql);
	pstmt.setTimestamp(4, endDateSql);
	pstmt.setString(5, contestId);
    pstmt.executeUpdate();
	
	DBUtil.close(pstmt);
	
	// question DB update
    sql = "update question set startdate=?, deadline=? where contestId=?";
    pstmt = conn.prepareStatement(sql);
	pstmt.setTimestamp(1, startDateSql);
	pstmt.setTimestamp(2, endDateSql);
	pstmt.setString(3, contestId);
    pstmt.executeUpdate();
	
	DBUtil.close(pstmt);
	DBUtil.close(conn);
	
	//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
	resultObj.put("result", "done");
	out.print(resultObj);
	out.close();
%>

