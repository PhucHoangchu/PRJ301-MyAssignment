<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Leave Management System</title>
    
    <!-- CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css">
    
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        /* Login Layout */
        .login-layout {
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            position: relative;
            overflow: hidden;
        }
        
        .login-layout::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="1" fill="rgba(255,255,255,0.1)"/><circle cx="75" cy="75" r="1" fill="rgba(255,255,255,0.1)"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
            opacity: 0.3;
        }
        
        .login-container {
            max-width: 450px;
            width: 100%;
            background: white;
            padding: 50px 40px;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            position: relative;
            z-index: 1;
            animation: fadeInUp 0.6s ease-out;
        }
        
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .login-title {
            text-align: center;
            margin-bottom: 40px;
            color: #2d3748;
            font-size: 2rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
        }
        
        .login-title i {
            font-size: 2.5rem;
            color: #667eea;
        }
        
        .alert {
            padding: 16px 20px;
            border-radius: 10px;
            margin-bottom: 25px;
            border-left: 4px solid;
            display: flex;
            align-items: center;
            gap: 12px;
            animation: shake 0.5s ease-in-out;
        }
        
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-10px); }
            75% { transform: translateX(10px); }
        }
        
        .alert-danger {
            background: #fed7d7;
            border-color: #e53e3e;
            color: #742a2a;
        }
        
        .alert-danger i {
            font-size: 1.2rem;
        }
        
        .login-form .form-group {
            margin-bottom: 24px;
        }
        
        .login-form label {
            display: block;
            font-size: 0.95rem;
            color: #4a5568;
            margin-bottom: 10px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .login-form label i {
            color: #667eea;
            font-size: 1rem;
        }
        
        .login-form .form-control {
            width: 100%;
            padding: 16px 20px;
            font-size: 1rem;
            font-family: 'Inter', sans-serif;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            transition: all 0.3s ease;
            background: #ffffff;
            color: #2d3748;
        }
        
        .login-form .form-control:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
        }
        
        .login-form .form-control::placeholder {
            color: #cbd5e0;
        }
        
        .login-btn {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            font-family: 'Inter', sans-serif;
            margin-top: 10px;
        }
        
        .login-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
        }
        
        .login-btn:active {
            transform: translateY(0);
        }
        
        .login-btn i {
            font-size: 1.1rem;
        }
    </style>
</head>
<body>
    <div class="login-layout">
        <div class="login-container fade-in-up">
            <h2 class="login-title">
                <i class="fas fa-calendar-alt"></i>
                Leave Management
            </h2>
            
            <% if (request.getAttribute("message") != null) { %>
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i>
                    <%= request.getAttribute("message") %>
                </div>
            <% } %>
            
            <form class="login-form" action="${pageContext.request.contextPath}/login" method="post" data-validate>
                <div class="form-group">
                    <label for="username">
                        <i class="fas fa-user"></i>
                        Username
                    </label>
                    <input type="text" id="username" name="username" class="form-control" 
                           placeholder="Enter your username" required autofocus>
                </div>
                
                <div class="form-group">
                    <label for="password">
                        <i class="fas fa-lock"></i>
                        Password
                    </label>
                    <input type="password" id="password" name="password" class="form-control" 
                           placeholder="Enter your password" required>
                </div>
                
                <button type="submit" class="login-btn">
                    <i class="fas fa-sign-in-alt"></i>
                    Sign In
                </button>
            </form>
        </div>
    </div>
    
    <!-- JavaScript -->
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    <script src="${pageContext.request.contextPath}/js/form-validation.js"></script>
</body>
</html>
