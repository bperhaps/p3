package algo;

import java.sql.*;
import java.util.*;
import javax.servlet.jsp.JspWriter;

// javac -cp /home/kknock/kknock/algo-tomcat/lib/jsp-api.jar algo/GroupManager.java algo/DBUtil.java

class Group {
	public Integer groupNum;
	public String groupName;
		
	public Group(int groupNum, String groupName) {
		this.groupNum = groupNum;
		this.groupName = groupName;
	}
}

public class GroupManager {	
	public HashMap<Integer, ArrayList<Group>> pgroups;
	public HashMap<Integer, ArrayList<Integer>> cgroups;
	public HashMap<Integer, Integer> rawgroups;
	// public HashMap<Integer, Group> groups = new HashMap<Integer, Group>();
		
	public GroupManager(Connection conn) {
		pgroups = new HashMap<Integer, ArrayList<Group>>();
		cgroups = new HashMap<Integer, ArrayList<Integer>>();
		rawgroups = new HashMap<Integer, Integer>();
		
		try {
			String sql = "select * from groups";
			PreparedStatement pstmt = conn.prepareStatement(sql);
			ResultSet rs = pstmt.executeQuery();
			
			if (rs == null) {
				DBUtil.close(pstmt);
				return ;
			}
			
			while (rs.next()) {
				int parentsGroup = rs.getInt("parentsGroup");
				Group group = new Group(rs.getInt("groupNum"), rs.getString("groupName"));
				// groups.put(groupNum, group);
				
				rawgroups.put(rs.getInt("groupNum"), rs.getInt("parentsGroup"));
				
				if (pgroups.containsKey(parentsGroup))
					pgroups.get(parentsGroup).add(group);
				else {
					ArrayList<Group> temp = new ArrayList<Group>();
					temp.add(group);
					pgroups.put(parentsGroup, temp);
				}
			}
				
				
			Iterator groupNumIter = rawgroups.keySet().iterator();
			while(groupNumIter.hasNext()){
				Integer groupNum = (Integer)groupNumIter.next();
				Integer parentsNum = rawgroups.get(groupNum);
				ArrayList<Integer> temp = new ArrayList<Integer>();
				
				if(!cgroups.containsKey(groupNum)){
					temp.add(parentsNum);
					cgroups.put(groupNum, temp);
					parentsNum = rawgroups.get(parentsNum);
				}
				
				while(true){
									
					if(rawgroups.containsKey(parentsNum)){				
						cgroups.get(groupNum).add(parentsNum);
						parentsNum = rawgroups.get(parentsNum);
					} 
					else 
						break;
				}
			}
				
			DBUtil.close(rs);
			DBUtil.close(pstmt);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

		
	/*
	public void check(int parent) {
		ArrayList<Group> temp = pgroups.get(parent);
		
		for (int i = 0; i < temp.size(); i++) {
			Group group = temp.get(i);
			
			System.out.println(group.groupNum + " : " + group.groupName);
			if (pgroups.containsKey(group.groupNum)) {
				System.out.println("┌");
				check(group.groupNum);
				System.out.println("└");
			}
		}
	}
	*/
		
	public void test(JspWriter out) throws java.io.IOException{
			Set key = cgroups.keySet();
  
			for (Iterator iterator = key.iterator(); iterator.hasNext();) {
                   Integer keyName = (Integer) iterator.next();
                   ArrayList<Integer> value = cgroups.get(keyName);
					
					
				for(int i=0; i<value.size(); i++){
                  out.println(keyName +" = " +value.get(i)+"<br>");
				}
		}

	}
	
	public void print(JspWriter out, int parent) {
		if (!pgroups.containsKey(parent)) return ;
		ArrayList<Group> temp = pgroups.get(parent);
		
		for (int i = 0; i < temp.size(); i++) {
			Group group = temp.get(i);
			boolean bParent = pgroups.containsKey(group.groupNum);
				
			try {
				out.print("<li class=\"treeview\">");
				out.print("<a href=\"#\">");
				out.print("<i class=\"fa fa-circle-o\"></i><span class=\"gname\" name=\""+group.groupNum+"\" style=\"color:#4C4C4C\">" + group.groupName + "</span>");
					
				out.print("<span class=\"pull-right-container\"><i class=\"fa fa-plus pull-right add\"></i>");
				if (bParent)
					out.print("<i class=\"fa fa-angle-left pull-right\"></i>");	
				out.print("</span></a>");
			
				if (bParent) {
					out.print("<ul class=\"treeview-menu\">");
					print(out, group.groupNum);
					out.print("</ul>");
				}
				out.print("</li>");
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	
	public void printGroupEdit(JspWriter out, int parent) {
		if (!pgroups.containsKey(parent)) return ;
		ArrayList<Group> temp = pgroups.get(parent);
		
		for (int i = 0; i < temp.size(); i++) {
			Group group = temp.get(i);
			boolean bParent = pgroups.containsKey(group.groupNum);
				
			try {
				out.print("<li class=\"treeview\">");
				out.print("<a href=\"#\">");
				out.print("<i class=\"fa fa-circle-o\"></i><span class=\"gname\" name=\""+group.groupNum+"\" style=\"color:#4C4C4C\">" + group.groupName + "</span>");
					
				out.print("<span class=\"pull-right-container\"><i class=\"fa fa-plus pull-right add\"></i><i class=\"fa fa-minus pull-right pop\"></i>");
				if (bParent)
					out.print("<i class=\"fa fa-angle-left pull-right\"></i>");	
				out.print("</span></a>");
			
				if (bParent) {
					out.print("<ul class=\"treeview-menu\">");
					printGroupEdit(out, group.groupNum);
					out.print("</ul>");
				}
				out.print("</li>");
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	

	public void printGroupSelect(JspWriter out, int parent) {
		if (!pgroups.containsKey(parent)) return ;
		ArrayList<Group> temp = pgroups.get(parent);
		
		for (int i = 0; i < temp.size(); i++) {
			Group group = temp.get(i);
			boolean bParent = pgroups.containsKey(group.groupNum);
				
			try {
				out.print("<li class=\"treeview\">");
				out.print("<a href=\"#\">");

				out.print("<i class=\"fa fa-circle-o\"></i><span class=\"gname\" name=\""+group.groupNum+"\" style=\"color:#4C4C4C\">" + group.groupName + "</span>");
					
				out.print("<span class=\"pull-right-container\"><i class=\"fa fa-plus pull-right add\"></i>");
				if (bParent)
					out.print("<i class=\"fa fa-angle-left pull-right\"></i>");	
				out.print("</span></a>");
			
				if (bParent) {
					out.print("<ul class=\"treeview-menu\">");
					printGroupEdit(out, group.groupNum);
					out.print("</ul>");
				}
				out.print("</li>");
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	
	
	public ArrayList<Integer> getCgroup(int c){
		return cgroups.get(c);
	}
	
	public void getGroupPath(JspWriter out, int c){
		ArrayList<Group> group = pgroups.get(c);
		ArrayList<Integer> list = new ArrayList<Integer>();
		
		if(group == null){
			list.add(-1);
			return ;
		}
		
		try{
			out.print("<ol class=\"breadcrumb\">");
			for(int i=0; i<group.size(); i++){
				out.print("<li><i class=\"fa fa-dashboard\"></i> "+group.get(i).groupName+"</a></li>");
			}
		
			out.print("<li class=\"active\">"+group.get(c).groupName+"</li>");
			out.print("</ol>");
		} catch(Exception e){
			e.printStackTrace();
		}
	}
	
	public ArrayList<Integer> getPgroup(int c){
		ArrayList<Group> group = pgroups.get(c);
		ArrayList<Integer> list = new ArrayList<Integer>();
		
		if(group == null){
			list.add(-1);
			return list;
		}
		
		for(int i=0; i<group.size(); i++){
			list.add(group.get(i).groupNum);
		}
		return list;
	}
	public ArrayList<Integer> getUserGroup(Connection conn,String studentId) throws SQLException{
		ArrayList<Integer> userGroup = getUserGroupInfo(conn,studentId);
		ArrayList<Integer> list = new ArrayList<Integer>();
		
		for (int i=0; i<userGroup.size(); i++){
			if(!pgroups.containsKey(userGroup.get(i)))
				list.add(userGroup.get(i));
		}
		
		return list;
	}

	
	public void userSelectGroupPrint(JspWriter out, int parent){
		if (!pgroups.containsKey(parent)) return ;
		ArrayList<Group> temp = pgroups.get(parent);

		for (int i = 0; i < temp.size(); i++) {
			Group group = temp.get(i);
			boolean bParent = pgroups.containsKey(group.groupNum);
				
			try {
				out.print("<li class=\"treeview\">");
				out.print("<a href=\"#\">");
				if(bParent)
					out.print("<i class=\"fa fa-circle-o\"></i><span class=\"gname\" style=\"color:#4C4C4C\">" + group.groupName + "</span>");
				else{
					out.print("<i class=\"fa fa-circle-o\"></i><span class=\"u_gname\" name=\""+group.groupNum+"\" style=\"color:#4C4C4C\">" + group.groupName + "</span>");
					out.print("<span class=\"pull-right-container\"><i class=\"fa fa-plus pull-right s_add\"></i>");
				}
					
				if (bParent)
					out.print("<i class=\"fa fa-angle-left pull-right\"></i>");	
				out.print("</span></a>");
			
				if (bParent) {
					out.print("<ul class=\"treeview-menu\">");
					userSelectGroupPrint(out, group.groupNum);
					out.print("</ul>");
				}
				out.print("</li>");
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	
	private ArrayList<Integer> getUserGroupInfo(Connection conn, String studentId) throws SQLException {
		ArrayList<Integer> userGroup = new ArrayList<Integer>();
		
		String sql = "select * from userGroup where studentId = ?";
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1,studentId);
		ResultSet rs = pstmt.executeQuery();
		
		if(rs == null)
			return userGroup;
		
		while(rs.next()){
			userGroup.add((Integer)rs.getObject("groupNum"));
		}
		return userGroup;
		
	}
	
	public void printByUserGroup(Connection conn, JspWriter out, String studentId, int parent) throws SQLException {
		if (!pgroups.containsKey(parent)) return ;
		
		ArrayList<Group> temp = pgroups.get(parent);
		ArrayList<Integer> userGroups = getUserGroupInfo(conn, studentId);
		
		for (int i = 0; i < temp.size(); i++) {
			Group group = temp.get(i);
			boolean bParent = pgroups.containsKey(group.groupNum);
			if(userGroups.indexOf(group.groupNum) == -1)
				continue;
			try {
				out.print("<li class=\"treeview\">");
				out.print("<a href=\"#\">");
				if(bParent)
					out.print("<i class=\"fa fa-circle-o\"></i><span style=\"color:#4C4C4C\">" + group.groupName + "</span>");
				else{
					out.print("<i class=\"fa fa-circle-o\"></i><span name=\""+group.groupNum+"\" style=\"color:#4C4C4C\" >" + group.groupName + "</span>");
					out.print("<span class=\"pull-right-container\"><i class=\"fa fa-hand-o-right pull-right\" onclick=\"location.href='./pracBoard.jsp?group="+group.groupNum+"'\"></i>");
				}
					
				if (bParent)
					out.print("<i class=\"fa fa-angle-left pull-right\"></i>");	
				out.print("</span></a>");
			
				if (bParent) {
					out.print("<ul class=\"treeview-menu\">");
					printByUserGroup(conn,out,studentId, group.groupNum);
					out.print("</ul>");
				}
				out.print("</li>");
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	

}
