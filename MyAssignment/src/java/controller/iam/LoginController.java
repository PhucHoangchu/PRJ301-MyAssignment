/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.iam;

import dal.UserDBContext;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.iam.User;

/**
 *
 * @author MWG
 */
@WebServlet(name="LoginController", urlPatterns={"/login"})
public class LoginController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
      request.getRequestDispatcher("view/auth/login.jsp").forward(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
       String username = request.getParameter("username");
       String password = request.getParameter("password");
       
       //validation (santinization)
       
        UserDBContext db = new UserDBContext();
        User u = db.get(username, password);
        if (u != null) {
            HttpSession session = request.getSession();
            session.setAttribute("auth", u);
            
            //print login successful!
            request.setAttribute("message", "Login Successful!");
        }else{
            request.setAttribute("message", "Login Failed!");
        }
        request.getRequestDispatcher("view/auth/message.jsp").forward(request, response);
    }
   
}
