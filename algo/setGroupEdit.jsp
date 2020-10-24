<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="algo.DBUtil"%>
<%@page import="algo.FileControll"%>
<%@page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.parser.JSONParser"%>
<%
if((String)session.getAttribute("isProfessor") == "true" || (String)session.getAttribute("isAdmin") == "true"){
} else return;
	JSONObject resultObj = new JSONObject();
	String jsonParam = request.getParameter("jsonParam");
	if (jsonParam == null) {
		resultObj.put("result", "잘못된 파라미터입니다.");
		out.print(resultObj);
		out.close();
		return ;
	}
	JSONParser jsonParser = new JSONParser();	
	
	JSONObject paramObj = (JSONObject)jsonParser.parse(jsonParam); 
	
	String pgroupNum = (String)paramObj.get("groupid");
	String mode = (String)paramObj.get("mode");
	String name = (String)paramObj.get("name");
	
	if(mode == ""){
		resultObj.put("result", "잘못된 파라미터입니다.1");
		out.print(resultObj);
		out.close();
		return ;
	}
	
	
	
	Connection conn = DBUtil.getMySqlConnection();
	if(mode.equals("add")){
		if(name == ""){
		resultObj.put("result", "잘못된 파라미터입니다1.");
		out.print(resultObj);
		out.close();
		return ;
	}
	
		String sql = "insert into groups values (0,?,?)";
		PreparedStatement pstmt = conn.prepareStatement(sql);
		if(pgroupNum.equals("")){
			pstmt.setNull(1, Types.INTEGER);
		} else {
			pstmt.setInt(1, Integer.parseInt(pgroupNum));
		}
		pstmt.setString(2, name);
		pstmt.executeUpdate();
		
		resultObj.put("result","done");
		out.print(resultObj);
		out.close();
		return ;
	} else if(mode.equals("pop")){
		String sql = "delete from groups where groupNum=?";
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, Integer.parseInt(pgroupNum));
		pstmt.executeUpdate();
		
		resultObj.put("result", "done");
		out.print(resultObj);
		out.close();
		return ;
	} else {
		resultObj.put("result", mode);
		out.print(resultObj);
		out.close();
		return ;
	}

	
 
%>