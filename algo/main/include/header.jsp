<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="algo.DBUtil"%>
<%@page import="java.util.*"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="algo.GroupManager"%>
<%
	Connection c = DBUtil.getMySqlConnection();
	GroupManager groupManager = new GroupManager(c);

	
%>
<!DOCTYPE html>
<!--
This is a starter template page. Use this page to start your new project from
scratch. This page gets rid of all links and provides the needed markup only.
-->
<html>
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>P3@KGU</title>
  <!-- Tell the browser to be responsive to screen width -->
  <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
  <link rel="stylesheet" href="bower_components/bootstrap/dist/css/bootstrap.min.css">
  <!-- Font Awesome -->
  <link rel="stylesheet" href="bower_components/font-awesome/css/font-awesome.min.css">
  <!-- Ionicons -->
  <link rel="stylesheet" href="bower_components/Ionicons/css/ionicons.min.css">
  <!-- Theme style -->
  <link rel="stylesheet" href="dist/css/AdminLTE.min.css">
  <!-- AdminLTE Skins. We have chosen the skin-blue for this starter
        page. However, you can choose any other skin. Make sure you
        apply the skin class to the body tag so the changes take effect. -->
  <link rel="stylesheet" href="dist/css/skins/_all-skins.css">

  <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
  <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
  <!--[if lt IE 9]>
  <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
  <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
  <![endif]-->

  <!-- Google Font -->
  <link rel="stylesheet"
        href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,600,700,300italic,400italic,600italic" />
		
    <link rel="stylesheet" href="./lib/codemirror.css" />
    <link rel="stylesheet" href="./theme/base16-dark.css" />
    <!--<link rel="stylesheet" href="./lib/algo.css" />-->
	<link rel="stylesheet" href="./lib/algo2.css" />
	<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
	<script src="https://code.jquery.com/jquery-3.1.0.min.js"></script>
	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <script type="text/javascript" src="./lib/codemirror.js"></script>
    <script type="text/javascript" src="./lib/clike.js"></script>
    <script type="text/javascript" src="./lib/python.js"> </script>
	<script src="./lib/algo.js"></script>
    <script type="text/javascript" src="./addon/edit/matchbrackets.js"></script>
	
</head>
<!--
BODY TAG OPTIONS:
=================
Apply one or more of the following classes to get the
desired effect
|---------------------------------------------------------|
| SKINS         | skin-blue                               |
|               | skin-black                              |
|               | skin-purple                             |
|               | skin-yellow                             |
|               | skin-red                                |
|               | skin-green                              |
|---------------------------------------------------------|
|LAYOUT OPTIONS | fixed                                   |
|               | layout-boxed                            |
|               | layout-top-nav                          |
|               | sidebar-collapse                        |
|               | sidebar-mini                            |
|---------------------------------------------------------|
-->
  <%
 
	if(session.getAttribute("studentId")==null){
		out.print("login plz");
		return;
	}

%>

<body class="hold-transition skin-purple-light sidebar-mini">
<div class="wrapper">

  <!-- Main Header -->
  <header class="main-header">

    <!-- Logo -->
    <a href="main.jsp" class="logo">
      <!-- mini logo for sidebar mini 50x50 pixels -->
      <span class="logo-mini"><b>P3</b></span>
      <!-- logo for regular state and mobile devices -->
      <span class="logo-lg"><b>P3</b>@<b>KGU</b></span>
    </a>

    <!-- Header Navbar -->
    <nav class="navbar navbar-static-top" role="navigation">
      <!-- Sidebar toggle button-->
      <a href="#" class="sidebar-toggle" data-toggle="push-menu" role="button">
        <span class="sr-only">Toggle navigation</span>
      </a>
      <!-- Navbar Right Menu -->
      <div class="navbar-custom-menu">
	
        <ul class="nav navbar-nav">

          <!-- Notifications Menu -->

          
          <!-- User Account Menu -->
          <li class="user user-menu">

            <a href="#" >
              <span class="hidden-xs"><%=(String)session.getAttribute("name")%></span>
			</a>
          </li>
          <!-- Control Sidebar Toggle Button -->
          <li>
            <a href="#" data-toggle="control-sidebar"><i class="fa fa-gears"></i></a>
          </li>
        </ul>
      </div>
    </nav>
  </header>
  <!-- Left side column. contains the logo and sidebar -->
  <aside class="main-sidebar">

    <!-- sidebar: style can be found in sidebar.less -->
    <section class="sidebar">

      <!-- Sidebar user panel (optional) -->
      <div class="user-panel">
        <div class="pull-left image">
          <img src="https://kknock.org/files/attach/images/161/f816ea43a272835a84d8d58ac28dc77f.jpg" class="img-circle" alt="User Image">
        </div>
        <div class="pull-left info">
          <p><%=(String)session.getAttribute("name")%></p>
          <!-- Status -->
          <a href="#"><i class="fa fa-circle text-success"></i> <%=(String)session.getAttribute("department")%></a>
        </div>
      </div>
      <!-- Sidebar Menu -->
      <ul class="sidebar-menu" data-widget="tree">
        <li class="header">Menu</li>
        <!-- Optionally, you can add icons to the links -->
        <li class="active"><a href="noticeBoard.jsp"><i class="fa fa-link"></i> <span>공지사항</span></a></li>
        <li class="treeview">
          <a href="#"><i class="fa fa-link"></i> <span>공부방</span>
            <span class="pull-right-container">
                <i class="fa fa-angle-left pull-right"></i>
              </span>
          </a>
          <ul class="treeview-menu">
			<li style="text-align:center;background-color:#605ca8;height:20px; color:white; onmouseover:none"><b>내 그룹</b></li>
			<%
				
				groupManager.printByUserGroup(c, out, (String)session.getAttribute("studentId"), 0);
				DBUtil.close(c);
			%>
			
			<li class="divider" style="height: 1px;margin: 9px 0; overflow: hidden;background-color: #605ca8;"></li>
			<li><a href="pracTest.jsp">프로그래밍 연습</a></li>
            <li><a href="pracBoard.jsp">전체 연습문제</a></li>
            <li><a href="contestBoard.jsp">대회</a></li>
			<li class="divider" style="height: 1px;margin: 9px 0; overflow: hidden;background-color: #605ca8;"></li>
          </ul>
		  
        </li>
		<%
			if((String)session.getAttribute("isProfessor") == "true" || (String)session.getAttribute("isAdmin") == "true"){
		%>
		<li class="treeview">
          <a href="#"><i class="fa fa-link"></i> <span>문제 관리</span>
            <span class="pull-right-container">
                <i class="fa fa-angle-left pull-right"></i>
              </span>
          </a>
          <ul class="treeview-menu">
            <li><a href="insertProb.jsp">연습 문제 제출</a></li>
            <li><a href="insertContest.jsp">대회 등록</a></li>
			 <li><a href="disableBoard.jsp">비공개 문제 확인</a></li>
          </ul>
        </li>
		<li class="treeview">
          <a href="#"><i class="fa fa-link"></i> <span>관리</span>
            <span class="pull-right-container">
                <i class="fa fa-angle-left pull-right"></i>
              </span>
          </a>
          <ul class="treeview-menu">
            <li><a href="./groupEdit.jsp">그룹 관리</a></li>
            <li><a href="./solvedViewBoard.jsp">풀이 현황</a></li>
			
          </ul>
        </li>
		<%}%>
        
      </ul>
      <!-- /.sidebar-menu -->
    </section>
    <!-- /.sidebar -->
  </aside>
