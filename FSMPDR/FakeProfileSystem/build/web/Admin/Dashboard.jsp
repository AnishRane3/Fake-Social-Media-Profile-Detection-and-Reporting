<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="java.util.logging.Logger" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.ArrayList, java.util.List"%>

<!DOCTYPE html>
<jsp:include page="SideBar.jsp"></jsp:include>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>

    <!-- Include Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">

    <!-- Include Chart.js library -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <!-- Your CSS styles here -->
    <link rel="stylesheet" href="../css/UserDashboardStyle.css">
</head>
<body>
    <%! 
        List<String> getRecentErrors() {
        // Your implementation to retrieve recent errors goes here
        List<String> errors = new ArrayList<String>(); // Specify the type in diamond operator
        // Add logic to populate 'errors' list with recent errors
        return errors;
    }

    // Declaration of method outside scriptlet block
    void logError(Logger logger, String errorMessage) {
        logger.severe(errorMessage);
    }
%>
<%
    Connection connection = null;
    PreparedStatement preparedStatement = null;
    ResultSet resultSet = null;
    ResultSet resultSetUsers = null;
    ResultSet resultSetDetectedProfiles = null;
    ResultSet resultSetReportedProfiles = null;
    ResultSet resultSetFeedbacks = null;

        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/fakeprofilesystem", "root", "");

        String userid = (String) session.getAttribute("u_id");
        String userQuery = "SELECT last_login, last_logout, login_logout_count, time_spent FROM user WHERE id = ?";
        
        preparedStatement = connection.prepareStatement(userQuery);
        preparedStatement.setString(1, userid); 
        resultSet = preparedStatement.executeQuery();

        String lastLogin = null;
        String lastLogout = null;
        int loginLogoutCount = 0;
        
        int timeSpentInSeconds = 0;

        if (resultSet.next()) {
            lastLogin = resultSet.getString("last_login");
            lastLogout = resultSet.getString("last_logout");
            loginLogoutCount = resultSet.getInt("login_logout_count");
            timeSpentInSeconds = resultSet.getInt("time_spent");
        }
        int hours = timeSpentInSeconds / 3600;
        int minutes = (timeSpentInSeconds % 3600) / 60;
        int seconds = timeSpentInSeconds % 60;

        String formattedTimeSpent = String.format("%02d:%02d:%02d", hours, minutes, seconds);
        

        String queryUsers = "SELECT COUNT(*) AS totalUsers FROM user";
        preparedStatement = connection.prepareStatement(queryUsers);
        resultSetUsers = preparedStatement.executeQuery();
        int totalUsers = 0;
        if (resultSetUsers.next()) {
            totalUsers = resultSetUsers.getInt("totalUsers");
        }

        // Querying total detected profiles
        String queryDetectedProfiles = "SELECT COUNT(*) AS totalDetectedProfiles FROM detected_tbl";
        preparedStatement = connection.prepareStatement(queryDetectedProfiles);
        resultSetDetectedProfiles = preparedStatement.executeQuery();
        int totalDetectedProfiles = 0;
        if (resultSetDetectedProfiles.next()) {
            totalDetectedProfiles = resultSetDetectedProfiles.getInt("totalDetectedProfiles");
        }

        // Querying total reported profiles
        String queryReportedProfiles = "SELECT COUNT(*) AS totalReportedProfiles FROM reported_profile_tbl";
        preparedStatement = connection.prepareStatement(queryReportedProfiles);
        resultSetReportedProfiles = preparedStatement.executeQuery();
        int totalReportedProfiles = 0;
        if (resultSetReportedProfiles.next()) {
            totalReportedProfiles = resultSetReportedProfiles.getInt("totalReportedProfiles");
        }

        // Querying total feedbacks
        String queryFeedbacks = "SELECT COUNT(*) AS totalFeedbacks FROM feedback_tbl";
        preparedStatement = connection.prepareStatement(queryFeedbacks);
        resultSetFeedbacks = preparedStatement.executeQuery();
        int totalFeedbacks = 0;
        if (resultSetFeedbacks.next()) {
            totalFeedbacks = resultSetFeedbacks.getInt("totalFeedbacks");
        }

    // System Health
        String systemHealthMessage = "";
        String systemHealthColor = "green";  // Default color for a healthy system
        Logger logger = Logger.getLogger("YourLoggerName");

        // Check database connection
        if (connection != null && !connection.isClosed()) {
            systemHealthMessage += "Connected<br>";
        } else {
            systemHealthMessage += "Disconnected<br>";
            systemHealthColor = "red";  // Change color to indicate an issue

            logError(logger, "Database connection error");
        }

        // ... (existing code)

        // Display recent error messages
        List<String> recentErrors = getRecentErrors(); 
    
        String queryLastUserLogin = "SELECT email FROM user WHERE role != 'admin' ORDER BY last_login DESC LIMIT 1";
        preparedStatement = connection.prepareStatement(queryLastUserLogin);
        ResultSet resultSetLastUserLogin = preparedStatement.executeQuery();
        String lastUserLogin = null;
        if (resultSetLastUserLogin.next()) {
            lastUserLogin = resultSetLastUserLogin.getString("email");
        }

        // Querying last reported profile
        String queryLastReportedProfile = "SELECT * FROM reported_profile_tbl ORDER BY reported_date DESC LIMIT 1";
        preparedStatement = connection.prepareStatement(queryLastReportedProfile);
        ResultSet resultSetLastReportedProfile = preparedStatement.executeQuery();
        String lastReportedProfileInfo = null;
        if (resultSetLastReportedProfile.next()) {
            // Adjust this line based on your table columns
            lastReportedProfileInfo = resultSetLastReportedProfile.getString("profile_username");
        }

        // Querying last detected profile
        String queryLastDetectedProfile = "SELECT * FROM detected_tbl ORDER BY detection_date DESC LIMIT 1";
        preparedStatement = connection.prepareStatement(queryLastDetectedProfile);
        ResultSet resultSetLastDetectedProfile = preparedStatement.executeQuery();
        String lastDetectedProfileInfo = null;
        if (resultSetLastDetectedProfile.next()) {
            // Adjust this line based on your table columns
            lastDetectedProfileInfo = resultSetLastDetectedProfile.getString("profile_username");
        }

%>

<div class="container mt-5">
    <div class="dashboard-container">
         <h2 class="mb-4">Dashboard</h2>
         <h4>Your Sign-In Information</h4>
         <hr style="background-color:black">
         <div class="row">
            <div class="col-md-6">
                <div class="dashboard-section" style="background-color:#9ad0f5;">
                <p>Sign-Ins Today: <span id="signInsToday"><%= loginLogoutCount %></span></p>
                </div>
            </div>
            <div class="col-md-6">
                <div class="dashboard-section" style="background-color:#f3f59a;">
                <p>Time Spend in last Session: <span id="timeSpend"><%= formattedTimeSpent %></span></p>
                </div>
            </div>
            <div class="col-md-6">
                <div class="dashboard-section" style="background-color:#ffa0b4">
                <p>Last Sign-In: <span id="lastSignIn"><%= lastLogin %></span></p>
                </div>
            </div>
             
             <div class="col-md-6">
                <div class="dashboard-section" style="background-color:#9af5c3">
                <p>Last Sign-Out: <span id="lastSignOut"><%= lastLogout %></span></p>
                </div>
            </div>
        </div>
         
         <h4 class="mt-4">System Information</h4><hr style="background-color:black">
        <div class="row">
            <div class="col-md-6">
                <div class="dashboard-section">
                    <h3>Number of Users</h3>
                    <div style="color:red"><p>Total Users: <span id="no_users"><%= totalUsers %></span></p></div>
                </div>
            </div>

            <div class="col-md-6">
                <div class="dashboard-section">
                    <h3>Number of Detected Profiles</h3>
                    <div style="color:red"><p>Total Detected Profiles: <span id="no_detectedProfiles"><%= totalDetectedProfiles %></span></p></div>
                </div>
            </div>
        </div>
         <div class="row">
            <div class="col-md-6">
                <div class="dashboard-section">
                    <h3>Number of Reported Profiles</h3>
                    <div style="color:red"><p>Total Reported Profiles: <span id="no_reportedProfiles"><%= totalReportedProfiles %></span></p></div>
                </div>
            </div>

            <div class="col-md-6">
                <div class="dashboard-section">
                    <h3>Number of Feedback</h3>
                    <div style="color:red"><p>Total Feedback: <span id="no_feedbacks"><%= totalFeedbacks %></span></p></div>
                </div>
            </div>
        </div>
                
           <h4 class="mt-4">Last activity in system</h4><hr style="background-color:black">
        <div class="row">   
            <div class="col-md-6">
                <div class="dashboard-section">
                    <h3>Last User Login</h3>
                    <div style="color:red"><p>Last User Login: <span id="lastUserLogin"><%= lastUserLogin %></span></p></div>
                </div>
            </div>

            <div class="col-md-6">
                <div class="dashboard-section">
                    <h3>Last Reported Profile</h3>
                    <div style="color:red"><p>Last Reported Profile Info: <span id="lastReportedProfile"><%= lastReportedProfileInfo %></span></p></div>
                </div>
            </div>



            <div class="col-md-6">
                <div class="dashboard-section">
                    <h3>Last Detected Profile</h3>
                    <div style="color:red"><p>Last Detected Profile Info: <span id="lastDetectedProfile"><%= lastDetectedProfileInfo %></span></p></div>
                </div>
            </div>
        </div>     
                
                
                
        <h4 class="mt-4">System Health</h4><hr style="background-color:black">
        <div class="row">       
            
                <div class="col-md-12">
                    <div class="dashboard-section">
                        <h3>Database Status</h3>
                        <div><p>Database Connection Status: <span id="DdHelth" style="color: <%= systemHealthColor %>;"><%= systemHealthMessage %></span></p></div>
                    </div>
                </div>

                <div class="col-md-12">
                    <div class="dashboard-section">
                        <h3>Error Status</h3>
                        <% if (recentErrors.isEmpty()) { %>
                            <div><p>Recent Error: <span id="errorno" style="color:green">No errors</span></p></div>
                        <% } else { %>
                            <% for (String error : recentErrors) { %>
                                <div><p>Recent Error: <span id="erroryes" style="color:red"><%= error %></span></p></div>
                            <% } %>
                        <% } %>
                    </div>
                </div>
        </div>     
    </div>
</div>

<script> 
</script>
</body>
</html>
