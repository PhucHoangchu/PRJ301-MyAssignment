<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.leave.RequestForLeave" %>
<%@page import="java.util.ArrayList" %>
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
                            <th><i class="fas fa-calendar-alt"></i> From</th>
                            <th><i class="fas fa-calendar-check"></i> To</th>
                            <th><i class="fas fa-comment"></i> Reason</th>
                            <th><i class="fas fa-info-circle"></i> Status</th>
                            <th><i class="fas fa-clock"></i> Created</th>
                            <th><i class="fas fa-user-check"></i> Processed By</th>
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
                                    statusText = "Pending"; 
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
                                <span class="status-badge <%= statusClass %>">
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
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            
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
                        <i class="fas fa-clock"></i> Pending: <strong><%= pendingCount %></strong>
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
}

.status-badge i {
    font-size: 0.85rem;
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
</style>
