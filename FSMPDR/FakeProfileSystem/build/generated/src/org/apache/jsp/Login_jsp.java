package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import DBmanager.DBConnector.*;

public final class Login_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final JspFactory _jspxFactory = JspFactory.getDefaultFactory();

  private static java.util.List<String> _jspx_dependants;

  private org.glassfish.jsp.api.ResourceInjector _jspx_resourceInjector;

  public java.util.List<String> getDependants() {
    return _jspx_dependants;
  }

  public void _jspService(HttpServletRequest request, HttpServletResponse response)
        throws java.io.IOException, ServletException {

    PageContext pageContext = null;
    HttpSession session = null;
    ServletContext application = null;
    ServletConfig config = null;
    JspWriter out = null;
    Object page = this;
    JspWriter _jspx_out = null;
    PageContext _jspx_page_context = null;

    try {
      response.setContentType("text/html;charset=UTF-8");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;
      _jspx_resourceInjector = (org.glassfish.jsp.api.ResourceInjector) application.getAttribute("com.sun.appserv.jsp.resource.injector");

      out.write("\n");
      out.write("\n");
      out.write("<!DOCTYPE html>\n");
      out.write("<html>\n");
      out.write("<head>\n");
      out.write("    <title>Login</title>\n");
      out.write("</head>\n");
      out.write("<body>\n");
      out.write("    ");
  
        session.setAttribute("email", "");
            DBmanager.DBConnector d = new DBmanager.DBConnector();
            if (request.getParameter("email")==null) {
                
            }
            else{
                String email = request.getParameter("email");
                String pass = request.getParameter("password");
                String role = request.getParameter("role");
                String id=d.login(email, pass, role);
                if (id!="") {
                    session.setAttribute("id", id);
                    session.setAttribute("email", email);
                    if(role.equals("admin")){
                        response.sendRedirect("Admin/Register.jsp");
                    }
                    else if(role.equals("user")){
                        response.sendRedirect("User/Dashboard.jsp");            
                    }
                } else {
                        out.print("Login Fail");
                }
            }
    
      out.write("\n");
      out.write("    <h2>Login</h2>\n");
      out.write("    <form name=\"login\" id=\"login\" method=\"post\">\n");
      out.write("        <label for=\"email\">Email:</label>\n");
      out.write("        <input type=\"email\" id=\"email\" name=\"email\" required><br><br>\n");
      out.write("\n");
      out.write("        <label for=\"password\">Password:</label>\n");
      out.write("        <input type=\"password\" id=\"password\" name=\"password\" required><br><br>\n");
      out.write("        \n");
      out.write("        <select id=\"role\" name=\"role\">\n");
      out.write("            <option value=\"\" disabled selected>Choose your option</option>\n");
      out.write("            <option value=\"admin\">Admin</option>\n");
      out.write("            <option value=\"user\">User</option>\n");
      out.write("        </select>\n");
      out.write("        <label>Role</label><br><br>\n");
      out.write("\n");
      out.write("        <input type=\"submit\" value=\"Login\">\n");
      out.write("    </form>\n");
      out.write("</body>\n");
      out.write("</html>\n");
    } catch (Throwable t) {
      if (!(t instanceof SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          out.clearBuffer();
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else throw new ServletException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
