package algo;

import java.io.*;
import java.util.*;

// 문제 입력, 정답 파일, 소스 파일 등을 옮겨주는 역할
public class Helper {	

	private static final String cmdFormat_dir = "mkdir algo/run/%d";
	private static final String cmdFormat_inoutdir = "mkdir algo/run/%d/%s";
	private static final String cmdFormat_prob = "cp /home/kknock/kknock/algo-tomcat/bin/algo/prob/%s/%s/* /home/kknock/kknock/algo-tomcat/bin/algo/run/%d/%s/";
	private static final String[] cmdFormat_exec = {"/bin/bash", "-c", "cmd"};
	private static final String cmdFormat_source = "cp algo/user/%d/%s/%d%s algo/run/%d/%%s";
	private static final String cmdFormat_rm = "rm -rf algo/run/%d";
	private static final String cmdFormat_ln = "cp /home/kknock/kknock/algo-tomcat/bin/algo/run/executer/*.class /home/kknock/kknock/algo-tomcat/bin/algo/run/%d/";
	private static final String cmdFormat_inputDataFile = "echo \"%s\" > algo/run/%d/input/%d";
	
	private static final String fileDirFormat_source = "algo/user/%d/%s/%d%s";
	private static final String fileDirFormat = "algo/run/%d";
	
	
	public static void Saveprac(int userNumber, int sourceNumber, String code, String ext) {
		
		String userDir = String.format("algo/user/%d", userNumber);
		File dir = new File(userDir);
		if (!dir.isDirectory()){
			Util.Exec("mkdir algo/user/"+userNumber);
		}
		
		userDir = String.format("algo/user/%d/prac", userNumber);
		dir = new File(userDir);
		if (!dir.isDirectory()){
			Util.Exec("mkdir algo/user/"+userNumber+"/prac");
		}
		
		String fileDir_source = String.format(fileDirFormat_source, userNumber,"prac",sourceNumber,ext);

		try {
			BufferedWriter out = new BufferedWriter(new FileWriter(fileDir_source));
			out.write(code);
			out.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	public static void Savesubmit(int userNumber, int sourceNumber, String code, String ext) {
		
		String userDir = String.format("algo/user/%d", userNumber);
		File dir = new File(userDir);
		if (!dir.isDirectory()){
			Util.Exec("mkdir algo/user/"+userNumber);
		}
		
		userDir = String.format("algo/user/%d/submit", userNumber);
		dir = new File(userDir);
		if (!dir.isDirectory()){
			Util.Exec("mkdir algo/user/"+userNumber+"/submit");
		}
		
		String fileDir_source = String.format(fileDirFormat_source, userNumber,"submit",sourceNumber,ext);

		try {
			BufferedWriter out = new BufferedWriter(new FileWriter(fileDir_source));
			out.write(code);
			out.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	// 실행
	public static boolean Create(int userNumber, int sourceNumber, String language, ArrayList<String> inputData, String ext) {
		// 폴더 존재 확인
		String fileDir = String.format(fileDirFormat, userNumber);
		File dir = new File(fileDir);
		if (dir.isDirectory()) return false;
		
		// 폴더 생성
		String cmd_dir = String.format(cmdFormat_dir, userNumber);
		String cmd_indir = String.format(cmdFormat_inoutdir, userNumber, "input");
		String cmd_outdir = String.format(cmdFormat_inoutdir, userNumber, "output");
		String cmd_errdir = String.format(cmdFormat_inoutdir, userNumber, "errput");
		String cmd_timedir = String.format(cmdFormat_inoutdir, userNumber, "time");
		Util.Exec(cmd_dir);
		Util.Exec(cmd_indir);
		Util.Exec(cmd_outdir);
		Util.Exec(cmd_errdir);
		Util.Exec(cmd_timedir);

		// 입력 파일 생성
		int i = 0;
		String[] cmd_exec = cmdFormat_exec.clone();
		for(String str : inputData){
			String cmd_inputDataFile = String.format(cmdFormat_inputDataFile, str, userNumber, i);
			cmd_exec[2] = cmd_inputDataFile;
			
			Util.Exec(cmd_exec);
			i++;
		}
		
		// 소스 파일 옮기기
		String cmd_source = String.format(cmdFormat_source, userNumber, "prac", sourceNumber,ext, userNumber);
		String cmdFormat_forjava = "cat /home/kknock/kknock/algo-tomcat/bin/algo/user/%d/prac/%d%s | tr \"\r\n\" \"\t\" | sed -e 's;^.*public[[:space:]]*class;;' | awk '{print \"/home/kknock/kknock/algo-tomcat/bin/algo/user/%d/prac/%d%s /home/kknock/kknock/algo-tomcat/bin/algo/run/%d/\"$1\".java\"}' | tr -d \"{\" | xargs cp";
		if (language.equals("Java")){
			cmd_exec[2] = String.format(cmdFormat_forjava, userNumber, sourceNumber, ext,userNumber, sourceNumber, ext, userNumber);
			Util.Exec(cmd_exec);
			cmd_source = null;
		}
		else if (language.equals("C++"))
			cmd_source = String.format(cmd_source, "main.cpp");
		else if (language.equals("C"))
			cmd_source = String.format(cmd_source, "main.c");
		else if (language.equals("Python2") || language.equals("Python3"))
			cmd_source = String.format(cmd_source, "main.py");
		else
			cmd_source = null;

		if (cmd_source != null)
			Util.Exec(cmd_source);
		
		// 실행 파일 링크 생성
		cmd_exec[2] = String.format(cmdFormat_ln, userNumber);	
		Util.Exec(cmd_exec);

		return true;
	}
	
	// 제출
	public static boolean Create(int userNumber, String probHash, int sourceNumber, String language, String ext, boolean datecheck) {
		// 폴더 존재 확인
		String fileDir = String.format(fileDirFormat, userNumber);
		File dir = new File(fileDir);
		if (dir.isDirectory()) return false;
		
		// 폴더 생성
		String cmd_dir = String.format(cmdFormat_dir, userNumber);
		String cmd_indir = String.format(cmdFormat_inoutdir, userNumber, "input");
		String cmd_answerdir = String.format(cmdFormat_inoutdir, userNumber, "answer");
		String cmd_outdir = String.format(cmdFormat_inoutdir, userNumber, "output");
		String cmd_errdir = String.format(cmdFormat_inoutdir, userNumber, "errput");
		String cmd_timedir = String.format(cmdFormat_inoutdir, userNumber, "time");
		Util.Exec(cmd_dir);
		Util.Exec(cmd_indir);
		Util.Exec(cmd_answerdir);
		Util.Exec(cmd_outdir);
		Util.Exec(cmd_errdir);
		Util.Exec(cmd_timedir);	

		// 문제 파일 옮기기
		cmdFormat_exec[2] = String.format(cmdFormat_prob, probHash, "input", userNumber, "input");
		Util.Exec(cmdFormat_exec);
	
		cmdFormat_exec[2] = String.format(cmdFormat_prob, probHash, "output", userNumber, "answer");
		Util.Exec(cmdFormat_exec);
		
		
		String[] cmd_exec = cmdFormat_exec.clone();
		
		// 소스 파일 옮기기
		String cmd_source = null;
		String cmdFormat_forjava = null;
		
		if(datecheck){
			cmd_source = String.format(cmdFormat_source, userNumber, "submit", sourceNumber, ext, userNumber);
			cmdFormat_forjava = "cat /home/kknock/kknock/algo-tomcat/bin/algo/user/%d/submit/%d%s | tr \"\r\n\" \"\t\" | sed -e 's;^.*public[[:space:]]*class;;' |awk '{print \"/home/kknock/kknock/algo-tomcat/bin/algo/user/%d/submit/%d%s /home/kknock/kknock/algo-tomcat/bin/algo/run/%d/\"$1\".java\"}' | tr -d \"{\" | xargs cp";
		}
		else{
			cmd_source = String.format(cmdFormat_source, userNumber, "prac", sourceNumber, ext, userNumber);
			cmdFormat_forjava = "cat /home/kknock/kknock/algo-tomcat/bin/algo/user/%d/prac/%d%s | tr \"\r\n\" \"\t\" | sed -e 's;^.*public[[:space:]]*class;;' |awk '{print \"/home/kknock/kknock/algo-tomcat/bin/algo/user/%d/prac/%d%s /home/kknock/kknock/algo-tomcat/bin/algo/run/%d/\"$1\".java\"}' | tr -d \"{\" | xargs cp";
		}
		
		if (language.equals("Java")){
			cmd_exec[2] = String.format(cmdFormat_forjava, userNumber, sourceNumber, ext,userNumber, sourceNumber, ext, userNumber);
			Util.Exec(cmd_exec);
			cmd_source = null;
		}
		else if (language.equals("C++"))
			cmd_source = String.format(cmd_source, "main.cpp");
		else if (language.equals("C"))
			cmd_source = String.format(cmd_source, "main.c");
		else if (language.equals("Python2") || language.equals("Python3"))
			cmd_source = String.format(cmd_source, "main.py");
		else
			cmd_source = null;

		if (cmd_source != null)
			Util.Exec(cmd_source);
		
		// 실행 파일 링크 생성
		cmd_exec[2] = String.format(cmdFormat_ln, userNumber);	
		Util.Exec(cmd_exec);
		
		return true;
	}

	public static int getFileCnt(int userNumber, String location){
		String src = String.format(fileDirFormat, userNumber);
		src = src + "/" + location;
		File dir = new File(src);
		File[] fileList = dir.listFiles();
		
		return fileList.length;
	}
	public static File[] getFile(int userNumber, String location){
		String src = String.format(fileDirFormat, userNumber);
		src = src + "/" + location;
		File dir = new File(src);
		File[] fileList = dir.listFiles();
		
		return fileList;
	}
	
	public static void Remove(int userNumber) {
		String cmdRm = String.format(cmdFormat_rm, userNumber);
		Util.Exec(cmdRm);
	}

}

