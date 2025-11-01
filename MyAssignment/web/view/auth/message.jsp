<%-- 
    Document   : message
    Created on : Oct 22, 2025, 4:54:18 PM
    Author     : MWG
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <span id="message">${requestScope.message}</span>
    </body>
</html>

<!-- CSS -->
<link rel="stylesheet" href="../css/main.css">
<link rel="stylesheet" href="../css/components.css">
<link rel="stylesheet" href="../css/responsive.css">

<!-- JavaScript -->
<script src="../js/main.js"></script>
<script src="../js/form-validation.js"></script>
<script src="../js/dashboard.js"></script>