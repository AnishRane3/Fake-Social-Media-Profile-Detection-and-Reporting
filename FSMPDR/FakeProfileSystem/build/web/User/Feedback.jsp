<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:include page="SideBar.jsp"></jsp:include>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Feedback Form</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

    <style>
        .feedback-container {
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            padding: 30px;
            width: 800px;   
            border-radius: 10px; 
            margin-top: 100px;
        }
    </style>
</head>
<body>
    <%
    Boolean feedbackSuccess = (Boolean) session.getAttribute("feedbackSuccess");

    if (feedbackSuccess != null) {
        if (feedbackSuccess) {
%>
            <div class="container mt-5">
                <div class="alert alert-success" role="alert" style="position: fixed; top: 0; left: 10px; right: 10px; width: calc(100% - 20px); margin: 10px auto; z-index: 999;">
                    Feedback Sent Successfully.
                </div>
            </div>
            <script>
                setTimeout(function() {
                    document.querySelector('.alert').style.display = 'none';
                }, 5000);
                <% session.removeAttribute("feedbackSuccess"); %>
            </script>
<%
        } else {
%>
            <div class="container mt-5">
                <div class="alert alert-danger" role="alert" style="position: fixed; top: 0; left: 10px; right: 10px; width: calc(100% - 20px); margin: 10px auto; z-index: 999;">
                    Failed to send Feedback.
                </div>
            </div>
            <script>
                setTimeout(function() {
                    document.querySelector('.alert').style.display = 'none';
                }, 5000);
                <% session.removeAttribute("feedbackSuccess"); %>
            </script>
<%          
        }
    }
%>
    <div class="container mt-5 feedback-container">
        <h3>Feedback Form</h3>
        <form action="../SubmitFeedbackServlet" method="post">
            <div class="form-group">
                <label for="subject">Subject:</label>
                <input type="text" class="form-control" id="subject" name="subject" required>
            </div>

            <div class="form-group">
                <label for="description">Description:</label>
                <textarea class="form-control" id="description" name="description" rows="5" required></textarea>
            </div>

            <button type="submit" class="btn" style="background-color:#9ad0f5;width: 100%;margin-top: 10px">Submit</button>
        </form>
    </div>
    <div class="container mt-5">
        <h3 style="margin-top:70px">Submitted Feedback</h3>
        <div class="table-responsive"> 
            <table class="table table-sm">
                <thead> 
                    <tr>
                        <th scope="col">Sr</th>
                        <th scope="col">Subject</th>
                        <th scope="col">Description</th>
                        <th scope="col">Submitted on</th>  
                        <th scope="col">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        Connection connection = null;
                        PreparedStatement preparedStatement = null;
                        PreparedStatement delpreparedStatement = null;
                        ResultSet resultSet = null;

                        Class.forName("com.mysql.cj.jdbc.Driver");
                        connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/fakeprofilesystem", "root", "");

                        int delQuery;

                        if (request.getParameter("id") != null) {
                            String deleteSqlQuery = "DELETE FROM feedback_tbl WHERE id=?";
                            delpreparedStatement = connection.prepareStatement(deleteSqlQuery);
                            delpreparedStatement.setString(1, request.getParameter("id"));  
                            delQuery = delpreparedStatement.executeUpdate();

                            if (delQuery > 0) {
                                session.setAttribute("deleteSuccess", true);
                            } else {
                                session.setAttribute("deleteSuccess", false);
                            }
                        }
                        
                        String user_id = (String) session.getAttribute("u_id");

                        String sqlQuery = "SELECT * FROM feedback_tbl WHERE feedback_by = ? ORDER BY created_on DESC";
                        preparedStatement = connection.prepareStatement(sqlQuery);
                        preparedStatement.setString(1, user_id);
                        
                        resultSet = preparedStatement.executeQuery();
                        int serialNumber = 1;
                        while (resultSet != null && resultSet.next()) {
                    %>
                    
                    <tr>
                        <td><%= serialNumber++ %></td>
                        <td><%= resultSet.getString("subject") %></td>
                        <td><%= resultSet.getString("description") %></td>
                        <td><%= resultSet.getString("created_on") %></td>
                        <td>
                            <a class="btn" style="color:red;font-size:18px" href="?id=<%=resultSet.getString("id")%>">
                                <i class="fa-solid fa-trash"></i>
                            </a>
                        </td>

                    </tr>
                    <% 
                    } %>
                </tbody>
            </table>
        </div>
                <%
                    Boolean deleteSuccess = (Boolean) session.getAttribute("deleteSuccess");
                     

                    if (deleteSuccess != null) {
                        if (deleteSuccess) {
                %>
                            <div class="container mt-5">
                                <div class="alert alert-success" role="alert" style="position: fixed; top: 0; left: 10px; right: 10px; width: calc(100% - 20px); margin: 10px auto; z-index: 999;">
                                    Feedback Deleted Successfully.
                                </div>
                            </div>
                            <script>
                                setTimeout(function() {
                                    document.querySelector('.alert').style.display = 'none';
                                }, 5000);
                                <% session.removeAttribute("deleteSuccess"); %>
                            </script>
                <%
                        } else {
                %>
                            <div class="container mt-5">
                                <div class="alert alert-danger" role="alert" style="position: fixed; top: 0; left: 10px; right: 10px; width: calc(100% - 20px); margin: 10px auto; z-index: 999;">
                                    Failed to Delete Feedback.
                                </div>
                            </div>
                            <script>
                                setTimeout(function() {
                                    document.querySelector('.alert').style.display = 'none';
                                }, 5000);
                                <% session.removeAttribute("deleteSuccess"); %>
                            </script>
                <%
                        }
                    }
                %>
    </div>
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
