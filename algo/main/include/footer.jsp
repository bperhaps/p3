<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

 <!-- Main Footer -->
  <footer class="main-footer">
    <!-- To the right -->
    <div class="pull-right hidden-xs">
		made by hyeon, minsung
    </div>
    <!-- Default to the left -->
    <strong>Copyright &copy; 2017 <a href="http://kknock.org">K.knock</a>.</strong> All rights reserved.
  </footer>

  <!-- Control Sidebar -->
  <aside class="control-sidebar control-sidebar-light">
    <!-- Create the tabs -->
    <ul class="nav nav-tabs nav-justified control-sidebar-tabs">
      <li class="active"><a href="#control-sidebar-home-tab" data-toggle="tab"><i class="fa fa-home"></i></a></li>
    
    </ul>
    <!-- Tab panes -->
    <div class="tab-content">
      <!-- Home tab content -->
      <div class="tab-pane active" id="control-sidebar-home-tab">
        <h3 class="control-sidebar-heading"><a href="logout.jsp">LogOut</a></h3>
				

      </div>
	  

     
      <!-- /.tab-pane -->
    </div>
	<ul class="sidebar-menu" data-widget="tree">
		<li class="treeview" >
			<a href="#">
				<i class="fa fa-share"></i><span>그룹 셋팅<br><small>들어갈 그룹을 선택하세요.</small></span>
					<span class="pull-right-container">
						<i class="fa fa-angle-left pull-right"></i>
					</span>
			</a>
			<ul class="treeview-menu">
				<% groupManager.userSelectGroupPrint(out, 0); %>
			</ul>
		</li>
	</ul>
	<div class="form-group sender">
		<button type="button" class="btn btn-default btn-flat send" style="float:right" id="pop">저장</button>
	</div>

		<script>
	var s_selectedData = [];
	$(document).ready(function(){

				$(".send").click(function(){
					
					var url = "../setUserGroup.jsp";
					var datas = new Array();
					var jsondatas = new Object();
					
					for(var i=0; i<s_selectedData.length; i++){
						var params = new Object();
						params.data = s_selectedData[i];
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
							location.reload();
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

				$(".s_add").click(function(e){
					e.stopPropagation() ;
					var checkInArray = s_selectedData.indexOf($(this).parents("a").find(".u_gname").attr("name"));
					if(checkInArray != -1){
						s_selectedData.splice(checkInArray, 1);
						$(this).parents("a").eq(0).css("background-color", "#f4f4f5");
						
					}
					else{
						s_selectedData.push($(this).parents("a").find(".u_gname").attr("name"));
						$(this).parents("a").eq(0).css("background-color", "#8C8C8C");
						
					}
					
				});
			});
				
			});
			
			<%
				Connection cc = DBUtil.getMySqlConnection();
				ArrayList<Integer> userGroup = groupManager.getUserGroup(cc, (String)session.getAttribute("studentId"));
				DBUtil.close(cc);
				
				for(int i=0; i<userGroup.size(); i++){%>
					$("span[name=<%=userGroup.get(i)%>][class='u_gname']").closest("a").css("background-color", "rgb(140, 140, 140)");
					s_selectedData.push("<%=userGroup.get(i)%>");
				<%}%>
				
	</script>

  </aside>
  <!-- /.control-sidebar -->
  <!-- Add the sidebar's background. This div must be placed
  immediately after the control sidebar -->
  <div class="control-sidebar-bg"></div>

<!-- ./wrapper -->

<!-- REQUIRED JS SCRIPTS -->

<!-- Bootstrap 3.3.7 -->
<script src="bower_components/bootstrap/dist/js/bootstrap.min.js"></script>
<!-- AdminLTE App -->
<script src="dist/js/adminlte.min.js"></script>

<!-- Optionally, you can add Slimscroll and FastClick plugins.
     Both of these plugins are recommended to enhance the
     user experience. -->
</body>
</html>