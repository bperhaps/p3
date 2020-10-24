<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="algo.DBUtil"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.parser.JSONParser"%>

<%
	JSONObject resultObj = new JSONObject();
	
	String requestData = request.getParameter("jsonParam");
	
		
	if(requestData==null){
		resultObj.put("result", "parm error");
		out.print(resultObj);
		out.close();
		return;
	}
	
	JSONParser jsonParser = new JSONParser();	
	JSONObject jsonData = (JSONObject)jsonParser.parse(requestData);
	
	String user_id = (String)jsonData.get("id");
	String password = (String)jsonData.get("password");
	
	if(user_id=="" || password==""){
		resultObj.put("result", "아이디, 패스워드를 확인해주세요");
		out.print(resultObj);
		out.close();
		return;
	}
	
	Connection conn = DBUtil.getMySqlConnection();
	String sql = "select student_id, name, department from kgu_cs_web.students where student_id=? and password=?";
	PreparedStatement pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, user_id);
	pstmt.setString(2, password);
	ResultSet rs = pstmt.executeQuery();
	
	if(rs == null && !rs.next()){
		resultObj.put("result", "conn error");
		out.print(resultObj);
		out.close();
	}
	
	rs.last();
	int count = rs.getRow();
	
	if(count == 0){
		resultObj.put("result", "id, pw를 확인해 주세요");
		out.print(resultObj);
		out.close();
	}	
	rs.first();
	
	session.setAttribute("studentId", rs.getString(1));
	session.setAttribute("name", rs.getString(2));
	session.setAttribute("department", rs.getString(3));
	
	sql = "select userId from superAdmin where userId=?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, user_id);
	rs = pstmt.executeQuery();
	
	if(rs == null && !rs.next()){
		resultObj.put("result", "conn error");
		out.print(resultObj);
		out.close();
	}
	
	rs.last();
	count = rs.getRow();
	
	if(count != 0){
		session.setAttribute("isAdmin", "true");
	}	

	
	sql = "select * from kgu_cs_web.professors where id=?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, user_id);
	rs = pstmt.executeQuery();
	
	if(rs == null && !rs.next()){
		resultObj.put("result", "conn error");
		out.print(resultObj);
		out.close();
	}
	
	rs.last();
	count = rs.getRow();
	
	if(count != 0){
		session.setAttribute("isProfessor", "true");
	}	
	
	sql = "select * from kgu_cs_web.assistants where assistant_id=?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, user_id);
	rs = pstmt.executeQuery();
	
	if(rs == null && !rs.next()){
		resultObj.put("result", "conn error");
		out.print(resultObj);
		out.close();
	}
	
	rs.last();
	count = rs.getRow();
	
	if(count != 0){
		session.setAttribute("isProfessor", "true");
	}	
	
	DBUtil.close(conn);
	
	resultObj.put("result", "done");
	out.print(resultObj);
	out.close();
	
%>
