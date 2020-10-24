<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="algo.urlHandler"%>
<%@page import="algo.DBUtil"%>
<%@page import="java.sql.*"%>
<%@include file="include/header.jsp"%>

<%!
	public static boolean isNum(String s) {
		try {
			Double.parseDouble(s);
			return true;
		} catch(NumberFormatException e) {
			return false;
		}
	}
%>
<%
	int contentView = 15;
	int pageNum;
	int pageLength=3;
	int dataRow;
	int pageLengthStart;
	int allPageLength;
	int allDataNum;
	//page가 정수인지 판별
	if(request.getParameter("page") == null || !isNum(request.getParameter("page")) || Integer.parseInt(request.getParameter("page")) <=0) 
		pageNum = 1;
	else
		pageNum = Integer.parseInt(request.getParameter("page"));

	Connection conn = DBUtil.getMySqlConnection();
	String sql = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
	
	/******정렬************/
	String order = request.getParameter("order");
	String order_sql = "order by me";
	if (order == null) order = "";
	if (order.equals(""))						order_sql = "order by me, endTime asc";
	if (order.equals("endTime-asc"))			order_sql = "order by endTime asc, contestId desc";
	else if (order.equals("endTime-desc"))		order_sql = "order by endTime desc, contestId desc";
	else if (order.equals("startTime-asc"))		order_sql = "order by startTime asc, contestId desc";
	else if (order.equals("startTime-desc"))	order_sql = "order by startTime desc, contestId desc";
	else if (order.equals("contestId-asc"))		order_sql = "order by contestId asc";
	else if (order.equals("contestId-desc"))	order_sql = "order by contestId desc";
	else if (order.equals("subject-asc"))		order_sql = "order by subject asc";
	else if (order.equals("subject-desc"))		order_sql = "order by subject desc";
		
	
	/************누군가가 나중에 이 주석을 보거든***********************/
	/***********201215595 손민성 갈려 들어갔다고 전하시오&&&************/
	/**********나 실은 JSP 처음만져봄 ㅎ.ㅎ.ㅎ.ㅎ.ㅎ.ㅎ 헿 *************/	
	
	String allDataSql=null;
	String search = request.getParameter("search");
	String category = request.getParameter("category");
	if(search != null && category != null){
		if(category.equals("subject")){
			sql = "select *, case when endTime > now() then 1 when endTime < now() then 3 else 2 end as me from contest where subject like ? " + order_sql + " limit ?,?";
			allDataSql = "select count(*) from contest where subject like ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, "%"+search+"%");
			pstmt.setInt(2, (pageNum-1)*contentView);
			pstmt.setInt(3, contentView);
		}
		else{
			sql = "select *, case when endTime > now() then 1 when endTime < now() then 3 else 2 end as me from contest " + order_sql + " limit ?,?";
			allDataSql = "select count(*) from contest";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, (pageNum-1)*contentView);
			pstmt.setInt(2, contentView);
		}
		
    } else {
		// questionId, writer, subject, displayNone
		sql = "select *, case when endTime > now() then 1 when endTime < now() then 3 else 2 end as me from contest " + order_sql + " limit ?,?";
		allDataSql = "select count(*) from contest";
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, (pageNum-1)*contentView);
		pstmt.setInt(2, contentView);
	}
	
	/*****전체문제 수 구함********/
	
    PreparedStatement pstmt_a = conn.prepareStatement(allDataSql);
	if(allDataSql.indexOf("like")!=-1)
		pstmt_a.setString(1, "%"+search+"%");
    ResultSet rs_a = pstmt_a.executeQuery();
	rs_a.next();
	
	allDataNum = rs_a.getInt(1);
	DBUtil.close(pstmt_a);
	
	
	rs = pstmt.executeQuery();
	
	rs.last();
	dataRow = rs.getRow();
	rs.beforeFirst();
	
	pageLengthStart = ((pageNum-1)/pageLength)*pageLength+1;
	allPageLength = allDataNum/contentView+1;
	if(pageLength > (allPageLength-pageLengthStart)+1){
		pageLength = (allPageLength-pageLengthStart)+1;
	}

	// 시간
%>


  <!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
      <h1>
        대회
        <small>대회 목록입니다.</small>
      </h1>

    </section>

    <!-- Main content -->
    <section class="content container-fluid">

     <div class="col-md-12">
          <div class="box box-primary">
            <div class="box-header with-border">
              <h3 class="box-title"> </h3>
				
              <div class="box-tools pull-right">
           
                <div class="has-feedback">
					<form class="form-search">
						
						<table>
						<tr><td>
						<div>
						<ul class="dropdown-menu">
							<li><a class="category-subject">제목</a></li>
						</ul>
						<button type="button" class="btn btn-default selected_category" data-toggle="dropdown">제목
							<span class="fa fa-caret-down"></span></button>
						<input name="category" type="hidden" class="form-control input-search-category" value="subject">
						
						</div>
						</td><td>
						<div>
						<input type="text" name="search" style="width:150px" class="form-control" placeholder="Search...">
						<span class="input-group-btn">
						</span>
						</td><td>
						<button type="submit" name="search" id="search-btn" class="btn btn-flat"><i class="fa fa-search"></i>
							</button>
							</td>
							</tr>
						</div>
						</table>

					</form>
                </div>
              </div>
              <!-- /.box-tools -->
            </div>
            <!-- /.box-header -->
            <div class="box-body no-padding">
              <div class="mailbox-controls">
                <!-- Check all button -->
				<% if(session.getAttribute("isAdmin")=="true"){ %>
                <button type="button" class="btn btn-default btn-sm checkbox-toggle"><i class="fa fa-square-o"></i>
                </button>
                <div class="btn-group">
                  <button type="button" class="btn btn-default btn-sm"><i class="fa fa-trash-o"></i></button>
                  <button type="button" class="btn btn-default btn-sm"><i class="fa fa-reply"></i></button>
                  <button type="button" class="btn btn-default btn-sm"><i class="fa fa-share"></i></button>
                </div>
                <!-- /.btn-group -->
                <button type="button" class="btn btn-default btn-sm" onclick="location.reload()"><i class="fa fa-refresh"></i></button>
				<% } else {%>
				<div class="btn-group">
                  <button type="button" class="btn btn-default btn-sm" onclick="location.reload()"><i class="fa fa-refresh"></i></button>
                </div>
				<% } %>
				
  
                <!-- /.pull-right -->
              </div>
              <div class="table-responsive mailbox-messages">
                <table class="table table-hover table-striped">
                  <tbody style="text-align:center">
				  <tr>
				  <%
					StringBuffer url = request.getRequestURL().append("?");
					String qs = request.getQueryString();
					if(qs==null) qs="";
					
					String orderForm_front = "<a class=\"order-href\" href=\"" + url + urlHandler.getParameter(qs, "order=%s") + "\">";
					String orderForm_tail = "</a> <a class=\"order-href\" href=\"" + url + urlHandler.getParameter(qs, "order=%s") + "\"><span class=\"fa fa-caret-%s\"></span></a>";
					String order_front = "";
					String order_tail = "";
					
					if (order.equals("contestId-asc")) {
						order_front = String.format(orderForm_front, "");
						order_tail = String.format(orderForm_tail, "contestId-desc", "up");
					}
					else if (order.equals("contestId-desc")) {
						order_front = String.format(orderForm_front, "");
						order_tail = String.format(orderForm_tail, "contestId-asc", "down");
					}
					else {
						order_front = String.format(orderForm_front, "contestId-asc");
						order_tail = "</a>";
					}
					
					out.print("<td style=\"width:100px\">" + order_front + "<b>번호<b>" + order_tail + "</td>");
				  %>
				  <%
					if (order.equals("subject-asc")) {
						order_front = String.format(orderForm_front, "");
						order_tail = String.format(orderForm_tail, "subject-desc", "up");
					}
					else if (order.equals("subject-desc")) {
						order_front = String.format(orderForm_front, "");
						order_tail = String.format(orderForm_tail, "subject-asc", "down");
					}
					else {
						order_front = String.format(orderForm_front, "subject-asc");
						order_tail = "</a>";
					}
					
					out.print("<td>" + order_front + "<b>제목<b>" + order_tail + "</td>");
				  %>
				  <%
					if (order.equals("startTime-asc")) {
						order_front = String.format(orderForm_front, "");
						order_tail = String.format(orderForm_tail, "startTime-desc", "up");
					}
					else if (order.equals("startTime-desc")) {
						order_front = String.format(orderForm_front, "");
						order_tail = String.format(orderForm_tail, "startTime-asc", "down");
					}
					else {
						order_front = String.format(orderForm_front, "startTime-asc");
						order_tail = "</a>";
					}
					
					out.print("<td style=\"width:150px\">" + order_front + "<b>시작 기한<b>" + order_tail + "</td>");
				  %>
				  <%
					if (order.equals("endTime-asc")) {
						order_front = String.format(orderForm_front, "");
						order_tail = String.format(orderForm_tail, "endTime-desc", "up");
					}
					else if (order.equals("endTime-desc")) {
						order_front = String.format(orderForm_front, "");
						order_tail = String.format(orderForm_tail, "endTime-asc", "down");
					}
					else {
						order_front = String.format(orderForm_front, "endTime-asc");
						order_tail = "</a>";
					}
					
					out.print("<td style=\"width:150px\">" + order_front + "<b>종료 기한<b>" + order_tail + "</td>");
				  %>
				  </tr>
				  <%
					java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					String today = formatter.format(new java.util.Date());

					while(rs.next()){
						String startTime = rs.getString("startTime");
						startTime = startTime.substring(0, startTime.lastIndexOf("."));
						
						String endTime = rs.getString("endTime");
						endTime = endTime.substring(0, endTime.lastIndexOf("."));
				  %>
                  <tr>
					<td><%=rs.getString("contestId")%></td>
                    <td class="mailbox-subject"><a href="./contestView.jsp?contest=<%=rs.getString("contestId")%>"><%=rs.getString("subject")%></a></td>
					<%if(endTime.compareTo(today) > 0){%>
						<td><%=startTime%></td>
						<td><%=endTime%></td>
					<%}else{%>
						<td style="text-decoration:line-through"><%=startTime%></td>
						<td style="text-decoration:line-through"><%=endTime%></td>
					<%}%>	
                  </tr>
				  <%}%>	
                  </tbody>
                </table>
                <!-- /.table -->
              </div>
              <!-- /.mail-box-messages -->
            </div>
            <!-- /.box-body -->
            <div class="box-footer no-padding">
              <div class="mailbox-controls" style="text-align:center">

                  <div class="btn-group">
		
				  
					<%
						url = request.getRequestURL().append("?");
						qs = request.getQueryString();
						if(qs==null)
							qs="";
						
						if(pageNum==1)
							out.print("<button type=\"button\" class=\"btn btn-default btn-sm disabled\"><i class=\"fa fa-chevron-left\"></i></button>");
						else
							out.print("<button type=\"button\" class=\"btn btn-default btn-sm\" onclick=\"location.href='"+url+urlHandler.getParameter(qs,"page="+(pageNum-1))+"'\" ><i class=\"fa fa-chevron-left\"></i></button>");
						for(int i=pageLengthStart; i<pageLengthStart+pageLength; i++){
							
							if(pageNum == i)
								out.print("<button type=\"button\" class=\"btn btn-default btn-sm disabled\">"+i+"</button>");
							else
								out.print("<button type=\"button\" class=\"btn btn-default btn-sm\" onclick=\"location.href='"+url+urlHandler.getParameter(qs,"page="+i)+"'\" >"+i+"</button>");
						}
						if(pageNum==allPageLength)
							out.print("<button type=\"button\" class=\"btn btn-default btn-sm disabled\"><i class=\"fa fa-chevron-right\"></i></button>");
						else
							out.print("<button type=\"button\" class=\"btn btn-default btn-sm\" onclick=\"location.href='"+url+urlHandler.getParameter(qs,"page="+(pageNum+1))+"'\" ><i class=\"fa fa-chevron-right\"></i></button>");
						
						DBUtil.close(conn);
						DBUtil.close(pstmt);
					%>
                    
                  </div>
                  <!-- /.btn-group -->

              </div>
            </div>
          </div>
          <!-- /. box -->
        </div>

    </section>
    <!-- /.content -->
  </div>
  <!-- /.content-wrapper -->

 <%@include file="include/footer.jsp"%>
