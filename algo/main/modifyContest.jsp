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
	
	//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
	// 파라미터 추출 및 확인
	String contestId = request.getParameter("contest");
	if (contestId == null) {
		out.print("error - 잘못된 파라미터입니다.");
		out.close();
		return ;
	}
	
	//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
	// contest DB select
    Connection conn = DBUtil.getMySqlConnection();
	
	String sql = "select * from contest where contestId=?";
    PreparedStatement pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, contestId);
    ResultSet rs = pstmt.executeQuery();
	
	if (rs == null || !rs.next()) {
		if (rs != null)
			DBUtil.close(rs);
		DBUtil.close(pstmt);
		DBUtil.close(conn);
	}
	
	String subject = rs.getString("subject");
	String context = rs.getString("context");
	
	// 시간 설정
	Timestamp startTime = new Timestamp(rs.getTimestamp("startTime").getTime());
	Timestamp endTime = new Timestamp(rs.getTimestamp("endTime").getTime());
		
	java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	String startDate  = dateFormat.format(startTime);
	String endDate = dateFormat.format(endTime);
	
	DBUtil.close(rs);
	DBUtil.close(pstmt);
	DBUtil.close(conn);
%>
<script src="./bower_components/ckeditor/ckeditor.js"></script>
<script src="./bower_components/moment/min/moment.min.js"></script>
<script src="./bower_components/bootstrap-daterangepicker/daterangepicker.js"></script>

<link rel="stylesheet" href="./bower_components/bootstrap-daterangepicker/daterangepicker.css">

<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
	<!-- Content Header (Page header) -->
	<section class="content-header">
	<h1>
	대회 수정 <small>대회를 수정하는 곳 입니다.</small>
	</h1>
	</section>
	<!-- Main content -->
	<section class="content container-fluid algo-css">
		<article>
			<div class="box">
				<div class="box-header">
					<i class="fa fa-edit"></i>
					<h3 class="box-title">대회 설정</h3>
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
							<input type="text" class="form-control pull-right" id="reservationtime">
							<div class="form-group">
							</div>
						</div>
					</div>
				</div>
			</div>
		</article>
		<article class="problem">
			<div class="box">
				<div class="box-header">
					<i class="fa fa-edit"></i>
					<h3 class="box-title">대회 내용</h3>
					<small>대회에 대한 설명을 적는 곳 입니다.</small>
					<div class="pull-right box-tools">
						<button type="button" class="btn btn-sm" data-widget="collapse" data-toggle="tooltip" title="Collapse">
						<i class="fa fa-minus"></i></button>
					</div>
				</div>
				<div class="box-body table-responsive pad">
					<input id="subject" class="form-control input-lg" type="text" placeholder="제목을 입력해 주세요." value="<%= subject %>">
					<textarea id="context" name="context" rows="10" cols="80"><%= context %></textarea>
					<script>
						$(function() {
							CKEDITOR.replace('context');
						});
					</script>
				</div>
			</div>
		</article>
		<article class="col-md-12">
			<div class="box">
				<input type="hidden" id="contestId" value="<%= contestId %>">
				<button type="button" id="saveSender_contest_modify" class="btn btn-block btn-default">저장</button>
				<div class="overlay" style="display:none">
					<i class="fa fa-refresh fa-spin"></i>
				</div>
			</div>
		</article>
	</section>
	<!-- /.content -->
</div>

<script>
	$('#reservationtime').daterangepicker({
		timePicker: true,
		locale: {
			format: 'YYYY/MM/DD hh:mm A'
		},
		minDate: new Date(),
		startDate: new Date("<%= startDate %>"),
		endDate : new Date("<%= endDate %>")
	});
</script>

<%@include file="include/footer.jsp"%>
