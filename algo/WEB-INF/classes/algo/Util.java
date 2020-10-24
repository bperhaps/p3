package algo;

import java.io.*;

public class Util {
	private static final String fileDirFormat = "algo/run/%d/%s";
	private static final String fileDirFormat_userDir = "algo/run/%d/";
	
	public static boolean Exec(String cmd) {
		try {
			Process ps = Runtime.getRuntime().exec(cmd);
			ps.waitFor();
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}
	public static boolean Exec(String[] cmd) {
		try {
			Process ps = Runtime.getRuntime().exec(cmd);
			BufferedReader in = new BufferedReader(new InputStreamReader(ps.getErrorStream()));
			String line;
			while ((line = in.readLine()) != null) {
				System.out.println(line);
			}
			ps.waitFor();
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}
	
	public static String ReadFile(int userNumber, String fileName) {
		String res = "", s;
	
		try {
			String fileDir = String.format(fileDirFormat, userNumber, fileName);
			String fileDir_userDir = String.format(fileDirFormat_userDir, userNumber);			

			BufferedReader in = new BufferedReader(new FileReader(fileDir));

			while ((s = in.readLine()) != null)
				res += s + "<br>";
			res = res.replace(fileDir_userDir, "");
			System.out.println(fileDir);
	
			if (in != null) in.close();
		} catch (IOException e) {
			e.printStackTrace();
			return null;
		}
		
		return res;
	}
}
