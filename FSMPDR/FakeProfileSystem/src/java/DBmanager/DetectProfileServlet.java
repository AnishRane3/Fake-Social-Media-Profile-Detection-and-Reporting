package DBmanager;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.StringWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/DetectProfileServlet")
public class DetectProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            response.setContentType("text/html;charset=UTF-8");

            // Retrieve the profile username from the form
            String profileName = request.getParameter("profilename");

            // Call the Python script with the provided input
            String pythonScriptPath = "C:\\Hackathon\\FSMPDR_ML\\FPDML.py";
            String[] cmd = new String[]{"python", pythonScriptPath, profileName};

            // Execute the Python script
            Process process = Runtime.getRuntime().exec(cmd);
            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            BufferedReader errorReader = new BufferedReader(new InputStreamReader(process.getErrorStream()));
            String line;

            // Read the standard output from the Python script
            StringBuilder pythonOutput = new StringBuilder();
            while ((line = reader.readLine()) != null) {
                pythonOutput.append(line).append("<br>");  // Add line breaks for better formatting in HTML
            }

            // Close the BufferedReaders
            reader.close();
            errorReader.close();

            boolean profileNotFound = pythonOutput.toString().contains("Profile not found.");
            
            if (profileNotFound) {
                HttpSession session = request.getSession();
                session.setAttribute("profileNotFound", true);
                response.sendRedirect(request.getContextPath() + "/User/DetectProfile.jsp");
            } else {
            // Extract additional details from Python output
            String[] outputLines = pythonOutput.toString().split("<br>");

            // Initialize variables
             String meanScore = "Value not available";
            String features = "Value not available";
            String fakeProbability = "Value not available";
            String realProbability = "Value not available";
            String pieChartImage = "Value not available";
            String barChartImage = "Value not available";
            String userProfilePic = "Value not available";
            String userPrivate = "Value not available";
            String nameEqualusername = "Value not available";
            String externalURL = "Value not available";
            String Descriptionlength = "Value not available";
            String numofpost = "Value not available";
            String numoffollowers = "Value not available";
            String numoffollows = "Value not available";
            String numofwordsinfullname = "Value not available";
            String Ratioofnumlengthusername = "Value not available";
            String Ratioofnumlengthfullname = "Value not available";

            // Iterate through output lines to find relevant information
            for (String outputLine : outputLines) {
                if (outputLine.startsWith("Mean Cross-Validation Score:")) {
                    meanScore = outputLine.replace("Mean Cross-Validation Score:", "").trim();
                } else if (outputLine.startsWith("Features for")) {
                    features = outputLine.replace("Features for", "").trim();
                } else if (outputLine.startsWith("Fake Probability for")) {
                    fakeProbability = outputLine.replace("Fake Probability for", "").trim();
                } else if (outputLine.startsWith("Real Probability for")) {
                    realProbability = outputLine.replace("Real Probability for", "").trim();
                } else if (outputLine.startsWith("Pie Chart Image:")) {
                    pieChartImage = outputLine.replace("Pie Chart Image:", "").trim();
                } else if (outputLine.startsWith("Bar Chart Image:")) {
                    barChartImage = outputLine.replace("Bar Chart Image:", "").trim();
                }else if (outputLine.startsWith("Profile pic:")) {
                    userProfilePic = outputLine.replace("Profile pic:", "").trim();
                }else if (outputLine.startsWith("private:")) {
                    userPrivate = outputLine.replace("private:", "").trim();
                }else if (outputLine.startsWith("name == username:")) {
                    nameEqualusername = outputLine.replace("name == username:", "").trim();
                }else if (outputLine.startsWith("external URL:")) {
                    externalURL = outputLine.replace("external URL:", "").trim();
                }else if (outputLine.startsWith("Description length:")) {
                    Descriptionlength = outputLine.replace("Description length:", "").trim();
                }else if (outputLine.startsWith("Number of posts:")) {
                    numofpost = outputLine.replace("Number of posts:", "").trim();
                }else if (outputLine.startsWith("Number of followers:")) {
                    numoffollowers = outputLine.replace("Number of followers:", "").trim();
                }else if (outputLine.startsWith("Number of follows:")) {
                    numoffollows = outputLine.replace("Number of follows:", "").trim();
                }else if (outputLine.startsWith("Number of words in the full name:")) {
                    numofwordsinfullname = outputLine.replace("Number of words in the full name:", "").trim();
                }else if (outputLine.startsWith("Ratio of numbers to the length of the username:")) {
                    Ratioofnumlengthusername = outputLine.replace("Ratio of numbers to the length of the username:", "").trim();
                }else if (outputLine.startsWith("Ratio of numbers to the length of the full name:")) {
                    Ratioofnumlengthfullname = outputLine.replace("Ratio of numbers to the length of the full name:", "").trim();
                }
            }

            // Save the extracted details in session attributes
            HttpSession session = request.getSession();
            session.setAttribute("meanScore", meanScore);
            session.setAttribute("features", features);
            session.setAttribute("fakeProbability", fakeProbability);
            session.setAttribute("realProbability", realProbability);
            session.setAttribute("pieChartImage", pieChartImage);
            session.setAttribute("barChartImage", barChartImage);
            session.setAttribute("userProfilePic", userProfilePic);
            session.setAttribute("userPrivate", userPrivate);
            session.setAttribute("profilename", profileName);
            session.setAttribute("nameEqualusername", nameEqualusername);
            session.setAttribute("externalURL", externalURL);
            session.setAttribute("Descriptionlength", Descriptionlength);
            session.setAttribute("numofpost", numofpost);
            session.setAttribute("numoffollowers", numoffollowers);
            session.setAttribute("numoffollows", numoffollows);
            session.setAttribute("numofwordsinfullname", numofwordsinfullname);
            session.setAttribute("Ratioofnumlengthusername", Ratioofnumlengthusername);
            session.setAttribute("Ratioofnumlengthfullname", Ratioofnumlengthfullname);
            
            response.sendRedirect(request.getContextPath() + "/User/DetectProfile.jsp");
        }
        } catch (Exception e) {
            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw);
            // Handle exceptions appropriately, log them, and provide feedback to the user if needed
            e.printStackTrace(pw); // Log the exception
            response.getWriter().println("An error occurred while processing the request. Stack trace:\n" + sw.toString());
        }
    }
}
