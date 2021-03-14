<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.*" %>
<%@ page import="com.koreait.board.BoardDTO" %>
<jsp:useBean id="dao" class="com.koreait.board.BoardDAO"/>
<jsp:useBean id="board" class="com.koreait.board.BoardDTO"/>
<%
	if(session.getAttribute("userid") == null){
%>
		<script>
			alert('로그인 후 이용하세요');
			location.href='../login.jsp';
		</script>
<%
		}else{
			
			Date from = new Date(); 
			SimpleDateFormat fm = new SimpleDateFormat("yyyy-MM-dd"); // 2021-03-02
			String to = fm.format(from);
		
			int totalCount = 0;	// 전체 글 개수
			int pagePerCount = 10; // 페이지당 글 개수
			int start = 0;	// 시작 글번호
			List<BoardDTO> list = new ArrayList<>(); 
			

			String pageNum = request.getParameter("pageNum");
			if(pageNum != null && !pageNum.equals("")){
				start = (Integer.parseInt(pageNum)-1) * pagePerCount;
			}else{
				pageNum = "1";
				start = 0;
			}
			
			try{
				Class.forName("com.mysql.jdbc.Driver");
				conn = DriverManager.getConnection(url, uid, upw);
				if(conn != null){
					
					sql = "select count(b_idx) as total from tb_board";
					pstmt = conn.prepareStatement(sql);
					rs = pstmt.executeQuery();
					if(rs.next()){
						totalCount = rs.getInt("total");
					}

					sql = "select * from tb_board order by b_idx desc limit ?, ?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setInt(1, start);
					pstmt.setInt(2, pagePerCount);
					rs = pstmt.executeQuery();
				}
				
			}catch(Exception e){
				e.printStackTrace();	
			}		
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>리스트</title>
</head>
<body>
	<h2>리스트</h2>
	<p>게시글 : <%=totalCount%>개</p>
	<table border="1" width="800">
		<tr>
			<th>번호</th>
			<th>제목</th>
			<th>글쓴이</th>
			<th>조회수</th>
			<th>좋아요</th>
			<th>날짜</th>
		</tr>
<%
	while(rs.next()){
		String b_idx = rs.getString("b_idx");
		String b_userid = rs.getString("b_userid");
		String b_name = rs.getString("b_name");
		String b_title = rs.getString("b_title");
		String b_regdate = rs.getString("b_regdate").substring(0,10);
		String b_up = rs.getString("b_up");
		String b_hit = rs.getString("b_hit");
		String b_file = rs.getString("b_file");
        String replyCntStr = "";
        String newDateStr = ""; 
        String fileStr ="";
        //String hasFile = ""; 
		
		sql = "select count(re_idx) as cnt from tb_reply where re_boardIdx = ?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, b_idx);
		ResultSet rs_reply = pstmt.executeQuery();	
													
		//sql = "select count(b_file) as cnt2 from tb_board where b_idx = ?;";
		//pstmt = conn.prepareStatement(sql);	
		//pstmt.setString(1, b_idx);
		//ResultSet rs_file = pstmt.executeQuery();
		
		
		
			
		if(to.equals(b_regdate)){
			newDateStr = "<img src = './images/new.png' alt='새글'>";
		}	
		
		
		if(rs_reply.next()){
			int cnt = rs_reply.getInt("cnt");
			if(cnt > 0){
				replyCntStr = "[" + cnt + "]";
			}
		}
		//if(rs_file.next()){
		//	int cnt2 = rs_file.getInt("cnt2");
		//	if(cnt2 > 0){
		//	hasFile = "<img src = './images/file.png' alt='파일'>";} 
		//}
		
		if(b_file != null && !b_file.equals("")){ 
			fileStr = "<img src ='./images/file.png' alt='파일'>"; 
		}

%>			
		<tr>
			<td><%=b_idx%></td>
			<td><a href="./view.jsp?b_idx=<%=b_idx%>"><%=b_title%></a><%=fileStr%><%=replyCntStr%><%=newDateStr%></td>
			<td><%=b_name%>(<%=b_userid%>)</td>
			<td><%=b_hit%></td>
			<td><%=b_up%></td>
			<td><%=b_regdate%></td>
		</tr>
<%
	}

	int pageNums = 0;
	if(totalCount % pagePerCount == 0){
		pageNums = (totalCount / pagePerCount); //25/5= 5
	}else{
		pageNums = (totalCount / pagePerCount) + 1; //24/5 = 4 +1 
	}
%>
		
		<tr>
			<td colspan="6">
				<%
					for(int i=1; i<=pageNums; i++){
						out.print("<a href='list.jsp?pageNum=" + i + "'>[" + i + "]</a>" + "&nbsp;&nbsp;");
					}
				%>
			
			</td>
		</tr>
		<tr>
			<td colspan="6"><input type="button" value="글작성" onclick="location.href='./write.jsp'"> 
			<input type="button" value="돌아가기" onclick="location.href='../login.jsp'"></td>
		</tr>
	</table>
</body>
</html>
<%
	}
%>