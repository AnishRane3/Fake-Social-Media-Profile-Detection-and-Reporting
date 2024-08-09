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
        
        <title>My Profile | Admin</title>
        <style>
            .dashboard-section {
                background-color: #fff;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                padding: 20px;
                margin-bottom: 20px;
            }
        </style>
    </head>
    <body>
        <%
            Connection connection = null;
            PreparedStatement preparedStatement = null;
            ResultSet resultSet = null;

            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/fakeprofilesystem", "root", "");
            String userid = (String) session.getAttribute("u_id");
            String userQuery = "SELECT id, name, email, password, role, last_login, last_logout, login_logout_count, time_spent FROM user WHERE id = ?";

            preparedStatement = connection.prepareStatement(userQuery);
            preparedStatement.setString(1, userid); 
            resultSet = preparedStatement.executeQuery();
            String lastLogin = null;
            String lastLogout = null;
            String role = null;
            String password = null;
            String email = null;
            String name = null;
            String userId = null;
            
            int loginLogoutCount = 0;

            int timeSpentInSeconds = 0;

            if (resultSet.next()) {
                lastLogin = resultSet.getString("last_login");
                lastLogout = resultSet.getString("last_logout");
                loginLogoutCount = resultSet.getInt("login_logout_count");
                timeSpentInSeconds = resultSet.getInt("time_spent");
                role = resultSet.getString("role");
                password = resultSet.getString("password");
                email = resultSet.getString("email");
                name = resultSet.getString("name");
                userId = resultSet.getString("id");
            }
            int hours = timeSpentInSeconds / 3600;
            int minutes = (timeSpentInSeconds % 3600) / 60;
            int seconds = timeSpentInSeconds % 60;

            String formattedTimeSpent = String.format("%02d:%02d:%02d", hours, minutes, seconds);
        %>
        <div class="container mt-5">
            <div class="dashboard-container">
                <h2 class="mb-4" style="margin-top:-20px">User Profile</h2>
                <h4>Your Profile Information</h4>
                <hr style="background-color:black">
                <div class="row" style="font-weight:500">
                    <div class="col-md-6">
                        <div class="dashboard-section" style="background-color:#cceeff;">
                            <p>User id: <span id="signInsToday"><%= userId %></span></p>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="dashboard-section" style="background-color:#cceeff;">
                            <p>Name: <span id="timeSpend"><%= name %></span></p>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="dashboard-section" style="background-color:#cceeff">
                            <p>Email id: <span id="lastSignIn"><%= email %></span></p>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="dashboard-section" style="background-color:#cceeff">
                            <p>Role: <span id="lastSignOut"><%= role %></span></p>
                        </div>
                    </div>
                    <hr style="background-color:black;margin-left:12px ;height:0.1px;width:98%">
                     <div class="col-md-12">
                        <div class="dashboard-section" style="background-color:#cceeff;">
                            <p>Password: <span id="signInsToday"><%= password %></span></p>
                        </div>
                    </div>
                    <div class="col-md-12">
                        <div class="dashboard-section" style="background-color:#cceeff;">
                            <p>Sign-Ins Today:  <span id="timeSpend"><%= loginLogoutCount %></span></p>
                        </div>
                    </div>
                    <div class="col-md-12">
                        <div class="dashboard-section" style="background-color:#cceeff">
                            <p>Time Spend in last Session: <span id="lastSignIn"><%= formattedTimeSpent %></span></p>
                        </div>
                    </div>
                    <hr style="background-color:black;margin-left:12px ;height:0.1px;width:98%">
                    <div class="col-md-6">
                        <div class="dashboard-section" style="background-color:#cceeff">
                            <p>Last Sign-In: <span id="lastSignOut"><%= lastLogin%></span></p>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="dashboard-section" style="background-color:#cceeff">
                            <p>Last Sign-Out: <span id="lastSignOut"><%= lastLogout %></span></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
