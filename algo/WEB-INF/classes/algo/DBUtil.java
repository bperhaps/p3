package algo;

import java.sql.*;

public class DBUtil {

    public static Connection getMySqlConnection(){
	Connection conn = null;

	try {
	    Class.forName("com.mysql.jdbc.Driver");
	    String url ="jdbc:mysql://localhost:3306/algo?useUnicode=true&characterEncoding=UTF-8";
	    String user = "test";
	    String password = "testUser";
	    conn = DriverManager.getConnection(url, user, password);
	} catch (ClassNotFoundException e) {
	    System.out.println("MySqL Driver Not Found<br>");
	} catch (SQLDataException e) {
	    System.out.println("Can't Found DB<br>");
	    } catch(SQLException e) {
					System.out.println("Mysql User Error<br>");
				    } 
	    return conn;

	    }

	    public static void close(Connection conn){
		try {
		    if(conn != null){
			conn.close();
		    }
		} catch (Exception e) {
		    e.printStackTrace();
		}
	    }

	    public static void close(Statement stmt){
		try {
		    if(stmt != null){
			stmt.close();
		    }   
		} catch (Exception e) {
		    e.printStackTrace();
		}
	    }  

	    public static void close(PreparedStatement pstmt){
		try {
		    if(pstmt != null){
			pstmt.close();
		    }   
		} catch (Exception e) {
		    e.printStackTrace();
		}
	    }  
	    public static void close(ResultSet rs){
		try {
		    if(rs != null){
			rs.close();
		    }   
		} catch (Exception e) {
		    e.printStackTrace();
		}
	    }  
	}
