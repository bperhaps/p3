<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="algo.DBUtil"%>
<%@page import="algo.FileControll"%>
<%@ page import="algo.GroupManager"%>
<%@page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@include file="include/header.jsp"%>
<%
/*
if((String)session.getAttribute("isProfessor") == "true" || (String)session.getAttribute("isAdmin") == "true"){
} else return;
	*/	
%>


  <!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
      <h1>
        그룹 선택
        <small>그룹을 선택하는 페이지 입니다.</small>
      </h1>
    </section>

    <!-- Main content --> 
    <section class="content container-fluid box">
	<input type="hidden" id="delgroup">
     <div class="form-group">
				<ul class="sidebar-menu" data-widget="tree">
					<li class="treeview" >
						<a href="#">
							<i class="fa fa-share"></i><span>그룹 목록</span>
							<span class="pull-right-container">
								<i class="fa fa-angle-left pull-right"></i>
							</span>
						</a>
						<ul class="treeview-menu" style="background-color : white; font-color:black">
							<% groupManager.userSelectGroupPrint(out, 0); %>
						</ul>
					</li>
				</ul>
		</div>
		<div class="form-group sender" style="display:none">
			<button type="button" class="btn btn-default btn-flat send" style="float:right" id="pop">저장</button>
		<div>
		<div class="overlay" style="display:none">
			<i class="fa fa-refresh fa-spin"></i>
		</div>		
    </section>

	
  </div>
  <!-- /.content-wrapper -->
	<script>
	var selectedData = [];
	$(document).ready(function(){
		
		
		
				$(".send").click(function(){
					
					var url = "../setUserGroup.jsp";
					var datas = new Array();
					var jsondatas = new Object();
					
					for(var i=0; i<selectedData.length; i++){
						var params = new Object();
						params.data = selectedData[i];
						datas.push(params);
					}
					jsondatas.data = datas;
					var jsonData = JSON.stringify(jsondatas);
					console.log(jsonData);
					$.ajax({
						type: "POST",
						url: url,
						dataType: "json",
						data: {
							jsonParam: jsonData
						},
						beforeSend: function() {
								$(".overlay").css("display", "table-cell");
						},
						success: function(args) {
							
								console.log(args);
							
						},	
						error: function(e) {
							alert(e.responseText);
						},
						complete: function() {
								$(".overlay").hide();
						}
					
				});
				});
				$(document).ready(function(){

				$(".add").click(function(e){
					e.stopPropagation() ;
					var checkInArray = selectedData.indexOf($(this).parents("a").find(".gname").attr("name"));
					if(checkInArray != -1){
						selectedData.splice(checkInArray, 1);
						$(this).parents("a").eq(0).css("background-color", "white");
						if(selectedData.length == 0)
							$(".sender").css("display","none");
					}
					else{
						selectedData.push($(this).parents("a").find(".gname").attr("name"));
						$(this).parents("a").eq(0).css("background-color", "#8C8C8C");
						$(".sender").css("display","inline");
					}
					
				});
			});
				
			});
	</script>
 <%@include file="include/footer.jsp"%>


