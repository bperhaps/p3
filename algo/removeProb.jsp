<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="algo.Util"%>
<%@ page import="algo.DBUtil"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="org.json.simple.parser.JSONParser"%>

<%
if((String)session.getAttribute("isProfessor") == "true" || (String)session.getAttribute("isAdmin") == "true"){
} else return;
	if(session.getAttribute("name") == null) return;
	String studentId = (String)session.getAttribute("studentId");
	if (studentId == null) return ;
	
	JSONObject resultObj = new JSONObject();
	JSONObject resultMainObj = new JSONObject();
	JSONArray resultArray = new JSONArray();
	ArrayList<String> inputDataArray = new ArrayList<String>();
	
	//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
	// 파라미터 추출 및 확인
	String jsonParam = request.getParameter("jsonParam");
	if (jsonParam == null) {
		resultObj.put("result", "잘못된 파라미터입니다.1");
		out.print(resultObj);
		out.close();
		return ;
	}
	
	JSONParser jsonParser = new JSONParser();	
	JSONObject paramObj = (JSONObject)jsonParser.parse(jsonParam); 

	String questionIdString = (String)paramObj.get("questionId");
	if (questionIdString == null) {
		resultObj.put("result", "잘못된 파라미터입니다.2");
		out.print(resultObj);
		out.close();
		return ;
	}
	int questionId = new Integer(questionIdString).intValue();

	//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
	// 권한 확인 및 DB 조회
	String userId, probHash;
	String contestId;

	Connection conn = DBUtil.getMySqlConnection();

    String sql_select = "select probHash, userId, contestId from question where questionId=?";
    PreparedStatement pstmt = conn.prepareStatement(sql_select);
	pstmt.setInt(1, questionId);
    ResultSet rs =  pstmt.executeQuery();
	
	if(rs == null) {
		resultObj.put("result", "잘못된 요청입니다.1");
		out.print(resultObj);
		out.close();
		return ;
	}
	
	if (rs.next()) {
		userId = rs.getString("userId");
		probHash = rs.getString("probHash");
		contestId = rs.getString("contestId");
		
		if (!studentId.equals(userId)) {
			resultObj.put("result", "권한이 없습니다.");
			out.print(resultObj);
			out.close();
			return ;
		}
	}
	else {
		resultObj.put("result", "잘못된 요청입니다.2");
		out.print(resultObj);
		out.close();
		return ;
	}
	
	//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
	// 문제 폴더 삭제 - algo/prob/probHash
	Util.Exec("rm -rf algo/prob/" + probHash);
	
	// DB 해당 data 삭제
	String sql_delete = "delete from question where probHash=? and questionId=?";
	pstmt = conn.prepareStatement(sql_delete);
	pstmt.setString(1, probHash);
	pstmt.setInt(2, questionId);
    pstmt.executeUpdate();
	
	// 출력
	resultObj.put("result", "삭제되었습니다.");
	if (contestId == null)
		resultObj.put("href", "/main/pracBoard.jsp");
	else
		resultObj.put("href", "/main/contestView.jsp" + "?contest=" + contestId);
	out.print(resultObj);
	out.close();
%>