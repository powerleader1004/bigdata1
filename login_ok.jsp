<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	String userid = request.getParameter("userid");
	String userpw = request.getParameter("userpw");
	
	Connection conn = null; 
    PreparedStatement pstmt = null; 
    ResultSet rs =null;
    
    String sql= ""; 
    String url = "jdbc:mysql://localhost:3306/jspstudy"; 
    String uid= "root"; 
    String upw = "1234";
    
    try{
    	Class.forName("com.mysql.jdbc.Driver"); //com.mysql.cj.jdbc.Driver 
    	conn = DriverManager.getConnection(url, uid, upw);
    	if(conn != null) { //연결되었다면, 
    		sql = "SELECT mem_idx,mem_name FROM tb_member WHERE mem_userid=? AND mem_userpw=?"; 
    		pstmt = conn.prepareStatement(sql);
    		pstmt.setString(1,userid);
    		pstmt.setString(2,userpw);
    		rs=pstmt.executeQuery(); 
    		
    		if(rs.next()){
    			// 로그인 성공!
    				session.setAttribute("userid",userid); //로그인할때 직접 입력한거.
    				session.setAttribute("username",rs.getString("mem_name")); //DB에서 가져온거. 
    				session.setAttribute("useridx",rs.getString("mem_idx")); 

    			%>
    			<script>
					alert('로그인 되었습니다');
					location.href = 'login.jsp';
				</script>
    			<%
    			
    		}else{
    			// 로그인 실패!
    			%>
    			<script>
					alert('아이디 또는 비밀번호를 확인하세요');
					history.back();
				</script>
    			<% 
    		}
    	}
    }catch(Exception e){
    	e.printStackTrace(); 
    }
%>