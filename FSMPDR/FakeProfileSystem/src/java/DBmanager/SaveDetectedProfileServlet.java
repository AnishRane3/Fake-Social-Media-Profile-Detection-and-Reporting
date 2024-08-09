package DBmanager;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/SaveDetectedProfileServlet")
public class SaveDetectedProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            response.setContentType("text/html;charset=UTF-8");

            // Retrieve the session attributes
            HttpSession session = request.getSession();
            String detectedBy = (String) session.getAttribute("u_id"); // Set the detected_by value based on your application's logic
            String profileName = (String) session.getAttribute("profilename");
            String meanScore = (String) session.getAttribute("meanScore");
            String fakeProbability = (String) session.getAttribute("fakeProbability");
            String realProbability = (String) session.getAttribute("realProbability");
            String userProfilePic = (String) session.getAttribute("userProfilePic");
            String userPrivate = (String) session.getAttribute("userPrivate");

            Class.forName("com.mysql.cj.jdbc.Driver");
            // Database connection parameters
            String jdbcUrl = "jdbc:mysql://localhost:3306/fakeprofilesystem";
            String dbUser = "root";
            String dbPassword = "";

            // Create a database connection
            try (Connection connection = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword)) {
                // Prepare the SQL statement
                String sql = "INSERT INTO detected_tbl (detected_by, profile_username, mcvs, fake_prob, real_prob, has_profilepic, is_private, detection_date) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                try (PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
                    preparedStatement.setString(1, detectedBy);
                    preparedStatement.setString(2, profileName);
                    preparedStatement.setString(3, meanScore);
                    preparedStatement.setString(4, fakeProbability);
                    preparedStatement.setString(5, realProbability);
                    preparedStatement.setInt(6, "yes".equalsIgnoreCase(userProfilePic) ? 1 : 0);
                    preparedStatement.setInt(7, "yes".equalsIgnoreCase(userPrivate) ? 1 : 0);
                    preparedStatement.setTimestamp(8, new java.sql.Timestamp(new Date().getTime()));

                    // Execute the SQL statement
                    int rowsAffected = preparedStatement.executeUpdate();
                    if (rowsAffected > 0) {
                        // Clear session attributes
                        session.removeAttribute("meanScore");
                        session.removeAttribute("features");
                        session.removeAttribute("fakeProbability");
                        session.removeAttribute("realProbability");
                        session.removeAttribute("pieChartImage");
                        session.removeAttribute("barChartImage");
                        session.removeAttribute("userProfilePic");
                        session.removeAttribute("userPrivate");
                        session.removeAttribute("profilename");

                        
                        response.sendRedirect(request.getContextPath() + "/User/DetectProfile.jsp");
                    } else {
                        response.getWriter().println("Error saving data to the database.");
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
                response.getWriter().println("Database connection error: " + e.getMessage());
            }
        } catch (Exception e) {
            response.getWriter().println("An error occurred while processing the request.");
        }
    }
}
