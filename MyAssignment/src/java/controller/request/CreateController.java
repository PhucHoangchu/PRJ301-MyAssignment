package controller.request;

import controller.iam.BaseRequiredAuthorizationController;
import dal.RequestForLeaveDBContex;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Timestamp; 
import java.sql.Date;    
import model.core.Employee;
import model.iam.User;
import model.leave.RequestForLeave;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
/**
 *
 * @author MWG
 */
public class CreateController extends BaseRequiredAuthorizationController {

    @Override
    protected void processPost(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
         try {
            // Lấy parameters từ form
            String fromStr = req.getParameter("from");
            String toStr = req.getParameter("to");
            String reason = req.getParameter("reason");
            String leaveType = req.getParameter("leave_type");

            // Validation
            if (fromStr == null || toStr == null || reason == null || leaveType == null
                    || fromStr.trim().isEmpty() || toStr.trim().isEmpty() || reason.trim().isEmpty() || leaveType.trim().isEmpty()) {
                req.setAttribute("error", "Vui lòng điền đầy đủ thông tin");
                req.getRequestDispatcher("/view/request/create.jsp").forward(req, resp);
                return;
            }

            // Parse dates
            Date from;
            Date to;
            try {
                from = Date.valueOf(fromStr);
                to = Date.valueOf(toStr);
            } catch (IllegalArgumentException ex) {
                req.setAttribute("error", "Định dạng ngày không hợp lệ. Vui lòng chọn lại ngày.");
                req.getRequestDispatcher("/view/request/create.jsp").forward(req, resp);
                return;
            }

            // Validate date range
            if (from.after(to)) {
                req.setAttribute("error", "Ngày bắt đầu không được sau ngày kết thúc");
                req.getRequestDispatcher("/view/request/create.jsp").forward(req, resp);
                return;
            }

            // Validate leave_type value
            String[] validTypes = {"annual", "sick", "personal", "unpaid", "maternity", "paternity", "other"};
            boolean isValidType = false;
            for (String type : validTypes) {
                if (type.equals(leaveType.trim())) {
                    isValidType = true;
                    break;
                }
            }
            if (!isValidType) {
                req.setAttribute("error", "Loại nghỉ phép không hợp lệ");
                req.getRequestDispatcher("/view/request/create.jsp").forward(req, resp);
                return;
            }

            // Set created_by employee
            Employee employee = user.getEmployee();
            if (employee == null) {
                req.setAttribute("error", "Không thể xác định thông tin nhân viên. Vui lòng đăng nhập lại.");
                req.getRequestDispatcher("/view/request/create.jsp").forward(req, resp);
                return;
            }
            
            if (employee.getId() == 0) {
                req.setAttribute("error", "ID nhân viên không hợp lệ. Vui lòng đăng nhập lại.");
                req.getRequestDispatcher("/view/request/create.jsp").forward(req, resp);
                return;
            }

            // Tạo RequestForLeave object
            RequestForLeave rfl = new RequestForLeave();
            rfl.setFrom(from);
            rfl.setTo(to);
            rfl.setReason(reason.trim());
            rfl.setLeaveType(leaveType.trim());
            rfl.setStatus(0); // Pending
            rfl.setCreated_time(new Timestamp(System.currentTimeMillis()));
            rfl.setCreated_by(employee);

            // Insert vào database
            RequestForLeaveDBContex db = new RequestForLeaveDBContex();
            db.insert(rfl);

            // Redirect về home page để hiển thị statistics mới nhất
            resp.sendRedirect(req.getContextPath() + "/home");

        } catch (RuntimeException ex) {
            // Lỗi từ database insert (SQLException được wrap trong RuntimeException)
            System.err.println("ERROR in CreateController.processPost: " + ex.getMessage());
            ex.printStackTrace();
            String errorMsg = "Có lỗi xảy ra khi lưu đơn vào database.";
            if (ex.getCause() != null) {
                errorMsg += " Chi tiết: " + ex.getCause().getMessage();
            }
            req.setAttribute("error", errorMsg);
            req.getRequestDispatcher("/view/request/create.jsp").forward(req, resp);
        } catch (Exception ex) {
            // Các lỗi khác
            System.err.println("ERROR in CreateController.processPost: " + ex.getMessage());
            ex.printStackTrace();
            req.setAttribute("error", "Có lỗi xảy ra khi tạo đơn: " + ex.getMessage());
            req.getRequestDispatcher("/view/request/create.jsp").forward(req, resp);
        }
    }

    @Override
    protected void processGet(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
        req.getRequestDispatcher("/view/request/create.jsp").forward(req, resp);
    }

}
