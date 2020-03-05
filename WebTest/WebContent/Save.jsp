<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@page import="java.io.*" %>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONValue"%>
<%@page import="org.json.simple.parser.JSONParser"%>


<%

	request.setCharacterEncoding("UTF-8");
	String reqdata = request.getParameter("modeldata");

	JSONObject JsonData = (JSONObject)JSONValue.parse(reqdata);
	JSONArray ListData = (JSONArray) JsonData.get("nodeDataArray");
    System.out.println(ListData);
	Connection conn = null;
    PreparedStatement state = null;
	ResultSet rs    = null;
	try
	{
		Class.forName("org.mariadb.jdbc.Driver");
		conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/test","root","asdf1234");
		if(conn == null)
		{
			throw new Exception("실패");
		} 
		state = conn.prepareStatement("TRUNCATE TABLE TEST");
		state.executeUpdate();
		for(int i = 0; i< ListData.size(); i++){
			JSONObject tmp = (JSONObject) ListData.get(i);
			if(tmp.get("parent") != null){
				state = conn.prepareStatement("INSERT INTO test (seq,name,title,parent,imgpath,age) Values (?,?,?,?,?,?) ");
				state.setString(1,tmp.get("key").toString());
				state.setString(2,tmp.get("name").toString());
				state.setString(3,tmp.get("title").toString());
				state.setString(4,tmp.get("parent").toString());
				state.setString(5,tmp.get("imgpath").toString());
				state.setString(6,tmp.get("age").toString());
			}
			else{
				state = conn.prepareStatement("INSERT INTO test (seq,name,title,parent,imgpath,age) Values (?,?,?,?,?,?) ");
				state.setString(1,tmp.get("key").toString());
				state.setString(2,tmp.get("name").toString());
				state.setString(3,tmp.get("title").toString());
				state.setString(4,"0");
				state.setString(5,tmp.get("imgpath").toString());
				state.setString(6,tmp.get("age").toString());
			}
			state.executeUpdate();
		}

		state.close();
		conn.commit();
		conn.close();

	  } catch(SQLException ex) {

	  out.println(ex.getMessage());

	  ex.printStackTrace();

	  } finally {

	  if (rs != null) try { rs.close(); } catch(SQLException ex) {}

	  if (state != null) try { state.close(); } catch(SQLException ex) {}


	  // 7. 커넥션 종료

	  if (conn != null) try { conn.close(); } catch(SQLException ex) {}

	  }
%>