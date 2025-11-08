<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.iam.User" %>
<%@page import="model.leave.RequestForLeave" %>
<%@page import="java.util.ArrayList" %>
<%@page import="util.Pagination" %>
<jsp:include page="../util/header.jsp">
    <jsp:param name="pageTitle" value="Dashboard - Leave Management System" />
</jsp:include>

<div class="dashboard-header">
    <div class="container">
        <h1 class="dashboard-title">
            <i class="fas fa-tachometer-alt"></i>
            Welcome back, ${user.displayname}!
        </h1>
        <p class="dashboard-subtitle">Manage your leave requests and track your team's activities</p>
    </div>
</div>

<div class="container">
    <!-- Quick Actions -->
    <div class="card">
        <div class="card-header">
            <h3 class="card-title">
                <i class="fas fa-bolt"></i>
                Quick Actions
            </h3>
        </div>
        <div class="quick-actions">
            <a href="${pageContext.request.contextPath}/request/create" class="btn btn-primary">
                <i class="fas fa-plus-circle"></i>
                Create New Request
            </a>
            <a href="${pageContext.request.contextPath}/request/list" class="btn btn-secondary">
                <i class="fas fa-list"></i>
                View My Requests
            </a>
            <% 
            ArrayList<RequestForLeave> pendingRequests = (ArrayList<RequestForLeave>) request.getAttribute("pendingRequests");
            if (pendingRequests != null && !pendingRequests.isEmpty()) { 
            %>
            <a href="${pageContext.request.contextPath}/request/review" class="btn btn-success">
                <i class="fas fa-check-circle"></i>
                Review Requests
                <span class="badge"><%= pendingRequests.size() %></span>
            </a>
            <% } %>
            <a href="${pageContext.request.contextPath}/division/agenda" class="btn btn-info">
                <i class="fas fa-users"></i>
                Division Agenda
            </a>
        </div>
    </div>

    <!-- Statistics -->
    <div class="stats-grid">
        <div class="stat-card" data-stat-type="total" style="cursor: pointer;" title="Click to view all requests">
            <div class="stat-icon">
                <i class="fas fa-file-alt"></i>
            </div>
            <div class="stat-number"><%
                Object totalObj = request.getAttribute("totalRequests");
                Integer total = null;
                if (totalObj instanceof Integer) {
                    total = (Integer) totalObj;
                } else if (totalObj != null) {
                    try {
                        total = Integer.valueOf(totalObj.toString());
                    } catch (NumberFormatException e) {
                        total = 0;
                    }
                }
                out.print(total != null ? total.intValue() : 0);
            %></div>
            <div class="stat-label">Total Requests</div>
        </div>
        <div class="stat-card" data-stat-type="pending" style="cursor: pointer;" title="Click to view in progress requests">
            <div class="stat-icon">
                <i class="fas fa-clock"></i>
            </div>
            <div class="stat-number"><%
                Object pendingObj = request.getAttribute("pendingCount");
                Integer pending = null;
                if (pendingObj instanceof Integer) {
                    pending = (Integer) pendingObj;
                } else if (pendingObj != null) {
                    try {
                        pending = Integer.valueOf(pendingObj.toString());
                    } catch (NumberFormatException e) {
                        pending = 0;
                    }
                }
                out.print(pending != null ? pending.intValue() : 0);
            %></div>
            <div class="stat-label">Total In progress</div>
        </div>
        <div class="stat-card" data-stat-type="approved" style="cursor: pointer;" title="Click to view approved requests">
            <div class="stat-icon">
                <i class="fas fa-check-circle"></i>
            </div>
            <div class="stat-number"><%
                Object approvedObj = request.getAttribute("approvedCount");
                Integer approved = null;
                if (approvedObj instanceof Integer) {
                    approved = (Integer) approvedObj;
                } else if (approvedObj != null) {
                    try {
                        approved = Integer.valueOf(approvedObj.toString());
                    } catch (NumberFormatException e) {
                        approved = 0;
                    }
                }
                out.print(approved != null ? approved.intValue() : 0);
            %></div>
            <div class="stat-label">Total Approved</div>
        </div>
        <div class="stat-card" data-stat-type="rejected" style="cursor: pointer;" title="Click to view rejected requests">
            <div class="stat-icon">
                <i class="fas fa-times-circle"></i>
            </div>
            <div class="stat-number"><%
                Object rejectedObj = request.getAttribute("rejectedCount");
                Integer rejected = null;
                if (rejectedObj instanceof Integer) {
                    rejected = (Integer) rejectedObj;
                } else if (rejectedObj != null) {
                    try {
                        rejected = Integer.valueOf(rejectedObj.toString());
                    } catch (NumberFormatException e) {
                        rejected = 0;
                    }
                }
                out.print(rejected != null ? rejected.intValue() : 0);
            %></div>
            <div class="stat-label">Total Rejected</div>
        </div>
    </div>

    <!-- Recent Requests -->
    <div class="card">
        <div class="card-header">
            <h3 class="card-title">
                <i class="fas fa-history"></i>
                Recent Requests
            </h3>
        </div>
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th><i class="fas fa-user"></i> Created By</th>
                        <th><i class="fas fa-tags"></i> Loại nghỉ phép</th>
                        <th><i class="fas fa-calendar"></i> From</th>
                        <th><i class="fas fa-calendar"></i> To</th>
                        <th><i class="fas fa-comment"></i> Reason</th>
                        <th><i class="fas fa-info-circle"></i> Status</th>
                        <th><i class="fas fa-clock"></i> Created</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    ArrayList<RequestForLeave> myRequests = (ArrayList<RequestForLeave>) request.getAttribute("myRequests");
                    if (myRequests != null && !myRequests.isEmpty()) {
                        for (RequestForLeave rfl : myRequests) {
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
                    <tr class="request-row" data-status="<%= rfl.getStatus() %>" data-request-id="<%= rfl.getId() %>">
                        <td><%= rfl.getCreated_by() != null && rfl.getCreated_by().getName() != null ? rfl.getCreated_by().getName() : "N/A" %></td>
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
                        <td><%= rfl.getFrom() %></td>
                        <td><%= rfl.getTo() %></td>
                        <td><%= rfl.getReason() %></td>
                        <td>
                            <span class="status-badge <%= statusClass %>"
                                  <% if (rfl.getStatus() == 3 && rfl.getCancelNote() != null && !rfl.getCancelNote().trim().isEmpty()) { %>
                                  title="Nhấn vào 'Chi tiết' để xem lý do hủy đơn"
                                  <% } %>>
                                <i class="<%= statusIcon %>"></i>
                                <%= statusText %>
                            </span>
                        </td>
                        <td><%= rfl.getCreated_time() %></td>
                    </tr>
                    <% 
                        }
                    } else {
                    %>
                    <tr>
                        <td colspan="7" class="text-center">
                            <div class="empty-state">
                                <i class="fas fa-inbox empty-state-icon"></i>
                                <h4 class="empty-state-title">No requests found</h4>
                                <p class="empty-state-message">You haven't created any leave requests yet.</p>
                                <a href="${pageContext.request.contextPath}/request/create" class="btn btn-primary">
                                    <i class="fas fa-plus-circle"></i>
                                    Create Your First Request
                                </a>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
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
                        <a href="${pageContext.request.contextPath}/home?page=<%= pagination.getCurrentPage() - 1 %>" 
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
                        <a href="${pageContext.request.contextPath}/home?page=1" class="pagination-btn">1</a>
                        <% if (startPage > 2) { %>
                            <span class="pagination-ellipsis">...</span>
                        <% } %>
                    <% } %>
                    
                    <% for (int i = startPage; i <= endPage; i++) { %>
                        <% if (i == pagination.getCurrentPage()) { %>
                            <span class="pagination-btn active"><%= i %></span>
                        <% } else { %>
                            <a href="${pageContext.request.contextPath}/home?page=<%= i %>" class="pagination-btn"><%= i %></a>
                        <% } %>
                    <% } %>
                    
                    <% if (endPage < pagination.getTotalPages()) { %>
                        <% if (endPage < pagination.getTotalPages() - 1) { %>
                            <span class="pagination-ellipsis">...</span>
                        <% } %>
                        <a href="${pageContext.request.contextPath}/home?page=<%= pagination.getTotalPages() %>" class="pagination-btn"><%= pagination.getTotalPages() %></a>
                    <% } %>
                    
                    <% if (pagination.hasNext()) { %>
                        <a href="${pageContext.request.contextPath}/home?page=<%= pagination.getCurrentPage() + 1 %>" 
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
    </div>
</div>

<style>
.quick-actions {
    display: flex;
    gap: 16px;
    flex-wrap: wrap;
}

.quick-actions .btn {
    flex: 1;
    min-width: 200px;
}

.dashboard-header {
    color: white;
    padding: 40px 0;
    margin-bottom: 30px;
    position: relative;
    overflow: hidden;
}

.dashboard-header::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="1" fill="rgba(255,255,255,0.1)"/><circle cx="75" cy="75" r="1" fill="rgba(255,255,255,0.1)"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
    opacity: 0.3;
}

.dashboard-header .container {
    position: relative;
    z-index: 1;
}

.dashboard-title {
    font-size: 2.5rem;
    margin-bottom: 10px;
    font-weight: 700;
}

.dashboard-subtitle {
    font-size: 1.2rem;
    opacity: 0.9;
}

.empty-state {
    text-align: center;
    padding: 60px 20px;
    color: var(--text-secondary);
}

.empty-state-icon {
    font-size: 4rem;
    margin-bottom: 20px;
    opacity: 0.5;
}

.empty-state-title {
    font-size: 1.5rem;
    margin-bottom: 10px;
    color: var(--text-primary);
}

.empty-state-message {
    font-size: 1rem;
    margin-bottom: 30px;
}

.text-center {
    text-align: center;
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

.status-cancelled {
    background: #f3f4f6;
    color: #6b7280;
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
    .quick-actions {
        flex-direction: column;
    }
    
    .quick-actions .btn {
        min-width: auto;
    }
    
    .dashboard-title {
        font-size: 2rem;
    }
    
    .dashboard-subtitle {
        font-size: 1rem;
    }
    
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

<jsp:include page="../util/footer.jsp" />