<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.ArrayList, java.util.List"%>

<!DOCTYPE html>
<jsp:include page="SideBar.jsp"></jsp:include>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Dashboard</title>

    <!-- Include Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">

    <!-- Include Chart.js library -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <!-- Your CSS styles here -->
    <link rel="stylesheet" href="../css/UserDashboardStyle.css">
</head>
<body>
<%
    Connection connection = null;
    PreparedStatement preparedStatement = null;
    ResultSet resultSet = null;
 
    List<Integer> counts = new ArrayList();
    String[] months = new String[]{"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};

        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/fakeprofilesystem", "root", "");
        // Assuming 'userid' is the user's ID stored in the session
    String userid = (String) session.getAttribute("u_id");

    // Modify the queries to consider the user's ID
    String reportedQuery = "SELECT COUNT(*) FROM reported_profile_tbl WHERE reported_by = ?";
    String detectedQuery = "SELECT COUNT(*) FROM detected_tbl WHERE detected_by = ?";

    // Set the user's ID as a parameter in the prepared statements
    preparedStatement = connection.prepareStatement(reportedQuery);
    preparedStatement.setString(1, userid);
    resultSet = preparedStatement.executeQuery();
    int reportedProfilesCount = 0;
    if (resultSet.next()) {
        reportedProfilesCount = resultSet.getInt(1);
    }    

    preparedStatement = connection.prepareStatement(detectedQuery);
    preparedStatement.setString(1, userid);
    resultSet = preparedStatement.executeQuery();
    int detectedProfilesCount = 0;   
    if (resultSet.next()) {
        detectedProfilesCount = resultSet.getInt(1);
    }

        String detectedQuery2 = "SELECT MONTH(detection_date) AS month, COUNT(*) AS count " +
                        "FROM detected_tbl " +
                        "WHERE detected_by = ? AND YEAR(detection_date) = YEAR(CURDATE()) " +
                        "GROUP BY MONTH(detection_date) " +
                        "ORDER BY month ASC";

                // Set the user's ID as a parameter in the prepared statement
                preparedStatement = connection.prepareStatement(detectedQuery2);
                preparedStatement.setString(1, userid);
                resultSet = preparedStatement.executeQuery();

                StringBuilder monthCounts = new StringBuilder("{");

                while (resultSet.next()) {
                    int month = resultSet.getInt("month");
                    int count = resultSet.getInt("count");
                    monthCounts.append("'").append(month).append("':").append(count).append(",");
                }

                // Remove the trailing comma and close the JSON-like structure
                if (monthCounts.charAt(monthCounts.length() - 1) == ',') {
                    monthCounts.deleteCharAt(monthCounts.length() - 1);
                }

                monthCounts.append("}");
        
        
        
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
         
         <h4 class="mt-4">Social Media Profile Information</h4><hr style="background-color:black">
        <div class="row">
            <div class="col-md-6">
                <div class="dashboard-section">
                    <h3>Reported Profiles</h3>
                    <div style="color:red"><p>Total Reported: <span id="reportedProfiles"><%= reportedProfilesCount %></span></p></div>
                </div>
            </div>

            <div class="col-md-6">
                <div class="dashboard-section">
                    <h3>Detected Profiles</h3>
                    <div style="color:red"><p>Total Detected: <span id="detectedProfiles"><%= detectedProfilesCount %></span></p></div>
                </div>
            </div>
        </div>

        <div class="row mt-4">
            <div class="col-md-12">
                <div>
                    <h2>Detected Profiles Graph(Current year in months)</h2>
                    <canvas style="max-width:60%;max-height: 600px;" id="profileChart"></canvas>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // Extracted data from the server
    var serverData = <%= monthCounts.toString() %>;

    // Fill in missing months with zero counts
    var dummyData = {
        labels: Array.from({ length: 12 }, function(_, i) { return i + 1; }),
        datasets: [{
            label: "Detected Profiles",
            data: Array.from({ length: 12 }, function(_, i) { return serverData[i + 1] || 0; }),
            backgroundColor: 'rgba(255, 99, 132, 0.2)',
            borderColor: 'rgba(255, 99, 132, 1)',
            borderWidth: 1
        }]
    };

    // Create the chart
    var ctx = document.getElementById('profileChart').getContext('2d');
    var myChart = new Chart(ctx, {
        type: 'bar',
        data: dummyData,
        options: {
            scales: {
                x: {
                    barPercentage: 0.8,
                    categoryPercentage: 0.7
                }
            }
        }
    });
</script>
</body>
</html>
