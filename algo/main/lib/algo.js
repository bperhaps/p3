String.prototype.replaceAll = function(org, dest) {
    return this.split(org).join(dest);
}


//칸 움직이는거 ㅇㅇ
$(function() {
    $(".code").resizable({
        minHeight: 100,
        handles: "s"
    });

});

function getRequest() {
    if (location.search.length > 1) {
        var get = new Object();
        var ret = location.search.substr(1).split('&');
        for (var i = 0; i < ret.length; i++) {
            var r = ret[i].split('=');
            get[r[0]] = r[1];
        }
        return get;
    } else {
        return false;
    }
}

// 검색
$(document).ready(function() {
	// 문제 목록
    $(".category-writer").click(function() {
        $(".selected_category").text($(".category-writer").text() + " ");
        $(".selected_category").append("<span class=\"fa fa-caret-down\"></span>");
        $(".input-search-category").attr("value", "writer");
    });
    $(".category-subject").click(function() {
        $(".selected_category").text($(".category-subject").text() + " ");
        $(".selected_category").append("<span class=\"fa fa-caret-down\"></span>");
        $(".input-search-category").attr("value", "subject");
    });
	
	// 문제 관리
    $(".category-userName").click(function() {
        $(".selected_category").text($(".category-userName").text() + " ");
        $(".selected_category").append("<span class=\"fa fa-caret-down\"></span>");
        $(".input-search-category").attr("value", "userName");
		$(".searchWrap").css("display","inline-block");
		$(".statusWrap").css("display","none");
		$(".langWrap").css("display","none");
    });
    $(".category-studentId").click(function() {
        $(".selected_category").text($(".category-studentId").text() + " ");
        $(".selected_category").append("<span class=\"fa fa-caret-down\"></span>");
        $(".input-search-category").attr("value", "studentId");
		$(".searchWrap").css("display","inline-block");
		$(".statusWrap").css("display","none");
		$(".langWrap").css("display","none");
    });
    $(".category-status").click(function() {
        $(".selected_category").text($(".category-status").text() + " ");
        $(".selected_category").append("<span class=\"fa fa-caret-down\"></span>");
        $(".input-search-category").attr("value", "status");
		$(".searchWrap").css("display","none");
		$(".statusWrap").css("display","inline-block");
		$(".langWrap").css("display","none");
    });
	$(".category-lang").click(function() {
        $(".selected_category").text($(".category-lang").text() + " ");
        $(".selected_category").append("<span class=\"fa fa-caret-down\"></span>");
        $(".input-search-category").attr("value", "language");
		$(".searchWrap").css("display","none");
		$(".statusWrap").css("display","none");
		$(".langWrap").css("display","inline-block");
    });
	
	// 문제-상태 관리
	$(".status-nomal").click(function() {
        $(".selected_status").text($(".status-nomal").text() + " ");
        $(".selected_status").append("<span class=\"fa fa-caret-down\"></span>");
		$("input[name=search]").val("");
    });
	$(".status-Complete").click(function() {
        $(".selected_status").text($(".status-Complete").text() + " ");
        $(".selected_status").append("<span class=\"fa fa-caret-down\"></span>");
		$("input[name=search]").val("Complete");
    });
    $(".status-CompileError").click(function() {
        $(".selected_status").text($(".status-CompileError").text() + " ");
        $(".selected_status").append("<span class=\"fa fa-caret-down\"></span>");
		$("input[name=search]").val("CompileError");
    });
    $(".status-TimeOver").click(function() {
        $(".selected_status").text($(".status-TimeOver").text() + " ");
        $(".selected_status").append("<span class=\"fa fa-caret-down\"></span>");
		$("input[name=search]").val("TimeOver");
    });
	$(".status-Failed").click(function() {
        $(".selected_status").text($(".status-Failed").text() + " ");
        $(".selected_status").append("<span class=\"fa fa-caret-down\"></span>");
		$("input[name=search]").val("Failed");
    });
	
	//문제-언어설정
	$(".search-nomal").click(function() {
		$(".selected_lang").text($(".search-nomal").text() + " ");
        $(".selected_lang").append("<span class=\"fa fa-caret-down\"></span>");
		$("input[name=search]").val("");

    });
	
	 $(".search-C").click(function() {
		$(".selected_lang").text($(".search-C").text() + " ");
        $(".selected_lang").append("<span class=\"fa fa-caret-down\"></span>");
		$("input[name=search]").val("C");

    });
    $(".search-Cpp").click(function() {
		$(".selected_lang").text($(".search-Cpp").text() + " ");
        $(".selected_lang").append("<span class=\"fa fa-caret-down\"></span>");
		$("input[name=search]").val("Cpp");

    });
    $(".search-Java").click(function() {
		$(".selected_lang").text($(".search-Java").text() + " ");
        $(".selected_lang").append("<span class=\"fa fa-caret-down\"></span>");;
		$("input[name=search]").val("Java");

    });
    $(".search-Python2").click(function() {
		$(".selected_lang").text($(".search-Python2").text() + " ");
        $(".selected_lang").append("<span class=\"fa fa-caret-down\"></span>");;
		$("input[name=search]").val("Python2");

    });
    $(".search-Python3").click(function() {
		$(".selected_lang").text($(".search-Python3").text() + " ");
        $(".selected_lang").append("<span class=\"fa fa-caret-down\"></span>");
		$("input[name=search]").val("Python3");

    });
});

// 체크박스
$(document).ready(function() {
	$("#allChecker").click(function(){
		if($("#allChecker").val() == "true") {
			// 모든 checkbox 설정
			$("input[type=checkbox]").prop("checked",true);
			$("#allChecker").val("false");
		} else {
			// 모든 checkbox 해제
			$("input[type=checkbox]").prop("checked", false);
			$("#allChecker").val("true");
		}
	});
});

// 다운로드
$(document).ready(function() {
	$(".downloadBtn").click(function(){

		if ($("input[name=source]:checked").length > 0 || $(this).attr("name") != null){}
		else	return ;
		
		var sourceObject = new Object;
		var sourceArray = new Array;
		
		var url = "../downloadSource.jsp";
        var params = new Object();
		params.questionId = $("#questionId").val();
		if($(this).attr("name") != null){
			sourceObject.name = "source";
			sourceObject.value = $(this).attr("name");
			sourceArray.push(sourceObject);
			params.sourceData = sourceArray;
		}
		else 
			params.sourceData = $("input[name=source]:checked").serializeArray();
	
        var jsonData = JSON.stringify(params);
		
		var downForm = document.downForm;
		downForm.action = url;
		downForm.method = 'post';
		downForm.target = 'download';
		downForm.jsonParam.value = jsonData;
		downForm.submit();
	});
	$("#downloadAllBtn").click(function(){
		var url = "../downloadSourceAll.jsp";
        var params = new Object();
		params.questionId = $("#questionId").val();
	
        var jsonData = JSON.stringify(params);
		
		var downForm = document.downForm;
		downForm.action = url;
		downForm.method = 'post';
		downForm.target = 'download';
		downForm.jsonParam.value = jsonData;
		downForm.submit();
	});
});

$(document).ready(function() {
    $("#high").click(function() {
        $("#level").text($("#high").text());
    });
    $("#middle").click(function() {
        $("#level").text($("#middle").text());
    });
    $("#low").click(function() {
        $("#level").text($("#low").text());
    });
});

//언어설정
$(document).ready(function() {
    $(".C").click(function() {
        editor.setOption("mode", "text/x-csrc");
        $(".selectedlang").text("C");

    });
    $(".Cpp").click(function() {
        editor.setOption("mode", "text/x-c++src");
        $(".selectedlang").text("C++");

    });
    $(".Java").click(function() {
        editor.setOption("mode", "text/x-java");
        $(".selectedlang").text("Java");

    });
    $(".Python2").click(function() {
        var mode = {
            name: "python",
            version: 2,
            singleLinesStringErrors: false
        };
        editor.setOption("mode", mode);
        $(".selectedlang").text("Python2");

    });
    $(".Python3").click(function() {
        var mode = {
            name: "python",
            version: 3,
            singleLinesStringErrors: false
        };
        editor.setOption("mode", mode);
        $(".selectedlang").text("Python3");

    });
});

//코드 보내는 부분
$(document).ready(function() {
	
	//소스 가져오기
	 $(".getSorce").click(function() {
        var url = "../getUserSorce.jsp";
        var params = new Object();

        params.probNumber = getRequest()['prob'];
        params.ext = $(".selectedlang").text();
		params.mode = $(this).attr("id");
        var jsonData = JSON.stringify(params);
		console.log(jsonData);
        $.ajax({
            type: "POST",
            url: url,
            dataType: "json",
            data: {
                jsonParam: jsonData
            },
            beforeSend: function() {
				for(var i=0; i<$(".overlay").length; i++)
					$(".overlay").eq(i).css("display", "table-cell");
            },
            success: function(args) {
               editor.getDoc().setValue(args.result);
            },
            error: function(e) {
                alert(e.responseText);
            },
            complete: function() {
				for(var i=0; i<$(".overlay").length; i++)
					$(".overlay").eq(i).hide();
            }
        });
    });
	
	
    //컴파일 하기위한..
    $("#sender").click(function() {
        var url = "../submitCode.jsp";
        var params = new Object();
	
        if ($("textarea[name=testInput_data]").length)
            params.inputData = $("textarea[name=testInput_data]").serializeArray();
        params.probNumber = getRequest()['prob'];
        params.code = editor.getValue();
        params.lang = $(".selectedlang").text();
        params.probHash = $("#probHash").val();
        params.mode = "prac";

		
        var jsonData = JSON.stringify(params);
        console.log(jsonData);

        $.ajax({
            type: "POST",
            url: url,
            dataType: "json",
            data: {
                jsonParam: jsonData
            },
            beforeSend: function() {
				for(var i=0; i<$(".overlay").length; i++)
					$(".overlay").eq(i).css("display", "table-cell");
            },
            success: function(args) {
                console.log(args);
                var result = "";
                if (args.result[0].result != "result") {
                    $(".result").html(args.result[0].result);
                } else {
                    if ($("textarea[name=testInput_data]").length==0){
                        $(".result").html(args.result[1].result);
					} else {
                        for (var i = 1; i < args.result.length; i++) {
                            result += (i) + "번째 케이스 : " + args.result[i].result + "<br>";
                        }
                        $(".result").html(result);
                    }
                }
            },
            error: function(e) {
                alert(e.responseText);
            },
            complete: function() {
				for(var i=0; i<$(".overlay").length; i++)
					$(".overlay").eq(i).hide();
            }
        });
    });
	
	
	// 삭제하기
	 $("#delete").click(function() {
        var url = "../removeProb.jsp";
        var params = new Object();

        params.questionId = getRequest()['prob'];
	
        var jsonData = JSON.stringify(params);
 
        $.ajax({
            type: "POST",
            url: url,
            dataType: "json",
            data: {
                jsonParam: jsonData
            },

            success: function(args) {
				alert(args.result);
                location.href = args.href;
            }
        });
    });
	
	// 제출 버튼
    $("#checker").click(function() {
        var url = "../submitCode.jsp";
        var params = new Object();

        params.probNumber = getRequest()['prob'];
        params.code = editor.getValue().replaceAll("\n", "\r\n");
        params.lang = $(".selectedlang").text();
        params.probHash = $("#probHash").val();
        params.mode = "submit";
	
        var jsonData = JSON.stringify(params);
        console.log(jsonData);

        $.ajax({
            type: "POST",
            url: url,
            dataType: "json",
            data: {
                jsonParam: jsonData
            },
            beforeSend: function() {
				for(var i=0; i<$(".overlay").length; i++)
					$(".overlay").eq(i).css("display", "table-cell");
            },
            success: function(args) {
                console.log(args);
                var result = "";
                if (args.result[0].result != "result") {
                    $(".result").html(args.result[0].result);
                } else {
                        for (var i = 1; i < args.result.length; i++) {
                            result += (i) + "번째 케이스 : " + args.result[i].result + "<br>";
                        }
                        $(".result").html(result);
                    
                }
            },
            error: function(e) {
                alert(e.responseText);
            },
            complete: function() {
				for(var i=0; i<$(".overlay").length; i++)
					$(".overlay").eq(i).hide();
            }
        });
    });
	
    // 문제 저장
    $("#saveSender").click(function() {
        var url = "../insertProbSubmit.jsp";
        var params = new Object();
        var language = new Array();
        var langsrc = new Object();
        var startDate = $('#reservationtime').data('daterangepicker').startDate._d;
        var deadline = $('#reservationtime').data('daterangepicker').endDate._d;
      
        if ($("textarea[name=input_data]").length)
            params.inputData = $("textarea[name=input_data]").serializeArray();

		if ($("textarea[name=output_data]").length)
            params.outputData = $("textarea[name=output_data]").serializeArray();


        if ($("textarea[name=inputExam_data]").length)
            params.inputExamData = $("textarea[name=inputExam_data]").serializeArray();
        if ($("textarea[name=outputExam_data]").length)
            params.outputExamData = $("textarea[name=outputExam_data]").serializeArray();

        if ($(".deadline .icheckbox_minimal-blue").attr("aria-checked") == "true") {
            params.deadline = null;
            params.startDate = null;
        } else {
            params.startDate = startDate;
            params.deadline = deadline;
        }

        params.level = $("#level").text();
		if($("#probHash").val()!=null){
			params.probHash = $("#probHash").val();
			url="../modifyProbSubmit.jsp";
		}
        params.context = CKEDITOR.instances.context.getData();
        params.displayNone = $(".visual .icheckbox_minimal-blue").attr("aria-checked");
		params.groupNum = $("#sgroup").val();


        if ($("#subject").val() == "") {
            alert("제목이 없습니다.");
            return;
        }
        params.subject = $("#subject").val();

        var langLength = $(".select2-selection__choice").length;

        if (langLength == 0) {
            alert("언어설정을 해 주세요");
            return;
        }

        for (var i = 0; i < langLength; i++) {
            langsrc.language = $(".select2-selection__choice").eq(i).attr("title");
            language.push(langsrc);
            langsrc = new Object();
        }

        params.language = language;
		params.time = $("#time").val();

        var jsonData = JSON.stringify(params);

        console.log(params);

        $.ajax({
            type: "POST",
            url: url,
            dataType: "json",
            data: {
                jsonParam: jsonData
            },
            beforeSend: function() {
                for(var i=0; i<$(".overlay").length; i++)
					$(".overlay").eq(i).css("display", "table-cell");
            },
            success: function(args) {
                location.href="pracPlace.jsp?prob="+args.result;
            },
            error: function(e) {
                alert(e.responseText);
            },
            complete: function() {
                for(var i=0; i<$(".overlay").length; i++)
					$(".overlay").eq(i).hide();
            }
        });
    });
	
	// 대회 문제 저장
    $("#saveSender_contestProb").click(function() {
        var url = "../insertContestProbSubmit.jsp";
        var params = new Object();
        var language = new Array();
        var langsrc = new Object();
        var startDate = $('#reservationtime').data('daterangepicker').startDate._d;
        var deadline = $('#reservationtime').data('daterangepicker').endDate._d;
        var contestId = $('#contestId').val();
      
        if ($("textarea[name=input_data]").length)
            params.inputData = $("textarea[name=input_data]").serializeArray();
		if ($("textarea[name=output_data]").length)
            params.outputData = $("textarea[name=output_data]").serializeArray();

        if ($("textarea[name=inputExam_data]").length)
            params.inputExamData = $("textarea[name=inputExam_data]").serializeArray();
        if ($("textarea[name=outputExam_data]").length)
            params.outputExamData = $("textarea[name=outputExam_data]").serializeArray();

		params.startDate = startDate;
		params.deadline = deadline;

        params.level = $("#level").text();
		if($("#probHash").val()!=null){
			params.probHash = $("#probHash").val();
			url="../modifyContestProbSubmit.jsp";
		}
        params.context = CKEDITOR.instances.context.getData();
        params.displayNone = $(".visual .icheckbox_minimal-blue").attr("aria-checked");
		params.groupNum = $("#sgroup").val();


        if ($("#subject").val() == "") {
            alert("제목이 없습니다.");
            return;
        }
        params.subject = $("#subject").val();

        var langLength = $(".select2-selection__choice").length;

        if (langLength == 0) {
            alert("언어설정을 해 주세요");
            return;
        }

        for (var i = 0; i < langLength; i++) {
            langsrc.language = $(".select2-selection__choice").eq(i).attr("title");
            language.push(langsrc);
            langsrc = new Object();
        }

        params.language = language;
		params.time = $("#time").val();
		
		params.contestId = contestId;

        var jsonData = JSON.stringify(params);

        console.log(params);

        $.ajax({
            type: "POST",
            url: url,
            dataType: "json",
            data: {
                jsonParam: jsonData
            },
            beforeSend: function() {
                for(var i=0; i<$(".overlay").length; i++)
					$(".overlay").eq(i).css("display", "table-cell");
            },
            success: function(args) {
                location.href="pracPlace.jsp?prob="+args.result;
            },
            error: function(e) {
                alert(e.responseText);
            },
            complete: function() {
                for(var i=0; i<$(".overlay").length; i++)
					$(".overlay").eq(i).hide();
            }
        });
    });
});

$(document).ready(function() {
	// 공지사항 저장
	$("#saveSender_notice").click(function() {
        var url = "../insertNoticeSubmit.jsp";
        var params = new Object();
        if ($("#subject").val() == "") {
            alert("제목이 없습니다.");
            return;
        }
        params.subject = $("#subject").val();
        params.context = CKEDITOR.instances.context.getData();

        var jsonData = JSON.stringify(params);

        $.ajax({
            type: "POST",
            url: url,
            dataType: "json",
            data: {
                jsonParam: jsonData
            },
            success: function(args) {
				var result = "" + args.result;
				
				if (result.indexOf("error") == -1) 
					location.href="noticeBoard.jsp";
				else
					alert(result);
            },
            error: function(e) {
                alert(e.responseText);
            }
        });
    });
	
	// 대회 저장
	$("#saveSender_contest").click(function() {
        var url = "../insertContestSubmit.jsp";
        var params = new Object();
		
		params.startTime = $('#reservationtime').data('daterangepicker').startDate._d;
		params.endTime = $('#reservationtime').data('daterangepicker').endDate._d;
		
        if ($("#subject").val() == "") {
            alert("제목이 없습니다.");
            return;
        }
        params.subject = $("#subject").val();
        params.context = CKEDITOR.instances.context.getData();
		

        var jsonData = JSON.stringify(params);

        $.ajax({
            type: "POST",
            url: url,
            dataType: "json",
            data: {
                jsonParam: jsonData
            },
            success: function(args) {
				var result = "" + args.result;
				
				if (result.indexOf("error") == -1) 
					location.href="contestBoard.jsp";
				else
					alert(result);
            },
            error: function(e) {
                alert(e.responseText);
            }
        });
    });
	
	// 대회 수정
	$("#saveSender_contest_modify").click(function() {
        var url = "../modifyContestSubmit.jsp";
        var params = new Object();
		
		params.contestId = $('#contestId').val();
		
		params.startTime = $('#reservationtime').data('daterangepicker').startDate._d;
		params.endTime = $('#reservationtime').data('daterangepicker').endDate._d;
		
        if ($("#subject").val() == "") {
            alert("제목이 없습니다.");
            return;
        }
		params.subject = $("#subject").val();
		params.context = CKEDITOR.instances.context.getData();

        var jsonData = JSON.stringify(params);

        $.ajax({
            type: "POST",
            url: url,
            dataType: "json",
            data: {
                jsonParam: jsonData
            },
            success: function(args) {
				var result = "" + args.result;
				
				if (result.indexOf("error") == -1) 
					location.href="contestBoard.jsp";
				else
					alert(result);
            },
            error: function(e) {
                alert(e.responseText);
            }
        });
    });
});


var input_cnt = 0;

function input_plus() {
    var input_box_src = '<tr id="inbox' + input_cnt + '"><td><textarea  class="form-control" rows=3 name="input_data" placeholder="ex) 4 2 11 8"></textarea></td><td><textarea  class="form-control" rows=3 name="output_data" placeholder="ex) 4 2 11 8"></textarea></td>';
    var input_minus_src = '<td><button type="button" class="btn btn-default" onclick="input_minus(' + input_cnt + ')"><i class="fa fa-minus"></i></button></td></tr>'
    var src = input_box_src + input_minus_src;
    $(".input-box").append(src);
    input_cnt++;
}

function input_minus(num) {
    var src = "#inbox" + num;
    $(src).remove();
}


var inputExam_cnt = 0;

function inputExam_plus() {
    var input_box_src = '<tr id="inExambox' + inputExam_cnt + '"><td><textarea class="form-control" rows=3 name="inputExam_data" placeholder="ex) 4 2 11 8"></textarea></td><td><textarea class="form-control" rows=3 name="outputExam_data" placeholder="ex) 4 2 11 8"></textarea></td>';
    var input_minus_src = '<td><button type="button" class="btn btn-default" onclick="inputExam_minus(' + inputExam_cnt + ')"><i class="fa fa-minus"></i></button></td></tr>'
    var src = input_box_src + input_minus_src;
    $(".inputExam-box").append(src);
    inputExam_cnt++;
}

function inputExam_minus(num) {
    var src = "#inExambox" + num;
    $(src).remove();
}

var testInput_cnt = 0;

function testInput_plus() {
    var input_box_src = '<tr id="testInbox' + testInput_cnt + '"><td><textarea  class="form-control" rows=3 name="testInput_data" placeholder="ex) 4 2 11 8"></textarea></td>';
    var input_minus_src = '<td><button type="button" class="btn btn-default" onclick="testInput_minus(' + testInput_cnt + ')"><i class="fa fa-minus"></i></button></td></tr>'
    var src = input_box_src + input_minus_src;
    $(".testInput-box").append(src);
    testInput_cnt++;
}

function testInput_minus(num) {
    var src = "#testInbox" + num;
    $(src).remove();
}