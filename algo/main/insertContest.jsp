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
	대회 등록 <small>새 대회를 등록하는 곳 입니다.</small>
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
					<input id="subject" class="form-control input-lg" type="text" placeholder="제목을 입력해 주세요.">
					<textarea id="context" name="context" rows="10" cols="80"></textarea>
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
				<button type="button" id="saveSender_contest" class="btn btn-block btn-default">저장</button>
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
		startDate: new Date(),
		endDate: new Date()
	});
</script>
		
<%@include file="include/footer.jsp"%>
