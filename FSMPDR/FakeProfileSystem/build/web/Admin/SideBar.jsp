<%-- 
    Document   : SideBar
    Created on : 10 Dec, 2023, 12:02:03 PM
    Author     : ranea
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<!-- Website - www.codingnepalweb.com -->
<html lang="en" dir="ltr">
  <head>
    <meta charset="UTF-8" />
    <title>FPDR</title>
    <link rel="stylesheet" href="../css/SideBarStyle.css" />
    <!-- Boxicons CDN Link -->
    <link href="https://unpkg.com/boxicons@2.0.7/css/boxicons.min.css" rel="stylesheet" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  </head>
  <body>
    <div class="sidebar" style="box-shadow: 8px 0 10px -5px rgba(0, 0, 0, 0.05);">
      <div class="logo-details">
          <h1 class="logo_name" style="color:black">ADMIN PANEL</h1>
        <i class="bx bx-menu" id="btn" style="color:black"></i>
      </div>
      <ul class="nav-list">
        <li><a class="<% if(request.getRequestURI().endsWith("Dashboard.jsp")){ %> active<%}%>" href="Dashboard.jsp"><i class="bx bx-grid-alt"></i><span class="links_name">Dashboard</span></a><span class="tooltip">Dashboard</span></li>
        
        <li><a class="<% if(request.getRequestURI().endsWith("AddManageUsers.jsp")){ %> active<%}%>" href="AddManageUsers.jsp"><i class="bx bxs-user-detail"></i><span class="links_name">Add & Manage Users</span></a><span class="tooltip">Add & Manage Users</span></li>
        
<!--        <li><a class="<% if(request.getRequestURI().endsWith("Analytics.jsp")){ %> active<%}%>" href="Analytics.jsp"><i class="bx bx-pie-chart-alt-2"></i><span class="links_name">Analytics</span></a><span class="tooltip">Analytics</span></li>-->
        
         <li><a class="<% if(request.getRequestURI().endsWith("ViewDetectedandReported.jsp")){ %> active<%}%>" href="ViewDetectedandReported.jsp"><i class='bx bx-align-justify'></i><span class="links_name">View Profiles</span></a><span class="tooltip">View Detected & Reported Profiles</span></li>
        
        <li><a class="<% if(request.getRequestURI().endsWith("ViewFeedback.jsp")){ %> active<%}%>" href="ViewFeedback.jsp"><i class="bx bx-message-alt-detail"></i><span class="links_name">View Feedback</span></a><span class="tooltip">View Feedback</span></li>
        
        <li><a class="<% if(request.getRequestURI().endsWith("MyProfile.jsp")){ %> active<%}%>" href="MyProfile.jsp"><i class="bx bx-user"></i><span class="links_name">My Profile</span></a><span class="tooltip">My Profile</span></li>
        
        
        
        <li class="profile">
          <div class="profile-details">
            <img src="../img/person.png" alt="profileImg" />
            <div class="name_job">
                
              <div class="name">${u_name}</div>
              <div class="job">${u_email}</div>
            </div>
          </div>
            <form action="../LogoutServlet" method="post">
                <button type="submit"><i class="bx bx-log-out" id="log_out"></i></button>
            </form>
        </li>
        
        
      </ul>
    </div>
    
    <script src="script.js"></script>
<script>
let sidebar = document.querySelector(".sidebar");
let closeBtn = document.querySelector("#btn");
let searchBtn = document.querySelector(".bx-search");

closeBtn.addEventListener("click", ()=>{
  sidebar.classList.toggle("open");
  menuBtnChange();
});

searchBtn.addEventListener("click", ()=>{ 
  sidebar.classList.toggle("open");
  menuBtnChange(); 
});


function menuBtnChange() {
 if(sidebar.classList.contains("open")){
   closeBtn.classList.replace("bx-menu", "bx-menu-alt-right");
 }else {
   closeBtn.classList.replace("bx-menu-alt-right","bx-menu");
 }
}
</script>
 <section>
     
  </body>
</html>

