<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.leave.RequestForLeave" %>
<%@page import="java.util.ArrayList" %>
<jsp:include page="../util/header.jsp" />

<!-- Page Header -->
<div class="page-header" style="margin-bottom: 32px;">
    <div style="display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 16px;">
        <div>
            <h1 style="font-size: 2rem; font-weight: 700; color: var(--text-primary); margin: 0 0 8px 0; display: flex; align-items: center; gap: 12px;">
                <i class="fas fa-check-circle" style="color: #667eea;"></i>
                Review Leave Requests
            </h1>
            <p style="color: var(--text-secondary); margin: 0;">Approve or reject pending leave requests</p>
        </div>
        <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary">
            <i class="fas fa-arrow-left"></i>
            Back to Home
        </a>
    </div>
</div>

<!-- Messages -->
<% if (request.getAttribute("message") != null) { %>
    <div class="alert alert-success" style="margin-bottom: 24px; animation: slideDown 0.3s ease-out;">
        <i class="fas fa-check-circle"></i>
        <span><%= request.getAttribute("message") %></span>
    </div>
<% } %>

<% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-error" style="margin-bottom: 24px; animation: slideDown 0.3s ease-out;">
        <i class="fas fa-exclamation-circle"></i>
        <span><%= request.getAttribute("error") %></span>
    </div>
<% } %>

<!-- Pending Requests Card -->
<div class="card">
    <div class="card-header">
        <div style="display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 16px;">
            <h3 class="card-title">
                <i class="fas fa-clock"></i>
                Pending Requests
            </h3>
            <% 
            ArrayList<RequestForLeave> pendingRequests = (ArrayList<RequestForLeave>) request.getAttribute("pendingRequests");
            int pendingCount = (pendingRequests != null) ? pendingRequests.size() : 0;
            if (pendingCount > 0) {
            %>
                <span style="display: inline-flex; align-items: center; gap: 6px; padding: 6px 14px; background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%); color: #92400e; border-radius: 20px; font-size: 0.9rem; font-weight: 600;">
                    <i class="fas fa-bell"></i>
                    <%= pendingCount %> request<%= pendingCount > 1 ? "s" : "" %> pending
                </span>
            <% } %>
        </div>
    </div>
    <div class="card-body">
        <% 
        if (pendingRequests == null || pendingRequests.isEmpty()) {
        %>
            <div class="empty-state">
                <i class="fas fa-check-double empty-state-icon" style="color: #48bb78;"></i>
                <h4 class="empty-state-title">All caught up!</h4>
                <p class="empty-state-message">There are no pending requests to review at this time.</p>
            </div>
        <% } else { %>
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th style="width: 180px;">
                                <i class="fas fa-user"></i> Employee
                            </th>
                            <th style="width: 120px;">
                                <i class="fas fa-calendar-alt"></i> From
                            </th>
                            <th style="width: 120px;">
                                <i class="fas fa-calendar-check"></i> To
                            </th>
                            <th>
                                <i class="fas fa-comment"></i> Reason
                            </th>
                            <th style="width: 160px;">
                                <i class="fas fa-clock"></i> Created
                            </th>
                            <th style="width: 200px; text-align: center;">
                                <i class="fas fa-cog"></i> Actions
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                        for (RequestForLeave rfl : pendingRequests) {
                        %>
                        <tr>
                            <td>
                                <div style="display: flex; align-items: center; gap: 10px;">
                                    <div style="width: 40px; height: 40px; border-radius: 50%; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); display: flex; align-items: center; justify-content: center; color: white; font-weight: 600; flex-shrink: 0;">
                                        <i class="fas fa-user"></i>
                                    </div>
                                    <div>
                                        <div style="font-weight: 600; color: var(--text-primary);">
                                            <%= rfl.getCreated_by() != null && rfl.getCreated_by().getName() != null ? rfl.getCreated_by().getName() : "N/A" %>
                                        </div>
                                        <div style="font-size: 0.85rem; color: var(--text-secondary);">
                                            <i class="fas fa-user-tag"></i> Employee
                                        </div>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <span style="display: inline-flex; align-items: center; gap: 6px; padding: 6px 10px; background: #f0f4ff; color: #667eea; border-radius: 8px; font-weight: 500; font-size: 0.9rem;">
                                    <i class="fas fa-calendar-alt"></i>
                                    <%= rfl.getFrom() != null ? new java.text.SimpleDateFormat("dd/MM/yyyy").format(rfl.getFrom()) : "-" %>
                                </span>
                            </td>
                            <td>
                                <span style="display: inline-flex; align-items: center; gap: 6px; padding: 6px 10px; background: #f0fdf4; color: #48bb78; border-radius: 8px; font-weight: 500; font-size: 0.9rem;">
                                    <i class="fas fa-calendar-check"></i>
                                    <%= rfl.getTo() != null ? new java.text.SimpleDateFormat("dd/MM/yyyy").format(rfl.getTo()) : "-" %>
                                </span>
                            </td>
                            <td>
                                <div style="max-width: 300px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;" title="<%= rfl.getReason() != null ? rfl.getReason().replace("\"", "&quot;") : "" %>">
                                    <%= rfl.getReason() != null && rfl.getReason().length() > 60 ? rfl.getReason().substring(0, 60) + "..." : (rfl.getReason() != null ? rfl.getReason() : "-") %>
                                </div>
                            </td>
                            <td>
                                <span style="display: inline-flex; align-items: center; gap: 6px; color: var(--text-secondary); font-size: 0.9rem;">
                                    <i class="fas fa-clock"></i>
                                    <%= rfl.getCreated_time() != null ? new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(rfl.getCreated_time()) : "-" %>
                                </span>
                            </td>
                            <td>
                                <div class="actions" style="display: flex; gap: 8px; justify-content: center;">
                                    <form action="${pageContext.request.contextPath}/request/review" method="post" style="display: inline; margin: 0;">
                                        <input type="hidden" name="rid" value="<%= rfl.getId() %>">
                                        <input type="hidden" name="action" value="approve">
                                        <button type="submit" class="btn btn-success" style="padding: 10px 20px; font-size: 14px; min-width: 90px;" onclick="return confirm('Are you sure you want to approve this request?')">
                                            <i class="fas fa-check"></i>
                                            Approve
                                        </button>
                                    </form>
                                    <form action="${pageContext.request.contextPath}/request/review" method="post" style="display: inline; margin: 0;">
                                        <input type="hidden" name="rid" value="<%= rfl.getId() %>">
                                        <input type="hidden" name="action" value="reject">
                                        <button type="submit" class="btn btn-danger" style="padding: 10px 20px; font-size: 14px; min-width: 90px;" onclick="return confirm('Are you sure you want to reject this request?')">
                                            <i class="fas fa-times"></i>
                                            Reject
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            
            <!-- Summary -->
            <div style="margin-top: 24px; padding-top: 20px; border-top: 1px solid var(--border-color); display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 16px;">
                <div style="display: flex; align-items: center; gap: 8px; color: var(--text-secondary);">
                    <i class="fas fa-info-circle"></i>
                    <span>Total: <strong style="color: var(--text-primary);"><%= pendingCount %></strong> pending request<%= pendingCount > 1 ? "s" : "" %></span>
                </div>
                <div style="display: flex; align-items: center; gap: 8px; padding: 8px 16px; background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%); border-radius: 8px; color: #92400e; font-size: 0.9rem; font-weight: 500;">
                    <i class="fas fa-exclamation-triangle"></i>
                    <span>Action required</span>
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

.alert {
    padding: 16px 20px;
    border-radius: 10px;
    border-left: 4px solid;
    display: flex;
    align-items: center;
    gap: 12px;
    animation: slideDown 0.3s ease-out;
}

@keyframes slideDown {
    from {
        opacity: 0;
        transform: translateY(-10px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.alert-success {
    background: #d1fae5;
    border-color: #48bb78;
    color: #065f46;
}

.alert-success i {
    font-size: 1.2rem;
    color: #48bb78;
}

.alert-error {
    background: #fee2e2;
    border-color: #ef4444;
    color: #991b1b;
}

.alert-error i {
    font-size: 1.2rem;
    color: #ef4444;
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
    transition: all 0.2s ease;
}

tbody tr:hover {
    background: linear-gradient(90deg, rgba(102, 126, 234, 0.03) 0%, rgba(118, 75, 162, 0.03) 100%);
    transform: scale(1.01);
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.actions form {
    transition: transform 0.2s ease;
}

.actions form:hover {
    transform: scale(1.05);
}

.btn-success {
    background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
    color: white;
    box-shadow: 0 4px 15px rgba(72, 187, 120, 0.3);
    border: none;
    cursor: pointer;
}

.btn-success:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(72, 187, 120, 0.4);
}

.btn-danger {
    background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
    color: white;
    box-shadow: 0 4px 15px rgba(239, 68, 68, 0.3);
    border: none;
    cursor: pointer;
}

.btn-danger:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(239, 68, 68, 0.4);
}

.empty-state {
    text-align: center;
    padding: 60px 20px;
    color: var(--text-secondary);
}

.empty-state-icon {
    font-size: 4rem;
    margin-bottom: 20px;
    opacity: 0.8;
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

@media (max-width: 768px) {
    .page-header h1 {
        font-size: 1.5rem;
    }
    
    .page-header > div {
        flex-direction: column;
        align-items: flex-start;
    }
    
    .table-container {
        overflow-x: scroll;
    }
    
    table {
        min-width: 900px;
    }
    
    .actions {
        flex-direction: column;
        width: 100%;
    }
    
    .actions form {
        width: 100%;
    }
    
    .actions button {
        width: 100%;
    }
    
    tbody tr:hover {
        transform: none;
    }
}
</style>
