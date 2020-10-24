<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ page import="java.sql.*"%>
<%@ page import="algo.DBUtil"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="org.json.simple.parser.JSONParser"%>
<%@ page import="java.util.*"%>
<%@ page import="algo.GroupManager"%>

<%
	Connection c = DBUtil.getMySqlConnection();
	GroupManager groupManager = new GroupManager(c);
	
	String name = (String)session.getAttribute("name");
	if(name == null) return;
	String studentId = (String)session.getAttribute("studentId");
	if (studentId == null) return ;
	
	JSONObject resultObj = new JSONObject();
	JSONObject resultMainObj = new JSONObject();
	JSONArray resultArray = new JSONArray();
	
	ArrayList<String> selectedDataArray = new ArrayList<String>();
	
	String jsonParam = request.getParameter("jsonParam");
	
	if (jsonParam == null) {
		resultObj.put("result", "잘못된 파라미터입니다.");
		out.print(resultObj);
		out.close();
		return ;
	}
	JSONParser jsonParser = new JSONParser();
	JSONObject paramObj = (JSONObject)jsonParser.parse(jsonParam);
	JSONArray inputData = (JSONArray)paramObj.get("data");
	
	
	if(inputData != null) {
		for (int i = 0; i < inputData.size(); i++) {
			JSONObject inputDataObj = (JSONObject)inputData.get(i);
			selectedDataArray.add((String)inputDataObj.get("data"));
		}
	} else {
		resultObj.put("result", "잘못된 파라미터입니다.1");
		out.print(resultObj);
		out.close();
		return ;
	}
	
	Connection conn = DBUtil.getMySqlConnection();
	
	String sql = "delete from userGroup where studentId=?";
    PreparedStatement pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, Integer.parseInt((String)session.getAttribute("studentId")));
    pstmt.executeUpdate();
	
	for(int i=0; i<selectedDataArray.size(); i++){
		int gnum = Integer.parseInt(selectedDataArray.get(i));
		ArrayList<Integer> cgroup = groupManager.getCgroup(gnum);
			
		try{	
			sql = "insert into userGroup values (?,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, Integer.parseInt((String)session.getAttribute("studentId")));
			pstmt.setInt(2, gnum);

			pstmt.executeUpdate();
			
			Iterator iterator = cgroup.iterator();
			while(iterator.hasNext()){
				sql = "insert into userGroup values(?,?)";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, Integer.parseInt((String)session.getAttribute("studentId")));
				pstmt.setInt(2, ((Integer)iterator.next()).intValue());
				pstmt.executeUpdate();
			}
		} catch (Exception e){}
		
	}
	resultObj.put("result", "done");
		out.print(resultObj);
		out.close();
		return ;
	
	
	
	
%>