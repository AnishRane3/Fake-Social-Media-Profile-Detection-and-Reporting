package DBmanager;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp; // Import Timestamp class
import java.util.Date; // Import Date class

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");

            String url = "jdbc:mysql://localhost:3306/fakeprofilesystem";
            String username = "root";
            String password = "";
            HttpSession session = request.getSession();
            try (Connection con = DriverManager.getConnection(url, username, password)) {

                String UserInputEmail = request.getParameter("email");
                String UserInputPassword = request.getParameter("password");
                String UserInputRole = request.getParameter("role");

                String query = "SELECT * FROM user WHERE email=? AND password=? AND role=?";
                try (PreparedStatement pst = con.prepareStatement(query)) {
                    pst.setString(1, UserInputEmail);
                    pst.setString(2, UserInputPassword);
                    pst.setString(3, UserInputRole);

                    try (ResultSet rs = pst.executeQuery()) {
                        if (rs.next()) {
                            String u_id = rs.getString("id");
                            String u_name = rs.getString("name");
                            String u_email = rs.getString("email");

                            // Update last_login column in the database
                            updateLastLogin(con, u_id);

                            // Create a session named "session" to store user information
                            
                            session.setAttribute("u_id", u_id);
                            session.setAttribute("u_name", u_name);
                            session.setAttribute("u_email", u_email);

                            

                            // Redirect based on the role
                            if ("admin".equals(UserInputRole)) {
                                response.sendRedirect("Admin/Dashboard.jsp");
                            } else if ("user".equals(UserInputRole)) {
                                response.sendRedirect("User/Dashboard.jsp");
                            } else {
                                out.println("Invalid role");
                            }
                            
                        } else {
                                String errorMessage = "Login Failed. Please check your credentials.";
                                request.setAttribute("error", true);
                                request.setAttribute("errorMessage", errorMessage);
                                response.setContentType("text/html");
                                response.getWriter().println("<script>");
                                response.getWriter().println("alert('" + errorMessage + "');");
                                response.getWriter().println("window.location.href='Login.jsp';");
                                response.getWriter().println("</script>");
                                
                        }

                    }
                }
            }

        } catch (ClassNotFoundException | SQLException e) {
            out.println(e);
        }
    }

    private void updateLastLogin(Connection con, String userId) throws SQLException {
    String updateQuery = "UPDATE user SET last_login = ?, login_logout_count = login_logout_count + 1 WHERE id = ?";
    try (PreparedStatement updateStatement = con.prepareStatement(updateQuery)) {
        // Set the current timestamp as the last login time
        updateStatement.setTimestamp(1, new Timestamp(new Date().getTime()));
        updateStatement.setString(2, userId);
        // Execute the update query
        updateStatement.executeUpdate();
    }
}

}
