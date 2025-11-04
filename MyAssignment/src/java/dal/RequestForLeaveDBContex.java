/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.util.ArrayList;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.core.Employee;
import model.leave.RequestForLeave;

/**
 *
 * @author MWG
 */
public class RequestForLeaveDBContex extends DBContext<RequestForLeave> {

    public ArrayList<RequestForLeave> getByEmployeeAndSubodiaries(int eid) {
        ArrayList<RequestForLeave> rfls = new ArrayList<>();
        try {
            String sql =
                    "WITH Org AS (" +
                    "    SELECT *, 0 as lvl FROM Employee e WHERE e.eid = ? " +
                    "    UNION ALL " +
                    "    SELECT c.*, o.lvl + 1 as lvl FROM Employee c JOIN Org o ON c.supervisorid = o.eid " +
                    ") " +
                    "SELECT " +
                    "      r.[rid] " +
                    "    , r.[created_by] " +
                    "    , e.ename as [created_name] " +
                    "    , r.[created_time] " +
                    "    , r.[from] " +
                    "    , r.[to] " +
                    "    , r.[reason] " +
                    "    , r.[status] " +
                    "    , r.[leave_type] " +
                    "    , r.[processed_by] " +
                    "    , p.ename as [processed_name] " +
                    "FROM Org e INNER JOIN [RequestForLeave] r ON e.eid = r.created_by " +
                    "LEFT JOIN Employee p ON p.eid = r.processed_by " +
                    "ORDER BY r.created_time DESC";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, eid);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                RequestForLeave rfl = new RequestForLeave();
                rfl.setId(rs.getInt("rid")); // Fix: Set ID để statistics và các operations khác có thể hoạt động đúng
                rfl.setCreated_time(rs.getTimestamp("created_time"));
                rfl.setFrom(rs.getDate("from"));
                rfl.setTo(rs.getDate("to"));
                rfl.setReason(rs.getString("reason"));
                rfl.setStatus(rs.getInt("status"));
                rfl.setLeaveType(rs.getString("leave_type"));

                Employee created_by = new Employee();
                created_by.setId(rs.getInt("created_by"));
                created_by.setName(rs.getString("created_name"));
                rfl.setCreated_by(created_by);

                int processed_by_id = rs.getInt("processed_by");
                if (processed_by_id != 0) {
                    Employee processed_by = new Employee();
                    processed_by.setId(rs.getInt("processed_by"));
                    processed_by.setName(rs.getString("processed_name"));
                    rfl.setProcessed_by(processed_by);
                }
                rfls.add(rfl);
            }
        } catch (SQLException ex) {
            Logger.getLogger(RequestForLeaveDBContex.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return rfls;
    }

    // Lấy tất cả requests của một phòng ban (division)
    public ArrayList<RequestForLeave> getByDivision(int divisionId) {
        ArrayList<RequestForLeave> rfls = new ArrayList<>();
        try {
            String sql =
                    "SELECT " +
                    "      r.[rid] " +
                    "    , r.[created_by] " +
                    "    , e.ename as [created_name] " +
                    "    , r.[created_time] " +
                    "    , r.[from] " +
                    "    , r.[to] " +
                    "    , r.[reason] " +
                    "    , r.[status] " +
                    "    , r.[leave_type] " +
                    "    , r.[processed_by] " +
                    "    , p.ename as [processed_name] " +
                    "FROM [RequestForLeave] r " +
                    "INNER JOIN Employee e ON e.eid = r.created_by " +
                    "LEFT JOIN Employee p ON p.eid = r.processed_by " +
                    "WHERE e.did = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, divisionId);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                RequestForLeave rfl = new RequestForLeave();
                rfl.setId(rs.getInt("rid"));
                rfl.setCreated_time(rs.getTimestamp("created_time"));
                rfl.setFrom(rs.getDate("from"));
                rfl.setTo(rs.getDate("to"));
                rfl.setReason(rs.getString("reason"));
                rfl.setStatus(rs.getInt("status"));
                rfl.setLeaveType(rs.getString("leave_type"));

                Employee created_by = new Employee();
                created_by.setId(rs.getInt("created_by"));
                created_by.setName(rs.getString("created_name"));
                rfl.setCreated_by(created_by);

                int processed_by_id = rs.getInt("processed_by");
                if (processed_by_id != 0) {
                    Employee processed_by = new Employee();
                    processed_by.setId(rs.getInt("processed_by"));
                    processed_by.setName(rs.getString("processed_name"));
                    rfl.setProcessed_by(processed_by);
                }
                rfls.add(rfl);
            }
        } catch (SQLException ex) {
            Logger.getLogger(RequestForLeaveDBContex.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return rfls;
    }

    @Override
    public ArrayList<RequestForLeave> list() {
        ArrayList<RequestForLeave> rfls = new ArrayList<>();
        try {
            String sql =
                    "SELECT " +
                    "      r.[rid] " +
                    "    , r.[created_by] " +
                    "    , e_created.ename as [created_name] " +
                    "    , r.[created_time] " +
                    "    , r.[from] " +
                    "    , r.[to] " +
                    "    , r.[reason] " +
                    "    , r.[status] " +
                    "    , r.[leave_type] " +
                    "    , r.[processed_by] " +
                    "    , e_processed.ename as [processed_name] " +
                    "FROM [RequestForLeave] r " +
                    "INNER JOIN Employee e_created ON e_created.eid = r.created_by " +
                    "LEFT JOIN Employee e_processed ON e_processed.eid = r.processed_by " +
                    "ORDER BY r.created_time DESC";
            PreparedStatement stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                RequestForLeave rfl = new RequestForLeave();
                rfl.setId(rs.getInt("rid"));
                rfl.setCreated_time(rs.getTimestamp("created_time"));
                rfl.setFrom(rs.getDate("from"));
                rfl.setTo(rs.getDate("to"));
                rfl.setReason(rs.getString("reason"));
                rfl.setStatus(rs.getInt("status"));
                rfl.setLeaveType(rs.getString("leave_type"));

                Employee created_by = new Employee();
                created_by.setId(rs.getInt("created_by"));
                created_by.setName(rs.getString("created_name"));
                rfl.setCreated_by(created_by);

                if (rs.getObject("processed_by") != null) {
                    Employee processed_by = new Employee();
                    processed_by.setId(rs.getInt("processed_by"));
                    processed_by.setName(rs.getString("processed_name"));
                    rfl.setProcessed_by(processed_by);
                }
                rfls.add(rfl);
            }
        } catch (SQLException ex) {
            Logger.getLogger(RequestForLeaveDBContex.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return rfls;
    }

    @Override
    public RequestForLeave get(int id) {
        try {
            String sql =
                    "SELECT " +
                    "      r.[rid] " +
                    "    , r.[created_by] " +
                    "    , e_created.ename as [created_name] " +
                    "    , r.[created_time] " +
                    "    , r.[from] " +
                    "    , r.[to] " +
                    "    , r.[reason] " +
                    "    , r.[status] " +
                    "    , r.[leave_type] " +
                    "    , r.[processed_by] " +
                    "    , e_processed.ename as [processed_name] " +
                    "FROM [RequestForLeave] r " +
                    "INNER JOIN Employee e_created ON e_created.eid = r.created_by " +
                    "LEFT JOIN Employee e_processed ON e_processed.eid = r.processed_by " +
                    "WHERE r.rid = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                RequestForLeave rfl = new RequestForLeave();
                rfl.setId(rs.getInt("rid"));
                rfl.setCreated_time(rs.getTimestamp("created_time"));
                rfl.setFrom(rs.getDate("from"));
                rfl.setTo(rs.getDate("to"));
                rfl.setReason(rs.getString("reason"));
                rfl.setStatus(rs.getInt("status"));
                rfl.setLeaveType(rs.getString("leave_type"));

                // Lấy đối tượng Employee đầy đủ
                Employee created_by = new Employee();
                created_by.setId(rs.getInt("created_by"));
                created_by.setName(rs.getString("created_name"));
                rfl.setCreated_by(created_by);

                if (rs.getObject("processed_by") != null) {
                    Employee processed_by = new Employee();
                    processed_by.setId(rs.getInt("processed_by"));
                    processed_by.setName(rs.getString("processed_name"));
                    rfl.setProcessed_by(processed_by);
                }
                return rfl;
            }
        } catch (SQLException ex) {
            Logger.getLogger(RequestForLeaveDBContex.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return null;
    }

    @Override
    public void insert(RequestForLeave model) {
        PreparedStatement stm = null;
        try {
            String sql =
                    "INSERT INTO [RequestForLeave] ([created_by], [created_time], [from], [to], [reason], [status], [leave_type]) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";
            // Use RETURN_GENERATED_KEYS to get the auto-generated ID
            stm = connection.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS);
            stm.setInt(1, model.getCreated_by().getId());
            stm.setTimestamp(2, new java.sql.Timestamp(model.getCreated_time().getTime()));
            stm.setDate(3, model.getFrom());
            stm.setDate(4, model.getTo());
            stm.setString(5, model.getReason());
            stm.setInt(6, model.getStatus());
            stm.setString(7, model.getLeaveType() != null ? model.getLeaveType() : "annual");

            int rowsAffected = stm.executeUpdate();
            if (rowsAffected > 0) {
                // Get the generated ID and set it to the model
                java.sql.ResultSet generatedKeys = stm.getGeneratedKeys();
                if (generatedKeys.next()) {
                    model.setId(generatedKeys.getInt(1));
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(RequestForLeaveDBContex.class.getName()).log(Level.SEVERE, null, ex);
            throw new RuntimeException("Failed to insert request: " + ex.getMessage(), ex);
        } finally {
            if (stm != null) {
                try {
                    stm.close();
                } catch (SQLException ex) {
                    Logger.getLogger(RequestForLeaveDBContex.class.getName()).log(Level.WARNING, null, ex);
                }
            }
            closeConnection();
        }
    }

    @Override
    public void update(RequestForLeave model) {
        try {
            String sql =
                    "UPDATE [RequestForLeave] SET [status] = ?, [processed_by] = ? WHERE [rid] = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, model.getStatus());

            if (model.getProcessed_by() != null) {
                stm.setInt(2, model.getProcessed_by().getId());
            } else {
                stm.setNull(2, java.sql.Types.INTEGER);
            }

            stm.setInt(3, model.getId());

            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(RequestForLeaveDBContex.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
    }

    @Override
    public void delete(RequestForLeave model) {
        try {
            String sql = "DELETE FROM [RequestForLeave] WHERE [rid] = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, model.getId());

            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(RequestForLeaveDBContex.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
    }
    // Phương thức bổ sung để approve/reject request

    public void approveRequest(int rid, int processedBy) throws SQLException {
        PreparedStatement stm = null;
        try {
            String sql =
                    "UPDATE [RequestForLeave] SET [status] = 1, [processed_by] = ? WHERE [rid] = ?";
            stm = connection.prepareStatement(sql);
            stm.setInt(1, processedBy);
            stm.setInt(2, rid);

            int rowsAffected = stm.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("No rows updated. Request may not exist or already processed.");
            }
        } catch (SQLException ex) {
            Logger.getLogger(RequestForLeaveDBContex.class.getName()).log(Level.SEVERE, "Error approving request", ex);
            throw ex; // Re-throw để controller có thể xử lý
        } finally {
            if (stm != null) {
                try {
                    stm.close();
                } catch (SQLException ex) {
                    Logger.getLogger(RequestForLeaveDBContex.class.getName()).log(Level.WARNING, null, ex);
                }
            }
            closeConnection();
        }
    }

    public void rejectRequest(int rid, int processedBy) throws SQLException {
        PreparedStatement stm = null;
        try {
            String sql =
                    "UPDATE [RequestForLeave] SET [status] = 2, [processed_by] = ? WHERE [rid] = ?";
            stm = connection.prepareStatement(sql);
            stm.setInt(1, processedBy);
            stm.setInt(2, rid);

            int rowsAffected = stm.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("No rows updated. Request may not exist or already processed.");
            }
        } catch (SQLException ex) {
            Logger.getLogger(RequestForLeaveDBContex.class.getName()).log(Level.SEVERE, "Error rejecting request", ex);
            throw ex; // Re-throw để controller có thể xử lý
        } finally {
            if (stm != null) {
                try {
                    stm.close();
                } catch (SQLException ex) {
                    Logger.getLogger(RequestForLeaveDBContex.class.getName()).log(Level.WARNING, null, ex);
                }
            }
            closeConnection();
        }
    }

// Phương thức lấy requests theo status
    public ArrayList<RequestForLeave> getByStatus(int status) {
        ArrayList<RequestForLeave> rfls = new ArrayList<>();
        try {
            String sql =
                    "SELECT " +
                    "    r.[rid], r.[created_by], e_created.ename as [created_name], r.[created_time], " +
                    "    r.[from], r.[to], r.[reason], r.[status], r.[leave_type], r.[processed_by], e_processed.ename as [processed_name] " +
                    "FROM [RequestForLeave] r " +
                    "INNER JOIN Employee e_created ON e_created.eid = r.created_by " +
                    "LEFT JOIN Employee e_processed ON e_processed.eid = r.processed_by " +
                    "WHERE r.[status] = ? ORDER BY r.created_time DESC";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, status);
            ResultSet rs = stm.executeQuery();

            while (rs.next()) {
                RequestForLeave rfl = new RequestForLeave();
                rfl.setId(rs.getInt("rid"));
                rfl.setCreated_time(rs.getTimestamp("created_time"));
                rfl.setFrom(rs.getDate("from"));
                rfl.setTo(rs.getDate("to"));
                rfl.setReason(rs.getString("reason"));
                rfl.setStatus(rs.getInt("status"));
                rfl.setLeaveType(rs.getString("leave_type"));

                Employee created_by = new Employee();
                created_by.setId(rs.getInt("created_by"));
                created_by.setName(rs.getString("created_name"));
                rfl.setCreated_by(created_by);

                if (rs.getObject("processed_by") != null) {
                    Employee processed_by = new Employee();
                    processed_by.setId(rs.getInt("processed_by"));
                    processed_by.setName(rs.getString("processed_name"));
                    rfl.setProcessed_by(processed_by);
                }

                rfls.add(rfl);
            }
        } catch (SQLException ex) {
            Logger.getLogger(RequestForLeaveDBContex.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return rfls;
    }

// Phương thức lấy requests của một employee cụ thể
    public ArrayList<RequestForLeave> getByEmployee(int employeeId) {
        ArrayList<RequestForLeave> rfls = new ArrayList<>();
        try {
            String sql =
                    "SELECT " +
                    "    r.[rid], r.[created_by], e_created.ename as [created_name], r.[created_time], " +
                    "    r.[from], r.[to], r.[reason], r.[status], r.[leave_type], r.[processed_by], e_processed.ename as [processed_name] " +
                    "FROM [RequestForLeave] r " +
                    "INNER JOIN Employee e_created ON e_created.eid = r.created_by " +
                    "LEFT JOIN Employee e_processed ON e_processed.eid = r.processed_by " +
                    "WHERE r.[created_by] = ? ORDER BY r.created_time DESC";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, employeeId);
            ResultSet rs = stm.executeQuery();

            while (rs.next()) {
                RequestForLeave rfl = new RequestForLeave();
                rfl.setId(rs.getInt("rid"));
                rfl.setCreated_time(rs.getTimestamp("created_time"));
                rfl.setFrom(rs.getDate("from"));
                rfl.setTo(rs.getDate("to"));
                rfl.setReason(rs.getString("reason"));
                rfl.setStatus(rs.getInt("status"));
                rfl.setLeaveType(rs.getString("leave_type"));

                Employee created_by = new Employee();
                created_by.setId(rs.getInt("created_by"));
                created_by.setName(rs.getString("created_name"));
                rfl.setCreated_by(created_by);

                if (rs.getObject("processed_by") != null) {
                    Employee processed_by = new Employee();
                    processed_by.setId(rs.getInt("processed_by"));
                    processed_by.setName(rs.getString("processed_name"));
                    rfl.setProcessed_by(processed_by);
                }

                rfls.add(rfl);
            }
            
        } catch (SQLException ex) {
            Logger.getLogger(RequestForLeaveDBContex.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return rfls;
    }
    

    /**
     * COUNT: Đếm tổng số requests của employee và subordinates
     */
    public int countByEmployeeAndSubodiaries(int eid) {
        PreparedStatement stm = null;
        ResultSet rs = null;
        try {
            String sql =
                    "WITH Org AS (" +
                    "    SELECT *, 0 as lvl FROM Employee e WHERE e.eid = ? " +
                    "    UNION ALL " +
                    "    SELECT c.*, o.lvl + 1 as lvl FROM Employee c JOIN Org o ON c.supervisorid = o.eid " +
                    ") " +
                    "SELECT COUNT(*) as total " +
                    "FROM Org e INNER JOIN [RequestForLeave] r ON e.eid = r.created_by";
            stm = connection.prepareStatement(sql);
            stm.setInt(1, eid);
            rs = stm.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException ex) {
            Logger.getLogger(RequestForLeaveDBContex.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            // Đóng ResultSet và PreparedStatement
            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException ex) {
                    Logger.getLogger(RequestForLeaveDBContex.class.getName()).log(Level.WARNING, null, ex);
                }
            }
            if (stm != null) {
                try {
                    stm.close();
                } catch (SQLException ex) {
                    Logger.getLogger(RequestForLeaveDBContex.class.getName()).log(Level.WARNING, null, ex);
                }
            }
            // KHÔNG đóng connection ở đây - để dùng lại cho method tiếp theo
        }
        return 0;
    }

    /**
     * Lấy requests của employee và subordinates với pagination (SQL Server)
     * @param eid Employee ID
     * @param offset Số records bỏ qua
     * @param fetch Số records lấy về
     */
    public ArrayList<RequestForLeave> getByEmployeeAndSubodiariesPaginated(int eid, int offset, int fetch) {
        ArrayList<RequestForLeave> rfls = new ArrayList<>();
        PreparedStatement stm = null;
        ResultSet rs = null;
        try {
            String sql =
                    "WITH Org AS (" +
                    "    SELECT *, 0 as lvl FROM Employee e WHERE e.eid = ? " +
                    "    UNION ALL " +
                    "    SELECT c.*, o.lvl + 1 as lvl FROM Employee c JOIN Org o ON c.supervisorid = o.eid " +
                    ") " +
                    "SELECT " +
                    "      r.[rid] " +
                    "    , r.[created_by] " +
                    "    , e.ename as [created_name] " +
                    "    , r.[created_time] " +
                    "    , r.[from] " +
                    "    , r.[to] " +
                    "    , r.[reason] " +
                    "    , r.[status] " +
                    "    , r.[leave_type] " +
                    "    , r.[processed_by] " +
                    "    , p.ename as [processed_name] " +
                    "FROM Org e INNER JOIN [RequestForLeave] r ON e.eid = r.created_by " +
                    "LEFT JOIN Employee p ON p.eid = r.processed_by " +
                    "ORDER BY r.created_time DESC " +
                    "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
            stm = connection.prepareStatement(sql);
            stm.setInt(1, eid);
            stm.setInt(2, offset);
            stm.setInt(3, fetch);
            rs = stm.executeQuery();
            while (rs.next()) {
                RequestForLeave rfl = new RequestForLeave();
                rfl.setId(rs.getInt("rid"));
                rfl.setCreated_time(rs.getTimestamp("created_time"));
                rfl.setFrom(rs.getDate("from"));
                rfl.setTo(rs.getDate("to"));
                rfl.setReason(rs.getString("reason"));
                rfl.setStatus(rs.getInt("status"));
                rfl.setLeaveType(rs.getString("leave_type"));

                Employee created_by = new Employee();
                created_by.setId(rs.getInt("created_by"));
                created_by.setName(rs.getString("created_name"));
                rfl.setCreated_by(created_by);

                // Fix: Xử lý processed_by đúng cách với NULL
                if (rs.getObject("processed_by") != null) {
                    int processed_by_id = rs.getInt("processed_by");
                    Employee processed_by = new Employee();
                    processed_by.setId(processed_by_id);
                    String processed_name = rs.getString("processed_name");
                    if (processed_name != null) {
                        processed_by.setName(processed_name);
                    }
                    rfl.setProcessed_by(processed_by);
                }
                rfls.add(rfl);
            }
        } catch (SQLException ex) {
            Logger.getLogger(RequestForLeaveDBContex.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            // Đóng ResultSet và PreparedStatement trước
            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException ex) {
                    Logger.getLogger(RequestForLeaveDBContex.class.getName()).log(Level.WARNING, null, ex);
                }
            }
            if (stm != null) {
                try {
                    stm.close();
                } catch (SQLException ex) {
                    Logger.getLogger(RequestForLeaveDBContex.class.getName()).log(Level.WARNING, null, ex);
                }
            }
            // KHÔNG đóng connection ở đây - để controller đóng sau khi dùng xong
        }
        return rfls;
    }
    
        /**
     * COUNT: Đếm tổng số requests theo status
     */
    public int countByStatus(int status) {
        PreparedStatement stm = null;
        ResultSet rs = null;
        try {
            String sql =
                    "SELECT COUNT(*) as total " +
                    "FROM [RequestForLeave] r " +
                    "WHERE r.[status] = ?";
            stm = connection.prepareStatement(sql);
            stm.setInt(1, status);
            rs = stm.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException ex) {
            Logger.getLogger(RequestForLeaveDBContex.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException ex) {
                    Logger.getLogger(RequestForLeaveDBContex.class.getName()).log(Level.WARNING, null, ex);
                }
            }
            if (stm != null) {
                try {
                    stm.close();
                } catch (SQLException ex) {
                    Logger.getLogger(RequestForLeaveDBContex.class.getName()).log(Level.WARNING, null, ex);
                }
            }
        }
        return 0;
    }

    /**
     * Lấy requests theo status với pagination (SQL Server) - cho IT Head
     * @param status Status code (0=pending, 1=approved, 2=rejected)
     * @param offset Số records bỏ qua
     * @param fetch Số records lấy về
     */
    public ArrayList<RequestForLeave> getByStatusPaginated(int status, int offset, int fetch) {
        ArrayList<RequestForLeave> rfls = new ArrayList<>();
        PreparedStatement stm = null;
        ResultSet rs = null;
        try {
            String sql =
                    "SELECT " +
                    "    r.[rid], r.[created_by], e_created.ename as [created_name], r.[created_time], " +
                    "    r.[from], r.[to], r.[reason], r.[status], r.[leave_type], r.[processed_by], e_processed.ename as [processed_name] " +
                    "FROM [RequestForLeave] r " +
                    "INNER JOIN Employee e_created ON e_created.eid = r.created_by " +
                    "LEFT JOIN Employee e_processed ON e_processed.eid = r.processed_by " +
                    "WHERE r.[status] = ? " +
                    "ORDER BY r.created_time DESC " +
                    "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
            stm = connection.prepareStatement(sql);
            stm.setInt(1, status);
            stm.setInt(2, offset);
            stm.setInt(3, fetch);
            rs = stm.executeQuery();

            while (rs.next()) {
                RequestForLeave rfl = new RequestForLeave();
                rfl.setId(rs.getInt("rid"));
                rfl.setCreated_time(rs.getTimestamp("created_time"));
                rfl.setFrom(rs.getDate("from"));
                rfl.setTo(rs.getDate("to"));
                rfl.setReason(rs.getString("reason"));
                rfl.setStatus(rs.getInt("status"));
                rfl.setLeaveType(rs.getString("leave_type"));

                Employee created_by = new Employee();
                created_by.setId(rs.getInt("created_by"));
                created_by.setName(rs.getString("created_name"));
                rfl.setCreated_by(created_by);

                if (rs.getObject("processed_by") != null) {
                    Employee processed_by = new Employee();
                    processed_by.setId(rs.getInt("processed_by"));
                    processed_by.setName(rs.getString("processed_name"));
                    rfl.setProcessed_by(processed_by);
                }

                rfls.add(rfl);
            }
        } catch (SQLException ex) {
            Logger.getLogger(RequestForLeaveDBContex.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException ex) {
                    Logger.getLogger(RequestForLeaveDBContex.class.getName()).log(Level.WARNING, null, ex);
                }
            }
            if (stm != null) {
                try {
                    stm.close();
                } catch (SQLException ex) {
                    Logger.getLogger(RequestForLeaveDBContex.class.getName()).log(Level.WARNING, null, ex);
                }
            }
        }
        return rfls;
    }

    /**
     * COUNT: Đếm số pending requests từ subordinates (không bao gồm của chính mình)
     */
    public int countPendingBySubordinates(int eid) {
        PreparedStatement stm = null;
        ResultSet rs = null;
        try {
            String sql =
                    "WITH Org AS (" +
                    "    SELECT *, 0 as lvl FROM Employee e WHERE e.eid = ? " +
                    "    UNION ALL " +
                    "    SELECT c.*, o.lvl + 1 as lvl FROM Employee c JOIN Org o ON c.supervisorid = o.eid " +
                    ") " +
                    "SELECT COUNT(*) as total " +
                    "FROM Org e INNER JOIN [RequestForLeave] r ON e.eid = r.created_by " +
                    "WHERE r.[status] = 0 AND r.[created_by] != ?";
            stm = connection.prepareStatement(sql);
            stm.setInt(1, eid);
            stm.setInt(2, eid);
            rs = stm.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException ex) {
            Logger.getLogger(RequestForLeaveDBContex.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException ex) {
                    Logger.getLogger(RequestForLeaveDBContex.class.getName()).log(Level.WARNING, null, ex);
                }
            }
            if (stm != null) {
                try {
                    stm.close();
                } catch (SQLException ex) {
                    Logger.getLogger(RequestForLeaveDBContex.class.getName()).log(Level.WARNING, null, ex);
                }
            }
        }
        return 0;
    }

    /**
     * Lấy pending requests từ subordinates với pagination (SQL Server) - không bao gồm của chính mình
     * @param eid Employee ID của supervisor
     * @param offset Số records bỏ qua
     * @param fetch Số records lấy về
     */
    public ArrayList<RequestForLeave> getPendingBySubordinatesPaginated(int eid, int offset, int fetch) {
        ArrayList<RequestForLeave> rfls = new ArrayList<>();
        PreparedStatement stm = null;
        ResultSet rs = null;
        try {
            String sql =
                    "WITH Org AS (" +
                    "    SELECT *, 0 as lvl FROM Employee e WHERE e.eid = ? " +
                    "    UNION ALL " +
                    "    SELECT c.*, o.lvl + 1 as lvl FROM Employee c JOIN Org o ON c.supervisorid = o.eid " +
                    ") " +
                    "SELECT " +
                    "      r.[rid] " +
                    "    , r.[created_by] " +
                    "    , e.ename as [created_name] " +
                    "    , r.[created_time] " +
                    "    , r.[from] " +
                    "    , r.[to] " +
                    "    , r.[reason] " +
                    "    , r.[status] " +
                    "    , r.[leave_type] " +
                    "    , r.[processed_by] " +
                    "    , p.ename as [processed_name] " +
                    "FROM Org e INNER JOIN [RequestForLeave] r ON e.eid = r.created_by " +
                    "LEFT JOIN Employee p ON p.eid = r.processed_by " +
                    "WHERE r.[status] = 0 AND r.[created_by] != ? " +
                    "ORDER BY r.created_time DESC " +
                    "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
            stm = connection.prepareStatement(sql);
            stm.setInt(1, eid);
            stm.setInt(2, eid);
            stm.setInt(3, offset);
            stm.setInt(4, fetch);
            rs = stm.executeQuery();
            while (rs.next()) {
                RequestForLeave rfl = new RequestForLeave();
                rfl.setId(rs.getInt("rid"));
                rfl.setCreated_time(rs.getTimestamp("created_time"));
                rfl.setFrom(rs.getDate("from"));
                rfl.setTo(rs.getDate("to"));
                rfl.setReason(rs.getString("reason"));
                rfl.setStatus(rs.getInt("status"));
                rfl.setLeaveType(rs.getString("leave_type"));

                Employee created_by = new Employee();
                created_by.setId(rs.getInt("created_by"));
                created_by.setName(rs.getString("created_name"));
                rfl.setCreated_by(created_by);

                if (rs.getObject("processed_by") != null) {
                    Employee processed_by = new Employee();
                    processed_by.setId(rs.getInt("processed_by"));
                    processed_by.setName(rs.getString("processed_name"));
                    rfl.setProcessed_by(processed_by);
                }
                rfls.add(rfl);
            }
        } catch (SQLException ex) {
            Logger.getLogger(RequestForLeaveDBContex.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException ex) {
                    Logger.getLogger(RequestForLeaveDBContex.class.getName()).log(Level.WARNING, null, ex);
                }
            }
            if (stm != null) {
                try {
                    stm.close();
                } catch (SQLException ex) {
                    Logger.getLogger(RequestForLeaveDBContex.class.getName()).log(Level.WARNING, null, ex);
                }
            }
        }
        return rfls;
    }

    
    /**
     * Đóng connection - gọi từ controller sau khi hoàn thành tất cả operations
     */
    public void closeDBConnection() {
        closeConnection();
    }

}

