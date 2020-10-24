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
	
	// Request - Contest Id
	String contestIdStr = request.getParameter("contest");
	int contestId;
	if (contestIdStr == null || !isNum(contestIdStr))
		return ;
	contestId = Integer.parseInt(contestIdStr);
	
	
	//＊＊＊＊＊대회 정보＊＊＊＊＊//
	// 대회 이름
	Connection conn = DBUtil.getMySqlConnection();
	String sql = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
	
	String contestSubejct;
	
	sql = "select * from contest where contestId=?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, contestId);
    rs = pstmt.executeQuery();
	
	if (rs == null || !rs.next()) {
		if (rs != null)
			DBUtil.close(rs);
		DBUtil.close(pstmt);
		DBUtil.close(conn);
		return;
	}
	contestSubejct = rs.getString("subject");
	
	DBUtil.close(rs);
	DBUtil.close(pstmt);
	
	// 대회 문제 수
	int probNum;
	
	sql = "select count(*) from question where displayNone=\"false\" and contestId=?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, contestId);
    rs = pstmt.executeQuery();
	
	if (rs == null || !rs.next()) {
		if (rs != null)
			DBUtil.close(rs);
		DBUtil.close(pstmt);
		DBUtil.close(conn);
		return;
	}
	
	probNum = rs.getInt(1);
	DBUtil.close(rs);
	DBUtil.close(pstmt);
	
	DBUtil.close(conn);
	
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
        <small>대회 순위표입니다.</small>
      </h1>
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
					  %>
					  <tr>
						<td><%= ++rankCount %></td>
						<td class="mailbox-name"><%= user.userName %></td>
						<td class="mailbox-subject"><%= user.completeCount %> / <%= probNum %></td>
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
    <!-- /.content -->
  </div>
  <!-- /.content-wrapper -->

 <%@include file="include/footer.jsp"%>
