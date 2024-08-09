package DBmanager;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/ManageUserServlet")
public class ManageUserServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        // Retrieve form parameters
        String userId = request.getParameter("M_id");
        String newName = request.getParameter("M_name");
        String newEmail = request.getParameter("M_email");
        String newPassword = request.getParameter("M_password");

        // Validate if ID is provided
        if (userId == null || userId.trim().isEmpty()) {
            // Handle the case where no ID is provided
            response.sendRedirect("Admin/aaa.jsp"); // Redirect back to the user management page
            return;
        }

        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        boolean ManageUserSuccess = false;

        try {
            // Establish a database connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/fakeprofilesystem", "root", "");

            // Check if the user with the provided ID exists
            String checkUserQuery = "SELECT * FROM user WHERE id = ?";
            preparedStatement = connection.prepareStatement(checkUserQuery);
            preparedStatement.setString(1, userId);
            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                // User with the specified ID exists, proceed with the update
                // Construct the dynamic update query based on provided values
                StringBuilder updateQuery = new StringBuilder("UPDATE user SET");
                int setValuesCount = 0;

                if (newName != null && !newName.trim().isEmpty()) {
                    updateQuery.append(" name = ?");
                    setValuesCount++;
                }
                if (newEmail != null && !newEmail.trim().isEmpty()) {
                    if (setValuesCount > 0) {
                        updateQuery.append(",");
                    }
                    updateQuery.append(" email = ?");
                    setValuesCount++;
                }
                if (newPassword != null && !newPassword.trim().isEmpty()) {
                    if (setValuesCount > 0) {
                        updateQuery.append(",");
                    }
                    updateQuery.append(" password = ?");
                }

                updateQuery.append(" WHERE id = ?");

                // Prepare the dynamic update query
                preparedStatement = connection.prepareStatement(updateQuery.toString());

                // Set parameter values based on provided fields
                int parameterIndex = 1;
                if (newName != null && !newName.trim().isEmpty()) {
                    preparedStatement.setString(parameterIndex++, newName);
                }
                if (newEmail != null && !newEmail.trim().isEmpty()) {
                    preparedStatement.setString(parameterIndex++, newEmail);
                }
                if (newPassword != null && !newPassword.trim().isEmpty()) {
                    preparedStatement.setString(parameterIndex++, newPassword);
                }

                // Set the last parameter to userId
                preparedStatement.setString(parameterIndex, userId);

                // Execute the update query
                int rowsAffected = preparedStatement.executeUpdate();
                ManageUserSuccess = rowsAffected > 0;

            } else {
                // User with the specified ID does not exist, set a session attribute to indicate failure
            }

            // Redirect back to the user management page
            response.sendRedirect("Admin/AddManageUsers.jsp");

            if (ManageUserSuccess) {
                // If feedback was successfully stored, set an attribute to indicate success
                session.setAttribute("ManageUserSuccess", true);
            } else {
                // If feedback failed to store, set an attribute to indicate failure
                session.setAttribute("ManageUserSuccess", false);
            }
        } catch (Exception e) {
            e.printStackTrace(); // Handle exceptions properly in a real application
        } finally {
            // Close resources
            try {
                if (resultSet != null) {
                    resultSet.close();
                }
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
