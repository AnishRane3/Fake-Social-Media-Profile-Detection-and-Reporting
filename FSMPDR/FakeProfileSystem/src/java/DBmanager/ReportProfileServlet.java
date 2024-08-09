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

@WebServlet("/ReportProfileServlet")
public class ReportProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            // Get data from the form
            String description = request.getParameter("desc");
            String fakeProb = request.getParameter("fake_prob");

            // Get profile data from the session
            HttpSession session = request.getSession();
            String reportedBy = (String) session.getAttribute("u_id"); // Assuming you have userId in the session
            String profileName = (String) session.getAttribute("profilename");
            String mcvs = (String) session.getAttribute("meanScore");
            String fakeProbability = (String) session.getAttribute("fakeProbability");
            String realProbability = (String) session.getAttribute("realProbability");
            String userProfilePic = (String) session.getAttribute("userProfilePic");
            String userPrivate = (String) session.getAttribute("userPrivate");

            // Store the reported profile information in the database
            try (Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/fakeprofilesystem", "root", "")) {
                String query = "INSERT INTO reported_profile_tbl (reported_by, description, priority_check, profile_username, mcvs, fake_prob, real_prob, has_profilepic, is_private, reported_date) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, current_timestamp())";
                try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {
                    preparedStatement.setString(1, reportedBy);
                    preparedStatement.setString(2, description);
                    preparedStatement.setString(3, fakeProb);
                    preparedStatement.setString(4, profileName);
                    preparedStatement.setString(5, mcvs);
                    preparedStatement.setString(6, fakeProbability);
                    preparedStatement.setString(7, realProbability);
                    preparedStatement.setInt(8, "yes".equalsIgnoreCase(userProfilePic) ? 1 : 0);
                    preparedStatement.setInt(9, "yes".equalsIgnoreCase(userPrivate) ? 1 : 0);

                    int rowsAffected = preparedStatement.executeUpdate();
                    if (rowsAffected > 0) {
                        // Clear session attributes
//                        session.removeAttribute("meanScore");
//                        session.removeAttribute("features");
//                        session.removeAttribute("fakeProbability");
//                        session.removeAttribute("realProbability");
//                        session.removeAttribute("pieChartImage");
//                        session.removeAttribute("barChartImage");
//                        session.removeAttribute("userProfilePic");
//                        session.removeAttribute("userPrivate");
//                        session.removeAttribute("profilename");

                        response.sendRedirect(request.getContextPath() + "/User/DetectProfile.jsp");
                    } else {
                        response.getWriter().println("Error saving data to the database.");
                    }
                }
            }
        } catch (Exception e) {
            response.getWriter().println("An error occurred while processing the report." + e);
        }
    }
}
