<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.iam.User" %>
<%@page import="model.leave.RequestForLeave" %>
<%@page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= request.getParameter("pageTitle") != null ? request.getParameter("pageTitle") : "Leave Management System" %></title>
    
    <!-- CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css">
    
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- JavaScript -->
    <script>
        // Get current page path to highlight active menu item
        const currentPath = window.location.pathname;
    </script>
</head>
<body>
    <% User user = (User) session.getAttribute("auth"); %>
    <% if (user != null) { %>
    <!-- Navigation Bar -->
    <nav class="navbar">
        <div class="nav-container">
            <div class="nav-brand">
                <a href="${pageContext.request.contextPath}/home">
                    <i class="fas fa-calendar-alt"></i>
                    <span>Leave Management</span>
                </a>
            </div>
            
            <div class="nav-menu" id="navMenu">
                <a href="${pageContext.request.contextPath}/home" class="nav-link ${pageContext.request.servletPath == '/view/home/index.jsp' ? 'active' : ''}">
                    <i class="fas fa-home"></i>
                    <span>Home</span>
                </a>
                <a href="${pageContext.request.contextPath}/request/create" class="nav-link ${pageContext.request.servletPath == '/view/request/create.jsp' ? 'active' : ''}">
                    <i class="fas fa-plus-circle"></i>
                    <span>Create Request</span>
                </a>
                <a href="${pageContext.request.contextPath}/request/list" class="nav-link ${pageContext.request.servletPath == '/view/request/list.jsp' ? 'active' : ''}">
                    <i class="fas fa-list"></i>
                    <span>My Requests</span>
                </a>
                <%
                    boolean canReview = false;
                    boolean canViewAgenda = false;
                    if (user != null && user.getRoles() != null) {
                        for (model.iam.Role r : user.getRoles()) {
                            for (model.iam.Feature f : r.getFeatures()) {
                                if ("/request/review".equals(f.getUrl())) canReview = true;
                                if ("/division/agenda".equals(f.getUrl())) canViewAgenda = true;
                            }
                        }
                    }
                    ArrayList<RequestForLeave> pendingRequests = (ArrayList<RequestForLeave>) request.getAttribute("pendingRequests");
                    if (canReview) {
                %>
                <a href="${pageContext.request.contextPath}/request/review" class="nav-link ${pageContext.request.servletPath == '/view/request/review.jsp' ? 'active' : ''}">
                    <i class="fas fa-check-circle"></i>
                    <span>Review Requests</span>
                    <% if (pendingRequests != null && !pendingRequests.isEmpty()) { %>
                    <span class="badge"><%= pendingRequests.size() %></span>
                    <% } %>
                </a>
                <% } if (canViewAgenda) { %>
                <a href="${pageContext.request.contextPath}/division/agenda" class="nav-link ${pageContext.request.servletPath == '/view/division/agenda.jsp' ? 'active' : ''}">
                    <i class="fas fa-users"></i>
                    <span>Division Agenda</span>
                </a>
                <% } %>
            </div>
            
            <div class="nav-user">
                <div class="user-dropdown">
                    <button class="user-btn">
                        <i class="fas fa-user-circle"></i>
                        <span><%= user.getDisplayname() != null && !user.getDisplayname().isEmpty() ? user.getDisplayname() : user.getUsername() %></span>
                        <i class="fas fa-chevron-down"></i>
                    </button>
                    <div class="dropdown-menu">
                        <a href="${pageContext.request.contextPath}/logout" class="dropdown-item">
                            <i class="fas fa-sign-out-alt"></i>
                            <span>Logout</span>
                        </a>
                    </div>
                </div>
                
                <button class="mobile-menu-toggle" id="mobileMenuToggle">
                    <i class="fas fa-bars"></i>
                </button>
            </div>
        </div>
    </nav>
    
    <!-- Main Content -->
    <main class="main-content">
        <div class="container">
    <% } else { %>
    <!-- Login Layout -->
    <div class="login-layout">
    <% } %>