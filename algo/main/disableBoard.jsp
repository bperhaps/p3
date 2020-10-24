
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
 <%@ page import="java.util.*"%>
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
	
	/******문제 풀었나 안풀었나 구함 개힘드네 진짜************/
	ArrayList<Integer> solvedProb = new ArrayList<Integer>();
    sql = "select distinct questionId from userLog where userId=? and status=?";
    pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, (String)session.getAttribute("studentId"));
	pstmt.setString(2, "Complete");
    rs = pstmt.executeQuery();

	while(rs.next()){
		solvedProb.add(rs.getInt(1));
	}
	
	/******정렬************/
	String order = request.getParameter("order");
	String order_sql = "order by me";
	if (order == null) order = "";
	if (order.equals(""))				order_sql = "order by me";
	if (order.equals("deadline-asc"))	order_sql = "order by deadline is null, deadline asc, questionId desc";
	else if (order.equals("deadline-desc"))				order_sql = "order by deadline is null, deadline desc, questionId desc";
	else if (order.equals("questionId-asc"))			order_sql = "order by questionId asc";
	else if (order.equals("questionId-desc"))			order_sql = "order by questionId desc";
	else if (order.equals("writer-asc"))				order_sql = "order by writer asc";
	else if (order.equals("writer-desc"))				order_sql = "order by writer desc";
	else if (order.equals("subject-asc"))				order_sql = "order by subject asc";
	else if (order.equals("subject-desc"))				order_sql = "order by subject desc";
	else if (order.equals("level-asc"))					order_sql = "order by level asc";
	else if (order.equals("level-desc"))				order_sql = "order by level desc";
		
	
	/************누군가가 나중에 이 주석을 보거든***********************/
	/***********201215595 손민성 갈려 들어갔다고 전하시오&&&************/
	/**********나 실은 JSP 처음만져봄 ㅎ.ㅎ.ㅎ.ㅎ.ㅎ.ㅎ 헿 *************/	
	
	String allDataSql=null;
	String search = request.getParameter("search");
	String category = request.getParameter("category");
	if(search != null && category != null){
		if(category.equals("writer")){
			sql = "select *,case when deadline>now() then 1 when deadline<now() then 3 else 2 end as me from question where displayNone=\"true\" and writer like ? " + order_sql + " limit ?,?";
			allDataSql = "select count(*) from question where  displayNone!=\"true\" and writer like ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, "%"+search+"%");
			pstmt.setInt(2, (pageNum-1)*contentView);
			pstmt.setInt(3, contentView);
		}
		else if(category.equals("subject")){
			sql = "select *,case when deadline>now() then 1 when deadline<now() then 3 else 2 end as me from question where displayNone=\"true\" and subject like ? " + order_sql + " limit ?,?";
			allDataSql = "select count(*) from question where displayNone=\"true\" and subject like ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, "%"+search+"%");
			pstmt.setInt(2, (pageNum-1)*contentView);
			pstmt.setInt(3, contentView);
		}
		else{
			sql = "select *,case when deadline>now() then 1 when deadline<now() then 3 else 2 end as me from question where displayNone=\"true\" " + order_sql + " limit ?,?";
			allDataSql = "select count(*) from question where displayNone=\"true\"";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, (pageNum-1)*contentView);
			pstmt.setInt(2, contentView);
		}
		
    } else {
		// questionId, writer, subject, displayNone
		sql = "select *,case when deadline>now() then 1 when deadline<now() then 3 else 2 end as me from question where displayNone=\"true\" " + order_sql + " limit ?,?";
		allDataSql = "select count(*) from question where displayNone=\"true\"";
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
        연습문제
        <small>연습문제 목록입니다.</small>
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
							<li><a class="category-writer">출제자</a></li>
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
				  <% if(session.getAttribute("isAdmin")=="true"){ %>
					<td style="width:50px">선택</td>
				  <% } %>
				  <%
					StringBuffer url = request.getRequestURL().append("?");
					String qs = request.getQueryString();
					if(qs==null) qs="";
					
					String orderForm_front = "<a class=\"order-href\" href=\"" + url + urlHandler.getParameter(qs, "order=%s") + "\">";
					String orderForm_tail = "</a> <a class=\"order-href\" href=\"" + url + urlHandler.getParameter(qs, "order=%s") + "\"><span class=\"fa fa-caret-%s\"></span></a>";
					String order_front = "";
					String order_tail = "";
					
					if (order.equals("questionId-asc")) {
						order_front = String.format(orderForm_front, "");
						order_tail = String.format(orderForm_tail, "questionId-desc", "up");
					}
					else if (order.equals("questionId-desc")) {
						order_front = String.format(orderForm_front, "");
						order_tail = String.format(orderForm_tail, "questionId-asc", "down");
						}
					else {
						order_front = String.format(orderForm_front, "questionId-asc");
						order_tail = "</a>";
					}
					
					out.print("<td style=\"width:100px\">" + order_front + "<b>번호<b>" + order_tail + "</td>");
				  %>
					<td style="width:30px"><i class="fa fa-star text-yellow"></td>
				  <%
					if (order.equals("writer-asc")) {
						order_front = String.format(orderForm_front, "");
						order_tail = String.format(orderForm_tail, "writer-desc", "up");
					}
					else if (order.equals("writer-desc")) {
						order_front = String.format(orderForm_front, "");
						order_tail = String.format(orderForm_tail, "writer-asc", "down");
						}
					else {
						order_front = String.format(orderForm_front, "writer-asc");
						order_tail = "</a>";
					}
					
					out.print("<td style=\"width:150px\">" + order_front + "<b>출제자<b>" + order_tail + "</td>");
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
					if (order.equals("deadline-asc")) {
						order_front = String.format(orderForm_front, "");
						order_tail = String.format(orderForm_tail, "deadline-desc", "up");
					}
					else if (order.equals("deadline-desc")) {
						order_front = String.format(orderForm_front, "");
						order_tail = String.format(orderForm_tail, "deadline-asc", "down");
						}
					else {
						order_front = String.format(orderForm_front, "deadline-asc");
						order_tail = "</a>";
					}
					
					out.print("<td style=\"width:150px\">" + order_front + "<b>기한<b>" + order_tail + "</td>");
				  %>
				  <%
					if (order.equals("level-asc")) {
						order_front = String.format(orderForm_front, "");
						order_tail = String.format(orderForm_tail, "level-desc", "up");
					}
					else if (order.equals("level-desc")) {
						order_front = String.format(orderForm_front, "");
						order_tail = String.format(orderForm_tail, "level-asc", "down");
						}
					else {
						order_front = String.format(orderForm_front, "level-asc");
						order_tail = "</a>";
					}
					
					out.print("<td style=\"width:70px\">" + order_front + "<b>난이도<b>" + order_tail + "</td>");
				  %>
				  </tr>
				  <%
					java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					String today = formatter.format(new java.util.Date());

					while(rs.next()){
						String deadline = rs.getString("deadline");
						if (deadline != null) 
							deadline = deadline.substring(0, deadline.lastIndexOf("."));
						else
							deadline = "기한 없음";
				  %>
                  <tr>
				  <% if(session.getAttribute("isAdmin")=="true"){%>
                    <td><input type="checkbox"></td>
				  <% } %>
				  <td><%=rs.getString("questionId")%></td>
                    <td class="mailbox-star">
					<%
						if(solvedProb.contains(Integer.parseInt(rs.getString("questionId"))))
							out.print("<i class=\"fa fa-star text-yellow\"></i>");
						else
							out.print("<i class=\"fa text-yellow fa-star-o\"></i>");
					%>
					</td>
                    <td class="mailbox-name"><%=rs.getString("writer")%></td>
                    <td class="mailbox-subject"><a href="./pracPlace.jsp?prob=<%=rs.getString("questionId")%>"><%=rs.getString("subject")%></a></td>
                    <%if(deadline.compareTo(today) > 0){%>
						<td>
					<%}else{%>
						<td style="text-decoration:line-through">
					<%}%>
							<%=deadline%>
					</td>
                    <td class="mailbox-date"><%=rs.getString("level")%></td>
                  </tr>
					<% } %>
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
