package algo;

import java.io.File;
import java.io.BufferedReader;
import java.io.InputStreamReader;

public class Executer {
	private static final String[] cmdFormat_run = {"docker", "run", "-d", "--rm", "-v", "[mountDir]", "--net=none", "--cpus=.5", "--memory=100m", "--name", "[containerName]", "executer", "sleep", "[limitTime]"};
	private static final String[] cmdFormat_exec = {"docker", "exec", "[containerName]", "java", "executer", "[language]"};
	private static final String cmdFormat_kill = "docker container kill container executer%d";
	private static final String paramFormat_mountDir = "/home/kknock/kknock/algo-tomcat/bin/algo/run/%d:/home";
	private static final String paramFormat_containerName = "executer%d";
	
	private static final String fileDirFormat = "algo/run/%d/%s";

	public static int Execute(int userNumber, String language, int limitTime, int caseNum) {
		// 변수 설정
		String mountDir = String.format(paramFormat_mountDir, userNumber);
		String containerName = String.format(paramFormat_containerName, userNumber);
		
		// 도커 정지
		String cmd_kill = String.format(cmdFormat_kill, userNumber);
		Util.Exec(cmd_kill);

		// 도커 실행
		String[] cmd_run = cmdFormat_run.clone();
		cmd_run[5] = mountDir;
		cmd_run[10] = containerName;
		cmd_run[13] = String.valueOf(limitTime * (caseNum + 1));

		Util.Exec(cmd_run);

		// 도커 명령어 실행
		String[] cmd_exec = cmdFormat_exec.clone();
		cmd_exec[2] = containerName;
		cmd_exec[5] = language; 
		
		Util.Exec(cmd_exec);

		// 결과 확인
		File[] file_input = Helper.getFile(userNumber, "input");
		File[] file_time = Helper.getFile(userNumber, "time");
		if (file_input.length != file_time.length)
			return -1; // 실행 중지

		return 0;	
	}
}
