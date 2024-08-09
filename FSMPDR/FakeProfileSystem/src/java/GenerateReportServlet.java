package DBmanager;

import org.apache.commons.codec.binary.Base64;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.graphics.image.PDImageXObject;
import org.apache.pdfbox.pdmodel.font.PDType1Font;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/GenerateReportServlet")
public class GenerateReportServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Retrieve session attributes
        String meanScore = (String) request.getSession().getAttribute("meanScore");
        String fakeProbability = (String) request.getSession().getAttribute("fakeProbability");
        String realProbability = (String) request.getSession().getAttribute("realProbability");
        String userProfilePic = (String) request.getSession().getAttribute("userProfilePic");
        String userPrivate = (String) request.getSession().getAttribute("userPrivate");
        String pieChartImage = (String) request.getSession().getAttribute("pieChartImage");
        String barChartImage = (String) request.getSession().getAttribute("barChartImage");
        String profilename = (String) request.getSession().getAttribute("profilename");
        String nameEqualusername = (String) request.getSession().getAttribute("nameEqualusername");
        String externalURL = (String) request.getSession().getAttribute("externalURL");
        String descriptionLength = (String) request.getSession().getAttribute("Descriptionlength");
        String numOfPost = (String) request.getSession().getAttribute("numofpost");
        String numOfFollowers = (String) request.getSession().getAttribute("numoffollowers");
        String numOfFollows = (String) request.getSession().getAttribute("numoffollows");
        String numOfWordsInFullName = (String) request.getSession().getAttribute("numofwordsinfullname");
        String ratioOfNumLengthUsername = (String) request.getSession().getAttribute("Ratioofnumlengthusername");
        String ratioOfNumLengthFullName = (String) request.getSession().getAttribute("Ratioofnumlengthfullname");

        // Set response headers
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + profilename + ".pdf\"");

        try (PDDocument document = new PDDocument()) {
            PDPage page = new PDPage();
            document.addPage(page);

            try (PDPageContentStream contentStream = new PDPageContentStream(document, page)) {

                // Set font color to red only for the header
                contentStream.setNonStrokingColor(0, 0, 225);

                // Center the header text
                float headerWidth = PDType1Font.HELVETICA_BOLD.getStringWidth("Profile Detection Report") / 1000f * 12;
                float headerHeight = PDType1Font.HELVETICA_BOLD.getFontDescriptor().getFontBoundingBox().getHeight() / 1000f * 12;
                float headerX = (page.getMediaBox().getWidth() - headerWidth) / 2;
                float headerY = page.getMediaBox().getHeight() - 20;

                // Draw the header text
                contentStream.beginText();
                contentStream.setFont(PDType1Font.HELVETICA_BOLD, 12);
                contentStream.newLineAtOffset(headerX, headerY);
                contentStream.showText("Profile Detection Report");
                contentStream.endText();

                // Reset font color to default
                contentStream.setNonStrokingColor(0, 0, 0);
                
                // Show other attributes
                contentStream.beginText();
                contentStream.setFont(PDType1Font.HELVETICA_BOLD, 12);
                contentStream.newLineAtOffset(100, headerY - 20);
                contentStream.newLineAtOffset(0, -20);
                contentStream.showText("Profile Name: " + profilename);
                contentStream.newLineAtOffset(0, -20);
                contentStream.showText("Mean Cross-Validation Score: " + meanScore);
                contentStream.newLineAtOffset(0, -20);
                contentStream.showText("User Profile Pic: " + userProfilePic);
                contentStream.newLineAtOffset(0, -20);
                contentStream.showText("User Profile Private: " + userPrivate);
                contentStream.newLineAtOffset(0, -20);
                contentStream.showText("Name Equal Username: " + nameEqualusername);
                contentStream.newLineAtOffset(0, -20);
                contentStream.showText("External URL: " + externalURL);
                contentStream.newLineAtOffset(0, -20);
                contentStream.showText("Description Length: " + descriptionLength);
                contentStream.newLineAtOffset(0, -20);
                contentStream.showText("Number of Posts: " + numOfPost);
                contentStream.newLineAtOffset(0, -20);
                contentStream.showText("Number of Followers: " + numOfFollowers);
                contentStream.newLineAtOffset(0, -20);
                contentStream.showText("Number of Follows: " + numOfFollows);
                contentStream.newLineAtOffset(0, -20);
                contentStream.showText("Number of Words in Full Name: " + numOfWordsInFullName);
                contentStream.newLineAtOffset(0, -20);
                contentStream.showText("Ratio of Number Length in Username: " + ratioOfNumLengthUsername);
                contentStream.newLineAtOffset(0, -20);
                contentStream.showText("Ratio of Number Length in Full Name: " + ratioOfNumLengthFullName);
                contentStream.newLineAtOffset(0, -20);
                // Set font color to red for "Fake Probability"
                contentStream.setNonStrokingColor(255, 0, 0);
                contentStream.showText("Fake Probability: ");
                contentStream.setNonStrokingColor(255, 0, 0); // Reset font color
                contentStream.showText(fakeProbability);
                contentStream.newLineAtOffset(0, -20);
                
                // Set font color to green for "Real Probability"
                contentStream.setNonStrokingColor(0, 255, 0);
                contentStream.showText("Real Probability: ");
                contentStream.setNonStrokingColor(0, 255, 0); // Reset font color
                contentStream.showText(realProbability);
                contentStream.newLineAtOffset(0, -20);
                

                // Decode and embed the pie chart image
                try {
                    String[] pieChartParts = pieChartImage.split(",");
                    if (pieChartParts.length == 2) {
                        byte[] decodedPieChart = Base64.decodeBase64(pieChartParts[1]);
                        PDImageXObject pieChartXObject = PDImageXObject.createFromByteArray(document, decodedPieChart, "Pie Chart");
                        contentStream.drawImage(pieChartXObject, 100, headerY - 20 - 20 - 50); // Adjust position as needed
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }

                // Decode and embed the bar chart image
                try {
                    String[] barChartParts = barChartImage.split(",");
                    if (barChartParts.length == 2) {
                        byte[] decodedBarChart = Base64.decodeBase64(barChartParts[1]);
                        PDImageXObject barChartXObject = PDImageXObject.createFromByteArray(document, decodedBarChart, "Bar Chart");
                        contentStream.drawImage(barChartXObject, 100, headerY - 20 - 20 - 50 - 200); // Adjust position as needed
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }

                contentStream.endText();
            }

            // Save the document
            document.save(response.getOutputStream());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
