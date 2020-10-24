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
	
	String studentId = (String)session.getAttribute("studentId");
	if (studentId == null) return ;
	
	ArrayList<String> language = new ArrayList<String>();
	String probNumber = request.getParameter("prob");	
	if(probNumber == null)
		return;

	// DB 연동
    Connection conn = DBUtil.getMySqlConnection();

	groupManager = new GroupManager(conn);
	
    String sql = "select * from question where questionId=?";
    PreparedStatement pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, probNumber);
    ResultSet rs =  pstmt.executeQuery();

	if(rs.next() && rs == null)
		return;
	
	String writer = rs.getString(2);
	String subject = rs.getString(3);
	String content = rs.getString(4);
	String probHash = rs.getString(5);
	String displayNone = rs.getString(6);
	String level = rs.getString(7);
	int time = rs.getInt(10);
	String contestId = rs.getString("contestId");
	
	String startTime=null;
	String deadline=null;
	
	if (contestId != null) {
		out.print("잘못된 접근입니다.");
		out.close();
		return ;
	}
	
	if(rs.getTimestamp(8) == null || rs.getTimestamp(9) == null){
		java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		startTime  = dateFormat.format(new java.util.Date());
		deadline = dateFormat.format(new java.util.Date());
	} else {
		Timestamp startTimed = new Timestamp(rs.getTimestamp(8).getTime());
		Timestamp deadlined = new Timestamp(rs.getTimestamp(9).getTime());
		
		java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		startTime  = dateFormat.format(startTimed);
		deadline = dateFormat.format(deadlined);
	}
	
	sql = "select language from language where questionId=?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, probNumber);
	rs = pstmt.executeQuery();
	
	if(rs == null)
		return;
	
	while(rs.next()){
		language.add(rs.getString(1));
	}
	
	sql = "select * from probGroup where questionId=? limit 1";
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, probNumber);
	rs = pstmt.executeQuery();
	
	if(rs == null)
		return;
	
	rs.last();
	int groupNum;
	if(rs.getRow()== 0)
		groupNum=0;
	else
		groupNum = rs.getInt("groupNum");
	
	ArrayList<String> input = FileControll.getProbInput(probHash);
	ArrayList<String> output = FileControll.getProbOutput(probHash);
	ArrayList<String> inputExam = FileControll.getProbInputExam(probHash);
	ArrayList<String> outputExam = FileControll.getProbOutputExam(probHash);
	
	sql = "select * from language where questionId=136";
    pstmt = conn.prepareStatement(sql);
    rs =  pstmt.executeQuery();
	
	if(rs == null)
		return;
	
	ArrayList<String> langArray = new ArrayList<String>();
	while(rs.next()){
		langArray.add(rs.getString("language"));	
	}
	
	DBUtil.close(conn);
%>
<script src="./bower_components/ckeditor/ckeditor.js"></script>
<script src="./bower_components/select2/dist/js/select2.full.min.js"></script>
<script src="./plugins/iCheck/icheck.min.js"></script>
<script src="./bower_components/moment/min/moment.min.js"></script>
<script src="./bower_components/bootstrap-daterangepicker/daterangepicker.js"></script>
  
<link rel="stylesheet" href="./bower_components/bootstrap-daterangepicker/daterangepicker.css">
<link rel="stylesheet" href="./bower_components/select2/dist/css/select2.min.css">
<link rel="stylesheet" href="./plugins/iCheck/all.css">  
<input type="hidden" id="probHash" value="<%=probHash%>">
  <!-- Content Wrapper. Contains page content -->
 		<div class="content-wrapper">
			<!-- Content Header (Page header) -->
			<!-- Content Header (Page header) -->
			
			<section class="content-header">
				<h1>
					문제 수정
					<small>문제를 수정하는 곳 입니다.</small>
				</h1>
				<ol class="breadcrumb">
					  <li><a href="#"><i class="fa fa-dashboard"></i> Level</a></li>
					  <li class="active">Here</li>
				</ol>
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
									<li class="treeview" >
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
							<%
								if(startTime.equals(deadline))
									out.print("<input type=\"checkbox\" class=\"minimal\" checked>");
								else 
									out.print("<input type=\"checkbox\" class=\"minimal\">");
							%>
							<b>기한없음</b>
							</span>
						    <div class="input-group">
								<div class="input-group-addon">
									<i class="fa fa-clock-o"></i>
								</div>
							<%
							if(startTime.equals(deadline))
									out.print("<input type=\"text\" class=\"form-control pull-right\" id=\"reservationtime\" disabled>");
								else 
									out.print("<input type=\"text\" class=\"form-control pull-right\" id=\"reservationtime\">");
								
							%>
								<div class="form-group">
        
              </div>
							</div>
						</div>
						
							<div class="form-group">
                <label>언어</label>
                <select class="form-control languageSelect" multiple="multiple" data-placeholder="Select Language"
                        style="width: 100%;">
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
			  <table><tr>
				<td>
				<div class="input-group time">
                        <span class="input-group-addon">
                          <% 
						  if(time == 2)
							out.print("<input type=\"checkbox\" class=\"minimal\">");
						  else
							out.print("<input type=\"checkbox\" class=\"minimal\" checked>");
						%>
                        </span>
                    <input type="text" id="time" class="form-control" style="width:40px; text-align:center" value="2" disabled>
                  </div>
				</td>
			  <td><b>초</b></td>
				</tr></table>
				<span class="runtime">
				</span>
			  </div>
			  
				<div class="btn-group">
				<label>
					난이도
				</label>
				<br>
                  <button type="button" id="level" class="btn btn-default btn-flat"><%=level%></button>
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
				<div class="form-group"></div>
				
				<div class="form-group">
                <label>
					비공개
				</label>
				<span class="visual">
				<% if(displayNone.equals("true")) {%>
                  <input type="checkbox" class="minimal" checked>
				<%} else {%>
				  <input type="checkbox" class="minimal">
				<% } %>
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
										<input id="subject" class="form-control input-lg" type="text" placeholder="제목을 입력해 주세요." value="<%=subject%>">
											<textarea id="context" name="context" rows="10" cols="80">
                                            <%=content%>
                    </textarea>
										
								
									<script>
										$(function() {
											CKEDITOR.replace('context')
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
							<button type="button" class="pull-right btn btn-default"  onclick="inputExam_plus()"><i class="fa fa-plus"></i></button>
						</div>
						<div class="box-body pad table-responsive">
							<table class="table table-bordered inputExam-box">
								<tr>
									<th>Input</th>
									<th>Output</th>
									<th style="width:50px; text-align:center">M</th>
								</tr>
								<%
									int inputExam_cnt=0;
									
									Iterator ind = inputExam.iterator();
									Iterator outd = outputExam.iterator();
									while(ind.hasNext() && outd.hasNext()){
										String inputd = ((String)ind.next()).replace("<br>","\n");
										String outoutd = ((String)outd.next()).replace("<br>","\n");
									%>
									<tr id="inExambox<%=inputExam_cnt%>">
										<td>
											<textarea class="form-control" rows=3 name="inputExam_data" placeholder="ex) 4 2 11 8"><%=inputd%></textarea>
										</td>
										<td>
											<textarea class="form-control" rows=3 name="outputExam_data" placeholder="ex) 4 2 11 8"><%=outoutd%></textarea>
										</td>
										<td>
											<button type="button" class="btn btn-default" onclick="inputExam_minus(<%=inputExam_cnt%>)"><i class="fa fa-minus"></i></button>
										</td>
									</tr>
									<%
									inputExam_cnt++;
									}
								%>
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
							
							<button type="button" class="pull-right btn btn-default"  onclick="input_plus()"><i class="fa fa-plus"></i></button>
						</div>
						<div class="box-body pad table-responsive">
							<table class="table table-bordered input-box">
								<tr>
									<th>Input</th>
									<th>Output</th>
									<th style="width:50px; text-align:center">M</th>
								</tr>
								<%
									int input_cnt=0;
									
									ind = input.iterator();
									outd = output.iterator();
									while(ind.hasNext() && outd.hasNext()){
										String inputd = ((String)ind.next()).replace("<br>","\n");
										String outoutd = ((String)outd.next()).replace("<br>","\n");
									%>
									<tr id="inbox<%=input_cnt%>">
										<td>
											<textarea class="form-control" rows=3 name="input_data" placeholder="ex) 4 2 11 8"><%=inputd%></textarea>
										</td>
										<td>
											<textarea class="form-control" rows=3 name="output_data" placeholder="ex) 4 2 11 8"><%=outoutd%></textarea>
										</td>
										<td>
											<button type="button" class="btn btn-default" onclick="input_minus(<%=input_cnt%>)"><i class="fa fa-minus"></i></button>
										</td>
									</tr>
									<%
									input_cnt++;
									}
								%>
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
			
			
			<!-- /.content -->
			</div>

		
		<script>
		var prev=null;
			if(<%=groupNum%>!=0){
					$("span[name=<%=groupNum%>]").parents("a").eq(0).css("background-color", "#8C8C8C");
					prev=$("span[name=<%=groupNum%>]").parents("a").eq(0);
			}
			
		$(document).ready(function(){
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
	
			
			var selectedValues = new Array();
			
			<%
				for(String str : language){
					out.println("selectedValues.push('"+str+"');");
				}
			%>
			$('.languageSelect').select2();
			
			$(function () {
				$('.languageSelect').select2().val(selectedValues);
				$('.languageSelect').select2().val();
			});
			
			
			
			Date.prototype.format = function(f) {
				if (!this.valueOf()) return " ";
		
				var weekName = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"];
				var d = this;
		
				return f.replace(/(yyyy|yy|MM|dd|E|hh|mm|ss|a\/p)/gi, function($1) {
					switch ($1) {
						case "yyyy": return d.getFullYear();
						case "yy": return (d.getFullYear() % 1000).zf(2);
						case "MM": return (d.getMonth() + 1).zf(2);
						case "dd": return d.getDate().zf(2);
						case "E": return weekName[d.getDay()];
						case "HH": return d.getHours().zf(2);
						case "hh": return ((h = d.getHours() % 12) ? h : 12).zf(2);
						case "mm": return d.getMinutes().zf(2);
						case "ss": return d.getSeconds().zf(2);
						case "a/p": return d.getHours() < 12 ? "am" : "pm";
						default: return $1;
					}
				});
			};
			String.prototype.string = function(len){var s = '', i = 0; while (i++ < len) { s += this; } return s;};
			String.prototype.zf = function(len){return "0".string(len - this.length) + this;};
			Number.prototype.zf = function(len){return this.toString().zf(len);};
			
			
			$('input[type="checkbox"].minimal, input[type="radio"].minimal').iCheck({
				checkboxClass: 'icheckbox_minimal-blue',
				radioClass   : 'iradio_minimal-blue'
			})
	
			$('#reservationtime').daterangepicker({ 
				timePicker: true,
				locale: {
					format: 'YYYY/MM/DD hh:mm A'
				},
				minDate: new Date("<%=startTime%>").format("yyyy/MM/dd hh:mm a/p"),
				startDate: new Date("<%=startTime%>").format("yyyy/MM/dd hh:mm a/p"),
				endDate : new Date("<%=deadline%>").format("yyyy/MM/dd hh:mm a/p")
			});
			
			

			$(".deadline .icheckbox_minimal-blue").attr("aria-checked", "true");
			$("#time").val(<%=time%>);
			<% if(time!=2){ %>
				$("#time").removeAttr("disabled");
			<% } %>
			input_cnt = <%=input_cnt%>
			inputExam_cnt = <%=inputExam_cnt%>
			
	
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
	
		</script>
		
 <%@include file="include/footer.jsp"%>
