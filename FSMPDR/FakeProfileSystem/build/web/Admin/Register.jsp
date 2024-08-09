<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="DBmanager.DBConnector"%>
<!DOCTYPE html>
<html>
<head>
    <title>Registration</title>
</head>
<body>
    <%  
        session.setAttribute("email", "");
        DBmanager.DBConnector d = new DBmanager.DBConnector();
        if (request.getParameter("email") == null) {
            // No form submission, do nothing
        } else {
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String pass = request.getParameter("password");
            String role = request.getParameter("role");

            if (name != null && email != null && pass != null && role != null) {
                int result = d.register(name, email, pass, role);
                if (result == 1) {
                    response.sendRedirect("./Login.jsp");
                } else {
                    out.print("Registration Failed");
                }
            }
        }
    %>
    <h2>Registration</h2>
    <form name="registration" id="registration" method="post">
        <label for="name">Name:</label>
        <input type="text" id="name" name="name" required><br><br>

        <label for="email">Email:</label>
        <input type="email" id="email" name="email" required><br><br>

        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required><br><br>

        <select id="role" name="role">
            <option value="" disabled selected>Choose your role</option>
            <option value="admin">Admin</option>
            <option value="user">User</option>
        </select>
        <label>Role</label><br><br>

        <input type="submit" value="Register">
    </form>
</body>
</html>
