package DBmanager;

import java.sql.*;
import java.sql.Connection;
/**
 *
 * @author Acer
 */
public class DBConnector {

    public ResultSet getResult(String query) throws SQLException {
        Connection con = null;

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/fakeprofilesystem", "root", "");
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(query);

            if (rs != null) {
                return rs;
            }
            con.close();
        } catch (Exception e) {
        }
        return null;
    }

    public String login(String email, String pass, String role) {
        Connection con;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/fakeprofilesystem", "root", "");
            Statement stmt = con.createStatement();
            String sql = "SELECT * FROM user WHERE email='" + email + "' AND password='" + pass + "' AND role='" + role + "';";
            System.out.print(sql);
            ResultSet result = stmt.executeQuery(sql);
            String id = "";
            boolean f = false;
            while (result.next()) {
                if (email.equals(result.getString("email")) && pass.equals(result.getString("password"))) {
                    id = result.getString("id");
                    f = true;
                }
            }
            if (f == true) {
                return id;
            } else {
                return "";
            }
        } catch (Exception e) {
            return "";
        }
    }
    
    public int register(String name, String email, String pass, String role) {
        Connection con = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/fakeprofilesystem", "root", "");
            Statement stmt = con.createStatement();
            int result;
            result = stmt.executeUpdate("INSERT INTO user(name,email,password,role) VALUES('" + name + "','" + email + "','" + pass + "','" + role + "');");

            if (result > 0) {
                con.close();
                return 1;
            } else {
                con.close();
                return 0;
            }

        } catch (Exception e) {
            return 0;
        }
    }

}
