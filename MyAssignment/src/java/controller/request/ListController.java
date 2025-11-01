/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
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

/**
 *
 * @author MWG
 */
public class ListController extends BaseRequiredAuthorizationController {

    protected void processRequest(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
        if (user.getEmployee() == null || user.getEmployee().getId() == 0) {
            req.setAttribute("error", "Thông tin nhân viên không hợp lệ. Vui lòng đăng nhập lại.");
            req.setAttribute("rfls", new ArrayList<>());
            req.getRequestDispatcher("/view/request/list.jsp").forward(req, resp);
            return;
        }
        
        RequestForLeaveDBContex db = new RequestForLeaveDBContex();
        int employeeId = user.getEmployee().getId();
        ArrayList<RequestForLeave> rfls = db.getByEmployeeAndSubodiaries(employeeId); 
        req.setAttribute("rfls", rfls != null ? rfls : new ArrayList<>());
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
