/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.iam;

import dal.UserDBContext;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.iam.User;

/**
 *
 * @author MWG
 */
public class LoginController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/view/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        UserDBContext db = new UserDBContext();
        User u = db.get(username, password);
        if (u != null) {
            HttpSession session = request.getSession();
            // Invalidate old session để đảm bảo không còn dữ liệu từ user cũ
            session.invalidate();
            session = request.getSession(true);
            session.setAttribute("auth", u);
            
            // Debug log
            System.out.println("Login successful - Username: " + username + ", Displayname: " + u.getDisplayname() + ", User ID: " + u.getId());

            // Redirect to home instead of message page
            response.sendRedirect(request.getContextPath() + "/home");
        } else {
            request.setAttribute("message", "Login Failed!");
            request.getRequestDispatcher("/view/auth/message.jsp").forward(request, response);
        }
    }
}
