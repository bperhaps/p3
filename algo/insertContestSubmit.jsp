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
	
	if (startTime == null || endTime == null || context == null || subject == null) {
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
	// contest DB insert
    Connection conn = DBUtil.getMySqlConnection();

    String sql = "insert into contest values (0, ?, ?, ?, ?)";
    PreparedStatement pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, subject);
	pstmt.setString(2, context);
	pstmt.setTimestamp(3, startDateSql);
	pstmt.setTimestamp(4, endDateSql);
    pstmt.executeUpdate();
	
	DBUtil.close(pstmt);
	
	// contest DB select 
	sql = "select contestId from contest where subject=? and context=? order by contestId desc";
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, subject);
	pstmt.setString(2, context);
    ResultSet rs = pstmt.executeQuery();
	
	if (rs == null || !rs.next()) {
		if (rs != null)
			DBUtil.close(rs);
		DBUtil.close(pstmt);
		DBUtil.close(conn);
	
		resultObj.put("result", "error - DB 오류");
		out.print(resultObj);
		out.close();
	}
	
	int contestId = rs.getInt("contestId");
	
	DBUtil.close(rs);
	DBUtil.close(pstmt);
	
	// contestAdmin DB insert
    sql = "insert into contestAdmin values (?, ?)";
    pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, contestId);
	pstmt.setString(2, studentId);
    pstmt.executeUpdate();
	
	DBUtil.close(pstmt);
	DBUtil.close(conn);
	
	resultObj.put("result", "done");
	out.print(resultObj);
	out.close();
%>

