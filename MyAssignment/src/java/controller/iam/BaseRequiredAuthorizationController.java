/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.iam;

import dal.RoleDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import model.iam.Feature;
import model.iam.User;
import model.iam.Role;

/**
 *
 * @author MWG
 */
public abstract class BaseRequiredAuthorizationController extends BaseRequiredAuthenticationController {

    private boolean isAuthorized(HttpServletRequest req, User user) {
        if (user.getRoles() == null || user.getRoles().isEmpty()) { //check if not yet fetch roles from db to user  
            RoleDBContext db = new RoleDBContext();
            ArrayList<Role> roles = db.getByUserId(user.getId());
            user.setRoles(roles != null ? roles : new ArrayList<>());
            req.getSession().setAttribute("auth", user);
        }
        String url = req.getServletPath();
        if (url == null || url.isEmpty()) {
            return false;
        }
        
        // Debug: Log để kiểm tra
        System.out.println("Authorization check for user ID: " + user.getId() + ", URL: " + url);
        System.out.println("User has " + (user.getRoles() != null ? user.getRoles().size() : 0) + " roles");
        
        for (Role role : user.getRoles()) {
            if (role != null && role.getFeatures() != null) {
                System.out.println("  Checking role: " + role.getName() + " with " + role.getFeatures().size() + " features");
                for (Feature feature : role.getFeatures()) {
                    if (feature != null && feature.getUrl() != null) {
                        System.out.println("    Feature URL: " + feature.getUrl() + " matches? " + feature.getUrl().equals(url));
                        if (feature.getUrl().equals(url)) {
                            System.out.println("    ✓ AUTHORIZED");
                            return true;
                        }
                    }
                }
            }
        }
        System.out.println("    ✗ NOT AUTHORIZED - No matching feature found");
        return false;
    }

    protected abstract void processPost(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException;
    protected abstract void processGet(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
        resp.setContentType("text/html;charset=UTF-8");
        if(isAuthorized(req, user)) {
            processPost(req, resp, user);
        } else {
            // Hiển thị thông báo lỗi rõ ràng hơn
            resp.getWriter().println("<html><head><meta charset='UTF-8'><title>Access Denied</title></head><body>");
            resp.getWriter().println("<h2>Access Denied</h2>");
            resp.getWriter().println("<p>Bạn không có quyền truy cập trang này.</p>");
            resp.getWriter().println("<p>URL yêu cầu: " + req.getServletPath() + "</p>");
            resp.getWriter().println("<p>Vui lòng liên hệ quản trị viên để được cấp quyền.</p>");
            resp.getWriter().println("<p><a href='" + req.getContextPath() + "/home'>← Về trang chủ</a></p>");
            resp.getWriter().println("</body></html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
        resp.setContentType("text/html;charset=UTF-8");
        if (isAuthorized(req, user)) {
            processGet(req, resp, user);
        } else {
            // Debug: Log user roles và features để kiểm tra
            System.out.println("Access denied for user ID: " + user.getId());
            System.out.println("Request URL: " + req.getServletPath());
            if (user.getRoles() != null) {
                for (Role r : user.getRoles()) {
                    System.out.println("  Role: " + r.getName());
                    if (r.getFeatures() != null) {
                        for (Feature f : r.getFeatures()) {
                            System.out.println("    Feature: " + (f != null ? f.getUrl() : "null"));
                        }
                    }
                }
            }
            
            // Hiển thị thông báo lỗi rõ ràng hơn
            resp.getWriter().println("<html><head><meta charset='UTF-8'><title>Access Denied</title></head><body>");
            resp.getWriter().println("<h2>Access Denied</h2>");
            resp.getWriter().println("<p>Bạn không có quyền truy cập trang này.</p>");
            resp.getWriter().println("<p>URL yêu cầu: <strong>" + req.getServletPath() + "</strong></p>");
            if (user.getRoles() != null && !user.getRoles().isEmpty()) {
                resp.getWriter().println("<p>Roles của bạn:");
                resp.getWriter().println("<ul>");
                for (Role r : user.getRoles()) {
                    resp.getWriter().println("<li>" + r.getName() + "</li>");
                }
                resp.getWriter().println("</ul></p>");
            } else {
                resp.getWriter().println("<p><em>Bạn chưa được gán role nào.</em></p>");
            }
            resp.getWriter().println("<p>Vui lòng liên hệ quản trị viên để được cấp quyền.</p>");
            resp.getWriter().println("<p><a href='" + req.getContextPath() + "/home'>&larr; Về trang chủ</a></p>");
            resp.getWriter().println("</body></html>");
        }
    }

}
