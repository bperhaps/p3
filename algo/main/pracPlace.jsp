<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="algo.DBUtil"%>
<%@page import="algo.FileControll"%>
<%@page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@include file="include/header.jsp"%>

<%!
public static boolean isNum(String s) {
  try {
      Double.parseDouble(s);
      return true;
  } catch(NumberFormatException e) {
      return false;
  }
}%>

<%
	String probNumber = request.getParameter("prob");
	String probHash=null;
	String subject=null;
	String context=null;
	String writer=null;
	String userId=null;
	String deadline=null;
	String contestId = null;
	String displayNone = null;
	
	if(!isNum(probNumber)){
		response.sendRedirect("/main/pracBoard.jsp");
		return;
	}
	
	//db 연동
    Connection conn = DBUtil.getMySqlConnection();

    String sql = "select * from question where questionId=?";
    PreparedStatement pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, probNumber);
    ResultSet rs =  pstmt.executeQuery();
	
	if(rs == null)
		return;
	
	rs.last();
	if(rs.getRow()==0){
		response.sendRedirect("/main/pracBoard.jsp");
		return;
	}
	rs.beforeFirst();
	
	if (rs != null && rs.next()){
		probHash = rs.getString("probHash");
		subject = rs.getString("subject");
		context = rs.getString("context");
		writer = rs.getString("writer");
		userId = rs.getString("userId");
		deadline = rs.getString("deadline");
		contestId = rs.getString("contestId");
		displayNone = rs.getString("displayNone");
	}
	
	if (displayNone.equals("true")) {
		if((String)session.getAttribute("isProfessor") == "true" || (String)session.getAttribute("isAdmin") == "true");
		else return;
	}
	
	sql = "select * from language where questionId=?";
    pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, probNumber);
    rs =  pstmt.executeQuery();
	
	if(rs == null)
		return;
	
	ArrayList<String> langArray = new ArrayList<String>();
	while(rs.next()){
		langArray.add(rs.getString("language"));
	}
	
	int groupNum=-1;
	
	sql = "select * from probGroup where questionId=? order by groupNum desc limit 1";
    pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, probNumber);
    rs =  pstmt.executeQuery();
	
	if(rs == null)
		return;
	rs.last();
	if(rs.getRow() != 0){
		rs.first();
		groupNum = rs.getInt("groupNum");
	}
	
	
	DBUtil.close(rs);
	DBUtil.close(pstmt);
	DBUtil.close(conn);
	
	//데이터 가져오기
	ArrayList<String> input = FileControll.getProbInputExam(probHash);
	ArrayList<String> output = FileControll.getProbOutputExam(probHash);
	
%>

  <input type="hidden" id="probHash" value="<%=probHash%>">
 		<div class="content-wrapper">
			<!-- Content Header (Page header) -->
			<!-- Content Header (Page header) -->
			<section class="content-header">
				<h1>
					<%=subject%>
				</h1>
				<% groupManager.getGroupPath(out, groupNum); %>
			</section>

			<!-- Main content -->
			<section class="content container-fluid algo-css">

				<article class="problem">
					<div class="box">
						<div class="box-header">
							<h3 class="box-title">문제 설명</h3>
							<%if(((String)session.getAttribute("studentId")).equals(userId)){%>
								<div class="btn-group pull-right">
								<button type="button" class="btn btn-default btn-flat pull-right" id="delete" style="margin-right: 5px">삭제</button>
								</div>
								<div class="btn-group pull-right">
								<% if (contestId == null) { %>
									<button type="button" class="btn btn-default btn-flat pull-right" style="margin-right: 5px" onclick="location.href='./modifyProb.jsp?prob=<%=probNumber%>'">수정</button>
								<% } else { %>
									<button type="button" class="btn btn-default btn-flat pull-right" style="margin-right: 5px" onclick="location.href='./modifyContestProb.jsp?prob=<%=probNumber%>'">수정</button>
								<% } %>
								</div>
							<%}	%>
						</div>
						<div class="box-body table-responsive pad">
							<p>
								<%=context%>
							</p>

							<table class="table table-bordered">
							<tr>
									<th>Input</th>
									<th>Output</th>
								</tr>
							<%
								Iterator ind = input.iterator();
								Iterator outd = output.iterator();
								while(ind.hasNext() && outd.hasNext()){
								out.println("<tr><td>"+(String)ind.next()+"</td><td>"+(String)outd.next()+"</td></tr>");
								}
							%>
							</table>
						</div>
					</div>

				</article>
				<article>
					
					<div class="box box-primary">
						<div class="box-header">
							<i class="fa fa-edit"></i>
							<h3 class="box-title">코드 에디터</h3>
							
							<div class="btn-group lang pull-right">
								
								
								<button type="button" class="btn btn-default selectedlang"><%=langArray.get(0)%></button>			
								<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown"><span class="caret"></span></button>
								
								<ul class="dropdown-menu" role="menu">
								<%
									for(int i=0; i<langArray.size(); i++){
										if(langArray.get(i).equals("C++")){
											out.print("<li><a class=\"Cpp\">C++</a></li>");
											continue;
										}
										out.print("<li><a class=\""+langArray.get(i)+"\">"+langArray.get(i)+"</a></li>");
									}
								%>
								</ul>
							</div>
							<button type="button" class="btn btn-default btn-flat pull-right getSorce" style="margin-right: 5px" id="submit" >마지막 제출 소스 가져오기</button>
							<button type="button" class="btn btn-default btn-flat pull-right getSorce" style="margin-right: 5px" id="prac" >마지막 실행 소스 가져오기</button> 
						</div>
						<div class="box-body pad table-responsive code">
							<textarea id="editor"></textarea>		
<div class="overlay" style="display:none">
						<i class="fa fa-refresh fa-spin"></i>
					</div>									
						</div>
			
					</div>

				</article>
				<article class="col-md-6">
					<div class="box">
						<div class="box-header">
							<i class="fa fa-edit"></i>
							<h3 class="box-title">입력값</h3>
							<button type="button" class="btn btn-default" style="float:right" onclick="testInput_plus()"><i class="fa fa-plus"></i></button>
						</div>
							<div class="box-body pad table-responsive">
							<table class="table table-bordered testInput-box">
								<tr>
									<th>Input</th>
									<th style="width:50px; text-align:center">M</th>
								</tr>
							</table>
							</div>
							<div class="overlay" style="display:none">
								<i class="fa fa-refresh fa-spin"></i>
							</div>
					</div>
				</article>
				<article class="col-md-6">
					<div class="box">
						<div class="box-header">
							<i class="fa fa-edit"></i>
							<h3 class="box-title">결과창</h3>
							<%
								java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
								String today = formatter.format(new java.util.Date());
								
								if(deadline!=null && deadline.compareTo(today)<0) {%>
									<br><small>기한이 지난 문제는 제출해도 저장되지 않습니다.</small>
								<%}%>
							<button type="button" class="btn btn-default btn-flat" style="float:right" id="checker" >제출</button>

							<button type="button" class="btn btn-default btn-flat" style="float:right; margin-right: 5px" id="sender" >실행</button> 

							</div>
							<div class="box-body pad table-responsive">
								<pre class="result"></pre>
							</div>
					<div class="overlay" style="display:none">
						<i class="fa fa-refresh fa-spin"></i>
					</div>		
					</div>
					
				</article>

				
			</section>
			<!-- /.content -->
		</div>

		
		<script>
			var textarea = document.getElementById('editor');
			var editor = CodeMirror.fromTextArea(textarea, {
				mode: "text/x-csrc",
				lineNumbers: true,
				lineWrapping: true,
				indentWithTabs: true,
				indentUnit: 4,
				theme: "base16-dark",
				styleActiveLine: true,
				matchBrackets: true,
			});
			
			
		//언어설정

		if($(".selectedlang").text() == "C") {
			editor.setOption("mode", "text/x-csrc");
		}
		
		if($(".selectedlang").text() == "C++"){
			editor.setOption("mode", "text/x-c++src");
		}
		
		if($(".selectedlang").text() == "Java"){
			editor.setOption("mode", "text/x-java");
		}
		
		if($(".selectedlang").text() == "Python2"){
			var mode = {
				name: "python",
				version: 2, 
				singleLinesStringErrors: false
			};
			editor.setOption("mode", mode);
		}
		if($(".selectedlang").text() == "Python3") {
			var mode = {
				name: "python",
				version: 3,
				singleLinesStringErrors: false
			};
			editor.setOption("mode", mode);
		}

				
		</script>
 <%@include file="include/footer.jsp"%>
