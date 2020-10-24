<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="algo.DBUtil"%>
<%@page import="algo.FileControll"%>
<%@page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@include file="include/header.jsp"%>
<%
	if(session.getAttribute("name")==null){
		out.print("nohack");
		return;
	}
if((String)session.getAttribute("isProfessor") == "true" || (String)session.getAttribute("isAdmin") == "true"){
} else return;
	String Nno = request.getParameter("no");
	if(Nno==null){
		return;
	}

	
			
	
	Connection conn = DBUtil.getMySqlConnection();

	
    String sql = "select * from notice where noticeNumber=?";
    PreparedStatement pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, Nno);
    ResultSet rs =  pstmt.executeQuery();

	if(rs == null)
		return;
	rs.last();
	int n = rs.getRow();
	if(n == 0){
		String userId = rs.getString("userId");
		if(userId != session.getAttribute("studentId")){
			return;
		}
	}

	rs.first();

	String subject = rs.getString(2);
	String context = rs.getString(3);
	
	
%>
<script>
$(document).ready(function(){
$("#saveSender_mnotice").click(function() {
        var url = "../insertmNoticeSubmit.jsp";
        var params = new Object();
        if ($("#subject").val() == "") {
            alert("제목이 없습니다.");
            return;
        }
		params.no = getRequest()['no'];
        params.subject = $("#subject").val();
        params.context = CKEDITOR.instances.context.getData();

        var jsonData = JSON.stringify(params);

        $.ajax({
            type: "POST",
            url: url,
            dataType: "json",
            data: {
                jsonParam: jsonData
            },
            success: function(args) {
				var result = "" + args.result;
				
				if (result.indexOf("error") == -1) 
					location.href="noticeBoard.jsp";
				else
					alert(result);
            },
            error: function(e) {
                alert(e.responseText);
            }
        });
    });
});

</script>
<script src="./bower_components/ckeditor/ckeditor.js"></script>

<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
	<!-- Content Header (Page header) -->
	<section class="content-header">
		<h1>
			공지사항 수정 <small>공지사항을 수정하는 곳 입니다.</small>
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
					<input id="subject" class="form-control input-lg" type="text" placeholder="제목을 입력해 주세요." value="<%=subject%>">
					<textarea id="context" name="context" rows="10" cols="80"><%=context%></textarea>
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
				<button type="button" id="saveSender_mnotice" class="btn btn-block btn-default">수정</button>
				<div class="overlay" style="display:none">
					<i class="fa fa-refresh fa-spin"></i>
				</div>
			</div>
		</article>
	</section>
</div>

		
 <%@include file="include/footer.jsp"%>

