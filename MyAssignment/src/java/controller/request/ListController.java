package controller.request;

import controller.iam.BaseRequiredAuthorizationController;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import model.leave.RequestForLeave;
import model.iam.User;
import dal.RequestForLeaveDBContex;
import util.Pagination;

/**
 *
 * @author MWG
 */
public class ListController extends BaseRequiredAuthorizationController {

    private static final int DEFAULT_PAGE_SIZE = 7; // Số records mỗi trang

    protected void processRequest(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
        if (user.getEmployee() == null || user.getEmployee().getId() == 0) {
            req.setAttribute("error", "Thông tin nhân viên không hợp lệ. Vui lòng đăng nhập lại.");
            req.setAttribute("rfls", new ArrayList<>());
            req.getRequestDispatcher("/view/request/list.jsp").forward(req, resp);
            return;
        }
        
        // Tự động reject các đơn pending đã quá ngày nghỉ
        RequestForLeaveDBContex autoRejectDB = new RequestForLeaveDBContex();
        autoRejectDB.autoRejectExpiredPendingRequests();
        autoRejectDB.closeDBConnection();
        
        // Parse pagination parameters
        int page = 1;
        int pageSize = DEFAULT_PAGE_SIZE;
        
        try {
            String pageParam = req.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                page = Integer.parseInt(pageParam);
            }
            
            String pageSizeParam = req.getParameter("pageSize");
            if (pageSizeParam != null && !pageSizeParam.isEmpty()) {
                pageSize = Integer.parseInt(pageSizeParam);
                if (pageSize < 1 || pageSize > 100) {
                    pageSize = DEFAULT_PAGE_SIZE; // Giới hạn từ 1-100
                }
            }
        } catch (NumberFormatException e) {
            // Nếu parse lỗi thì dùng giá trị mặc định
            page = 1;
            pageSize = DEFAULT_PAGE_SIZE;
        }
        
        RequestForLeaveDBContex db = new RequestForLeaveDBContex();
        int employeeId = user.getEmployee().getId();
        
        // Lấy tổng số records
        int totalRecords = db.countByEmployeeAndSubodiaries(employeeId);
        
        // Tạo Pagination object
        Pagination pagination = new Pagination(page, pageSize, totalRecords);
        
        // Lấy dữ liệu với pagination
        ArrayList<RequestForLeave> rfls = db.getByEmployeeAndSubodiariesPaginated(
            employeeId, 
            pagination.getOffset(), 
            pagination.getPageSize()
        );
        
        req.setAttribute("rfls", rfls != null ? rfls : new ArrayList<>());
        req.setAttribute("pagination", pagination);
        req.getRequestDispatcher("/view/request/list.jsp").forward(req, resp);
    }

    @Override
    protected void processPost(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
        processRequest(req, resp, user);
    }

    @Override
    protected void processGet(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
        processRequest(req, resp, user);
    }

}