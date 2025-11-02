<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.iam.User" %>
<%@page import="model.leave.RequestForLeave" %>
<%@page import="java.util.ArrayList" %>
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
        <div class="stat-card" data-stat-type="pending" style="cursor: pointer;" title="Click to view pending requests">
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
            <div class="stat-label">Total Pending</div>
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
                            <span class="status-badge <%= statusClass %>">
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
    background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
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
}
</style>

<jsp:include page="../util/footer.jsp" />