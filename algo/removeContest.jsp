<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="algo.Util"%>
<%@ page import="algo.DBUtil"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="org.json.simple.parser.JSONParser"%>

<%
	if((String)session.getAttribute("isProfessor") == "true" || (String)session.getAttribute("isAdmin") == "true");
	else return;
	
	if(session.getAttribute("name") == null) return;
	String studentId = (String)session.getAttribute("studentId");
	if (studentId == null) return ;
	
	String contestIdStr = request.getParameter("contest");
	if(contestIdStr == null) return;
	int contestId = Integer.parseInt(contestIdStr);

	
	//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
	// 권한 확인
	Connection conn = DBUtil.getMySqlConnection();

    String sql_select = "select userId from contestAdmin where contestId=?";
    PreparedStatement pstmt = conn.prepareStatement(sql_select);
	pstmt.setInt(1, contestId);
    ResultSet rs =  pstmt.executeQuery();
	
	if(rs == null) {
		DBUtil.close(pstmt);
		DBUtil.close(conn);
		return;
	}
	
	boolean bAdmin = false;
	while (rs.next()) {
		String userId = rs.getString("userId");
		if (studentId.equals(userId)) {
			bAdmin = true;
			break;
		}
	}
	
	DBUtil.close(rs);
	DBUtil.close(pstmt);
	
	if (!bAdmin) {
		DBUtil.close(conn);
		return ;
	}	
	
	//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
	// question File Delete
	String sql = "select probHash from question where contestId=?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, contestId);
	rs = pstmt.executeQuery();
	
	if (rs != null) {
		while (rs.next()) {
			String probHash = rs.getString("probHash");
			Util.Exec("rm -rf algo/prob/" + probHash);
		}
		DBUtil.close(rs);
	}
	
	DBUtil.close(pstmt);
	
	// contest DB delete
	String sql_delete = "delete from contest where contestId=?";
	pstmt = conn.prepareStatement(sql_delete);
	pstmt.setInt(1, contestId);
    pstmt.executeUpdate();
	
	DBUtil.close(pstmt);
	
	// question DB delete
	sql_delete = "delete from question where contestId=?";
	pstmt = conn.prepareStatement(sql_delete);
	pstmt.setInt(1, contestId);
    pstmt.executeUpdate();
		
	DBUtil.close(pstmt);
	
	// contestAdmin DB delete
	sql_delete = "delete from contestAdmin where contestId=?";
	pstmt = conn.prepareStatement(sql_delete);
	pstmt.setInt(1, contestId);
    pstmt.executeUpdate();
	
	DBUtil.close(pstmt);
	DBUtil.close(conn);
	
	// 리다이렉트
	response.sendRedirect("/main/contestBoard.jsp");
%>