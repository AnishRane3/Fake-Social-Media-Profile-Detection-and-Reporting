<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<jsp:include page="SideBar.jsp"></jsp:include>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add & Manage Users</title>
    <!-- Include Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        .adduser-container {
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            padding: 30px;
            width: 900px;   
            border-radius: 10px; 
            margin-top: 100px;
        }
    </style>
</head>
<body>
        <%
    Boolean adduserSuccess = (Boolean) session.getAttribute("adduserSuccess");

    if (adduserSuccess != null) {
        if (adduserSuccess) {
%>
            <div class="container mt-5">
                <div class="alert alert-success" role="alert" style="position: fixed; top: 0; left: 10px; right: 10px; width: calc(100% - 20px); margin: 10px auto; z-index: 999;">
                    User Added Successfully.
                </div>
            </div>
            <script>
                setTimeout(function() {
                    document.querySelector('.alert').style.display = 'none';
                }, 5000);
                <% session.removeAttribute("adduserSuccess"); %>
            </script>
<%
        } else {
%>
            <div class="container mt-5">
                <div class="alert alert-danger" role="alert" style="position: fixed; top: 0; left: 10px; right: 10px; width: calc(100% - 20px); margin: 10px auto; z-index: 999;">
                    Failed to add user.
                </div>
            </div>
            <script>
                setTimeout(function() {
                    document.querySelector('.alert').style.display = 'none';
                }, 5000);
                <% session.removeAttribute("adduserSuccess"); %>
            </script>
<%          
        }
    }
%>

 <%
    Boolean ManageUserSuccess = (Boolean) session.getAttribute("ManageUserSuccess");

    if (ManageUserSuccess != null) {
        if (ManageUserSuccess) {
%>
            <div class="container mt-5">
                <div class="alert alert-success" role="alert" style="position: fixed; top: 0; left: 10px; right: 10px; width: calc(100% - 20px); margin: 10px auto; z-index: 999;">
                    User data updated Successfully.
                </div>
            </div>
            <script>
                setTimeout(function() {
                    document.querySelector('.alert').style.display = 'none';
                }, 5000);
                <% session.removeAttribute("ManageUserSuccess"); %>
            </script>
<%
        } else {
%>
            <div class="container mt-5">
                <div class="alert alert-danger" role="alert" style="position: fixed; top: 0; left: 10px; right: 10px; width: calc(100% - 20px); margin: 10px auto; z-index: 999;">
                    Failed to update user data.
                </div>
            </div>
            <script>
                setTimeout(function() {
                    document.querySelector('.alert').style.display = 'none';
                }, 5000);
                <% session.removeAttribute("ManageUserSuccess"); %>
            </script>
<%          
        }
    }
%>


    <div class="container mt-5 adduser-container">
        <div class="">
            <h2 class="mb-4">Add Users</h2>

            <form action="../AddUserServlet" method="post">
                <div class="form-group">
                    <label for="name">Name:</label>
                    <input type="text" class="form-control" id="name" name="name" placeholder="Name" required>
                </div>

                <div class="form-group">
                    <label for="email">Email:</label>
                    <input type="email" class="form-control" id="email" name="email" placeholder="Email" required>
                </div>

                <div class="form-group">
                    <label for="password">Password:</label>
                    <input type="password" class="form-control" id="password" name="password" placeholder="Password" required>
                </div>

                <div class="form-group">
                    <label for="role">Role:</label>
                    <select class="form-control" id="role" name="role" required>
                        <option value="admin">admin</option>
                        <option value="user">user</option>
                    </select>
                </div>
                
                <button type="submit" class="btn" style="background-color:#9ad0f5;width: 100%;margin-top: 10px">Add User</button>
                
            </form>
        </div>
    </div>
    
    <div class="container mt-5">
        <h3 style="margin-top:70px">Users Information</h3>
        <div class="table-responsive"> 
            <table class="table table-sm">
                <thead> 
                    <tr>
                        <th scope="col">ID</th>
                        <th scope="col">Name</th>
                        <th scope="col">Email</th>
                        <th scope="col">Role</th>  
                        <th scope="col">Last login</th>
                        <th scope="col">Last logout</th> 
                        <th scope="col">No. of login</th>
                        <th scope="col">Time Spent</th> 
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
                            String deleteSqlQuery = "DELETE FROM user WHERE id=?";
                            delpreparedStatement = connection.prepareStatement(deleteSqlQuery);
                            delpreparedStatement.setString(1, request.getParameter("id"));  
                            delQuery = delpreparedStatement.executeUpdate();

                            if (delQuery > 0) {
                                session.setAttribute("deleteUserSuccess", true);
                            } else {
                                session.setAttribute("deleteUserSuccess", false);
                            }
                        }
                        

                        String sqlQuery = "SELECT * FROM user";
                        preparedStatement = connection.prepareStatement(sqlQuery);
                        
                        
                        resultSet = preparedStatement.executeQuery();
                        while (resultSet != null && resultSet.next()) {
                    %>
                    
                    <tr>
                        <td><%= resultSet.getString("id") %></td>
                        <td><%= resultSet.getString("name") %></td>
                        <td><%= resultSet.getString("email") %></td>
                        <td><%= resultSet.getString("role") %></td>
                        <td><%= resultSet.getString("last_login") %></td>
                        <td><%= resultSet.getString("last_logout") %></td>
                        <td><%= resultSet.getString("login_logout_count") %></td>
                        <td><%= formatTime(resultSet.getLong("time_spent")) %></td>
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
    </div>     
<%!
        // Function to format time from seconds to hh:mm:ss
        public String formatTime(long timeInSeconds) {
            long hours = timeInSeconds / 3600;
            long minutes = (timeInSeconds % 3600) / 60;
            long seconds = timeInSeconds % 60;
            return String.format("%02d:%02d:%02d", hours, minutes, seconds);
        }
    %>
     <div class="container mt-5 adduser-container">
        <div class="">
            <h2 class="mb-4">Manage Users</h2>

            <form action="../ManageUserServlet" method="post">
                <div class="form-group">
                    <label for="id">ID:</label>
                    <input type="text" class="form-control" id="M_id" name="M_id" placeholder="ID of user" required>
                </div>

                <div class="form-group">
                    <label for="name">Name:</label>
                    <input type="text" class="form-control" id="M_name" name="M_name" placeholder="Name" >
                </div>

                <div class="form-group">
                    <label for="email">Email:</label>
                    <input type="email" class="form-control" id="M_email" name="M_email" placeholder="Email" >
                </div>

                <div class="form-group">
                    <label for="password">Password:</label>
                    <input type="password" class="form-control" id="M_password" name="M_password" placeholder="Password" >
                </div>

                <button type="submit" class="btn" style="background-color:#9ad0f5;width: 100%;margin-top: 10px">Manage User</button>
                
            </form>
        </div>
    </div>
   <%
                    
        Boolean deleteUserSuccess = (Boolean) session.getAttribute("deleteUserSuccess");

        if (deleteUserSuccess != null) {
            if (deleteUserSuccess) {
        %>
            <!-- Display success alert -->
            <div class="container mt-5">
                <div class="alert alert-success" role="alert" style="position: fixed; top: 0; left: 10px; right: 10px; width: calc(100% - 20px); margin: 10px auto; z-index: 999;">
                    User Deleted Successfully.
                </div>
            </div>
            <script>
                setTimeout(function() {
                    document.querySelector('.alert').style.display = 'none';
                }, 5000);
                <% session.removeAttribute("deleteUserSuccess"); %>
            </script>
        <%
            } else {
        %>
            <!-- Display failure alert -->
            <div class="container mt-5">
                <div class="alert alert-danger" role="alert" style="position: fixed; top: 0; left: 10px; right: 10px; width: calc(100% - 20px); margin: 10px auto; z-index: 999;">
                    Failed to Delete User.
                </div>
            </div>
            <script>
                setTimeout(function() {
                    document.querySelector('.alert').style.display = 'none';
                }, 5000);
                <% session.removeAttribute("deleteUserSuccess"); %>
            </script>
        <%
            }
        }
    %>
      
    <!-- Include Bootstrap JS and Popper.js (for Bootstrap) -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
