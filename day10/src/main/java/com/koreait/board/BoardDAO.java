package com.koreait.board;

import java.util.*;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;

import com.koreait.db.SqlMapConfigBoard;

public class BoardDAO {
   SqlSessionFactory ssf = SqlMapConfigBoard.getSqlMapInstance();
   SqlSession sqlsession;
   
   public BoardDAO() {
      sqlsession = ssf.openSession(true);   // openSessioni(true) 설정시 자동 commit
      System.out.println("마이바티스 설정 성공");
   }
   
   public int upload(BoardDTO board) {
      HashMap<String, String> dataMap = new HashMap<>();

      dataMap.put("b_userid", board.getUserid());
      dataMap.put("b_name", board.getName());
      dataMap.put("b_title", board.getTitle());
      dataMap.put("b_content", board.getContent());
      
      return sqlsession.insert("Member.join", dataMap);
   }
   
   public int count() { 
	   return sqlsession.insert("Board.totalCount");
   }
   
   public List<BoardDTO> selectList(String pageNum, int start){
	   
   }
   
}