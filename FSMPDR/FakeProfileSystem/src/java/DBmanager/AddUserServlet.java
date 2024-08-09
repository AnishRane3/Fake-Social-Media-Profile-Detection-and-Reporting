/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DBmanager;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/AddUserServlet")
public class AddUserServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        // Retrieve form parameters
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        Connection connection = null;
        PreparedStatement preparedStatement = null;
        boolean adduserSuccess = false;
        try {
            // Establish a database connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/fakeprofilesystem", "root", "");

            // Prepare SQL statement
            String sqlQuery = "INSERT INTO user (name, email, password, role) VALUES (?, ?, ?, ?)";
            preparedStatement = connection.prepareStatement(sqlQuery);
            preparedStatement.setString(1, name);
            preparedStatement.setString(2, email);
            preparedStatement.setString(3, password);
            preparedStatement.setString(4, role);

            // Execute the SQL statement
            int rowsAffected = preparedStatement.executeUpdate();
            adduserSuccess = rowsAffected > 0;

            // Redirect to the page after successful user addition
            response.sendRedirect("Admin/AddManageUsers.jsp");
            if (adduserSuccess) {
            // If feedback was successfully stored, set an attribute to indicate success
            session.setAttribute("adduserSuccess", true);
        } else {
            // If feedback failed to store, set an attribute to indicate failure
            session.setAttribute("adduserSuccess", false);
        }
            
        } catch (Exception e) {
            e.printStackTrace(); // Handle exceptions properly in a real application
        } finally {
            // Close resources
            try {
                if (preparedStatement != null) {
                    preparedStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
