<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<jsp:include page="SideBar.jsp"></jsp:include>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detect Profile</title>

    <!-- Include Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    

    <!-- Your CSS styles here -->
    <link rel="stylesheet" href="../css/DetectProfileStyle.css">
    
    <style>
        .report-box {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background-color: #f8f9fa; /* Light gray background */
            padding: 30px;
            border: 1px solid #1393de; /* Border color */
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.2);
            z-index: 999;
            width: 70%; /* Adjust the width as needed */
            max-width: 650px; /* Set a maximum width */
        }

        .overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 998;
        }
        .close-icon {
            position: absolute;
            top: 10px;
            right: 20px;
            cursor: pointer;
            font-size: 40px;
            color: #1393de;
        }   
    </style>
</head>
<body style="background-color:white">
<%
    // Check if session attributes have values
    String profileName = (String) session.getAttribute("profilename");
    String meanScore = (String) session.getAttribute("meanScore");
    String fakeProbability = (String) session.getAttribute("fakeProbability");
    String realProbability = (String) session.getAttribute("realProbability");
    String userProfilePic = (String) session.getAttribute("userProfilePic");
    String userPrivate = (String) session.getAttribute("userPrivate");
    String pieChartImage = (String) session.getAttribute("pieChartImage");
    String barChartImage = (String) session.getAttribute("barChartImage");

    boolean hasData = profileName != null && meanScore != null && fakeProbability != null &&
                      realProbability != null && userProfilePic != null && userPrivate != null &&
                      pieChartImage != null && barChartImage != null;
%>
<div class="container" style="margin-top:80px">
    <div class="form-container p-4">
        <h2 class="text-center">Detect Profile</h2>

        <!-- Inside your form in DetectProfile.jsp -->
        <form action="../DetectProfileServlet" method="post">
            <div class="form-group">
                <select id="Platform" name="Platform" class="form-input" style="margin-bottom:-10px;">
                <option value="insta">Instagram</option>
                <option value="x">X (Twitter)</option>
                <option value="fb">Facebook</option>
                <option value="snap">Snapchat</option>
                </select><br>
                <input type="text" class="form-input" id="profilename" name="profilename" placeholder="Profile Username" required style="margin-bottom:20px;">
            </div>
            <button type="submit" name="detectProfileBtn">Analyze the Profile</button>
        </form>
        
    </div>
    <br>
    <% Boolean profileNotFound = (Boolean) session.getAttribute("profileNotFound"); 
        if (profileNotFound != null && profileNotFound) { %>
        <div class="container mt-5">
            <div class="alert alert-danger" role="alert" style="position: fixed; top: 0; left: 10px; right: 10px; width: calc(100% - 20px); margin: 10px auto; z-index: 999;">
                Profile not found! Please check the provided username.
            </div>
            
        </div>
        <script>
        // Set profileNotFound to false after 2000 milliseconds (2 seconds)
        setTimeout(function() {
            document.querySelector('.alert').style.display = 'none';
            <% session.setAttribute("profileNotFound", false); %>
        }, 5000);
    </script>
    <% } else {%>
        <div class="container mt-5">
            <div class="alert alert-success" role="alert" style="position: fixed; top: 0; left: 10px; right: 10px; width: calc(100% - 20px); margin: 10px auto; z-index: 999;">
               Done Successfully.
            </div>
        </div>
        <script>
        // Set profileNotFound to false after 2000 milliseconds (2 seconds)
        setTimeout(function() {
            document.querySelector('.alert').style.display = 'none';
            <% session.setAttribute("profileNotFound", false); %>
        }, 5000);
    </script>
    <% if (hasData) { %>
    <div>
        
        <h2 style="text-decoration: underline;margin-top:-25px;padding-bottom:20px;text-align: center"><b>Profile Detection Results</b></h2>
        <h5>Profile Name is  ${sessionScope.profilename}</h5>
        <%
        String features = (String) session.getAttribute("features");

        String cleanedFeatures = features.replace("[", "").replace("#", "").replace("]", "");
        %>
        <h5>Parameter Checked <%=cleanedFeatures%></h5>
        <h5>Number of words in full name:  ${numofwordsinfullname}</h5>
        <h5>Ratio of numbers to the length of the username:  ${Ratioofnumlengthusername}</h5>
        <h5>Ratio of numbers to the length of the full name:  ${Ratioofnumlengthfullname}</h5>
        <h5>User has profile pic:  ${userProfilePic}</h5>
        <h5>User profile is private:  ${userPrivate}</h5>
        <h5>Name is same as Username:  ${nameEqualusername}</h5>
        <h5>User has External URL:  ${externalURL}</h5>
        <h5>Description Length:  ${Descriptionlength}</h5>
        <h5>Number of post:  ${numofpost}</h5>
        <h5>Number of followers:  ${numoffollowers}</h5>
        <h5>Number of follows:  ${numoffollows}</h5>
        <h5>Fake Probability of  ${sessionScope.profilename} is<span style="color: #1f77b4;"> ${fakeProbability}%</span></h5>
        <h5>Real Probability of  ${sessionScope.profilename} is<span style="color: #ff7f0e;"> ${realProbability}%</span></h5>
        <h5>Mean Cross-Validation Score: ${meanScore}</h5> 
        <hr style="height: 2px;background-color: #f0f0f0">
        <img style="margin-left: -330px" src="${sessionScope.pieChartImage}" alt="Pie Chart">
        <img style="margin-left: -120px" src="${sessionScope.barChartImage}" alt="Bar Chart">
        <hr style="height: 2px;background-color: #f0f0f0">
        <div style="display: flex;justify-content: center;margin-bottom: 20px">
            <button style="margin:10px;color: black;background-color: #ffa0b4; width:150px" onclick="showReportBox()">Report Profile</button>
            <form  style="margin:10px;" action="../SaveDetectedProfileServlet" method="post">
                <button style="color: black;background-color: #9ad0f5;">Save & Clear</button>
            </form>
            <form style="margin:10px;" action="../GenerateReportServlet" method="get">
                <button style="color: black;background-color: #9af5c3;">Generate Report(PDF)</button>
            </form>
        </div>
    </div>
    <% } }%>
    
    <div class="report-box" id="reportBox">
        <span class="close-icon" onclick="closeReportBox()">&times;</span>
        <form action="../ReportProfileServlet" method="post">

            <h3>Report Profile <b>${profilename}</b></h3>
            <div class="form-group">
                <label for="Description">Description</label>
                <input type="text" class="form-input" id="desc" name="desc" placeholder="Description" required style="margin-bottom:20px;">
                
                <label for="fake_profile_prob">Fake Profile Probability(asper your observation)</label>
                <select id="fake_prob" name="fake_prob" class="form-input" style="margin-bottom:-10px;">
                <option value="low">Low</option>
                <option value="average">Average</option>
                <option value="high">High</option>
                <option value="very high">Very High</option>
                </select>
                <button style="margin-top:40px;width: 100%;max-width: 600px;" type="submit">Report Profile</button> 
            </div>
        </form>
    </div>
    <div class="overlay" id="overlay"></div>
</div>

<script>
    function showReportBox() {
        document.getElementById('reportBox').style.display = 'block';
        document.getElementById('overlay').style.display = 'block';
    }

    function closeReportBox() {
        document.getElementById('reportBox').style.display = 'none';
        document.getElementById('overlay').style.display = 'none';
    }
</script>
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

</body>
</html>
