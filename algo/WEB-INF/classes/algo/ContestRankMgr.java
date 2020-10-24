package algo;

import java.util.*;
import java.sql.*;

// javac algo/ContestRankMgr.java algo/DBUtil.java

public class ContestRankMgr {
	public static class User {
		public String userId, userName;
		public String date;
		public int completeCount;
		
		public User(String userId, String userName, String date) {
			this.userId = userId;
			this.userName = userName;
			this.date = date;
			completeCount = 1;
		}
	}
	
	public static class UserComparator implements Comparator<User> { 
		@Override
		public int compare(User user1, User user2) {
			if (user1.completeCount < user2.completeCount)			return 1;
			else if (user1.completeCount > user2.completeCount)		return -1;
			else
				return user1.date.compareTo(user2.date);
		}
	}
	
	public static ArrayList<User> GetRank(int contestId) {
		HashMap<String, User> userMap = new HashMap<String, User>();
		ArrayList<User> userList = new ArrayList<User>();
		
		try {
			Connection conn = DBUtil.getMySqlConnection();
			String sql = "select * from userLog where logNumber in (select min(logNumber) from userLog where questionId in (select questionId from question where contestId=?) and status='Complete' group by userId, questionId)order by logNumber";
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, contestId);
			ResultSet rs = pstmt.executeQuery();
			
			if (rs == null) {
				DBUtil.close(pstmt);
				DBUtil.close(conn);
				return null;
			}
			
			while (rs.next()) {
				String userId = rs.getString("userId");
				String userName = rs.getString("userName");
				String date = rs.getString("date");
				
				if (userMap.containsKey(userId)) {
					User user = userMap.get(userId);
					if (user.date.compareTo(date) < 0)
						user.date = date;
					user.completeCount++;
				}
				else {
					User user = new User(userId, userName, date);
					userMap.put(userId, user);
					userList.add(user);
				}
			}
			
			DBUtil.close(rs);
			DBUtil.close(pstmt);
			DBUtil.close(conn);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		Collections.sort(userList, new UserComparator());
		
		return userList;
	}
	
}