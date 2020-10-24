<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="algo.urlHandler"%>
<%@page import="algo.DBUtil"%>
<%@page import="java.sql.*"%>
<%@include file="include/header.jsp"%>

<%!
	public static boolean isNum(String s) {
		try {
			Double.parseDouble(s);
			return true;
		} catch(NumberFormatException e) {
			return false;
		}
	}
%>
<%
if((String)session.getAttribute("isProfessor") == "true" || (String)session.getAttribute("isAdmin") == "true"){
} else return;

	int contentView = 15;
	int pageNum;
	int pageLength=3;
	int dataRow;
	int pageLengthStart;
	int allPageLength;
	int allDataNum;
	
	//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
	//page가 정수인지 판별
	if(request.getParameter("page") == null || !isNum(request.getParameter("page")) || Integer.parseInt(request.getParameter("page")) <=0) 
		pageNum = 1;
	else
		pageNum = Integer.parseInt(request.getParameter("page"));

	Connection conn = DBUtil.getMySqlConnection();
	String sql = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
	
	// 매개변수
	String questionIdString = request.getParameter("prob");
	int questionId=0;
	if (questionIdString == null) return ;
	try{
		questionId = Integer.parseInt(questionIdString);
	} catch(Exception e){
		return;
	}
	

	
	// question DB 조회
	sql = "select subject from question where questionId=?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, questionId);
	rs = pstmt.executeQuery();
	
	if (rs == null || !rs.next()) {
		if (rs != null)
			DBUtil.close(rs);
		DBUtil.close(pstmt);
		DBUtil.close(conn);
		return ;
	}
	
	String questionSubject = rs.getString("subject");
	//언어
	sql = "select * from language where questionId=?";
    pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, questionIdString);
    rs =  pstmt.executeQuery();
	
	if(rs == null)
		return;
	
	ArrayList<String> langArray = new ArrayList<String>();
	while(rs.next()){
		langArray.add(rs.getString("language"));
	}
	//매개변수
	String lang = request.getParameter("lang");
	String langSql = "";
	if (lang != null){
		if(!langArray.contains(lang)){
				lang = langArray.get(0);
		} 
		
		langSql = "and language='"+lang+"'";
	}
	out.print(langSql);
	DBUtil.close(rs);
	DBUtil.close(pstmt);
	
	//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
	// userLog DB 조회
	String allDataSql=null;
	String search = request.getParameter("search");
	String category = request.getParameter("category");

	if(search != null && category != null){
		if(category.equals("studentId")){
			sql = "select * from userLog where logNumber in (select max(logNumber) from userLog where questionId=? "+langSql+" group by userId, language) and userId like ? order by logNumber desc";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, questionId);
			pstmt.setString(2, "%" + search + "%");

		}
		else if(category.equals("status")){
			sql = "select * from userLog where logNumber in (select max(logNumber) from userLog where questionId=? "+langSql+" group by userId, language) and status like ? order by logNumber desc";		
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, questionId);
			pstmt.setString(2, "%" + search + "%");

		}
		else if(category.equals("userName")){
			sql = "select * from userLog where logNumber in (select max(logNumber) from userLog where questionId=? "+langSql+" group by userId, language) and userName like ? order by logNumber desc";		
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, questionId);
			pstmt.setString(2, "%" + search + "%");

		}
		else if(category.equals("status")){
			sql = "select * from userLog where logNumber in (select max(logNumber) from userLog where questionId=? "+langSql+" group by userId, language) and status = ? order by logNumber desc";		
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, questionId);
			pstmt.setString(2,  search);

		}
		else if(category.equals("language")){
			sql = "select * from userLog where logNumber in (select max(logNumber) from userLog where questionId=? "+langSql+" group by userId, language) and language = ? order by logNumber desc";		
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, questionId);
			pstmt.setString(2, search);

		}
		else{
			sql = "select * from userLog where logNumber in (select max(logNumber) from userLog where questionId=? "+langSql+" group by userId, language) order by logNumber desc";		
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, questionId);

		}
		
    } else {
		sql = "select * from userLog where logNumber in (select max(logNumber) from userLog where questionId=? "+langSql+" group by userId, language) order by logNumber desc";
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, questionId);
	}

	rs = pstmt.executeQuery();
	
	if (rs == null) {
		out.print("error");
		return ;
	}
	
	

	// 시간
%>


  <!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
      <h1>
        풀이 현황
        <small>해당 문제를 푼 사람들입니다.</small>
      </h1>

    </section>

    <!-- Main content -->
    <section class="content container-fluid">

     <div class="col-md-12">
          <div class="box box-primary">
            <div class="box-header with-border">
              <h3 class="box-title"><%= questionSubject %></h3>
				
              <div class="box-tools pull-right">
           
                <div class="has-feedback">
					<form class="form-search">
						<input type="hidden" name="prob" class="form-control" value="<%= questionId %>">
						<table>
						<tr><td>
						<div class="btn-group">
						<ul class="dropdown-menu">
							<li><a class="category-userName">이름</a></li>
							<li><a class="category-studentId">학번</a></li>
							<li><a class="category-status">상태</a></li>
							<li><a class="category-lang">언어</a></li>
						</ul>
						<button type="button" class="btn btn-default selected_category" data-toggle="dropdown">이름
							<span class="fa fa-caret-down"></span></button>
						<input name="category" type="hidden" class="form-control input-search-category" value="userName">
						</div>
						</td>

						<td class="searchWrap">
							<input type="text" name="search" style="width:150px" class="form-control" placeholder="Search...">
						</td>
						<td class="statusWrap" style="display:none">
						<div class="btn-group">
							<ul class="dropdown-menu">
							<li><a class="status-nomal" value="">전체</a></li>
							<li><a class="status-Complete" value="Complete">Complete</a></li>
							<li><a class="status-CompileError" value="CompileError">CompileError</a></li>
							<li><a class="status-TimeOver" value="TimeOver">TimeOver</a></li>
							<li><a class="status-Failed" value="Failed">Failed</a></li>
						</ul>
						
						<button type="button" class="btn btn-default selected_status" data-toggle="dropdown">상태선택
							<span class="fa fa-caret-down"></span></button>
						</div>
						</td>
						<td class="langWrap" style="display:none">
						<div class="btn-group">
							<ul class="dropdown-menu" role="menu">
							<li><a class="search-nomal" value="">전체</a></li>
							<%
									for(int i=0; i<langArray.size(); i++){
										if(langArray.get(i).equals("C++")){
											out.print("<li><a class=\"search-Cpp\">C++</a></li>");
											continue;
										}
										out.print("<li><a class=\"search-"+langArray.get(i)+"\">"+langArray.get(i)+"</a></li>");
									}
								%>
							</ul>
							<button type="button" class="btn btn-default selected_lang" data-toggle="dropdown">언어선택
							<span class="fa fa-caret-down"></span></button>
						</div>
						</td>
						<td>
							<button type="submit" id="search-btn" class="btn btn-flat"><i class="fa fa-search"></i></button>
						</td>
						
						</tr>
	
						</table> 

					</form>
                </div>
              </div>
              <!-- /.box-tools -->
            </div>
            <!-- /.box-header -->
            <div class="box-body no-padding">
              <div class="mailbox-controls">
                <!-- Check all button -->
				
                <button type="button" class="btn btn-default btn-sm checkbox-toggle" id="allChecker" value="true"><i class="fa fa-square-o"></i>
                </button>
                <!-- /.btn-group -->
                <button type="button" class="btn btn-default btn-sm" onclick="location.reload()"><i class="fa fa-refresh"></i></button>
				
              </div>
              <div class="table-responsive mailbox-messages">
                <table class="table table-hover table-striped">
                  <tbody style="text-align:center">
					  <tr>
						<td style="width:20px">선택</td>
						<td style="width:75px"><b>이름<b></td>
						<td style="width:60px"><b>학번<b></td>
						<td style="width:60px"><b>상태<b></td>
						<td style="width:60px"><b>제출 시간<b></td>
						<td style="width:60px"><b>언어<b></td>
						<td style="width:60px"><b>맞춘 케이스 / 전체 케이스<b></td>
					  </tr>
					  <% while (rs.next()) {
						  String boxValue = rs.getString("userId") + ";" + rs.getString("status") + ";" +rs.getString("language");
						  String date = rs.getString("date");
						  date = date.substring(0, date.lastIndexOf("."));
					  %>
					  <tr>
						<td><input type="checkbox" name="source" value="<%= boxValue %>"></td>
						<td class="mailbox-name downloadBtn" name = "<%= boxValue %>" style="cursor:pointer"><%= rs.getString("userName") %></td>
						<td class="mailbox-subject"><%= rs.getString("userId") %></td>
						<td><%= rs.getString("status") %></td>
						<td><%= date %></td>
						<td><%= rs.getString("language") %></td>
						<td><%= rs.getInt("completeCaseNum") %> / <%= rs.getInt("caseNum") %></td>
					  </tr>
					  <% } %>
                  </tbody>
                </table>
                <!-- /.table -->
              </div>
              <!-- /.mail-box-messages -->
            </div>
            <!-- /.box-body -->
            <div class="box-footer no-padding">
              <div class="mailbox-controls" style="text-align:center">

                  <div class="btn-group">
				  <input type="hidden" id="questionId" value="<%= questionId %>">
				  <button type="button" class="btn btn-default btn-flat downloadBtn"  style="float:right; margin-bottom: 5px" >선택 다운로드</button>
				  <button type="button" class="btn btn-default btn-flat" id="downloadAllBtn" style="float:right; margin-bottom: 5px; margin-right: 5px" >전체 다운로드</button>
              </div>
			  <form name="downForm">
				<input type="hidden" name="jsonParam" value="">
			  </form>
            </div>
          </div>
          <!-- /. box -->
        </div>

    </section>
    <!-- /.content -->
  </div>
  <!-- /.content-wrapper -->

  <script>
  
  $(document).ready(function() {
    $(".C").click(function() {
        editor.setOption("mode", "text/x-csrc");
        $(".selectedlang").text("C");

    });
    $(".Cpp").click(function() {
        editor.setOption("mode", "text/x-c++src");
        $(".selectedlang").text("C++");

    });
    $(".Java").click(function() {
        editor.setOption("mode", "text/x-java");
        $(".selectedlang").text("Java");

    });
    $(".Python2").click(function() {
        var mode = {
            name: "python",
            version: 2,
            singleLinesStringErrors: false
        };
        editor.setOption("mode", mode);
        $(".selectedlang").text("Python2");

    });
    $(".Python3").click(function() {
        var mode = {
            name: "python",
            version: 3,
            singleLinesStringErrors: false
        };
        editor.setOption("mode", mode);
        $(".selectedlang").text("Python3");

    });
});

  </script>


 <%@include file="include/footer.jsp"%>
