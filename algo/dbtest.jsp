<%@page language="java" contentType="test/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="algo.DBUtil"%>
<%@page import="java.sql.*"%>

<!Doctype html>
<%
        Connection conn = DBUtil.getMySqlConnection();

        String sql = "select name from kgu_cs_web.students";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        ResultSet rs =  pstmt.executeQuery();

        while(rs.next()){
                out.println(rs.getString("name"));
        }

%>

<html>
<body>
hello
</body>

</html>

