package algo;

import java.io.File;

public class Compiler {
	private static final String[] cmdFormat = {"/bin/bash", "-c", ""};
	private static final String cmdFormat_java = "ls algo/run/%d/ | grep java | xargs -i bash -c \"javac -encoding UTF-8 -g:none algo/run/%d/{} 2> algo/run/%d/errput/compile\"";
	private static final String cmdFormat_java_check = "ls algo/run/%d/ | grep java | sed 's/.java/.class/g' | xargs -i cp algo/run/%d/{} algo/run/%d/testJava";
	private static final String cmdFormat_cpp = "g++ -std=c++11 -Wno-unused-result -O2 -o algo/run/%d/main algo/run/%d/main.cpp 2> algo/run/%d/errput/compile";
	private static final String cmdFormat_c = "gcc -Wno-unused-result -lm -O2 -o algo/run/%d/main algo/run/%d/main.c 2> algo/run/%d/errput/compile";

	private static final String fileDirFormat_java = "algo/run/%d/testJava";
	private static final String fileDirFormat_cpp = "algo/run/%d/main";
	private static final String fileDirFormat_c = "algo/run/%d/main";

	public static int Compile(int sourceNumber, int userNumber, String language) {
		String[] cmd;
		String fileDir;
		
		// 문자열 설정
		cmd = cmdFormat.clone();
		if (language.equals("Java")) {
			cmd[2] = String.format(cmdFormat_java, userNumber,userNumber, userNumber);
			fileDir = String.format(fileDirFormat_java, userNumber);
		}
		else if (language.equals("C++")) {
			cmd[2] = String.format(cmdFormat_cpp, userNumber, userNumber, userNumber);
			fileDir = String.format(fileDirFormat_cpp, userNumber);
		}
		else if (language.equals("C")) {
			cmd[2] = String.format(cmdFormat_c,userNumber, userNumber, userNumber);
			fileDir = String.format(fileDirFormat_c, userNumber);
		}
		else if (language.equals("Python2") || language.equals("Python3"))
			return 1;
		else return 0;

		// 실행
		Util.Exec(cmd);
		
		if (language.equals("Java")) {
			cmd[2] = String.format(cmdFormat_java_check, userNumber,userNumber,userNumber);
			Util.Exec(cmd);
		}
		
		
		File file = new File(fileDir);
		if (file.isFile())
			return 1;
		return -1;
	}
}
