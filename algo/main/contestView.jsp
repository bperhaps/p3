<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="algo.urlHandler"%>
<%@ page import="algo.DBUtil"%>
<%@ page import="algo.ContestRankMgr"%>
<%@ page import="java.sql.*"%>
<%@ include file="include/header.jsp"%>

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
	String studentId = (String)session.getAttribute("studentId");
	if (studentId == null) return ;
	
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
	pstmt.setString(1, studentId);
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
	
	/******대회************/
	String contestIdString = request.getParameter("contest");
	String contest_sql = "";
	if (contestIdString == null)
		return ;
	
	int contestId = Integer.parseInt(contestIdString);
	
	
	/*****대회 정보********/
	sql = "select * from contest where contestId=?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, contestId);
    rs = pstmt.executeQuery();
	
	if (rs == null || !rs.next())
		return;
	String contestSubejct = rs.getString("subject");
	String contestContext = rs.getString("context");
	
	DBUtil.close(rs);
	DBUtil.close(pstmt);
	
	/*****대회 관리자 정보********/
	sql = "select userId from contestAdmin where contestId=?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, contestId);
	rs = pstmt.executeQuery();
	
	if (rs == null)
		return;
	
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
	
	/************누군가가 나중에 이 주석을 보거든***********************/
	/***********201215595 손민성 갈려 들어갔다고 전하시오&&&************/
	/**********나 실은 JSP 처음만져봄 ㅎ.ㅎ.ㅎ.ㅎ.ㅎ.ㅎ 헿 *************/
	String allDataSql=null;
	String search = request.getParameter("search");
	String category = request.getParameter("category");
	if(search != null && category != null){
		if(category.equals("writer")){
			sql = "select * from question where displayNone=\"false\" and contestId=? and writer like ? " + order_sql + " limit ?,?";
			allDataSql = "select count(*) from question where  displayNone!=\"false\" and contestId=? and writer like ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, contestId);
			pstmt.setString(2, "%"+search+"%");
			pstmt.setInt(3, (pageNum-1)*contentView);
			pstmt.setInt(4, contentView);
		}
		else if(category.equals("subject")){
			sql = "select * from question where displayNone=\"false\" and contestId=? and subject like ? " + order_sql + " limit ?,?";
			allDataSql = "select count(*) from question where displayNone=\"false\" and contestId=? and subject like ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, contestId);
			pstmt.setString(2, "%"+search+"%");
			pstmt.setInt(3, (pageNum-1)*contentView);
			pstmt.setInt(4, contentView);
		}
		else{
			sql = "select * from question where displayNone=\"false\" and contestId=? " + order_sql + " limit ?,?";
			allDataSql = "select count(*) from question where displayNone=\"false\" and contestId=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, contestId);
			pstmt.setInt(2, (pageNum-1)*contentView);
			pstmt.setInt(3, contentView);
		}
		
    } else {
		// questionId, writer, subject, displayNone
		sql = "select *,case when deadline>now() then 1 when deadline<now() then 3 else 2 end as me from question where displayNone=\"false\" and contestId=? " + order_sql + " limit ?,?";
		allDataSql = "select count(*) from question where displayNone=\"false\" and contestId=?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, contestId);
		pstmt.setInt(2, (pageNum-1)*contentView);
		pstmt.setInt(3, contentView);
	}
	
	/*****전체문제 수 구함********/
    PreparedStatement pstmt_a = conn.prepareStatement(allDataSql);
	pstmt_a.setInt(1, contestId);
	if(allDataSql.indexOf("like")!=-1)
		pstmt_a.setString(2, "%"+search+"%");
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
	
	//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
	// 순위표
	ArrayList<ContestRankMgr.User> rankList = ContestRankMgr.GetRank(contestId);
	
%>

  <!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
      <h1>
        <%= contestSubejct %>
        <small>대회 입니다.</small>
      </h1>
    </section>

	<section class="content container-fluid algo-css">
		<article class="problem">
			<div class="col-md-12">
				<div class="box">
					<div class="box-header">
						<h3 class="box-title">대회 설명</h3>
						<% if (isAdmin) {%>
							<div class="btn-group pull-right">
								<button type="button" class="btn btn-default btn-flat" onClick="location.href='../removeContest.jsp?contest=<%=contestId%>'" >삭제</button>
							</div>
							<div class="btn-group pull-right">
								<button type="button" class="btn btn-default btn-flat" style="margin-right: 5px" onclick="location.href='./modifyContest.jsp?contest=<%=contestId%>'">수정</button>
							</div>
						<% } %>
					</div>
					<div class="box-body table-responsive pad">
						<p>
							<%= contestContext %>
						</p>
					</div>
				</div>
			</div>
		</article>
	</section>
	
    <!-- 순위표 -->
	<section class="content container-fluid">
     <div class="col-md-12">
          <div class="box box-primary">
            <div class="box-header with-border">
              <h3 class="box-title">대회 순위표</h3>
            </div>
            <!-- /.box-header -->
            <div class="box-body no-padding">
              <div class="mailbox-controls">
                <!-- Check all button -->
				<div class="btn-group">
                  <button type="button" class="btn btn-default btn-sm" onclick="location.reload()"><i class="fa fa-refresh"></i></button>
                </div>
				<div class="btn-group pull-right">
					<button type="button" class="btn btn-default btn-flat" style="bottom: 2px" onclick="location.href='./contestRankView.jsp?contest=<%=contestId%>'">전체 순위 보기</button>
				</div>
                <!-- /.pull-right -->
              </div>
              <div class="table-responsive mailbox-messages">
                <table class="table table-hover table-striped">
                  <tbody style="text-align:center">
					  <tr>
						<td>순위</td>
						<td class="mailbox-name">이름</td>
						<td class="mailbox-subject">맞힌 문제 수 / 총 문제 수</td>
						<td class="mailbox-date">점수 변동 시간</td>
					  </tr>
					  <%	
						int rankCount = 0;
						for (ContestRankMgr.User user : rankList) { 
							if (++rankCount > 5) break;
					  %>
					  <tr>
						<td><%= rankCount %></td>
						<td class="mailbox-name"><%= user.userName %></td>
						<td class="mailbox-subject"><%= user.completeCount %> / <%= allDataNum %></td>
						<td class="mailbox-date"><%= user.date %></td>
					  </tr>
					  <% } %>
                  </tbody>
                </table>
                <!-- /.table -->
              </div>
              <!-- /.mail-box-messages -->
            </div>
            <!-- /.box-body -->
            <div class="box-footer no-padding"></div>
          </div>
          <!-- /. box -->
        </div>
    </section>
	
    <!-- Main content -->
    <section class="content container-fluid">
     <div class="col-md-12">
          <div class="box box-primary">
            <div class="box-header with-border">
              <h3 class="box-title">대회 문제 목록</h3>
				<% if (isAdmin) { %>
				  <div class="btn-group pull-right">
					<button type="button" class="btn btn-default btn-flat" onclick="location.href='./insertContestProb.jsp?contest=<%=contestId%>'">문제 추가하기</button>
				  </div>
				<% } %>
				<!-- /.box-tools -->
            </div>
            <!-- /.box-header -->
            <div class="box-body no-padding">
              <div class="mailbox-controls">
                <!-- Check all button -->
				<div class="btn-group">
                  <button type="button" class="btn btn-default btn-sm" onclick="location.reload()"><i class="fa fa-refresh"></i></button>
                </div>
  
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
				  %>
                  <tr>
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
						
						DBUtil.close(pstmt);
						DBUtil.close(conn);
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
