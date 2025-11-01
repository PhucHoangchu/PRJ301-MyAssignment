/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.division;

import controller.iam.BaseRequiredAuthorizationController;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.sql.Date;
import model.iam.User;
import model.leave.RequestForLeave;
import model.core.Employee;
import dal.RequestForLeaveDBContex;
import dal.EmployeeDBContext;

public class ViewAgendaController extends BaseRequiredAuthorizationController {

    @Override
    protected void processPost(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
        doGet(req, resp, user);
    }

    @Override
    protected void processGet(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
        try {
            RequestForLeaveDBContex requestDB = new RequestForLeaveDBContex();
            EmployeeDBContext employeeDB = new EmployeeDBContext();

            Employee currentEmployee = user.getEmployee();
            int currentEmployeeId = currentEmployee.getId();
            Employee fullEmployee = employeeDB.get(currentEmployeeId);
            if (fullEmployee == null || fullEmployee.getDivision() == null) {
                req.setAttribute("error", "Your profile is missing division information. Please contact administrator.");
                req.getRequestDispatcher("/view/division/agenda.jsp").forward(req, resp);
                return;
            }

            // Tối ưu: Check director role sớm, break khi tìm thấy
            boolean isDirector = false;
            if (user.getRoles() != null) {
                for (model.iam.Role r : user.getRoles()) {
                    if (isDirector) break; // Early exit
                    String rn = r.getName();
                    if (rn != null) {
                        String lowerName = rn.toLowerCase();
                        if (lowerName.contains("director") || lowerName.contains("giám đốc") || lowerName.contains("giam doc")) {
                            isDirector = true;
                            break;
                        }
                    }
                }
            }

            ArrayList<Employee> employees = isDirector ? employeeDB.list() : employeeDB.getByDivision(fullEmployee.getDivision().getId());
            ArrayList<RequestForLeave> requests = isDirector ? requestDB.list() : requestDB.getByDivision(fullEmployee.getDivision().getId());

            // Build 9-day range from query params
            String fromParam = req.getParameter("from");
            String toParam = req.getParameter("to");
            Date rangeFrom;
            Date rangeTo;
            try {
                final long ONE_DAY_MS = 24L * 60L * 60L * 1000L;
                if (fromParam != null && !fromParam.isEmpty()) {
                    Calendar cal = Calendar.getInstance();
                    rangeFrom = Date.valueOf(fromParam);
                    if (toParam != null && !toParam.isEmpty()) {
                        rangeTo = Date.valueOf(toParam);
                        if (rangeTo.before(rangeFrom)) {
                            // swap
                            Date tmp = rangeFrom; rangeFrom = rangeTo; rangeTo = tmp;
                        }
                        long diffDays = (rangeTo.getTime() - rangeFrom.getTime()) / ONE_DAY_MS;
                        if (diffDays > 8) {
                            rangeTo = new Date(rangeFrom.getTime() + 8 * ONE_DAY_MS);
                        }
                    } else {
                        cal.setTimeInMillis(rangeFrom.getTime());
                        cal.add(Calendar.DAY_OF_MONTH, 8);
                        rangeTo = new Date(cal.getTimeInMillis());
                    }
                } else if (toParam != null && !toParam.isEmpty()) {
                    Calendar cal = Calendar.getInstance();
                    rangeTo = Date.valueOf(toParam);
                    cal.setTimeInMillis(rangeTo.getTime());
                    cal.add(Calendar.DAY_OF_MONTH, -8);
                    rangeFrom = new Date(cal.getTimeInMillis());
                } else {
                    Calendar cal = Calendar.getInstance();
                    cal.set(Calendar.HOUR_OF_DAY, 0);
                    cal.set(Calendar.MINUTE, 0);
                    cal.set(Calendar.SECOND, 0);
                    cal.set(Calendar.MILLISECOND, 0);
                    rangeFrom = new Date(cal.getTimeInMillis());
                    cal.add(Calendar.DAY_OF_MONTH, 8);
                    rangeTo = new Date(cal.getTimeInMillis());
                }
            } catch (IllegalArgumentException ex) {
                Calendar cal = Calendar.getInstance();
                cal.set(Calendar.HOUR_OF_DAY, 0);
                cal.set(Calendar.MINUTE, 0);
                cal.set(Calendar.SECOND, 0);
                cal.set(Calendar.MILLISECOND, 0);
                rangeFrom = new Date(cal.getTimeInMillis());
                cal.add(Calendar.DAY_OF_MONTH, 8);
                rangeTo = new Date(cal.getTimeInMillis());
            }

            ArrayList<Date> dateRange = new ArrayList<>();
            Calendar walker = Calendar.getInstance();
            walker.setTimeInMillis(rangeFrom.getTime());
            while (!walker.getTime().after(rangeTo)) {
                dateRange.add(new Date(walker.getTimeInMillis()));
                walker.add(Calendar.DAY_OF_MONTH, 1);
            }

            // Fallback: nếu không lấy được danh sách nhân sự theo phòng ban,
            // suy ra từ các đơn nghỉ có trong phạm vi ngày để vẫn hiển thị được bảng
            if ((employees == null || employees.isEmpty()) && requests != null) {
                Map<Integer, Employee> inferred = new HashMap<>();
                for (RequestForLeave r : requests) {
                    if (r.getCreated_by() != null) {
                        inferred.putIfAbsent(r.getCreated_by().getId(), r.getCreated_by());
                    }
                }
                employees = new ArrayList<>(inferred.values());
            }

            // Hydrate missing basic fields to avoid null names when newly added
            if (employees != null) {
                for (int i = 0; i < employees.size(); i++) {
                    Employee e = employees.get(i);
                    if (e == null) continue;
                    if (e.getName() == null || e.getDivision() == null) {
                        Employee hydrated = employeeDB.get(e.getId());
                        if (hydrated != null) employees.set(i, hydrated);
                    }
                }
            }

            // Build approved-leave map by employee and date
            Map<Integer, Set<Date>> leaveDatesByEmployee = new HashMap<>();
            for (Employee e : employees) {
                leaveDatesByEmployee.put(e.getId(), new HashSet<>());
            }
            for (RequestForLeave rfl : requests) {
                // Fix NPE: Check all required fields before processing
                if (rfl.getStatus() != 1 || rfl.getFrom() == null || rfl.getTo() == null 
                    || rfl.getCreated_by() == null) continue;
                if (rfl.getTo().before(rangeFrom) || rfl.getFrom().after(rangeTo)) continue;
                Calendar dcal = Calendar.getInstance();
                Date start = rfl.getFrom().before(rangeFrom) ? rangeFrom : rfl.getFrom();
                Date end = rfl.getTo().after(rangeTo) ? rangeTo : rfl.getTo();
                dcal.setTimeInMillis(start.getTime());
                while (!dcal.getTime().after(end)) {
                    leaveDatesByEmployee.computeIfAbsent(rfl.getCreated_by().getId(), k -> new HashSet<>())
                            .add(new Date(dcal.getTimeInMillis()));
                    dcal.add(Calendar.DAY_OF_MONTH, 1);
                }
            }

            // Attributes
            req.setAttribute("currentEmployee", fullEmployee);
            req.setAttribute("divisionEmployees", employees);
            req.setAttribute("divisionRequests", requests);
            req.setAttribute("dateRange", dateRange);
            req.setAttribute("rangeFrom", rangeFrom);
            req.setAttribute("rangeTo", rangeTo);
            req.setAttribute("leaveDatesByEmployee", leaveDatesByEmployee);

            req.getRequestDispatcher("/view/division/agenda.jsp").forward(req, resp);

        } catch (ServletException | IOException ex) {
            req.setAttribute("error", "Có lỗi xảy ra: " + ex.getMessage());
            req.getRequestDispatcher("/view/division/agenda.jsp").forward(req, resp);
        }
    }
}

