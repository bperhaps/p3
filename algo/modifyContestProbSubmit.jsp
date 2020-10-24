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

<%!
	private String MD5f( String strVal ){
        StringBuffer sb = new StringBuffer();
        try
        {
                byte[] digest = java.security.MessageDigest.getInstance("MD5").digest( strVal.getBytes() );
                sb.setLength(0);
                for( int i = 0; i < digest.length; i++ ) {
                        sb.append( Integer.toString( ( digest[i] & 0xf0) >> 4, 16 ) );
                        sb.append( Integer.toString( digest[i] & 0x0f, 16 ) );
                }
                return sb.toString();
        }
        catch( Exception ex )
        {
                return null;
        }
	}
%>


<%
if((String)session.getAttribute("isProfessor") == "true" || (String)session.getAttribute("isAdmin") == "true"){
} else return;
	if (session.getAttribute("name")==null) return;
	String studentId = (String)session.getAttribute("studentId");
	if (studentId == null) return ;
	
	JSONObject resultObj = new JSONObject();
	ArrayList<String> inputDataArray = new ArrayList<String>();
	ArrayList<String> outputDataArray = new ArrayList<String>();
	ArrayList<String> inputExamDataArray = new ArrayList<String>();
	ArrayList<String> outputExamDataArray = new ArrayList<String>();
	ArrayList<String> languageArray = new ArrayList<String>();
	//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
	// 파라미터 추출 및 확인
	
	String jsonParam = request.getParameter("jsonParam");
	if (jsonParam == null) {
		resultObj.put("result", "잘못된 파라미터입니다.");
		out.print(resultObj);
		out.close();
		return ;
	}

	JSONParser jsonParser = new JSONParser();	
	JSONObject paramObj = (JSONObject)jsonParser.parse(jsonParam); 

	String probHash = (String)paramObj.get("probHash");
	String context = (String)paramObj.get("context");
	String subject = (String)paramObj.get("subject");
	String displayNone = (String)paramObj.get("displayNone");
	String time = (String)paramObj.get("time");
	String level = (String)paramObj.get("level");
	String groupNum = (String)paramObj.get("groupNum");
	String startDate = (String)paramObj.get("startDate");
	String deadline = (String)paramObj.get("deadline");
	JSONArray inputData = (JSONArray)paramObj.get("inputData");
	JSONArray outputData = (JSONArray)paramObj.get("outputData");
	JSONArray inputExamData = (JSONArray)paramObj.get("inputExamData");
	JSONArray outputExamData = (JSONArray)paramObj.get("outputExamData");	
	JSONArray language = (JSONArray)paramObj.get("language");

	if (context == "" || subject == "" || level == "" ||probHash=="") {
		resultObj.put("result", "잘못된 파라미터입니다.");
		out.print(resultObj);
		out.close();
		return ;
	}
	
	if(language != null) {
		for (int i = 0; i < language.size(); i++) {
				JSONObject languageObj = (JSONObject)language.get(i);
				languageArray.add((String)languageObj.get("language"));
			}
	}
	else{
		resultObj.put("result", "잘못된 파라미터입니다.");
		out.print(resultObj);
		out.close();
		return ;
	}
	
	if(inputData != null) {
			for (int i = 0; i < inputData.size(); i++) {
				JSONObject inputDataObj = (JSONObject)inputData.get(i);
				inputDataArray.add((String)inputDataObj.get("value"));
			}
	}else
		inputDataArray.add("");
	
	if(outputData != null) {
			for (int i = 0; i < outputData.size(); i++) {
				JSONObject outputDataObj = (JSONObject)outputData.get(i);
				outputDataArray.add((String)outputDataObj.get("value"));
			}
	}else
		outputDataArray.add("");
	
	if(inputExamData != null) {
			for (int i = 0; i < inputExamData.size(); i++) {
				JSONObject inputExamDataObj = (JSONObject)inputExamData.get(i);
				inputExamDataArray.add((String)inputExamDataObj.get("value"));
			}
	}else
		inputExamDataArray.add("");
	
	if(outputExamData != null) {
			for (int i = 0; i < inputExamData.size(); i++) {
				JSONObject outputExamDataObj = (JSONObject)outputExamData.get(i);
				outputExamDataArray.add((String)outputExamDataObj.get("value"));
			}
	}else
		outputExamDataArray.add("");
	
	
	//시간설정
	
	java.text.SimpleDateFormat formatter=null;
	Date startDated=null;
	Date deadlined=null;
	java.sql.Timestamp startDateSqld=null;
	java.sql.Timestamp deadlineSqld=null;
	
	if(startDate != null  && deadline != null){
		formatter = new SimpleDateFormat("yyyy-MM-dd'T'hh:mm:ss");
		startDated= (Date)formatter.parse(startDate);
		deadlined= (Date)formatter.parse(deadline);
		
		startDateSqld = new java.sql.Timestamp(startDated.getTime()+((long)1000*60*60*9));
		deadlineSqld = new java.sql.Timestamp(deadlined.getTime()+((long)1000*60*60*9));
		

		
	}
	
	//덮어쓰기...
	FileControll.saveProbInput(inputDataArray, probHash);
	FileControll.saveProbOutput(outputDataArray, probHash);
	FileControll.saveProbExamInput(inputExamDataArray, probHash);
	FileControll.saveProbExamOutput(outputExamDataArray, probHash);
	
	
	//db 연동
    Connection conn = DBUtil.getMySqlConnection();

	String sql = "select questionId from question where probHash=?";
    PreparedStatement pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, probHash);
    ResultSet rs = pstmt.executeQuery();
	
	if(rs.next()&& rs == null)
		return;
	
	int questionId = rs.getInt(1);
	
    sql = "update question set writer=?, subject=?, context=?,probHash=?,displayNone=?,level=?,startdate=?,deadline=?,time=? where questionId=?";
    pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, (String)session.getAttribute("name"));
	pstmt.setString(2, subject);
	pstmt.setString(3, context);
	pstmt.setString(4, probHash);
	pstmt.setString(5, displayNone);
	pstmt.setString(6, level);
	if(startDate == null  && deadline == null){
		pstmt.setNull(7, java.sql.Types.TIMESTAMP);
		pstmt.setNull(8, java.sql.Types.TIMESTAMP);
	} else {
		pstmt.setTimestamp(7,startDateSqld);
		pstmt.setTimestamp(8,deadlineSqld);
	}
	pstmt.setInt(9, Integer.parseInt(time));
	pstmt.setInt(10, questionId);
		
    pstmt.executeUpdate();
	
	
	sql = "delete from language where questionId=?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, questionId);
	pstmt.executeUpdate();
	
	for(int i=0; i<language.size(); i++){
		
		sql = "insert into language values (?, ?)";
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, questionId);
		pstmt.setString(2, (String)languageArray.get(i));
		pstmt.executeUpdate();
	}
	
	DBUtil.close(conn);

	resultObj.put("result", questionId);
	out.print(resultObj);
	out.close();

%>

