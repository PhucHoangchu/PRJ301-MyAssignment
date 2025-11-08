package controller.request;

import controller.iam.BaseRequiredAuthenticationController;
import dal.RequestForLeaveDBContex;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.iam.User;
import model.leave.RequestForLeave;

/**
 *
 * @author MWG
 */
public class ViewController extends BaseRequiredAuthenticationController {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        try {
            String ridParam = request.getParameter("rid");
            if (ridParam == null || ridParam.trim().isEmpty()) {
                request.getSession().setAttribute("errorMessage", "Invalid request ID.");
                response.sendRedirect(request.getContextPath() + "/request/list");
                return;
            }

            int rid = Integer.parseInt(ridParam);
            
            RequestForLeaveDBContex rflDB = new RequestForLeaveDBContex();
            RequestForLeave rfl = rflDB.getById(rid); // Sử dụng getById() để có cancel_note
            
            if (rfl == null) {
                request.getSession().setAttribute("errorMessage", "Request not found.");
                response.sendRedirect(request.getContextPath() + "/request/list");
                return;
            }
            
            request.setAttribute("request", rfl);
            request.getRequestDispatcher("/view/request/detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid request ID format.");
            response.sendRedirect(request.getContextPath() + "/request/list");
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/request/list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        doGet(request, response, user);
    }
}

