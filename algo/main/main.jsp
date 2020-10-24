<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
 
<%@include file="include/header.jsp"%>
<%

	
	Connection conn = DBUtil.getMySqlConnection();
	String sql = "select userId,userName, count(status) as cnt, max(date) as date from (select distinct userId,userName, status, questionId,  max(date) as date from userLog where status = \"Complete\" and questionId in (select questionId from question where contestId is null) group by userId,userName,status,questionId)data where userId not in (select professor_id from kgu_cs_web.professors) group by userId,userName order by cnt desc, date asc limit 10;";
    PreparedStatement pstmt = null;

    pstmt = conn.prepareStatement(sql);
    ResultSet rank_rs = pstmt.executeQuery();
	
	sql = "select questionId,subject,date from question where to_days(now())-to_days(date) <= 7 and displayNone=\"false\" and contestId is null order by date desc limit 5";
	pstmt = conn.prepareStatement(sql);
	ResultSet newPb_rs = pstmt.executeQuery();
	
	sql = "select questionId, result, subject from question natural join (select questionId, round(a/b*100) as result from (select questionId,count(*) as a from (select distinct userId, questionId, status, language  from userLog where status = \"Complete\")data group by questionId)data1 natural join (select questionId,count(*) as b from (select distinct userId, questionId, language from userLog)data2 group by questionId)data3 order by result limit 5)data5";
	pstmt = conn.prepareStatement(sql);
	ResultSet lowCor_rs = pstmt.executeQuery();
%>

<script src="./bower_components/Flot/jquery.flot.js"></script>
<script src="./bower_components/Flot/jquery.flot.categories.js"></script>
<script src="./bower_components/Flot/jquery.flot.resize.js"></script>

  <!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
      <h1>
        Programming Practice Page
        <small>Kyonggi Univ. Computer Science P3</small>
      </h1>
    </section>

    <!-- Main content -->
    <section class="content container-fluid">
<section class="content">
        <div class="col-md-6">
          <div class="box">
            <div class="box-header with-border">
              <h3 class="box-title">최신 문제</h3>
            </div>
            <!-- /.box-header -->
            <div class="box-body">
              <table class="table table-bordered">
                <tr>
                  <th style="width: 10px">#</th>
                  <th>문제 이름</th>
                  <th>업로드 날짜</th>
                </tr>
				<%
				int cnt=1;
				while(newPb_rs.next()){
				%>
                <tr>
                  <td><%=cnt%>.</td>
                  <td><a href="pracPlace.jsp?prob=<%=newPb_rs.getString(1)%>"><%=newPb_rs.getString(2)%></a></td>
                  <td>
                      <%=newPb_rs.getString(3).substring(0, newPb_rs.getString(3).lastIndexOf("."))%>
                  </td>
                </tr>
				<%
				cnt++;
				}%>
              </table>
			  </div>
			</div>
            
            <!-- /.box-body -->
          </div>      
		   <div class="col-md-6">
          <div class="box">
            <div class="box-header with-border">
              <h3 class="box-title">정답률이 낮은 연습문제</h3>
            </div>
            <!-- /.box-header -->
            <div class="box-body">
              <table class="table table-bordered">
                <tr>
                  <th style="width: 10px">#</th>
                  <th>문제 이름</th>
                  <th style="width: 30%">정답률</th>
                  <th style="width: 40px">%</th>
                </tr>
				<%
				cnt = 1;
				while(lowCor_rs.next()){
					int per = lowCor_rs.getInt(2);
					String color = null;
					String bcolor = null;
					if(0<=per && per <30){
						color = "progress-bar progress-bar-danger";
						bcolor = "badge bg-red";
					} else if (30<=per && per<55){
						color = "progress-bar progress-bar-yellow";
						bcolor = "badge bg-yellow";
					} else if (55<=per && per<80){
						color = "progress-bar progress-bar-primary";
						bcolor = "badge bg-light-blue";
					} else if (80<=per && per<=100){
						color = "progress-bar progress-bar-success";
						bcolor = "badge bg-green";
					}
				%>
                <tr>
                  <td><%=cnt%></td>
                  <td><a href="pracPlace.jsp?prob=<%=lowCor_rs.getString(1)%>"><%=lowCor_rs.getString(3)%></a></td>
                  <td>
                    <div class="progress progress-xs">
                      <div class="<%=color%>" style="width: <%=lowCor_rs.getString(2)%>%"></div>
                    </div>
                  </td>
                  <td><span class="<%=bcolor%>"><%=lowCor_rs.getString(2)%>%</span></td>
                </tr> 
				<%cnt++; }%>
              </table>
			  </div>
			</div>
            
            <!-- /.box-body -->
          </div>      
	  </section>
<div class="col-md-12">
<div class="box box-primary">
            <div class="box-header with-border">
              <i class="fa fa-bar-chart-o"></i>
              <h3 class="box-title">연습문제 풀이 랭킹<br><small>같은문제를 다른 언어로 풀 경우도 카운트 됨</small></h3>

              <div class="box-tools pull-right">
               
              </div>
            </div>
            <div class="box-body">
              <div id="bar-chart" style="height: 300px;"></div>
            </div>
            
    </section>
    <!-- /.content -->
  </div>
  </div>
	  </div>
  <script>
 var bar_data = {
      data : [
	  <%
		String data = "";
		while(rank_rs.next()){
		data += "['"+rank_rs.getString("userId")+"<br>"+rank_rs.getString("userName")+"', "+rank_rs.getInt("cnt")+"],";
		}
		data = data.substring(0, data.lastIndexOf(","));
		data+="],";
		out.print(data);
	  %>
	  
      color: '#3c8dbc'
    }
    $.plot('#bar-chart', [bar_data], {
      grid  : {
        borderWidth: 1,
        borderColor: '#f3f3f3',
        tickColor  : '#f3f3f3'
      },
      series: {
        bars: {
          show    : true,
          barWidth: 0.5,
          align   : 'center'
        }
      },
      xaxis : {
        mode      : 'categories',
        tickLength: 0
      }
    })
  </script>
  
  
 <%@include file="include/footer.jsp"%>

