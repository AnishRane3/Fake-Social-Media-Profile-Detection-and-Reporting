
package DBmanager;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/SubmitFeedbackServlet")
public class SubmitFeedbackServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Get user information from the session
        String User_id = (String) session.getAttribute("u_id");
        String email = (String) session.getAttribute("u_email");

        // Get feedback form data
        String subject = request.getParameter("subject");
        String description = request.getParameter("description");

        // Get the current date and time
        String createdOn = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());

        // JDBC connection details
        String jdbcUrl = "jdbc:mysql://localhost:3306/fakeprofilesystem";
        String jdbcUsername = "root";
        String jdbcPassword = "";
        
        boolean feedbackSuccess = false;

        try {
            // Load the MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish the connection
            try (Connection connection = DriverManager.getConnection(jdbcUrl, jdbcUsername, jdbcPassword)) {
                String sql = "INSERT INTO feedback_tbl (feedback_by, email, subject, description, created_on) VALUES (?, ?, ?, ?, ?)";
                try (PreparedStatement statement = connection.prepareStatement(sql)) {
                    statement.setString(1, User_id);
                    statement.setString(2, email);
                    statement.setString(3, subject);
                    statement.setString(4, description);
                    statement.setString(5, createdOn);

                    int rowsAffected = statement.executeUpdate();
                    feedbackSuccess = rowsAffected > 0;
                }
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace(); // Handle exceptions appropriately
            
        }
        response.sendRedirect("User/Feedback.jsp");
        if (feedbackSuccess) {
            // If feedback was successfully stored, set an attribute to indicate success
            session.setAttribute("feedbackSuccess", true);
        } else {
            // If feedback failed to store, set an attribute to indicate failure
            session.setAttribute("feedbackSuccess", false);
        }
    }
}
