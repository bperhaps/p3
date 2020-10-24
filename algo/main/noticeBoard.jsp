
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
	int contentView = 5;
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

	/************누군가가 나중에 이 주석을 보거든***********************/
	/***********201215595 손민성 갈려 들어갔다고 전하시오&&&************/
	/**********나 실은 JSP 처음만져봄 ㅎ.ㅎ.ㅎ.ㅎ.ㅎ.ㅎ 헿 *************/	
	
	String allDataSql=null;
	sql = "select * from notice order by noticeNumber desc limit ?, ?";
	allDataSql = "select count(*) from notice";
	
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, (pageNum-1)*contentView);
	pstmt.setInt(2, contentView);
	
	/*****전체문제 수 구함********/
	
    PreparedStatement pstmt_a = conn.prepareStatement(allDataSql);
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
        공지사항
        <small>공지사항 목록입니다.</small>
      </h1>

    </section>

    <!-- Main content -->
    <section class="content container-fluid">
	
     <div class="col-md-12">
          <div>
            <!-- /.box-header -->
            <div class="box-body no-padding">
              <div>


				  <%
					while(rs.next()){
						String date = rs.getString("date");
						date = date.substring(0, date.lastIndexOf("."));
				  %>
				
			<div class="box box collapsed-box">
			
				<div class="box-header">
				<div class="pull-right box-tools">
                <button type="button" class="btn btn-default btn-sm" data-widget="collapse" data-toggle="tooltip"
                        title="Collapse">
                  <i class="fa fa-plus"></i></button>
				  
              </div>
				<div>
				
					<%=rs.getInt("noticeNumber")%>
					<%=rs.getString("writer")%>
					<%= date %>
				<h5><b>
							<%=rs.getString("subject")%>		
				</b>
				</h5>
				<%
					if(rs.getString("userId").equals((String)session.getAttribute("studentId"))){%>
						<button type="button" class="btn btn-default btn-flat" onClick="location.href='../removeNotice.jsp?no=<%=rs.getInt("noticeNumber")%>'" >삭제</button>
						<button type="button" class="btn btn-default btn-flat" onClick="location.href='./modifyNotice.jsp?no=<%=rs.getInt("noticeNumber")%>'" >수정</button>
					<%}%>
				</div>
              <!-- tools box -->
              
              <!-- /. tools -->
            </div>
            <!-- /.box-header -->
            <div style="display: none;" class="box-body pad">
              		<%=rs.getString("context")%>
            </div>
          </div>
				
				  <% } %>

                <!-- /.table -->
              </div>
              <!-- /.mail-box-messages -->
            </div>
            <!-- /.box-body -->
            <div class="box-footer no-padding">
              <div class="mailbox-controls" style="text-align:center">

                  <div class="btn-group">
					<%
						StringBuffer url = request.getRequestURL().append("?");
						String qs = request.getQueryString();
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
				  <%
					if((String)session.getAttribute("isProfessor") == "true" || (String)session.getAttribute("isAdmin") == "true"){
						%>
				  <button type="button" class="btn btn-default btn-flat" style="float:right; margin-bottom: 5px" onClick="location.href='insertNotice.jsp'" >글 작성</button>
					<%}%>
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
