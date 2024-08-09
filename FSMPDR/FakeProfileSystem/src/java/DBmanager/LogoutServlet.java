package DBmanager;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            // Get the user ID from the session
            HttpSession session = request.getSession();
            String userId = (String) session.getAttribute("u_id");

            Class.forName("com.mysql.cj.jdbc.Driver");

            String url = "jdbc:mysql://localhost:3306/fakeprofilesystem";
            String username = "root";
            String password = "";

            try (Connection con = DriverManager.getConnection(url, username, password)) {
                // Update last_logout column in the database
                updateLastLogout(con, userId);

                // Invalidate the session and redirect to the login page
                session.invalidate();
                response.sendRedirect("Login.jsp");
            }
        } catch (ClassNotFoundException | SQLException e) {
            out.println(e);
        }
    }

    // Function to update last_logout column in the database
    private void updateLastLogout(Connection con, String userId) throws SQLException {
    // Get the current timestamp for logout
    Timestamp logoutTime = new Timestamp(new Date().getTime());

    // Retrieve the login timestamp from the database
    Timestamp loginTime;
    String selectLoginTimeQuery = "SELECT last_login FROM user WHERE id = ?";
    try (PreparedStatement selectLoginTimeStatement = con.prepareStatement(selectLoginTimeQuery)) {
        selectLoginTimeStatement.setString(1, userId);
        try (ResultSet loginTimeResult = selectLoginTimeStatement.executeQuery()) {
            if (loginTimeResult.next()) {
                loginTime = loginTimeResult.getTimestamp("last_login");

                // Calculate the time spent in seconds
                long timeSpentInSeconds = (logoutTime.getTime() - loginTime.getTime()) / 1000;

                // Update the time_spent column in the database
                String updateQuery = "UPDATE user SET last_logout = ?, time_spent = ? WHERE id = ?";
                try (PreparedStatement updateStatement = con.prepareStatement(updateQuery)) {
                    updateStatement.setTimestamp(1, logoutTime);
                    updateStatement.setLong(2, timeSpentInSeconds);
                    updateStatement.setString(3, userId);
                    // Execute the update query
                    updateStatement.executeUpdate();
                }
            }
        }
    }
}

}
