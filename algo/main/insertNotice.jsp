<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="algo.DBUtil"%>
<%@page import="algo.FileControll"%>
<%@page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@include file="include/header.jsp"%>

<%
	if((String)session.getAttribute("isProfessor") == "true" || (String)session.getAttribute("isAdmin") == "true");
	else return;
%>
<script src="./bower_components/ckeditor/ckeditor.js"></script>

<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
	<!-- Content Header (Page header) -->
	<section class="content-header">
		<h1>
			공지사항 등록 <small>새 공지사항을 등록하는 곳 입니다.</small>
		</h1>
	</section>
	
	<!-- Main content -->
	<section class="content container-fluid algo-css">
		<article class="problem">
			<div class="box">
				<div class="box-header">
					<i class="fa fa-edit"></i>
					<h3 class="box-title">공지사항</h3>
					<div class="pull-right box-tools">
						<button type="button" class="btn btn-sm" data-widget="collapse" data-toggle="tooltip" title="Collapse">
						<i class="fa fa-minus"></i></button>
					</div>
				</div>
				<div class="box-body table-responsive pad">
					<input id="subject" class="form-control input-lg" type="text" placeholder="제목을 입력해 주세요.">
					<textarea id="context" name="context" rows="10" cols="80">내용을 입력해 주세요.</textarea>
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
			<div class="box">
				<button type="button" id="saveSender_notice" class="btn btn-block btn-default">저장</button>
				<div class="overlay" style="display:none">
					<i class="fa fa-refresh fa-spin"></i>
				</div>
			</div>
		</article>
	</section>
</div>

		
 <%@include file="include/footer.jsp"%>
