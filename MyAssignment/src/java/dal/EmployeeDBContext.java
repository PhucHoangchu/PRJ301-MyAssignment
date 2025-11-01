/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.util.ArrayList;
import model.core.Employee;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.core.Division;

/**
 *
 * @author MWG
 */
public class EmployeeDBContext extends DBContext<Employee> {

    @Override
    public ArrayList<Employee> list() {
        ArrayList<Employee> emps = new ArrayList<>();
        try {
            String sql =
                    "SELECT e.eid, e.ename, " +
                    "       e.supervisorid, s.ename as supervisor_name, " +
                    "       e.did, d.dname " +
                    "FROM Employee e " +
                    "LEFT JOIN Employee s ON e.supervisorid = s.eid " +
                    "INNER JOIN Division d ON e.did = d.did";
            PreparedStatement stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                emps.add(mapResultSetToEmployee(rs));
            }
        } catch (SQLException ex) {
            Logger.getLogger(EmployeeDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return emps;
    }

    @Override
    public Employee get(int id) {
        try {
            String sql =
                    "SELECT e.eid, e.ename, " +
                    "       e.supervisorid, s.ename as supervisor_name, " +
                    "       e.did, d.dname " +
                    "FROM Employee e " +
                    "LEFT JOIN Employee s ON e.supervisorid = s.eid " +
                    "INNER JOIN Division d ON e.did = d.did " +
                    "WHERE e.eid = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return mapResultSetToEmployee(rs);
            }
        } catch (SQLException ex) {
            Logger.getLogger(EmployeeDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return null;
    }

    @Override
    public void insert(Employee model) {
        try {
            String sql = "INSERT INTO [Employee] (eid, ename, did, supervisorid) VALUES (?, ?, ?, ?)";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, model.getId());
            stm.setString(2, model.getName());
            stm.setInt(3, model.getDivision().getId());

            if (model.getSupervisor() != null) {
                stm.setInt(4, model.getSupervisor().getId());
            } else {
                stm.setNull(4, java.sql.Types.INTEGER);
            }

            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(EmployeeDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
    }

    @Override
    public void update(Employee model) {
        try {
            String sql = "UPDATE [Employee] SET ename = ?, did = ?, supervisorid = ? WHERE eid = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, model.getName());
            stm.setInt(2, model.getDivision().getId());

            if (model.getSupervisor() != null) {
                stm.setInt(3, model.getSupervisor().getId());
            } else {
                stm.setNull(3, java.sql.Types.INTEGER);
            }

            stm.setInt(4, model.getId());
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(EmployeeDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
    }

    @Override
    public void delete(Employee model) {
        try {
            // Cần xóa các references trước
            connection.setAutoCommit(false);

            // Xóa UserRole references (nếu có)
            String sqlUserRole = "DELETE FROM [UserRole] WHERE uid IN (SELECT uid FROM [Enrollment] WHERE eid = ?)";
            PreparedStatement stmUserRole = connection.prepareStatement(sqlUserRole);
            stmUserRole.setInt(1, model.getId());
            stmUserRole.executeUpdate();

            // Xóa Enrollment references
            String sqlEnrollment = "DELETE FROM [Enrollment] WHERE eid = ?";
            PreparedStatement stmEnrollment = connection.prepareStatement(sqlEnrollment);
            stmEnrollment.setInt(1, model.getId());
            stmEnrollment.executeUpdate();

            // Xóa RequestForLeave references
            String sqlRequests = "DELETE FROM [RequestForLeave] WHERE created_by = ? OR processed_by = ?";
            PreparedStatement stmRequests = connection.prepareStatement(sqlRequests);
            stmRequests.setInt(1, model.getId());
            stmRequests.setInt(2, model.getId());
            stmRequests.executeUpdate();

            // Cập nhật supervisorid của subordinates
            String sqlUpdateSubordinates = "UPDATE [Employee] SET supervisorid = NULL WHERE supervisorid = ?";
            PreparedStatement stmUpdateSubordinates = connection.prepareStatement(sqlUpdateSubordinates);
            stmUpdateSubordinates.setInt(1, model.getId());
            stmUpdateSubordinates.executeUpdate();

            // Cuối cùng xóa Employee
            String sqlEmployee = "DELETE FROM [Employee] WHERE eid = ?";
            PreparedStatement stmEmployee = connection.prepareStatement(sqlEmployee);
            stmEmployee.setInt(1, model.getId());
            stmEmployee.executeUpdate();

            connection.commit();
        } catch (SQLException ex) {
            Logger.getLogger(EmployeeDBContext.class.getName()).log(Level.SEVERE, null, ex);
            try {
                connection.rollback();
            } catch (SQLException ex1) {
                Logger.getLogger(EmployeeDBContext.class.getName()).log(Level.SEVERE, null, ex1);
            }
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException ex) {
                Logger.getLogger(EmployeeDBContext.class.getName()).log(Level.SEVERE, null, ex);
            }
            closeConnection();
        }
    }

    // Lấy employees theo division
    public ArrayList<Employee> getByDivision(int divisionId) {
        ArrayList<Employee> emps = new ArrayList<>();
        try {
            String sql =
                    "SELECT e.eid, e.ename, " +
                    "       e.supervisorid, s.ename as supervisor_name, " +
                    "       e.did, d.dname " +
                    "FROM Employee e " +
                    "LEFT JOIN Employee s ON e.supervisorid = s.eid " +
                    "INNER JOIN Division d ON e.did = d.did " +
                    "WHERE e.did = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, divisionId);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                emps.add(mapResultSetToEmployee(rs));
            }
        } catch (SQLException ex) {
            Logger.getLogger(EmployeeDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return emps;
    }

    // Lấy subordinates của một employee
    public ArrayList<Employee> getSubordinates(int supervisorId) {
        ArrayList<Employee> emps = new ArrayList<>();
        try {
            String sql =
                    "SELECT e.eid, e.ename, " +
                    "       e.supervisorid, s.ename as supervisor_name, " +
                    "       e.did, d.dname " +
                    "FROM Employee e " +
                    "LEFT JOIN Employee s ON e.supervisorid = s.eid " +
                    "INNER JOIN Division d ON e.did = d.did " +
                    "WHERE e.supervisorid = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, supervisorId);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                emps.add(mapResultSetToEmployee(rs));
            }
        } catch (SQLException ex) {
            Logger.getLogger(EmployeeDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return emps;
    }
// Lấy managers (employees có subordinates)

    public ArrayList<Employee> getManagers() {
        ArrayList<Employee> emps = new ArrayList<>();
        try {
            String sql =
                    "SELECT DISTINCT e.eid, e.ename, " +
                    "       e.supervisorid, s.ename as supervisor_name, " +
                    "       e.did, d.dname " +
                    "FROM Employee e " +
                    "LEFT JOIN Employee s ON e.supervisorid = s.eid " +
                    "INNER JOIN Division d ON e.did = d.did " +
                    "WHERE e.eid IN (SELECT DISTINCT supervisorid FROM Employee WHERE supervisorid IS NOT NULL)";
            PreparedStatement stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                emps.add(mapResultSetToEmployee(rs));
            }
        } catch (SQLException ex) {
            Logger.getLogger(EmployeeDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return emps;
    }

    // Hàm helper để tái sử dụng logic map ResultSet
    private Employee mapResultSetToEmployee(ResultSet rs) throws SQLException {
        Employee e = new Employee();
        e.setId(rs.getInt("eid"));
        e.setName(rs.getString("ename"));

        if (rs.getObject("supervisorid") != null) {
            Employee supervisor = new Employee();
            supervisor.setId(rs.getInt("supervisorid"));
            supervisor.setName(rs.getString("supervisor_name"));
            e.setSupervisor(supervisor);
            // Lưu ý: Supervisor này chưa được "hydrate" đầy đủ (chưa có Division, Supervisor của Supervisor)
            // Để hydrate đầy đủ cần truy vấn đệ quy, nhưng sẽ phức tạp.
            // Tạm thời chỉ lấy ID và Tên cho hầu hết các nghiệp vụ.
        }

        Division d = new Division();
        d.setId(rs.getInt("did"));
        d.setName(rs.getString("dname"));
        e.setDivision(d);
        return e;
    }

}
