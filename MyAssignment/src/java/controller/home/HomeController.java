/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.home;

import controller.iam.BaseRequiredAuthenticationController;
import dal.RequestForLeaveDBContex;
import dal.RoleDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import model.core.Employee;
import model.iam.Role;
import model.iam.User;
import model.leave.RequestForLeave;

/**
 *
 * @author MWG
 */
public class HomeController extends BaseRequiredAuthenticationController {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
        doGet(req, resp, user);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
        try {
            RequestForLeaveDBContex requestDB = new RequestForLeaveDBContex();
            RoleDBContext roleDB = new RoleDBContext();
            
            // Lấy requests theo phạm vi hiển thị
            Employee userEmployee = user.getEmployee();
            if (userEmployee == null || userEmployee.getId() == 0) {
                System.err.println("ERROR: User employee is null or invalid!");
                req.setAttribute("error", "Thông tin nhân viên không hợp lệ. Vui lòng đăng nhập lại.");
                req.setAttribute("myRequests", new ArrayList<>());
                req.setAttribute("totalRequests", Integer.valueOf(0));
                req.setAttribute("pendingCount", Integer.valueOf(0));
                req.setAttribute("approvedCount", Integer.valueOf(0));
                req.setAttribute("rejectedCount", Integer.valueOf(0));
                req.setAttribute("pendingRequests", new ArrayList<>());
                req.getRequestDispatcher("/view/home/index.jsp").forward(req, resp);
                return;
            }
            
            int employeeId = userEmployee.getId();
            
            // Xác định có quyền review (xem phạm vi rộng hơn không) - tối ưu loop
            ArrayList<Role> userRoles = roleDB.getByUserId(user.getId());
            user.setRoles(userRoles);
            req.getSession().setAttribute("auth", user);

            boolean canReview = false;
            // Tối ưu: break sớm khi tìm thấy
            for (Role role : userRoles) {
                if (canReview) break; // Early exit
                for (model.iam.Feature f : role.getFeatures()) {
                    if ("/request/review".equals(f.getUrl())) {
                        canReview = true;
                        break;
                    }
                }
            }

            // Tối ưu: Chỉ query một lần, reuse kết quả
            ArrayList<RequestForLeave> scopeRequests;
            ArrayList<RequestForLeave> myRequests;
            
            if (canReview) {
                // Nếu có quyền review, lấy cả subordinate requests (bao gồm cả của mình)
                scopeRequests = requestDB.getByEmployeeAndSubodiaries(employeeId);
                if (scopeRequests == null) {
                    scopeRequests = new ArrayList<>();
                }
                // Filter ra chỉ requests của mình để hiển thị trong myRequests
                myRequests = new ArrayList<>();
                for (RequestForLeave rfl : scopeRequests) {
                    if (rfl != null && rfl.getCreated_by() != null && rfl.getCreated_by().getId() == employeeId) {
                        myRequests.add(rfl);
                    }
                }
            } else {
                // Chỉ lấy requests của mình
                myRequests = requestDB.getByEmployee(employeeId);
                if (myRequests == null) {
                    myRequests = new ArrayList<>();
                }
                scopeRequests = myRequests;
            }

            // Tính toán thống kê và pending requests trong cùng một loop - tối ưu hơn
            int totalRequests = scopeRequests.size();
            int pendingCount = 0, approvedCount = 0, rejectedCount = 0;
            ArrayList<RequestForLeave> pendingRequests = new ArrayList<>();
            
            for (RequestForLeave rfl : scopeRequests) {
                if (rfl != null) {
                    switch (rfl.getStatus()) {
                        case 0: 
                            pendingCount++;
                            if (canReview) {
                                pendingRequests.add(rfl); // Chỉ thêm nếu có quyền review
                            }
                            break;
                        case 1: approvedCount++; break;
                        case 2: rejectedCount++; break;
                    }
                }
            }
            
            // Set attributes - đảm bảo luôn set giá trị, kể cả khi có lỗi
            req.setAttribute("user", user);
            req.setAttribute("myRequests", myRequests != null ? myRequests : new ArrayList<>());
            req.setAttribute("totalRequests", Integer.valueOf(totalRequests));
            req.setAttribute("pendingCount", Integer.valueOf(pendingCount));
            req.setAttribute("approvedCount", Integer.valueOf(approvedCount));
            req.setAttribute("rejectedCount", Integer.valueOf(rejectedCount));
            req.setAttribute("pendingRequests", pendingRequests != null ? pendingRequests : new ArrayList<>());
            
            // Forward đến home page
            req.getRequestDispatcher("/view/home/index.jsp").forward(req, resp);
            
        } catch (Exception ex) {
            // Xử lý tất cả exceptions, đảm bảo luôn có giá trị để hiển thị
            System.err.println("Error in HomeController: " + ex.getMessage());
            ex.printStackTrace();
            
            // Set default values nếu có lỗi
            req.setAttribute("user", user);
            req.setAttribute("myRequests", new ArrayList<>());
            req.setAttribute("totalRequests", Integer.valueOf(0));
            req.setAttribute("pendingCount", Integer.valueOf(0));
            req.setAttribute("approvedCount", Integer.valueOf(0));
            req.setAttribute("rejectedCount", Integer.valueOf(0));
            req.setAttribute("pendingRequests", new ArrayList<>());
            req.setAttribute("error", "Có lỗi xảy ra: " + ex.getMessage());
            
            req.getRequestDispatcher("/view/home/index.jsp").forward(req, resp);
        }
    }
}
    

