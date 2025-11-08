/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.leave;

import java.sql.Timestamp;
import model.core.Employee;
import java.util.Date;
import model.BaseModel;

/**
 *
 * @author MWG
 */
public class RequestForLeave extends BaseModel {

    private Employee created_by;
    private java.sql.Timestamp created_time;
    private java.sql.Date from;
    private java.sql.Date to;
    private String reason;
    private int status;
    private Employee processed_by;
    private String leaveType;
    private String cancelNote;

    public Employee getCreated_by() {
        return created_by;
    }

    public void setCreated_by(Employee created_by) {
        this.created_by = created_by;
    }

    public Date getCreated_time() {
        return created_time;
    }

    public void setCreated_time(Timestamp created_time) {
        this.created_time = created_time;
    }

    public java.sql.Date getFrom() {
        return from;
    }

    public void setFrom(java.sql.Date from) {
        this.from = from;
    }

    public java.sql.Date getTo() {
        return to;
    }

    public void setTo(java.sql.Date to) {
        this.to = to;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public Employee getProcessed_by() {
        return processed_by;
    }

    public void setProcessed_by(Employee processed_by) {
        this.processed_by = processed_by;
    }

    public boolean isValidDateRange() {
        return from != null && to != null && !from.after(to);
    }

    public boolean isPending() {
        return status == 0;
    }

    public boolean isApproved() {
        return status == 1;
    }

    public boolean isRejected() {
        return status == 2;
    }
    // Thêm vào RequestForLeave.java sau method isRejected()

    public boolean isCancelled() {
        return status == 3;
    }

    public boolean isOwnedBy(int employeeId) {
        return created_by != null && created_by.getId() == employeeId;
    }

    public boolean canBeCancelled(int currentEmployeeId, boolean isITHead, dal.EmployeeDBContext empDB) {
        // 1. Thằng A (IT Head): Có thể hủy toàn bộ (trừ cancelled và rejected)
        if (isITHead) {
            return !isCancelled() && !isRejected();
        }
        
        // 2. Đã bị hủy hoặc từ chối thì không thể hủy
        if (isCancelled() || isRejected()) {
            return false;
        }
        
        // 3. Kiểm tra trạng thái đơn
        if (isPending()) {
            // In progress: Chỉ owner mới hủy được
            return isOwnedBy(currentEmployeeId);
        }
        
        if (isApproved()) {
            // Approved: Chỉ supervisor trực tiếp mới hủy được
            if (isOwnedBy(currentEmployeeId)) {
                // Owner không thể hủy đơn đã approved của chính mình
                return false;
            }
            
            // Kiểm tra xem currentEmployee có phải supervisor của owner không
            if (created_by != null && empDB != null) {
                return empDB.isSupervisorOf(currentEmployeeId, created_by.getId());
            }
            return false;
        }
        
        return false;
    }
    
    // Overload method để tương thích với code cũ (không dùng empDB)
    public boolean canBeCancelled(int currentEmployeeId, boolean isITHead) {
        return canBeCancelled(currentEmployeeId, isITHead, null);
    }

    public String getLeaveType() {
        return leaveType;
    }

    public void setLeaveType(String leaveType) {
        this.leaveType = leaveType;
    }

    public String getLeaveTypeDisplayName() {
        if (leaveType == null || leaveType.isEmpty()) {
            return "Nghỉ phép năm";
        }
        switch (leaveType.toLowerCase()) {
            case "annual":
                return "Nghỉ phép năm";
            case "sick":
                return "Nghỉ ốm";
            case "personal":
                return "Việc riêng";
            case "unpaid":
                return "Nghỉ không lương";
            case "maternity":
                return "Nghỉ thai sản";
            case "paternity":
                return "Nghỉ chăm sóc con";
            case "other":
                return "Khác";
            default:
                return "Nghỉ phép năm";
        }
    }

    public String getCancelNote() {
        return cancelNote;
    }

    public void setCancelNote(String cancelNote) {
        this.cancelNote = cancelNote;
    }

}
