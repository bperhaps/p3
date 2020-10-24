package algo;

import java.io.*;
import java.util.ArrayList;
import java.sql.ResultSet;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletRequest;

// javac -cp /home/kknock/kknock/algo-tomcat/lib/servlet-api.jar algo/FileDownloader.java algo/Util.java

public class FileDownloader {
	private int questionId;
	private String dirPath;
	private String downloadFilePath, downloadFileName;
	
	public boolean ready(int questionId, ResultSet rs) {
		//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
		// 폴더 및 파일 확인
		dirPath = "algo/download/" + questionId;
		downloadFileName = questionId + ".zip";
		downloadFilePath = dirPath + "/" + downloadFileName;
		
		if (new File(dirPath).exists())
			return false;
			
		// 폴더 생성
		Util.Exec("mkdir " + dirPath);
		
		//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
		// 파일 복사
		String userId, prevUserId = "";
		String status, language;
		String ext_ori = null, ext_cp = null;
		
		String filePathFormat_ori = "algo/user/%s/submit/%s";	// algo/user/[userId]/[questionId].[ext]
		String filePathFormat_cp = "algo/download/%d/%s/%s";	// algo/download/[questionId]/[userId]/[questionId][status].[ext]
		String filePath_ori = null, filePath_cp = null;
		
		String cmdFormat_cp = "cp %s %s";
		String cmd_cp;
		
		String cmdFormat_mkdir = "mkdir algo/download/" + questionId + "/"; // algo/download/[questionId]/[userId]
		
		try {
			while (rs.next()) {
				// 유저
				userId = rs.getString("userId");
				if (!userId.equals(prevUserId)) {
					 // 유저 폴더 생성
					 Util.Exec(cmdFormat_mkdir + userId);
				}
				
				// 상태
				status = rs.getString("status");
				if (status.equals("Complete"))
					status = "";
				else
					status = "-" + status;
				
				// 확장자
				language = rs.getString("language");
				if (language == null)					continue;
				else if (language.equals("C"))			ext_cp = ext_ori = ".c";
				else if (language.equals("C++"))		ext_cp = ext_ori = ".cpp";
				else if (language.equals("Java"))		ext_cp = ext_ori = ".java";
				else if (language.equals("Python2"))	ext_cp = ext_ori = ".py2";
				else if (language.equals("Python3"))	ext_cp = ext_ori = ".py3";
				else									continue;
				
				// 파일명
				filePath_ori = String.format(filePathFormat_ori, userId, questionId+ext_ori);
				filePath_cp= String.format(filePathFormat_cp, questionId, userId, questionId+status+ext_cp);
				
				// 복사
				cmd_cp = String.format(cmdFormat_cp, filePath_ori, filePath_cp);
				Util.Exec(cmd_cp);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
		// 폴더 압축
		String[] cmd_zip = {"/bin/bash", "-c", "cd algo/download/%d && zip -r ./%d.zip ./*"};
		cmd_zip[2] = String.format(cmd_zip[2], questionId, questionId);
		Util.Exec(cmd_zip);
		
		return true;
	}
	public boolean ready(int questionId, ArrayList<String> sourceDataArray) {
		this.questionId = questionId;
		
		if (sourceDataArray.size() == 1)
			return ready(sourceDataArray.get(0));
		else
			return ready(sourceDataArray);
	}
	private boolean ready(String sourceData) {
		//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
		// 폴더 및 파일 확인
		dirPath = "algo/download/" + questionId;
		
		if (new File(dirPath).exists())
			return false;
			
		// 폴더 생성
		Util.Exec("mkdir " + dirPath);
		
		//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
		// 파일 복사
		String userId;
		String status, language;
		String ext_ori = null, ext_cp = null;
		
		String filePathFormat_ori = "algo/user/%s/submit/%s";	// algo/user/[userId]/submit/[questionId].[ext]
		String filePathFormat_cp = "algo/download/%d/%s";		// algo/download/[questionId]/[questionId][status].[ext]
		String filePath_ori = null, filePath_cp = null;
		
		String cmdFormat_cp = "cp %s %s";
		String cmd_cp;
		
		// userId;status;language
		String[] sourceDataSplit = sourceData.split(";");
		
		// 유저
		userId = sourceDataSplit[0];
			
		// 상태
		status = sourceDataSplit[1];
		if (status.equals("Complete"))	status = "";
		else							status = "-" + status;
			
		// 확장자
		language = sourceDataSplit[2];
		if (language == null)					return false;
		else if (language.equals("C"))			ext_cp = ext_ori = ".c";
		else if (language.equals("C++"))		ext_cp = ext_ori = ".cpp";
		else if (language.equals("Java"))		ext_cp = ext_ori = ".java";
		else if (language.equals("Python2"))	ext_cp = ext_ori = ".py2";
		else if (language.equals("Python3"))	ext_cp = ext_ori = ".py3";
		else									return false;
			
		// 파일명
		filePath_ori = String.format(filePathFormat_ori, userId, questionId + ext_ori);
		filePath_cp = String.format(filePathFormat_cp, questionId, questionId + status + ext_cp);
			
		// 복사
		cmd_cp = String.format(cmdFormat_cp, filePath_ori, filePath_cp);
		Util.Exec(cmd_cp);
		
		//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
		// 파일 이름 설정
		downloadFileName = questionId + "_" + userId + status + ext_cp;
		downloadFilePath = filePath_cp;
		
		return true;
	}
	private boolean ready(ArrayList<String> sourceDataArray) {
		//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
		// 폴더 및 파일 확인
		dirPath = "algo/download/" + questionId;
		downloadFileName = questionId + ".zip";
		downloadFilePath = dirPath + "/" + downloadFileName;
		
		if (new File(dirPath).exists())
			return false;
			
		// 폴더 생성
		Util.Exec("mkdir " + dirPath);
		
		//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
		// 파일 복사
		String userId, prevUserId = "";
		String status, language;
		String ext_ori = null, ext_cp = null;
		
		String filePathFormat_ori = "algo/user/%s/submit/%s";	// algo/user/[userId]/[questionId].[ext]
		String filePathFormat_cp = "algo/download/%d/%s/%s";	// algo/download/[questionId]/[userId]/[questionId][status].[ext]
		String filePath_ori = null, filePath_cp = null;
		
		String cmdFormat_cp = "cp %s %s";
		String cmd_cp;
		
		String cmdFormat_mkdir = "mkdir algo/download/" + questionId + "/"; // algo/download/[questionId]/[userId]
		
		for (int i = 0; i < sourceDataArray.size(); i++) {
			// userId;status;language
			String[] sourceData = sourceDataArray.get(i).split(";");
		
			// 유저
			userId = sourceData[0];
			if (!userId.equals(prevUserId)) {
				 // 유저 폴더 생성
				 Util.Exec(cmdFormat_mkdir + userId);
			}
			
			// 상태
			status = sourceData[1];
			if (status.equals("Complete"))
				status = "";
			else
				status = "-" + status;
			
			// 확장자
			language = sourceData[2];
			if (language == null)					continue;
			else if (language.equals("C"))			ext_cp = ext_ori = ".c";
			else if (language.equals("C++"))		ext_cp = ext_ori = ".cpp";
			else if (language.equals("Java"))		ext_cp = ext_ori = ".java";
			else if (language.equals("Python2"))	ext_cp = ext_ori = ".py2";
			else if (language.equals("Python3"))	ext_cp = ext_ori = ".py3";
			else									continue;
			
			// 파일명
			filePath_ori = String.format(filePathFormat_ori, userId, questionId+ext_ori);
			filePath_cp= String.format(filePathFormat_cp, questionId, userId, questionId+status+ext_cp);
			
			// 복사
			cmd_cp = String.format(cmdFormat_cp, filePath_ori, filePath_cp);
			Util.Exec(cmd_cp);
		}
		
		
		//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
		// 폴더 압축
		String[] cmd_zip = {"/bin/bash", "-c", "cd algo/download/%d && zip -r ./%d.zip ./*"};
		cmd_zip[2] = String.format(cmd_zip[2], questionId, questionId);
		Util.Exec(cmd_zip);
		
		return true;
	}
	
	public void close() {
		// 폴더 삭제
		Util.Exec("rm -rf " + dirPath);
	}
	
	public void download(HttpServletResponse response, HttpServletRequest request) {
		
		try {
			String client;
			
			client = request.getHeader("User-Agent");
			response.setContentType("application/octet-stream");
			
			if(client.indexOf("MSIE") != -1){
				response.setHeader("Content-Disposition", "attachment; filename=" + new String(downloadFileName.getBytes("KSC5601"), "ISO8859_1"));
			} else{
				// 한글 파일명 처리
				downloadFileName = new String(downloadFileName.getBytes("utf-8"),"iso-8859-1");
		 
				response.setHeader("Content-Disposition", "attachment; filename=\"" + downloadFileName + "\"");
				response.setHeader("Content-Type", "application/octet-stream; charset=utf-8");
			}
			
			// 파일 전송
			File downFile = new File(downloadFilePath);
			InputStream in = new FileInputStream(downFile);
			OutputStream os = response.getOutputStream();
			
			byte b[] = new byte[(int)downFile.length()];
			int len = 0;
			
			while( (len = in.read(b)) > 0 )
				os.write(b, 0, len);
			
			in.close();
			os.close();
		} catch(Exception e) {
			e.printStackTrace();
		}
		
	}
}