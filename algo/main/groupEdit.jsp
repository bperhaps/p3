<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="algo.DBUtil"%>
<%@page import="algo.FileControll"%>
<%@ page import="algo.GroupManager"%>
<%@page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@include file="include/header.jsp"%>
<%
if((String)session.getAttribute("isProfessor") == "true" || (String)session.getAttribute("isAdmin") == "true"){
} else return;
		
%>


  <!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
      <h1>
        그룹 관리
        <small>그룹을 관리하는 페이지 입니다.</small>
      </h1>
    </section>

    <!-- Main content -->
    <section class="content container-fluid">
	<input type="hidden" id="delgroup">
     <div class="form-group">
				<ul class="sidebar-menu" data-widget="tree">
					<li class="treeview" >
						<a href="#">
							<i class="fa fa-share"></i><span>그룹 목록</span>
							<span class="pull-right-container">
							<i class="fa fa-plus pull-right add"></i>
								<i class="fa fa-angle-left pull-right"></i>
							</span>
						</a>
						<ul class="treeview-menu" style="background-color : white; font-color:black">
							<% groupManager.printGroupEdit(out, 0); %>
						</ul>
					</li>
				</ul>
		</div>
		<div class="form-group sender" style="display:none">
			<font color=red>※※※※하위 그룹이 모두 삭제됩니다※※※※</font>
			<button type="button" class="btn btn-default btn-flat send" style="float:right" id="pop">제출</button>
		<div>
    </section>
    <!-- /.content -->
	
		<div class="modal fade" id="modal-default">

          <div class="modal-dialog">
            <div class="modal-content box">
              <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <h4 class="modal-title">하위 그룹 추가</h4>
              </div>
              <div class="modal-body">
			  <div>
				<h6 class="pgroup"></h6>
				<input type="hidden" id="pgroupid">
			  </div>
                <div class="input-group">
                <span class="input-group-addon">@</span>
                <input type="text" id="newgname" class="form-control" placeholder="Groupname">
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
	
  </div>
  <!-- /.content-wrapper -->
	<script>
	$(document).ready(function(){
				$(".send").click(function(){
					
					var url = "../setGroupEdit.jsp";
					var params = new Object();
					
					params.mode = $(this).attr("id");
					
					if($(this).attr("id")=="add"){
						params.groupid = $("#pgroupid").val();
						params.name = $("#newgname").val();
					} else 
					{
						params.groupid = $("#delgroup").val();
					}
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
							
								location.reload();
							
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
				$(".add").click(function(e){
					e.stopPropagation() ;
					$(".pgroup").html("<h3>"+$(this).parents("a").find(".gname").text()+"</h3>의 하위그룹으로 만들어집니다.");
					$("#pgroupid").val($(this).parents("a").find(".gname").attr("name"));
					$("#modal-default").modal();
				});
				
				var prev=null;
				$(".pop").click(function(e){
					e.stopPropagation() ;
					if($("#delgroup").val() == $(this).parents("a").find(".gname").attr("name")){
						$("#delgroup").val("");
						$(this).parents(".treeview").eq(0).css("background-color", "white");

					}
					else{
						$("#delgroup").val($(this).parents("a").find(".gname").attr("name"));
						if(prev != null)
							prev.css("background-color", "white");
						$(this).parents(".treeview").eq(0).css("background-color", "red");
						prev =$(this).parents(".treeview").eq(0);
					}
					if($("#delgroup").val()=="") 
						$(".sender").hide();
					else
						$(".sender").css("display","inline");
						
				});
			});
	</script>
 <%@include file="include/footer.jsp"%>

