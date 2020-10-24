<%@ page session="false"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
 
<%@include file="include/header.jsp"%>

  <!-- Content Wrapper. Contains page content -->
<div class="content-wrapper" style="height:873px">
<div id="loader"><div class="loader-text"><p>LOADING...</p></div></div>
    <header class="algo-header">
        <aside id="menu">dd</aside>
        <article class="probnum">
        <h1>
                뭐야 이건ㄴ
        </h1>
        </article>
        <article class="userinfo"></article>
        <aside id="lang">
            <span class="selectedlang">C</span>
            <div class="languages">
                <p class="C">C</p>
                <p class="Cpp">C++</p>
                <p class="Java">Java</p>
                <p class="Python2">Python2</p>
                <p class="Python3">Python3</p>
            </div>
        </aside>
    </header>
    <section class="algo-section">
        <article class="problem">
            <p>문제1 안녕</p>
        </article>
        <div class="horizontal"></div>

        <article class="code">
            <textarea id="editor"></textarea>
        </article>

        <div class="vertical"></div>
        <article class="result">
            result
        </article>

    </section>
    <footer class="algo-footer">
            <div id="sender">제출</div>
            <div id="checker">실행</div>
      
        <script>
            var textarea = document.getElementById('editor');
            var editor = CodeMirror.fromTextArea(textarea, {
                mode: "text/x-csrc",
                lineNumbers: true,
                lineWrapping: true,
				indentWithTabs:true,
				indentUnit:4,
                theme: "base16-dark",
                styleActiveLine: true,
                matchBrackets: true,
            });
        </script>
    </footer>
  </div>
  <!-- /.content-wrapper -->

 <%@include file="include/footer.jsp"%>
