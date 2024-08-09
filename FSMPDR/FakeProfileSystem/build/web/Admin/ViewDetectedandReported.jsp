<%-- 
    Document   : ViewDetectedandReported
    Created on : 6 Feb, 2024, 9:43:24 PM
    Author     : ranea
--%>

<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<jsp:include page="SideBar.jsp"></jsp:include>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <title>JSP Page</title>
    </head>
    <body>
        <div class="container mt-5">
        <h3 style="margin-top:70px" >Detected Profiles</h3>
            <div class="table-responsive"> 
                <table class="table table-sm">
                    <thead> 
                        <tr>
                            <th scope="col">Profile Username</th>
                            <th scope="col">MCVs</th>
                            <th scope="col">Fake Probability</th>
                            <th scope="col">Real Probability</th>
                            <th scope="col">Profile Pic</th>
                            <th scope="col">Private</th>
                            <th scope="col">Detected Date</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            Connection connection = null;
                            PreparedStatement preparedStatement = null;
//                            PreparedStatement delpreparedStatement = null;
//                            PreparedStatement Fin_updatepreparedStatement = null;
                            ResultSet resultSet = null;
                            
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/fakeprofilesystem", "root", "");

                            String user_id = (String) session.getAttribute("u_id");

                            String sqlQuery = "SELECT * FROM detected_tbl ORDER BY detection_date DESC";
                            preparedStatement = connection.prepareStatement(sqlQuery);
                            

                            resultSet = preparedStatement.executeQuery();     
                            while (resultSet != null && resultSet.next()) {
                        %>
                        <tr>
                            <td><%= resultSet.getString("profile_username") %></td>
                            <td><%= resultSet.getString("mcvs") %></td>
                            <td><%= resultSet.getString("fake_prob") %></td>
                            <td><%= resultSet.getString("real_prob") %></td>
                            <td><%= resultSet.getInt("has_profilepic") == 1 ? "Yes" : "No" %></td>
                            <td><%= resultSet.getInt("is_private") == 1 ? "Yes" : "No" %></td>
                            <td><%= resultSet.getString("detection_date") %></td>
                        </tr>
                        <% 
                        } %>
                    </tbody>
                </table>
            </div>
            <hr style=" margin-top:40px;height: 0.1px;width:100%;background-color:black">
            <h3 style="margin-top:50px">Reported Profiles</h3>
            <div class="table-responsive"> 
                <table class="table table-sm">
                    <thead> 
                        <tr>
                            <th scope="col">Description</th>
                            <th scope="col">priority check</th>
                            <th scope="col">profile_username</th>
                            <th scope="col">MCVs</th>
                            <th scope="col">Fake Probability</th>
                            <th scope="col">Real Probability</th>
                            <th scope="col">Profile Pic</th>
                            <th scope="col">Private</th>
                            <th scope="col">reported_date</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/fakeprofilesystem", "root", "");

                            String sqlQuery1 = "SELECT * FROM reported_profile_tbl ORDER BY reported_date DESC";
                            preparedStatement = connection.prepareStatement(sqlQuery1);
                            

                            resultSet = preparedStatement.executeQuery();     
                            while (resultSet != null && resultSet.next()) {
                        %>
                        <tr>
                            <td><%= resultSet.getString("description") %></td>
                            <td><%= resultSet.getString("priority_check") %></td>
                            <td><%= resultSet.getString("profile_username") %></td>
                            <td><%= resultSet.getString("mcvs") %></td>
                            <td><%= resultSet.getString("fake_prob") %></td>
                            <td><%= resultSet.getString("real_prob") %></td>
                            <td><%= resultSet.getInt("has_profilepic") == 1 ? "Yes" : "No" %></td>
                            <td><%= resultSet.getInt("is_private") == 1 ? "Yes" : "No"%></td>
                            <td><%= resultSet.getString("reported_date") %></td>
                        </tr>
                        <% 
                        } %>
                    </tbody>
                </table>
            </div>
        </div>
    </body>
</html>
