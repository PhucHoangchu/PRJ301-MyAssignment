<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.leave.RequestForLeave" %>
<%@page import="java.util.ArrayList" %>
<%@page import="util.Pagination" %>
<%@page import="model.iam.User" %>
<%@page import="dal.RoleDBContext" %>
<%@page import="dal.EmployeeDBContext" %>
<jsp:include page="../util/header.jsp" />

<!-- Page Header -->
<div class="page-header" style="margin-bottom: 32px;">
    <div style="display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 16px;">
        <div>
            <h1 style="font-size: 2rem; font-weight: 700; color: var(--text-primary); margin: 0 0 8px 0; display: flex; align-items: center; gap: 12px;">
                <i class="fas fa-list-alt" style="color: #667eea;"></i>
                My Leave Requests
            </h1>
            <p style="color: var(--text-secondary); margin: 0;">View and manage all your leave requests</p>
        </div>
        <div style="display: flex; gap: 12px;">
            <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary">
                <i class="fas fa-home"></i>
                Back to Home
            </a>
            <a href="${pageContext.request.contextPath}/request/create" class="btn btn-primary">
                <i class="fas fa-plus-circle"></i>
                Create New Request
            </a>
        </div>
    </div>
</div>
<!-- Success/Error Messages -->
<% 
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");
    if (successMessage != null) {
        session.removeAttribute("successMessage");
%>
<div class="alert alert-success" style="margin-bottom: 24px; padding: 12px 16px; background: #d1fae5; color: #065f46; border-radius: 8px; border-left: 4px solid #10b981; display: flex; align-items: center; gap: 12px;">
    <i class="fas fa-check-circle"></i>
    <span><%= successMessage %></span>
</div>
<% 
    }
    if (errorMessage != null) {
        session.removeAttribute("errorMessage");
%>
<div class="alert alert-error" style="margin-bottom: 24px; padding: 12px 16px; background: #fee2e2; color: #991b1b; border-radius: 8px; border-left: 4px solid #ef4444; display: flex; align-items: center; gap: 12px;">
    <i class="fas fa-exclamation-circle"></i>
    <span><%= errorMessage %></span>
</div>
<% 
    }
%>
<!-- Requests Table Card -->
<div class="card">
    <div class="card-header">
        <h3 class="card-title">
            <i class="fas fa-table"></i>
            All Requests
        </h3>
    </div>
    <div class="card-body">
        <% 
        ArrayList<RequestForLeave> rfls = (ArrayList<RequestForLeave>) request.getAttribute("rfls");
        if (rfls == null || rfls.isEmpty()) {
        %>
        <div class="empty-state">
            <i class="fas fa-inbox empty-state-icon"></i>
            <h4 class="empty-state-title">No requests found</h4>
            <p class="empty-state-message">You haven't created any leave requests yet.</p>
            <a href="${pageContext.request.contextPath}/request/create" class="btn btn-primary">
                <i class="fas fa-plus-circle"></i>
                Create Your First Request
            </a>
        </div>
        <% } else { %>
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th><i class="fas fa-user"></i> Created By</th>
                        <th><i class="fas fa-tags"></i> Loại nghỉ phép</th>
                        <th><i class="fas fa-calendar-alt"></i> From</th>
                        <th><i class="fas fa-calendar-check"></i> To</th>
                        <th><i class="fas fa-comment"></i> Reason</th>
                        <th><i class="fas fa-info-circle"></i> Status</th>
                        <th><i class="fas fa-clock"></i> Created</th>
                        <th><i class="fas fa-user-check"></i> Processed By</th>
                        <th><i class="fas fa-cog"></i> Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    for (RequestForLeave rfl : rfls) {
                        String statusClass = "";
                        String statusText = "";
                        String statusIcon = "";
                        switch (rfl.getStatus()) {
                            case 0: 
                                statusClass = "status-pending"; 
                                statusText = "In progress"; 
                                statusIcon = "fas fa-clock";
                                break;
                            case 1: 
                                statusClass = "status-approved"; 
                                statusText = "Approved"; 
                                statusIcon = "fas fa-check-circle";
                                break;
                            case 2: 
                                statusClass = "status-rejected"; 
                                statusText = "Rejected"; 
                                statusIcon = "fas fa-times-circle";
                                break;
                            case 3: 
                                statusClass = "status-cancelled"; 
                                statusText = "Cancelled"; 
                                statusIcon = "fas fa-ban";
break;     
                                    
                        }
                    %>
                    <tr>
                        <td>
                            <div style="display: flex; align-items: center; gap: 8px;">
                                <i class="fas fa-user-circle" style="color: var(--primary-color);"></i>
                                <strong><%= rfl.getCreated_by() != null && rfl.getCreated_by().getName() != null ? rfl.getCreated_by().getName() : "N/A" %></strong>
                            </div>
                        </td>
                        <td>
                            <% 
                            String leaveType = rfl.getLeaveType();
                            String leaveTypeDisplay = "";
                            String leaveTypeIcon = "";
                            String leaveTypeColor = "";
                                
                            if (leaveType == null || leaveType.isEmpty()) leaveType = "annual";
                                
                            switch (leaveType.toLowerCase()) {
                                case "annual":
                                    leaveTypeDisplay = "Nghỉ phép năm";
                                    leaveTypeIcon = "🏖️";
                                    leaveTypeColor = "#06b6d4";
                                    break;
                                case "sick":
                                    leaveTypeDisplay = "Nghỉ ốm";
                                    leaveTypeIcon = "🏥";
                                    leaveTypeColor = "#ef4444";
                                    break;
                                case "personal":
                                    leaveTypeDisplay = "Việc riêng";
                                    leaveTypeIcon = "👤";
                                    leaveTypeColor = "#8b5cf6";
                                    break;
                                case "unpaid":
                                    leaveTypeDisplay = "Nghỉ không lương";
                                    leaveTypeIcon = "💼";
                                    leaveTypeColor = "#6b7280";
                                    break;
                                case "maternity":
                                    leaveTypeDisplay = "Nghỉ thai sản";
                                    leaveTypeIcon = "👶";
                                    leaveTypeColor = "#ec4899";
                                    break;
                                case "paternity":
                                    leaveTypeDisplay = "Nghỉ chăm sóc con";
                                    leaveTypeIcon = "👨‍👩‍👦";
                                    leaveTypeColor = "#3b82f6";
                                    break;
                                default:
                                    leaveTypeDisplay = "Khác";
                                    leaveTypeIcon = "📝";
                                    leaveTypeColor = "#94a3b8";
                            }
                            %>
                            <span style="display: inline-flex; align-items: center; gap: 6px; padding: 6px 12px; background: <%= leaveTypeColor %>15; color: <%= leaveTypeColor %>; border-radius: 20px; font-size: 0.85rem; font-weight: 500;">
                                <span style="font-size: 1rem;"><%= leaveTypeIcon %></span>
                                <%= leaveTypeDisplay %>
                            </span>
                        </td>
                        <td>
                            <span style="display: inline-flex; align-items: center; gap: 6px;">
                                <i class="fas fa-calendar-alt" style="color: var(--text-secondary); font-size: 0.9rem;"></i>
                                <%= rfl.getFrom() %>
                            </span>
                        </td>
                        <td>
                            <span style="display: inline-flex; align-items: center; gap: 6px;">
                                <i class="fas fa-calendar-check" style="color: var(--text-secondary); font-size: 0.9rem;"></i>
                                <%= rfl.getTo() %>
                            </span>
                        </td>
                        <td>
                            <div style="max-width: 300px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;" title="<%= rfl.getReason() != null ? rfl.getReason().replace("\"", "&quot;") : "" %>">
                                <%= rfl.getReason() != null && rfl.getReason().length() > 50 ? rfl.getReason().substring(0, 50) + "..." : (rfl.getReason() != null ? rfl.getReason() : "-") %>
                            </div>
                        </td>
                        <td>
                            <span class="status-badge <%= statusClass %>" 
                                  <% if (rfl.getStatus() == 3 && rfl.getCancelNote() != null && !rfl.getCancelNote().trim().isEmpty()) { %>
                                  title="Nhấn vào 'Chi tiết' để xem lý do hủy đơn"
                                  <% } %>>
                                <i class="<%= statusIcon %>"></i>
                                <%= statusText %>
                            </span>
                        </td>
                        <td>
                            <span style="display: inline-flex; align-items: center; gap: 6px; color: var(--text-secondary); font-size: 0.9rem;">
                                <i class="fas fa-clock"></i>
                                <%= rfl.getCreated_time() != null ? new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(rfl.getCreated_time()) : "-" %>
                            </span>
                        </td>
                        <td>
                            <% if (rfl.getProcessed_by() != null && rfl.getProcessed_by().getName() != null) { %>
                            <div style="display: flex; align-items: center; gap: 6px;">
                                <i class="fas fa-user-check" style="color: var(--success-color);"></i>
                                <span><%= rfl.getProcessed_by().getName() %></span>
                            </div>
                            <% } else { %>
                            <span style="color: var(--text-muted);">-</span>
                            <% } %>
                        </td>
                        <td>
                            <% 
                            User currentUser = (User) session.getAttribute("auth");
                            boolean isITHead = false;
                            int currentEmployeeId = 0;

                            if (currentUser != null) {
                                RoleDBContext roleDB = new RoleDBContext();
                                isITHead = roleDB.hasRole(currentUser.getId(), "IT Head");
                                if (currentUser.getEmployee() != null) {
                                    currentEmployeeId = currentUser.getEmployee().getId();
                                }
                            }

                            EmployeeDBContext empDB = new EmployeeDBContext();
                            boolean canCancel = rfl.canBeCancelled(currentEmployeeId, isITHead, empDB);
                            %>
                            <div style="display: flex; gap: 8px; align-items: center; flex-wrap: wrap;">
                                <a href="${pageContext.request.contextPath}/request/view?rid=<%= rfl.getId() %>" 
                                   class="btn btn-secondary btn-sm" 
                                   style="padding: 6px 12px; font-size: 0.85rem; background: #6b7280; color: white; border: none; border-radius: 6px; cursor: pointer; display: inline-flex; align-items: center; gap: 6px; text-decoration: none;">
                                    <i class="fas fa-eye"></i> Chi tiết
                                </a>
                                <% if (canCancel) { %>
                                <button type="button" onclick="openCancelModal(<%= rfl.getId() %>)" 
                                        class="btn btn-danger btn-sm" 
                                        style="padding: 6px 12px; font-size: 0.85rem; background: #ef4444; color: white; border: none; border-radius: 6px; cursor: pointer; display: inline-flex; align-items: center; gap: 6px;">
                                    <i class="fas fa-times"></i> Hủy
                                </button>
                                <% } %>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Pagination Controls -->
    <% 
    Pagination pagination = (Pagination) request.getAttribute("pagination");
    if (pagination != null && pagination.getTotalPages() > 1) {
    %>
    <div class="pagination-container" style="margin-top: 24px; padding-top: 20px; border-top: 1px solid var(--border-color);">
        <div style="display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 16px;">
            <div style="color: var(--text-secondary); font-size: 0.9rem;">
                Showing <strong><%= pagination.getStartRecord() %></strong> to 
                <strong><%= pagination.getEndRecord() %></strong> of 
                <strong><%= pagination.getTotalRecords() %></strong> requests
            </div>
            <div class="pagination" style="display: flex; align-items: center; gap: 8px;">
                <% if (pagination.hasPrevious()) { %>
                <a href="${pageContext.request.contextPath}/request/list?page=<%= pagination.getCurrentPage() - 1 %>" 
                   class="pagination-btn" title="Previous">
                    <i class="fas fa-chevron-left"></i>
                </a>
                <% } else { %>
                <span class="pagination-btn disabled" title="Previous">
                    <i class="fas fa-chevron-left"></i>
                </span>
                <% } %>

                <% 
                int startPage = Math.max(1, pagination.getCurrentPage() - 2);
                int endPage = Math.min(pagination.getTotalPages(), pagination.getCurrentPage() + 2);
                        
                if (startPage > 1) {
                %>
                <a href="${pageContext.request.contextPath}/request/list?page=1" class="pagination-btn">1</a>
                <% if (startPage > 2) { %>
                <span class="pagination-ellipsis">...</span>
                <% } %>
                <% } %>

                <% for (int i = startPage; i <= endPage; i++) { %>
                <% if (i == pagination.getCurrentPage()) { %>
                <span class="pagination-btn active"><%= i %></span>
                <% } else { %>
                <a href="${pageContext.request.contextPath}/request/list?page=<%= i %>" class="pagination-btn"><%= i %></a>
                <% } %>
                <% } %>

                <% if (endPage < pagination.getTotalPages()) { %>
                <% if (endPage < pagination.getTotalPages() - 1) { %>
                <span class="pagination-ellipsis">...</span>
                <% } %>
                <a href="${pageContext.request.contextPath}/request/list?page=<%= pagination.getTotalPages() %>" class="pagination-btn"><%= pagination.getTotalPages() %></a>
                <% } %>

                <% if (pagination.hasNext()) { %>
                <a href="${pageContext.request.contextPath}/request/list?page=<%= pagination.getCurrentPage() + 1 %>" 
                   class="pagination-btn" title="Next">
                    <i class="fas fa-chevron-right"></i>
                </a>
                <% } else { %>
                <span class="pagination-btn disabled" title="Next">
                    <i class="fas fa-chevron-right"></i>
                </span>
                <% } %>
            </div>
        </div>
    </div>
    <% } %>

    <!-- Summary Info -->

    <!-- Summary Info -->
    <div style="margin-top: 24px; padding-top: 20px; border-top: 1px solid var(--border-color); display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 16px;">
        <div style="display: flex; align-items: center; gap: 8px; color: var(--text-secondary);">
            <i class="fas fa-info-circle"></i>
            <span>Total: <strong style="color: var(--text-primary);"><%= rfls.size() %></strong> request(s)</span>
        </div>
        <div style="display: flex; gap: 16px; flex-wrap: wrap;">
            <% 
            int pendingCount = 0, approvedCount = 0, rejectedCount = 0;
            for (RequestForLeave r : rfls) {
                if (r.getStatus() == 0) pendingCount++;
                else if (r.getStatus() == 1) approvedCount++;
                else if (r.getStatus() == 2) rejectedCount++;
            }
            %>
            <span style="display: inline-flex; align-items: center; gap: 6px; padding: 6px 12px; background: #fef3c7; color: #92400e; border-radius: 20px; font-size: 0.9rem;">
                <i class="fas fa-clock"></i> In progress: <strong><%= pendingCount %></strong>
            </span>
            <span style="display: inline-flex; align-items: center; gap: 6px; padding: 6px 12px; background: #d1fae5; color: #065f46; border-radius: 20px; font-size: 0.9rem;">
                <i class="fas fa-check-circle"></i> Approved: <strong><%= approvedCount %></strong>
            </span>
            <span style="display: inline-flex; align-items: center; gap: 6px; padding: 6px 12px; background: #fee2e2; color: #991b1b; border-radius: 20px; font-size: 0.9rem;">
                <i class="fas fa-times-circle"></i> Rejected: <strong><%= rejectedCount %></strong>
            </span>
        </div>
    </div>
    <% } %>
</div>
</div>

<!-- Modal Hủy Đơn -->
<div id="cancelModal" class="modal" style="display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.5);">
    <div class="modal-content" style="background-color: white; margin: 15% auto; padding: 24px; border-radius: 12px; width: 90%; max-width: 500px; box-shadow: 0 8px 16px rgba(0,0,0,0.2);">
        <h3 style="margin-top: 0; margin-bottom: 20px; color: #ef4444; display: flex; align-items: center; gap: 10px;">
            <i class="fas fa-exclamation-triangle"></i> Xác nhận hủy đơn
        </h3>
        <form id="cancelForm" method="POST" action="${pageContext.request.contextPath}/request/cancel">
            <input type="hidden" name="rid" id="cancelRid">
            <div style="margin-bottom: 20px;">
                <label style="display: block; margin-bottom: 8px; font-weight: 600; color: var(--text-primary);">
                    Lý do hủy đơn <span style="color: #ef4444;">*</span>
                </label>
                <textarea name="cancelNote" id="cancelNote" 
                    required 
                    rows="4" 
                    style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px; font-family: inherit; resize: vertical; font-size: 0.95rem;"
                    placeholder="Vui lòng nhập lý do hủy đơn nghỉ phép này..."></textarea>
                <small style="color: var(--text-secondary); font-size: 0.85rem; display: block; margin-top: 6px;">
                    Ghi chú này sẽ được lưu lại và hiển thị trong lịch sử đơn.
                </small>
            </div>
            <div style="display: flex; gap: 12px; justify-content: flex-end;">
                <button type="button" onclick="closeCancelModal()" 
                    style="padding: 10px 20px; background: #6b7280; color: white; border: none; border-radius: 6px; cursor: pointer; font-weight: 500; transition: background 0.2s;">
                    Hủy bỏ
                </button>
                <button type="submit" 
                    style="padding: 10px 20px; background: #ef4444; color: white; border: none; border-radius: 6px; cursor: pointer; font-weight: 500; transition: background 0.2s; display: inline-flex; align-items: center; gap: 6px;">
                    <i class="fas fa-times"></i> Xác nhận hủy
                </button>
            </div>
        </form>
    </div>
</div>

<script>
function openCancelModal(rid) {
    document.getElementById('cancelRid').value = rid;
    document.getElementById('cancelNote').value = '';
    document.getElementById('cancelModal').style.display = 'block';
}

function closeCancelModal() {
    document.getElementById('cancelModal').style.display = 'none';
    document.getElementById('cancelNote').value = '';
}

// Đóng modal khi click outside
window.onclick = function(event) {
    const modal = document.getElementById('cancelModal');
    if (event.target == modal) {
        closeCancelModal();
    }
}

// Đóng modal khi nhấn ESC
document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        closeCancelModal();
    }
});
</script>

<jsp:include page="../util/footer.jsp" />

<style>
    .page-header {
        margin-bottom: 32px;
    }

    .status-badge {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 6px 12px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        white-space: nowrap;
    }

    .status-badge i {
        font-size: 0.85rem;
    }

    .status-cancelled {
        background: #f3f4f6;
        color: #6b7280;
    }

    .table-container {
        overflow-x: auto;
        border-radius: var(--border-radius-sm);
    }

    table {
        width: 100%;
        border-collapse: collapse;
    }

    tbody tr {
        transition: background-color 0.2s ease;
    }

    tbody tr:hover {
        background: linear-gradient(90deg, rgba(102, 126, 234, 0.03) 0%, rgba(118, 75, 162, 0.03) 100%);
    }

    @media (max-width: 768px) {
        .page-header > div {
            flex-direction: column;
            align-items: flex-start;
        }

        .page-header h1 {
            font-size: 1.5rem;
        }

        .table-container {
            overflow-x: scroll;
        }

        table {
            min-width: 900px;
        }

        tbody td {
            font-size: 0.9rem;
        }
    }
    /* Pagination Styles */
    .pagination-container {
        margin-top: 24px;
        padding-top: 20px;
        border-top: 1px solid var(--border-color);
    }

    .pagination {
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .pagination-btn {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        min-width: 36px;
        height: 36px;
        padding: 0 12px;
        background: var(--bg-secondary);
        color: var(--text-primary);
        border: 1px solid var(--border-color);
        border-radius: var(--border-radius-sm);
        text-decoration: none;
        font-size: 0.9rem;
        font-weight: 500;
        transition: all 0.2s ease;
        cursor: pointer;
    }

    .pagination-btn:hover:not(.disabled):not(.active) {
        background: var(--primary-color);
        color: white;
        border-color: var(--primary-color);
        transform: translateY(-1px);
    }

    .pagination-btn.active {
        background: var(--primary-color);
        color: white;
        border-color: var(--primary-color);
        cursor: default;
    }

    .pagination-btn.disabled {
        opacity: 0.5;
        cursor: not-allowed;
        pointer-events: none;
    }

    .pagination-ellipsis {
        padding: 0 8px;
        color: var(--text-secondary);
        font-weight: 500;
    }

    @media (max-width: 768px) {
        .pagination-container > div {
            flex-direction: column;
            align-items: center;
        }

        .pagination {
            flex-wrap: wrap;
            justify-content: center;
        }
    }
</style>

