<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	//로그인 세션 체크
   if(session.getAttribute("userid") == null){ 
%>
   <script> 
      alert('로그인 후 이용하세요');
      location.href='./login.jsp';
   </script>
<%
   }else{
	   //info.jsp로부터 데이터를 전달받음. 
	   request.setCharacterEncoding("UTF-8");
	   String useridx = (String)session.getAttribute("useridx");
	   String userid = (String)session.getAttribute("userid");
	   String userpw = request.getParameter("userpw");
	   String username = request.getParameter("username");
	   String hp = request.getParameter("hp");
	   String email = request.getParameter("email");
	   String hobby[] = request.getParameterValues("hobby");
	   String hobbystr = "";
	    for(int i=0; i< hobby.length; i++) {
			hobbystr = hobbystr +hobby[i] + " ";
		}
	   String ssn1 = request.getParameter("ssn1");
	   String ssn2 = request.getParameter("ssn2");
	   String zipcode = request.getParameter("zipcode");
	   String address1 = request.getParameter("address1");
	   String address2 = request.getParameter("address2");
	   String address3 = request.getParameter("address3");
	   
	   //DB 연결 
		Connection conn = null; 
	    PreparedStatement pstmt = null; 
	    ResultSet rs1 =null;
	    ResultSet rs2 =null;
	    
	    String sql= ""; 
	    String url = "jdbc:mysql://localhost:3306/jspstudy"; 
	    String uid= "root"; 
	    String upw = "1234";
	    
	    try{
	    	Class.forName("com.mysql.jdbc.Driver"); //com.mysql.cj.jdbc.Driver 
	    	conn = DriverManager.getConnection(url, uid, upw);
	    	if(conn != null) { //연결되었다면, 
		    	//비밀번호가 맞는지 체크 
		    	sql = "SELECT mem_idx,mem_userid,mem_userpw FROM tb_member WHERE mem_userid=? AND mem_userpw=?"; 
		    	pstmt = conn.prepareStatement(sql);
	    		pstmt.setString(1,userid);
	    		pstmt.setString(2,userpw);
	    		rs1=pstmt.executeQuery(); 
				
	    		if(rs1.next()){  // 비밀번호 일치
	    			//update문 실행
	    			sql = "UPDATE tb_member SET mem_name = ?,mem_hp = ?, mem_email = ?, mem_hobby = ?, mem_ssn1 = ?, mem_ssn2 = ?, mem_zipcode = ?, mem_address1 = ?, mem_address2 = ?, mem_address3 = ? WHERE mem_idx= ?;"; 
		    		pstmt = conn.prepareStatement(sql);
		    		pstmt.setString(1,username);
		    		pstmt.setString(2,hp);
		    		pstmt.setString(3,email);
		    		pstmt.setString(4,hobbystr);
		    		pstmt.setString(5,ssn1);
		    		pstmt.setString(6,ssn2);
		    		pstmt.setString(7,zipcode);
		    		pstmt.setString(8,address1);
		    		pstmt.setString(9,address2);
		    		pstmt.setString(10,address3);
		    		pstmt.setString(11,useridx);
		    		pstmt.executeUpdate();     
		    		
	    			%>
	    			<script>
						alert('회원정보가 수정되었습니다.');
						location.href = 'info.jsp';  //info.jsp 로 이동. 
					</script>
	    			<%
	    		}
	    	}else{// 비밀번호 불일치
	    		%>
    			<script>
					alert('비밀번호를 확인하세요');
					history.back();
				</script>
    			<%
	    	}
	    
	    }catch(Exception e){
	    	e.printStackTrace(); 
	    }
   %>
   
   