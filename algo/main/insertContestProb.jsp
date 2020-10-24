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
	
	String contestId = request.getParameter("contest");
	if (contestId == null) {
		out.print("잘못된 파라미터입니다.");
		out.close();
		return ;
	}
	
		
	Connection conn = DBUtil.getMySqlConnection();
	
	//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
	// 대회 정보 가져오기
	String sql = "select subject, startTime, endTime from contest where contestId=?";
	PreparedStatement pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, contestId);
	ResultSet rs = pstmt.executeQuery();
		
	if (rs == null || !rs.next()) {
		if (rs != null)
			DBUtil.close(rs);
		DBUtil.close(pstmt);
		DBUtil.close(conn);
			
		out.print("DB 오류");
		out.close();
		return;
	}
		
	String contestSubject = rs.getString("subject");
	
	Timestamp startTimed = new Timestamp(rs.getTimestamp("startTime").getTime());
	Timestamp deadlined = new Timestamp(rs.getTimestamp("endTime").getTime());
		
	java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	String startTime  = dateFormat.format(startTimed);
	String deadline = dateFormat.format(deadlined);
		
	DBUtil.close(rs);
	DBUtil.close(pstmt);
		
	//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
	// 대회 관리자 확인
	sql = "select userId from contestAdmin where contestId=?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, contestId);
	rs = pstmt.executeQuery();
		
	if (rs == null) {
		DBUtil.close(pstmt);
		DBUtil.close(conn);
			
		out.print("DB 오류");
		out.close();
		return;
	}
		
	boolean isAdmin = false;
	while (rs.next()) {
		String userId = rs.getString("userId");
		if (userId.equals(studentId)) {
			isAdmin = true;
			break;
		}
	}
		
	DBUtil.close(rs);
	DBUtil.close(pstmt);
	DBUtil.close(conn);
		
	if (!isAdmin) {
		out.print("권한이 없습니다.");
		out.close();
		return ;
	}
	
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
	대회 문제 등록 <small>새 문제를 등록하는 곳 입니다.</small>
	</h1>
	<ol class="breadcrumb">
		<li><a href="#"><i class="fa fa-dashboard"></i> 대회</a></li>
		<li class="active"><%= contestSubject %></li>
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
					<label>기한</label>
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
		<input type="hidden" id="contestId" value="<%= contestId %>">
		<button type="button" id="saveSender_contestProb" class="btn btn-block btn-default">저장</button>
		<div class="overlay" style="display:none">
			<i class="fa fa-refresh fa-spin"></i>
		</div>
	</div>
	</article>
	<article>
	<div class="box box-primary col-md-6">
		<div class="box-header">
			<i class="fa fa-edit"></i>
			<h3 class="box-title">코드 에디터</h3>
			<div class="btn-group lang">
				<button type="button" class="btn btn-default selectedlang">C</button>
				<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
				<span class="caret"></span>
				</button>
				<ul class="dropdown-menu" role="menu">
					<li><a class="C">C</a></li>
					<li><a class="Cpp">C++</a></li>
					<li><a class="Java">Java</a></li>
					<li><a class="Python2">Python2</a></li>
					<li><a class="Python3">Python3</a></li>
				</ul>
			</div>
		</div>
		<div class="box-body pad table-responsive code">
			<textarea id="editor"></textarea>
		</div>
	</div>
	</article>
	<article class="col-md-6">
	<div class="box">
		<div class="box-header">
			<i class="fa fa-edit"></i>
			<h3 class="box-title">입출력값</h3>
			<small>실제 코드에 적용될 입출력값 입니다.</small>
			<button type="button" class="pull-right btn btn-default" onclick="testInput_plus()"><i class="fa fa-plus"></i></button>
		</div>
		<div class="box-body pad table-responsive">
			<table class="table table-bordered testInput-box">
			<tr>
				<th>
					Input
				</th>
				<th style="width:50px; text-align:center">
					M
				</th>
			</tr>
			</table>
		</div>
	</div>
	</article>
	<article class="col-md-6">
	<div class="box">
		<div class="box-header">
			<i class="fa fa-edit"></i>
			<h3 class="box-title">결과창</h3>
			<button type="button" class="btn btn-default btn-flat" style="float:right" id="sender">실행</button>
		</div>
		<div class="box-body pad table-responsive">
			<p class="result">
				test
			</p>
		</div>
	</div>
	</article>
	</section>
	
	
	<!-- /.content -->
</div>

		
		<script>
		$(document).ready(function() {
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
				minDate: new Date(),
				startDate: new Date("<%= startTime %>"),
				endDate: new Date("<%= deadline %>")
			})
		</script>
		
 <%@include file="include/footer.jsp"%>
