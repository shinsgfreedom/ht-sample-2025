<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>

<head>
    <title>Error</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css" />
    <style>
        .error-page {
          background:#fff;
            text-align: center;
        }
        .error-codetext {
             font-family: san-serif;
            font-size: 60px;
        }
        .error-code {
             font-family: san-serif;
            font-size: 120px;
        }
        .error-title {
            font-size: 35px;
            font-weight: bold;
        }
        .error-message {
            font-size: 20px;
            color: #999;
        }
        .error-btn {
            border: 1px solid #ddd;
            padding: 1em 2em;
            margin-top: 30px;
            color: #333;
        }
    </style>
</head>
<body>
    <div class="error-page">
        <h1 class="error-codetext">
            <div> Authorization </div>
        </h1>
        <h1 class="error-code">
            <i class="far fa-sad-tear" style="color:#666"> </i>
        </h1>
        <p class="error-title">${error}</p>
        <div class="error-message"> ${requestScope['javax.servlet.error.message']} </div>
    
        <div>
            <button type="button" class="error-btn" onclick="location.href='/login.html'">Go Login Page</button>
            &nbsp;
            <button type="button" class="error-btn" onclick="location.href='/MAIN/main.html'">Go Main Page</button>   
        </div>
    </div>
    
</body>

</html>