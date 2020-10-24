<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="algo.DBUtil"%>
<%@ page import="algo.FileControll"%>
<%@ page import="algo.GroupManager"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@include file="include/header.jsp"%>

<%
	if((String)session.getAttribute("isProfessor") == "true" || (String)session.getAttribute("isAdmin") == "true");
	else return;
	
	
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
<script src="./bower_components/ckeditor/ckeditor.js"></script>
<script src="./bower_components/select2/dist/js/select2.full.min.js"></script>
<script src="./plugins/iCheck/icheck.min.js"></script>
<script src="./bower_components/moment/min/moment.min.js"></script>
<script src="./bower_components/bootstrap-daterangepicker/daterangepicker.js"></script>
  
<link rel="stylesheet" href="./bower_components/bootstrap-daterangepicker/daterangepicker.css">
<link rel="stylesheet" href="./bower_components/select2/dist/css/select2.min.css">
<link rel="stylesheet" href="./plugins/iCheck/all.css">  

<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
	<!-- Content Header (Page header) -->
	<section class="content-header">
	<h1>
	문제 등록 <small>새 문제를 등록하는 곳 입니다.</small>
	</h1>
	
	</section>
	<!-- Main content -->
	<section class="content container-fluid algo-css">
	<article>
	<div class="box">
		<div class="box-header">
			<i class="fa fa-edit"></i>
			<h3 class="box-title">문제 설정</h3>
			<div class="pull-right box-tools">
				<button type="button" class="btn btn-sm" data-widget="collapse" data-toggle="tooltip" title="Collapse">
				<i class="fa fa-minus"></i></button>
			</div>
		</div>
		<div class="box-body">
			<div class="form-group">
			<input type="hidden" id="sgroup" name="sgroup">
				<label>그룹 설정</label>
				<ul class="sidebar-menu" data-widget="tree">
					<li class="treeview">
						<a href="#">
							<i class="fa fa-share"></i><span>그룹 목록</span>
							<span class="pull-right-container">
								<i class="fa fa-angle-left pull-right"></i>
							</span>
						</a>
						<ul class="treeview-menu" style="background-color : white; font-color:black">
							<% groupManager.print(out, 0); %>
						</ul>
					</li>
				</ul>
			</div>
			<div class="form-group">
				<label>기한</label>
				<span class="pull-right deadline">
				<input type="checkbox" class="minimal" checked>
				<b>기한없음</b>
				</span>
				<div class="input-group">
					<div class="input-group-addon">
						<i class="fa fa-clock-o"></i>
					</div>
					<input type="text" class="form-control pull-right" id="reservationtime" disabled>
					<div class="form-group">
					</div>
				</div>
			</div>
			<div class="form-group">
				<label>언어</label>
				<select class="form-control languageSelect" multiple="multiple" data-placeholder="Select Language" style="width: 100%;">
					<option>C</option>
					<option>C++</option>
					<option>Java</option>
					<option>Python2</option>
					<option>Python3</option>
				</select>
			</div>
			<div class="form-group">
				<label>런타임 시간 설정</label>
				<small>런타임 시간을 설정합니다. 런타임 시간이 지나도 결과가 나오지 않으면 오답처리 합니다.</small>
				<table>
				<tr>
					<td>
						<div class="input-group time">
							<span class="input-group-addon">
							<input type="checkbox" class="minimal">
							</span>
							<input type="text" id="time" class="form-control" style="width:40px; text-align:center" value="2" disabled>
						</div>
					</td>
					<td>
						<b>초</b>
					</td>
				</tr>
				</table>
				<span class="runtime">
				</span>
			</div>
			<div class="btn-group">
				<label>
				난이도 </label>
				<br>
				<button type="button" id="level" class="btn btn-default btn-flat">중</button>
				<button type="button" class="btn btn-default btn-flat dropdown-toggle" data-toggle="dropdown">
				<span class="caret"></span>
				<span class="sr-only">ToggleDropdown</span>
				</button>
				<ul class="dropdown-menu level" role="menu">
					<li><a id="high">상</a></li>
					<li><a id="middle">중</a></li>
					<li><a id="low">하</a></li>
				</ul>
			</div>
			<div class="form-group">
			</div>
			<div class="form-group">
				<label>
				비공개 </label>
				<span class="visual">
				<input type="checkbox" class="minimal">
				<small>해당 문제가 글쓴이에게만 보여집니다.</small>
				</span>
			</div>
		</div>
		<div class="overlay" style="display:none">
			<i class="fa fa-refresh fa-spin"></i>
		</div>
	</div>
	</article>
	<article class="problem">
	<div class="box">
		<div class="box-header">
			<i class="fa fa-edit"></i>
			<h3 class="box-title">문제 내용</h3>
			<small>문제에 대한 설명을 적는 곳 입니다.</small>
			<div class="pull-right box-tools">
				<button type="button" class="btn btn-sm" data-widget="collapse" data-toggle="tooltip" title="Collapse">
				<i class="fa fa-minus"></i></button>
			</div>
		</div>
		<div class="box-body table-responsive pad">
			<input id="subject" class="form-control input-lg" type="text" placeholder="제목을 입력해 주세요.">
			<textarea id="context" name="context" rows="10" cols="80"></textarea>
			<script>	
										
										$(function() {
											var config = {};
											config.placeholder = '문제 내용을 입력해 주세요 '; 
											CKEDITOR.replace('context', config)
										});
									</script>
		</div>
		<div class="overlay" style="display:none">
			<i class="fa fa-refresh fa-spin"></i>
		</div>
	</div>
	</article>
	<article class="col-md-12">
	<div class="box">
		<div class="box-header">
			<i class="fa fa-edit"></i>
			<h3 class="box-title">예시 입출력값</h3>
			<small>사용자에게 예시로 보여줄 입출력값 입니다.</small>
			<button type="button" class="pull-right btn btn-default" onclick="inputExam_plus()"><i class="fa fa-plus"></i></button>
		</div>
		<div class="box-body pad table-responsive">
			<table class="table table-bordered inputExam-box">
			<tr>
				<th>
					Input
				</th>
				<th>
					Output
				</th>
				<th style="width:50px; text-align:center">
					M
				</th>
			</tr>
			</table>
		</div>
		<div class="overlay" style="display:none">
			<i class="fa fa-refresh fa-spin"></i>
		</div>
	</div>
	</article>
	<article class="col-md-12">
	<div class="box">
		<div class="box-header">
			<i class="fa fa-edit"></i>
			<h3 class="box-title">입출력값</h3>
			<small>실제 코드에 적용될 입출력값 입니다.</small>
			<button type="button" class="pull-right btn btn-default" onclick="input_plus()"><i class="fa fa-plus"></i></button>
		</div>
		<div class="box-body pad table-responsive">
			<table class="table table-bordered input-box">
			<tr>
				<th>
					Input
				</th>
				<th>
					Output
				</th>
				<th style="width:50px; text-align:center">
					M
				</th>
			</tr>
			</table>
		</div>
		<div class="overlay" style="display:none">
			<i class="fa fa-refresh fa-spin"></i>
		</div>
	</div>
	</article>
	<article class="col-md-12">
	<div class="box">
		<button type="button" id="saveSender" class="btn btn-block btn-default">저장</button>
		<div class="overlay" style="display:none">
			<i class="fa fa-refresh fa-spin"></i>
		</div>
	</div>
	</article>
	
	
	
	<article class="col-md-12">
					
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
	
	
	<div class="modal fade" id="modal-default">

          <div class="modal-dialog">
            <div class="modal-content box">
              <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <h4 class="modal-title">소스 From 추가</h4>
              </div>
              <div class="modal-body">
			  
			  <div class="box-body pad table-responsive code">
				<textarea id="editor"></textarea>		
				<div class="overlay" style="display:none">
					<i class="fa fa-refresh fa-spin"></i>
				</div>									
			  </div>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">Close</button>
                <button type="button" id="add" class="btn btn-primary groupAdd send">Save</button>
              </div>
			  <div class="overlay" style="display:none">
			<i class="fa fa-refresh fa-spin"></i>
		</div>
            </div>
            <!-- /.modal-content -->
          </div>
          <!-- /.modal-dialog -->
    </div>
	
	
	<!-- /.content -->
</div>

		
		<script>
		$(document).ready(function(){
				$(".deadline .iCheck-helper").click(function(){
					if($(".deadline .icheckbox_minimal-blue").attr("aria-checked") == "true")						
						$("#reservationtime").attr("disabled", "disabled");
					else
						$("#reservationtime").removeAttr("disabled");
				});
				
				$(".time .iCheck-helper").click(function(){
					if($(".time .icheckbox_minimal-blue").attr("aria-checked") == "true"){
						$(".runtime").append("<small ><font color=\"red\">시간을 너무 큰 수로 둘 경우,무한루프에 빠졌을 시 재 컴파일까지의 시간이 오래 소요됩니다.</font></small>");
						$("#time").removeAttr("disabled");
					}
					else{
						$("#time").attr("disabled", "disabled");
						$("#time").val(2);
						$(".runtime").html("");
					}
				});

			});
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
			
			
			$(function () {
				$('.languageSelect').select2();
			});
			
			$('input[type="checkbox"].minimal, input[type="radio"].minimal').iCheck({
				checkboxClass: 'icheckbox_minimal-blue',
				radioClass   : 'iradio_minimal-blue'
			})
	
			$('#reservationtime').daterangepicker({
				timePicker: true,
				locale: {
					format: 'YYYY/MM/DD hh:mm A'
				},
				minDate: new Date()
			})
			
			$(".deadline .icheckbox_minimal-blue").attr("aria-checked", "true");
			
			$(document).ready(function(){
				var prev=null;
				$(".add").click(function(e){
					e.stopPropagation() ;
					if($("#sgroup").val() == $(this).parents("a").find(".gname").attr("name")){
						$("#sgroup").val("");
						$(this).parents("a").eq(0).css("background-color", "white");
					}
					else{
						$("#sgroup").val($(this).parents("a").find(".gname").attr("name"));
						if(prev != null)
							prev.css("background-color", "white");
						$(this).parents("a").eq(0).css("background-color", "#8C8C8C");
					}
					prev = $(this).parents("a").eq(0);
				});
			});
		</script>
				<script>
			
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
