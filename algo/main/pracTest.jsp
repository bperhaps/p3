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
	String probHash=null;
	String subject=null;
	String context=null;
	String writer=null;
	String userId=null;
	String deadline=null;

	//db 연동
    Connection conn = DBUtil.getMySqlConnection();

    String sql = "select * from question where questionId=136";
    PreparedStatement pstmt = conn.prepareStatement(sql);
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
		deadline = rs.getString("deadline");
	}
	
	sql = "select * from language where questionId=136";
    pstmt = conn.prepareStatement(sql);
    rs =  pstmt.executeQuery();
	
	if(rs == null)
		return;
	
	ArrayList<String> langArray = new ArrayList<String>();
	while(rs.next()){
		langArray.add(rs.getString("language"));
	
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
					프로그래밍 테스트 페이지
				</h1>
			</section>

			<!-- Main content -->
			<section class="content container-fluid algo-css">

				<article class="problem">
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
							<button type="button" class="btn btn-default btn-flat pull-right test_getSorce" style="margin-right: 5px" id="prac" >마지막 실행 소스 가져오기</button> 
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
							<button type="button" class="btn btn-default btn-flat" style="float:right; margin-right: 5px" id="test_sender" >실행</button> 

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
			
			
		
			
			
		$("#test_sender").click(function() {
        var url = "../submitCode.jsp";
        var params = new Object();
	
        if ($("textarea[name=testInput_data]").length)
            params.inputData = $("textarea[name=testInput_data]").serializeArray();
        params.probNumber = "136";
        params.code = editor.getValue().replaceAll("\n", "\r\n");
        params.lang = $(".selectedlang").text();
        params.probHash = $("#probHash").val();
        params.mode = "prac";

		
        var jsonData = JSON.stringify(params);
        console.log(jsonData);

        $.ajax({
            type: "POST",
            url: url,
            dataType: "json",
            data: {
                jsonParam: jsonData
            },
            beforeSend: function() {
				for(var i=0; i<$(".overlay").length; i++)
					$(".overlay").eq(i).css("display", "table-cell");
            },
            success: function(args) {
                console.log(args);
                var result = "";
                if (args.result[0].result != "result") {
                    $(".result").html(args.result[0].result);
                } else {
                    if ($("textarea[name=testInput_data]").length==0){
                        $(".result").html(args.result[1].result);
					} else {
                        for (var i = 1; i < args.result.length; i++) {
                            result += (i) + "번째 케이스 : " + args.result[i].result + "<br>";
                        }
                        $(".result").html(result);
                    }
                }
            },
            error: function(e) {
                alert(e.responseText);
            },
            complete: function() {
				for(var i=0; i<$(".overlay").length; i++)
					$(".overlay").eq(i).hide();
            }
        });
    });	
			
			
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
		
		 $(".test_getSorce").click(function() {
        var url = "../getUserSorce.jsp";
        var params = new Object();

        params.probNumber = "136";
        params.ext = $(".selectedlang").text();
		params.mode = $(this).attr("id");
        var jsonData = JSON.stringify(params);
		console.log(jsonData);
        $.ajax({
            type: "POST",
            url: url,
            dataType: "json",
            data: {
                jsonParam: jsonData
            },
            beforeSend: function() {
				for(var i=0; i<$(".overlay").length; i++)
					$(".overlay").eq(i).css("display", "table-cell");
            },
            success: function(args) {
               editor.getDoc().setValue(args.result);
            },
            error: function(e) {
                alert(e.responseText);
            },
            complete: function() {
				for(var i=0; i<$(".overlay").length; i++)
					$(".overlay").eq(i).hide();
            }
        });	
		 });
		</script>
 <%@include file="include/footer.jsp"%>


