<%@page import="java.text.DateFormatSymbols"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<jsp:include page="SideBar.jsp"></jsp:include>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Analytics</title>
    <!-- Include Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <!-- Include Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        /* Add custom CSS for container and box shadow */
        .custom-container {
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            border-radius: 10px;
            margin-top: 20px;
        }
    </style>
</head>
<body style="background-color: white">
    
    <div class="container mt-5">
        <div class="row">
            <div class="col-md-8 offset-md-2 text-center">
                <h2 class="mb-4" style="text-align:left">Analytics</h2>
                <div class="custom-container"> <!-- Apply custom container class here -->
                    

                    <!-- Dropdown for selecting time range -->
                    <div class="form-group">
                        <label for="timeRange">Select Time Range:</label>
                        <select id="timeRange" class="form-control" onchange="updateChart()">
                            <option value="previousYear">Previous Year</option>
                        </select>
                    </div>

                    <!-- Chart to display analytics --> 
                    <canvas id="analyticsChart" width="1400" height="1000"></canvas>        
                </div>    
            </div>
                
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
                            PreparedStatement delpreparedStatement = null;
                            PreparedStatement Fin_updatepreparedStatement = null;
                            ResultSet resultSet = null;
                            
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/fakeprofilesystem", "root", "");

                            String user_id = (String) session.getAttribute("u_id");

                            String sqlQuery = "SELECT * FROM detected_tbl WHERE detected_by = ? ORDER BY detection_date DESC";
                            preparedStatement = connection.prepareStatement(sqlQuery);
                            preparedStatement.setString(1, user_id);

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

                            String sqlQuery1 = "SELECT * FROM reported_profile_tbl WHERE reported_by = ? ORDER BY reported_date DESC";
                            preparedStatement = connection.prepareStatement(sqlQuery1);
                            preparedStatement.setString(1, user_id);

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

    <%
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/fakeprofilesystem", "root", "");

        // Get Detected Profile Data
        String detectedSqlQuery = "SELECT MONTH(detection_date) AS month, COUNT(*) AS count FROM detected_tbl WHERE detected_by = ? AND YEAR(detection_date) = YEAR(CURDATE() - INTERVAL 1 YEAR) GROUP BY month ORDER BY month";
        preparedStatement = connection.prepareStatement(detectedSqlQuery);
        preparedStatement.setString(1, user_id);

        resultSet = preparedStatement.executeQuery();
        List<String> detectedLabels = new ArrayList<String>();
        List<Integer> detectedPoints = new ArrayList<Integer>();
        while (resultSet.next()) {
            int month = resultSet.getInt("month");
            String monthName = new DateFormatSymbols().getMonths()[month - 1]; // Convert month number to month name
            detectedLabels.add(monthName);
            detectedPoints.add(resultSet.getInt("count"));
        }

        // Get Reported Profile Data
        String reportedSqlQuery = "SELECT MONTH(reported_date) AS month, COUNT(*) AS count FROM reported_profile_tbl WHERE reported_by = ? AND YEAR(reported_date) = YEAR(CURDATE() - INTERVAL 1 YEAR) GROUP BY month ORDER BY month";
        preparedStatement = connection.prepareStatement(reportedSqlQuery);
        preparedStatement.setString(1, user_id);

        resultSet = preparedStatement.executeQuery();
        List<String> reportedLabels = new ArrayList<String>();
        List<Integer> reportedPoints = new ArrayList<Integer>();
        while (resultSet.next()) {
            int month = resultSet.getInt("month");
            String monthName = new DateFormatSymbols().getMonths()[month - 1]; // Convert month number to month name
            reportedLabels.add(monthName);
            reportedPoints.add(resultSet.getInt("count"));
        }

        // Prepare a list of all months
        String[] allMonths = new DateFormatSymbols().getMonths();
        List<String> allMonthsList = Arrays.asList(allMonths);
        allMonthsList = allMonthsList.subList(0, allMonthsList.size() - 1); // Remove the empty month at the end

        // Convert Java lists to JavaScript arrays
        StringBuilder allMonthsArray = new StringBuilder("[");
        for (int i = 0; i < allMonthsList.size(); i++) {
            allMonthsArray.append("'").append(allMonthsList.get(i)).append("'");
            if (i < allMonthsList.size() - 1) {
                allMonthsArray.append(",");
            }
        }
        allMonthsArray.append("]");

        StringBuilder detectedLabelsArray = new StringBuilder("[");
        StringBuilder detectedPointsArray = new StringBuilder("[");

        for (int i = 0; i < allMonthsList.size(); i++) {
            String monthName = allMonthsList.get(i);
            detectedLabelsArray.append("'").append(monthName).append("'");
            
            // Check if the month exists in the detected data, if not, set count to 0
            int count = detectedLabels.indexOf(monthName) != -1 ? detectedPoints.get(detectedLabels.indexOf(monthName)) : 0;
            detectedPointsArray.append(count);

            if (i < allMonthsList.size() - 1) {
                detectedLabelsArray.append(",");
                detectedPointsArray.append(",");
            }
        }

        detectedLabelsArray.append("]");
        detectedPointsArray.append("]");

        StringBuilder reportedLabelsArray = new StringBuilder("[");
        StringBuilder reportedPointsArray = new StringBuilder("[");

        for (int i = 0; i < allMonthsList.size(); i++) {
            String monthName = allMonthsList.get(i);
            reportedLabelsArray.append("'").append(monthName).append("'");
            
            // Check if the month exists in the reported data, if not, set count to 0
            int count = reportedLabels.indexOf(monthName) != -1 ? reportedPoints.get(reportedLabels.indexOf(monthName)) : 0;
            reportedPointsArray.append(count);

            if (i < allMonthsList.size() - 1) {
                reportedLabelsArray.append(",");
                reportedPointsArray.append(",");
            }
        }

        reportedLabelsArray.append("]");
        reportedPointsArray.append("]");
    %>
                    
<script>
    var ctx = document.getElementById('analyticsChart').getContext('2d');
    var myChart;

    var allMonths = <%= allMonthsArray.toString() %>;
    var detectedLabels = <%= detectedLabelsArray.toString() %>;
    var detectedPoints = <%= detectedPointsArray.toString() %>;

    var reportedLabels = <%= reportedLabelsArray.toString() %>;
    var reportedPoints = <%= reportedPointsArray.toString() %>;

    if (allMonths.length > 0 && detectedLabels.length > 0 && detectedPoints.length > 0 && reportedLabels.length > 0 && reportedPoints.length > 0) {
        if (myChart) {
            myChart.destroy();
        }

        myChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: allMonths,
                datasets: [
                    {
                        label: 'Detected Profile Points',
                        data: detectedPoints,
                        borderColor: 'rgb(75, 192, 192)',
                        borderWidth: 2,
                        fill: false
                    },
                    {
                        label: 'Reported Profile Points',
                        data: reportedPoints,
                        borderColor: 'rgb(255, 99, 132)',
                        borderWidth: 2,
                        fill: false
                    }
                ]
            }
        });
    }
</script>

</body>
</html>
