/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.request;

import controller.iam.BaseRequiredAuthorizationController;
import dal.RequestForLeaveDBContex;
import dal.RoleDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import model.iam.User;
import model.iam.Role;
import model.leave.RequestForLeave;

/**
 *
 * @author MWG
 */
public class ReviewController extends BaseRequiredAuthorizationController {

    @Override
    protected void processPost(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
        try {
            String action = req.getParameter("action");
            String ridStr = req.getParameter("rid");

            // Validation
            if (action == null || ridStr == null) {
                req.setAttribute("error", "Thiếu thông tin cần thiết");
                processGet(req, resp, user);
                return;
            }

            int rid = Integer.parseInt(ridStr);
            
            if (user.getEmployee() == null || user.getEmployee().getId() == 0) {
                req.setAttribute("error", "Thông tin nhân viên không hợp lệ. Vui lòng đăng nhập lại.");
                processGet(req, resp, user);
                return;
            }
            
            int employeeId = user.getEmployee().getId();

            RequestForLeaveDBContex db = new RequestForLeaveDBContex();

            // Xử lý action
            String redirectMessage = null;
            if ("approve".equals(action)) {
                try {
                    db.approveRequest(rid, employeeId);
                    redirectMessage = "approved";
                } catch (Exception ex) {
                    System.err.println("ERROR approving request: " + ex.getMessage());
                    ex.printStackTrace();
                    resp.sendRedirect(req.getContextPath() + "/request/review?error=approve_failed");
                    return;
                }
            } else if ("reject".equals(action)) {
                try {
                    db.rejectRequest(rid, employeeId);
                    redirectMessage = "rejected";
                } catch (Exception ex) {
                    System.err.println("ERROR rejecting request: " + ex.getMessage());
                    ex.printStackTrace();
                    resp.sendRedirect(req.getContextPath() + "/request/review?error=reject_failed");
                    return;
                }
            } else {
                resp.sendRedirect(req.getContextPath() + "/request/review?error=invalid_action");
                return;
            }

            // Redirect về review page để refresh danh sách với message
            resp.sendRedirect(req.getContextPath() + "/request/review?message=" + redirectMessage);

        } catch (NumberFormatException ex) {
            req.setAttribute("error", "ID request không hợp lệ");
            processGet(req, resp, user);
        } catch (Exception ex) {
            req.setAttribute("error", "Có lỗi xảy ra: " + ex.getMessage());
            processGet(req, resp, user);
        }
    }

    @Override
    protected void processGet(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
        try {
            RequestForLeaveDBContex db = new RequestForLeaveDBContex();

            String ridParam = req.getParameter("rid");
            String format = req.getParameter("format");
            
            // If format=json, return JSON response for API
            if ("json".equals(format) && ridParam != null && !ridParam.isEmpty()) {
                int rid = Integer.parseInt(ridParam);
                RequestForLeave selected = db.get(rid);
                
                resp.setContentType("application/json;charset=UTF-8");
                resp.setCharacterEncoding("UTF-8");
                
                if (selected != null) {
                    // Escape JSON string helper
                    String reason = selected.getReason();
                    if (reason != null) {
                        reason = reason.replace("\\", "\\\\")
                                     .replace("\"", "\\\"")
                                     .replace("\n", "\\n")
                                     .replace("\r", "\\r")
                                     .replace("\t", "\\t");
                    } else {
                        reason = "";
                    }
                    
                    String createdBy = "";
                    if (selected.getCreated_by() != null && selected.getCreated_by().getName() != null) {
                        createdBy = selected.getCreated_by().getName()
                                .replace("\\", "\\\\")
                                .replace("\"", "\\\"")
                                .replace("\n", "\\n")
                                .replace("\r", "\\r")
                                .replace("\t", "\\t");
                    }
                    
                    StringBuilder json = new StringBuilder();
                    json.append("{");
                    json.append("\"id\":").append(selected.getId()).append(",");
                    json.append("\"from\":\"").append(selected.getFrom() != null ? selected.getFrom().toString() : "").append("\",");
                    json.append("\"to\":\"").append(selected.getTo() != null ? selected.getTo().toString() : "").append("\",");
                    json.append("\"reason\":\"").append(reason).append("\",");
                    json.append("\"status\":").append(selected.getStatus()).append(",");
                    json.append("\"created\":\"").append(selected.getCreated_time() != null ? selected.getCreated_time().toString() : "").append("\",");
                    json.append("\"createdBy\":\"").append(createdBy).append("\"");
                    json.append("}");
                    
                    resp.getWriter().write(json.toString());
                } else {
                    resp.getWriter().write("{\"error\":\"Request not found\"}");
                }
                return;
            }

            // Lấy message từ query parameter sau khi approve/reject
            String messageParam = req.getParameter("message");
            if ("approved".equals(messageParam)) {
                req.setAttribute("message", "Đã duyệt request thành công");
            } else if ("rejected".equals(messageParam)) {
                req.setAttribute("message", "Đã từ chối request");
            }
            
            // Lấy error từ query parameter
            String errorParam = req.getParameter("error");
            if (errorParam != null) {
                if ("approve_failed".equals(errorParam)) {
                    req.setAttribute("error", "Có lỗi xảy ra khi duyệt request. Vui lòng thử lại.");
                } else if ("reject_failed".equals(errorParam)) {
                    req.setAttribute("error", "Có lỗi xảy ra khi từ chối request. Vui lòng thử lại.");
                } else if ("invalid_action".equals(errorParam)) {
                    req.setAttribute("error", "Action không hợp lệ");
                }
            }

            if (ridParam != null && !ridParam.isEmpty()) {
                // Hiển thị form duyệt chi tiết cho 1 request
                int rid = Integer.parseInt(ridParam);
                RequestForLeave selected = db.get(rid);
                req.setAttribute("selectedRequest", selected);
            }

            // Validate user employee
            if (user.getEmployee() == null || user.getEmployee().getId() == 0) {
                req.setAttribute("error", "Thông tin nhân viên không hợp lệ. Vui lòng đăng nhập lại.");
                req.setAttribute("pendingRequests", new ArrayList<>());
                req.getRequestDispatcher("/view/request/review.jsp").forward(req, resp);
                return;
            }

            // Kiểm tra xem user có phải IT Head (rid=1) không
            RoleDBContext roleDB = new RoleDBContext();
            ArrayList<Role> userRoles = roleDB.getByUserId(user.getId());
            boolean isITHead = false;
            for (Role role : userRoles) {
                if (role != null && role.getId() == 1 && "IT Head".equals(role.getName())) {
                    isITHead = true;
                    break;
                }
            }

            int employeeId = user.getEmployee().getId();
            ArrayList<RequestForLeave> pendingRequests = new ArrayList<>();
            
            if (isITHead) {
                // IT Head: Lấy TẤT CẢ pending requests (bao gồm cả đơn của chính mình)
                ArrayList<RequestForLeave> allPendingRequests = db.getByStatus(0);
                for (RequestForLeave rfl : allPendingRequests) {
                    if (rfl != null && rfl.getStatus() == 0) {
                        pendingRequests.add(rfl);
                    }
                }
            } else {
                // Các role khác: Chỉ lấy pending requests từ subordinates (không bao gồm đơn của chính mình)
                ArrayList<RequestForLeave> allSubordinateRequests = db.getByEmployeeAndSubodiaries(employeeId);
                for (RequestForLeave rfl : allSubordinateRequests) {
                    if (rfl != null && rfl.getStatus() == 0 && rfl.getCreated_by() != null 
                            && rfl.getCreated_by().getId() != employeeId) {
                        pendingRequests.add(rfl);
                    }
                }
            }
            
            req.setAttribute("pendingRequests", pendingRequests);
            req.getRequestDispatcher("/view/request/review.jsp").forward(req, resp);

        } catch (Exception ex) {
            req.setAttribute("error", "Có lỗi xảy ra: " + ex.getMessage());
            req.getRequestDispatcher("/view/request/review.jsp").forward(req, resp);
        }
    }

}
