<%-- 
    Document   : ViewFeedback
    Created on : 26 Jan, 2024, 3:19:55 PM
    Author     : ranea
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<jsp:include page="SideBar.jsp"></jsp:include>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>View Feedback | Admin</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    </head>
    <body>
        <div class="container mt-5">
        <h3 style="margin-top:70px">Submitted Feedback</h3>
        <div class="table-responsive"> 
            <table class="table table-sm">
                <thead> 
                    <tr>
                        <th scope="col">ID</th>
                        <th scope="col">Submitted by</th> 
                        <th scope="col">Subject</th>
                        <th scope="col">Description</th>
                        <th scope="col">Submitted on</th>  
                    </tr>
                </thead>
                <tbody>
                    <% 
                        Connection connection = null;
                        PreparedStatement preparedStatement = null;
                       
                        ResultSet resultSet = null;

                        Class.forName("com.mysql.cj.jdbc.Driver");
                        connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/fakeprofilesystem", "root", "");
                       

                        String sqlQuery = "SELECT * FROM feedback_tbl ORDER BY created_on DESC";
                        preparedStatement = connection.prepareStatement(sqlQuery);
                        
                        
                        resultSet = preparedStatement.executeQuery();
                        while (resultSet != null && resultSet.next()) {
                    %>
                    
                    <tr>
                        <td><%= resultSet.getString("id") %></td>
                        <td><%= resultSet.getString("email") %></td>
                        <td><%= resultSet.getString("subject") %></td>
                        <td><%= resultSet.getString("description") %></td>
                        <td><%= resultSet.getString("created_on") %></td>
                    </tr>
                     <% 
                    } %>
                </tbody>
            </table>
        </div>
    </div>
    </body>
</html>
