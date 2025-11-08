package controller.request;

import controller.iam.BaseRequiredAuthorizationController;
import dal.RequestForLeaveDBContex;
import dal.RoleDBContext;
import dal.EmployeeDBContext;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.iam.User;
import model.leave.RequestForLeave;

/**
 *
 * @author MWG
 */
public class CancelController extends BaseRequiredAuthorizationController {

    @Override
    protected void processGet(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        // Redirect về trang list nếu truy cập bằng GET
        response.sendRedirect(request.getContextPath() + "/request/list");
    }

    @Override
    protected void processPost(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        try {
            // Lấy request ID và ghi chú từ parameter
            String ridParam = request.getParameter("rid");
            String cancelNote = request.getParameter("cancelNote");
            
            if (ridParam == null || ridParam.trim().isEmpty()) {
                request.getSession().setAttribute("errorMessage", "Invalid request ID.");
                response.sendRedirect(request.getContextPath() + "/request/list");
                return;
            }
            
            // Validate ghi chú (bắt buộc)
            if (cancelNote == null || cancelNote.trim().isEmpty()) {
                request.getSession().setAttribute("errorMessage", "Vui lòng nhập lý do hủy đơn.");
                response.sendRedirect(request.getContextPath() + "/request/list");
                return;
            }

            int rid = Integer.parseInt(ridParam);
            
            // Kiểm tra employee
            if (user.getEmployee() == null) {
                request.getSession().setAttribute("errorMessage", "You must be logged in to cancel a request.");
                response.sendRedirect(request.getContextPath() + "/request/list");
                return;
            }

            int currentEmployeeId = user.getEmployee().getId();
            
            // Kiểm tra quyền IT Head
            RoleDBContext roleDB = new RoleDBContext();
            boolean isITHead = roleDB.hasRole(user.getId(), "IT Head");
            
            // Lấy request từ database
            RequestForLeaveDBContex rflDB = new RequestForLeaveDBContex();
            RequestForLeave rfl = rflDB.getById(rid);
            
            if (rfl == null) {
                request.getSession().setAttribute("errorMessage", "Request not found.");
                response.sendRedirect(request.getContextPath() + "/request/list");
                return;
            }
            
            // Kiểm tra xem có thể hủy không (với EmployeeDBContext để kiểm tra supervisor)
            EmployeeDBContext empDB = new EmployeeDBContext();
            if (!rfl.canBeCancelled(currentEmployeeId, isITHead, empDB)) {
                request.getSession().setAttribute("errorMessage", 
                    "Bạn không có quyền hủy đơn này.");
                response.sendRedirect(request.getContextPath() + "/request/list");
                return;
            }
            
            // Thực hiện hủy đơn - tạo instance mới vì getById() đã đóng connection
            RequestForLeaveDBContex cancelDB = new RequestForLeaveDBContex();
            boolean success = cancelDB.cancelRequest(rid, currentEmployeeId, cancelNote.trim());
            
            if (success) {
                request.getSession().setAttribute("successMessage", "Đơn đã được hủy thành công.");
            } else {
                request.getSession().setAttribute("errorMessage", "Không thể hủy đơn. Vui lòng thử lại.");
            }
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid request ID format.");
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "An error occurred: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/request/list");
    }
}