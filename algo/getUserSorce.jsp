<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="algo.FileControll"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="org.json.simple.parser.JSONParser"%>

<%

	JSONObject resultObj = new JSONObject();
	String jsonParam = request.getParameter("jsonParam");
	if (jsonParam == null) {
		resultObj.put("result", "잘못된 파라미터입니다.");
		out.print(resultObj);
		out.close();
		return ;
	}
	String id = (String)session.getAttribute("studentId");
	JSONParser jsonParser = new JSONParser();	
	JSONObject paramObj = (JSONObject)jsonParser.parse(jsonParam); 
	
	String probNum = (String)paramObj.get("probNumber");
	String language = (String)paramObj.get("ext");
	String mode = (String)paramObj.get("mode");
	

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
		resultObj.put("result", "파일을 불러오는데 실패했습니다.");
		out.print(resultObj);
		out.close();
	}
	
	try{
		String src = FileControll.getUserSorce(id, Integer.parseInt(probNum), mode, ext);
		resultObj.put("result", src);
		out.print(resultObj);
		out.close();
	} catch(Exception e){
		resultObj.put("result", "파일을 불러오는데 실패했습니다.");
		out.print(resultObj);
		out.close();
	}
%>
