package algo;

import java.io.*;
import java.util.*;

public class FileControll{
	
	public static File[] sortFileList(File[] files) {
	
		Arrays.sort(files,
			new Comparator < Object > () {
					@Override
				public int compare(Object object1, Object object2) {
					String s1 = "";
					String s2 = "";
	
					s1 = ((File) object1).getName();
					s2 = ((File) object2).getName();
					return s1.compareTo(s2);
				}
			});
		return files;
	}	
	
	private static final String cmdFormat_dir = "mkdir algo/%s/%s";		// prob/문제해시 폴더 생성을 위함(기본 폴더)
	private static final String cmdFormat_dirindir = "mkdir algo/%s/%s/%s";		// prob/문제해시/input, output 폴더안에 폴더를 위함
	private static final String cmdFormat_Path="algo/%s/%s/%s";;
	private static final String cmdFormat_inputDataFile = "echo \"%s\" > algo/%s/%s/%s/%d";
	private static final String[] cmdFormat_exec = {"/bin/bash", "-c", "cmd"};
	
	private static boolean isfolderCreated = false;
	
	private static ArrayList<String> getCore(String src){
		ArrayList <String> list = new ArrayList<String>();
		
		File dir = new File(src);
		File[] filedata = dir.listFiles();
		File[] files = sortFileList(filedata);
		try{
			for(int i=0; i < files.length; i++){
				String result="";
				FileReader FR = new FileReader(files[i]);
				BufferedReader data = new BufferedReader(FR);
				
				while(true){
					String s = data.readLine();
					if(s == null) break;
					result+=s+"<br>";
				}
				result = result.substring(0, result.lastIndexOf("<br>"));
				list.add(result);
			}
		} catch( IOException e ){
			list.add("");
			return list;
		}
		
		return list;
	}
	

	public static void createFolder(String probHash){
		String cmd_dir = String.format(cmdFormat_dir, "prob", probHash);
		String cmd_inputdir = String.format(cmdFormat_dirindir, "prob", probHash, "input");
		String cmd_inputexamdir = String.format(cmdFormat_dirindir, "prob", probHash, "inputexam");
		String cmd_outputdir = String.format(cmdFormat_dirindir, "prob", probHash, "output");
		String cmd_outputexamdir = String.format(cmdFormat_dirindir, "prob", probHash, "outputexam");
		
		Util.Exec(cmd_dir);
		Util.Exec(cmd_inputdir);
		Util.Exec(cmd_inputexamdir);
		Util.Exec(cmd_outputdir);
		Util.Exec(cmd_outputexamdir);
		isfolderCreated = true;
	}
	
	private static void saveCore(ArrayList<String> inputData, String probHash, String dir){
		int i = 0;
		String[] cmd_exec = cmdFormat_exec.clone();
		for(String str : inputData){
			String cmd_inputDataFile = String.format(cmdFormat_inputDataFile, str, "prob", probHash, dir, i);
			cmd_exec[2] = cmd_inputDataFile;
			Util.Exec(cmd_exec);
			i++;
		}
	}
	public static String getUserSorce(String userid, int probNum, String mode,String ext) {
		String src=null;
		if(mode.equals("prac"))
			src = String.format(cmdFormat_Path, "user", userid+"/prac", Integer.toString(probNum)+ext);
		else 
			src = String.format(cmdFormat_Path, "user", userid+"/submit", Integer.toString(probNum)+ext);
		File files = new File(src);
		String result="";
		try{
			FileReader FR = new FileReader(files);
			BufferedReader data = new BufferedReader(FR);
				
			while(true){
				String s = data.readLine();
				if(s == null) break;
				result+=s+"\n";
			}
		} catch ( IOException e ){
			return "error";
		}
		
		return result;
	}
	
	public static ArrayList<String> getProbInput(String probHash) throws IOException {
		String src = String.format(cmdFormat_Path, "prob", probHash, "input");
		ArrayList<String> data = getCore(src);
		return data;
	}
	
	public static ArrayList<String> getProbOutput(String probHash) throws IOException {
		String src = String.format(cmdFormat_Path, "prob",probHash, "output");
		ArrayList<String> data = getCore(src);
		return data;
	}
	
	public static ArrayList<String> getProbOutputExam(String probHash) throws IOException {
		String src = String.format(cmdFormat_Path, "prob",probHash, "outputexam");
		ArrayList<String> data = getCore(src);
		return data;
	}
	
	public static ArrayList<String> getProbInputExam(String probHash)  throws IOException{
		String src = String.format(cmdFormat_Path, "prob",probHash, "inputexam");
		ArrayList<String> data = getCore(src);
		return data;
	}
	
	public static void saveProbInput(ArrayList<String> data, String probHash) {
		if(!isfolderCreated) createFolder(probHash);
		
		saveCore(data, probHash, "input");
	}
	
	public static void saveProbOutput(ArrayList<String> data, String probHash) {
		if(!isfolderCreated) createFolder(probHash);
		
		saveCore(data, probHash, "output");
	}
	
	public static void saveProbExamInput(ArrayList<String> data, String probHash) {
		if(!isfolderCreated) createFolder(probHash);
		
		saveCore(data, probHash, "inputexam");
	}
	
	public static void saveProbExamOutput(ArrayList<String> data, String probHash) {
		if(!isfolderCreated) createFolder(probHash);
		
		saveCore(data, probHash, "outputexam");
	}
	
}