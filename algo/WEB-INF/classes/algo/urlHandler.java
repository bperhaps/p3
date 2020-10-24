package algo;

import java.util.*;
import java.text.*;
import java.util.regex.*;

public class urlHandler {

	// Method get 파라메터 컨트롤러
	public static String getParameter(String parameter,String update) {
		// 파라메터를 담을 HashMap
		HashMap params = new HashMap();
		// 패턴
		String patten = "^(.*)=(.*)$";
		Pattern para_patten = Pattern.compile(patten,Pattern.MULTILINE);

		if (parameter != null && parameter != "") {

			String para = parameter.replaceAll("^\\?","");
			String para_tokens[] = para.split("&");
			int para_cnt = para_tokens.length;
			for (int i = 0; i < para_cnt; i++ ) {       
				Matcher para_matcher = para_patten.matcher(para_tokens[i]);
				String para_name = para_matcher.replaceAll("$1");
				String para_value = para_matcher.replaceAll("$2");
				params.put(para_name,para_value);
			}
		}

		if (update != null && !update.equals("")) {
			String new_para = update.replaceAll("^\\?","");
			String new_para_tokens[] = new_para.split("&");
			int new_para_cnt = new_para_tokens.length;
			for (int x = 0; x < new_para_cnt; x++ ) {       
				Matcher new_para_matcher = para_patten.matcher(new_para_tokens[x]);
				String new_para_name = new_para_matcher.replaceAll("$1");
				String new_para_value = new_para_matcher.replaceAll("$2");
				params.put(new_para_name,new_para_value);
			}
		}

		// 완성된 HashMap key 로드
		String params_ext = "";
		Iterator iter = params.keySet().iterator();
		while(iter.hasNext()){
			String addkey = (String)iter.next();
			String addvalue = (String)params.get(addkey);
			// 값이 있는 파라메터만 유효
			if (addvalue != null && !addvalue.equals("")) params_ext += addkey + "=" + params.get(addkey) + "&";     
		}
		params_ext = params_ext.replaceAll("&$","");
		return params_ext;
	}
}
