<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <script
      src="https://kit.fontawesome.com/64d58efce2.js"
      crossorigin="anonymous"
    ></script>
    <link rel="stylesheet" href="css/LoginStyle.css" />

    <title>Fake Profile Detection And Reporting</title>
  </head>
  <body>
      
    <div class="container">
      <div class="forms-container">
        <div class="signin-signup">
        <form action="LoginServlet" method="post" class="sign-in-form">
            <h2 class="title">Sign in</h2>
            <div class="input-field">
                <i class="fas fa-envelope"></i>
                <input type="email" id="email" name="email" placeholder="Email" required>
            </div>
            <div class="input-field" style="margin-bottom: 15px">
                <i class="fas fa-lock"></i>
                <input type="password" id="password" name="password" placeholder="Password" required>
            </div>
            <label style="margin-right: 270px;font-weight: 500">Select Role</label>
            <select id="role" name="role" class="input-field" style="border: none">
                <option value="admin">Administrator</option>
                <option value="user">User</option>
            </select>
            
            <input type="submit" value="Login" class="btn solid" />
        </form>
          
        </div>
      </div>

      <div class="panels-container">
        <div class="panel left-panel">
          <div class="content">
            <h3 style="color: black;text-transform: uppercase">Fake Profile Detection And Reporting</h3>
            <p style="color: black">
              "Unmasking Deception, Securing Connections in the Digital Landscape: Your Trusted Platform for Identifying and Reporting Fake Profiles."
            </p>
          </div>
            
             <img src="img/loginpageimg.png" class="image" alt="" />
        </div>
        
      </div>
    </div>
    <script src="app.js"></script>
  </body>
</html>


