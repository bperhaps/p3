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
	
	String userId, no;
	no = request.getParameter("no");
	if(no==""){
		return;
	}

	Connection conn = DBUtil.getMySqlConnection();

    String sql_select = "select userId from notice where noticeNumber=?";
    PreparedStatement pstmt = conn.prepareStatement(sql_select);
	pstmt.setString(1, no);
    ResultSet rs =  pstmt.executeQuery();
	
	if(rs == null) {
		return;
	}
	
	if (rs.next()) {
		userId = rs.getString("userId");
		if (!studentId.equals(userId)) {
			return ;
		}
	}
	else {
		return ;
	}
	
	//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
	
	String sql_delete = "delete from notice where noticeNumber=?";
	pstmt = conn.prepareStatement(sql_delete);
	pstmt.setString(1, no);
    pstmt.executeUpdate();
	
	// 출력
	response.sendRedirect("/main/noticeBoard.jsp");
%>