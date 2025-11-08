<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.leave.RequestForLeave" %>
<jsp:include page="../util/header.jsp" />

<%
    RequestForLeave rfl = (RequestForLeave) request.getAttribute("request");
    if (rfl == null) {
        response.sendRedirect(request.getContextPath() + "/request/list");
        return;
    }
    
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

<!-- Page Header -->
<div class="page-header" style="margin-bottom: 32px;">
    <div style="display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 16px;">
        <div>
            <h1 style="font-size: 2rem; font-weight: 700; color: var(--text-primary); margin: 0 0 8px 0; display: flex; align-items: center; gap: 12px;">
                <i class="fas fa-info-circle" style="color: #667eea;"></i>
                Chi tiết đơn nghỉ phép
            </h1>
            <p style="color: var(--text-secondary); margin: 0;">Xem thông tin chi tiết của đơn nghỉ phép</p>
        </div>
        <a href="${pageContext.request.contextPath}/request/list" class="btn btn-secondary">
            <i class="fas fa-arrow-left"></i>
            Quay lại danh sách
        </a>
    </div>
</div>

<!-- Detail Card -->
<div class="card">
    <div class="card-header">
        <h3 class="card-title">
            <i class="fas fa-file-alt"></i>
            Thông tin đơn nghỉ phép #<%= rfl.getId() %>
        </h3>
    </div>
    <div class="card-body">
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 24px;">
            <!-- Thông tin cơ bản -->
            <div>
                <h4 style="margin-bottom: 16px; color: var(--text-primary); font-size: 1.1rem; display: flex; align-items: center; gap: 8px;">
                    <i class="fas fa-user"></i> Thông tin người tạo
                </h4>
                <div style="display: flex; flex-direction: column; gap: 12px;">
                    <div>
                        <label style="display: block; font-weight: 600; color: var(--text-secondary); margin-bottom: 4px; font-size: 0.9rem;">Người tạo đơn</label>
                        <div style="padding: 10px; background: var(--bg-secondary); border-radius: 8px; display: flex; align-items: center; gap: 8px;">
                            <i class="fas fa-user-circle" style="color: var(--primary-color); font-size: 1.2rem;"></i>
                            <span style="font-weight: 500;"><%= rfl.getCreated_by() != null && rfl.getCreated_by().getName() != null ? rfl.getCreated_by().getName() : "N/A" %></span>
                        </div>
                    </div>
                    <div>
                        <label style="display: block; font-weight: 600; color: var(--text-secondary); margin-bottom: 4px; font-size: 0.9rem;">Thời gian tạo</label>
                        <div style="padding: 10px; background: var(--bg-secondary); border-radius: 8px; display: flex; align-items: center; gap: 8px;">
                            <i class="fas fa-clock" style="color: var(--text-secondary);"></i>
                            <span><%= rfl.getCreated_time() != null ? new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(rfl.getCreated_time()) : "-" %></span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Thông tin nghỉ phép -->
            <div>
                <h4 style="margin-bottom: 16px; color: var(--text-primary); font-size: 1.1rem; display: flex; align-items: center; gap: 8px;">
                    <i class="fas fa-calendar-alt"></i> Thông tin nghỉ phép
                </h4>
                <div style="display: flex; flex-direction: column; gap: 12px;">
                    <div>
                        <label style="display: block; font-weight: 600; color: var(--text-secondary); margin-bottom: 4px; font-size: 0.9rem;">Loại nghỉ phép</label>
                        <div style="padding: 10px; background: <%= leaveTypeColor %>15; border-radius: 8px; display: inline-flex; align-items: center; gap: 8px;">
                            <span style="font-size: 1.2rem;"><%= leaveTypeIcon %></span>
                            <span style="font-weight: 500; color: <%= leaveTypeColor %>;"><%= leaveTypeDisplay %></span>
                        </div>
                    </div>
                    <div>
                        <label style="display: block; font-weight: 600; color: var(--text-secondary); margin-bottom: 4px; font-size: 0.9rem;">Từ ngày</label>
                        <div style="padding: 10px; background: var(--bg-secondary); border-radius: 8px; display: flex; align-items: center; gap: 8px;">
                            <i class="fas fa-calendar-alt" style="color: var(--text-secondary);"></i>
                            <span><%= rfl.getFrom() != null ? new java.text.SimpleDateFormat("dd/MM/yyyy").format(rfl.getFrom()) : "-" %></span>
                        </div>
                    </div>
                    <div>
                        <label style="display: block; font-weight: 600; color: var(--text-secondary); margin-bottom: 4px; font-size: 0.9rem;">Đến ngày</label>
                        <div style="padding: 10px; background: var(--bg-secondary); border-radius: 8px; display: flex; align-items: center; gap: 8px;">
                            <i class="fas fa-calendar-check" style="color: var(--text-secondary);"></i>
                            <span><%= rfl.getTo() != null ? new java.text.SimpleDateFormat("dd/MM/yyyy").format(rfl.getTo()) : "-" %></span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Trạng thái và xử lý -->
            <div>
                <h4 style="margin-bottom: 16px; color: var(--text-primary); font-size: 1.1rem; display: flex; align-items: center; gap: 8px;">
                    <i class="fas fa-info-circle"></i> Trạng thái
                </h4>
                <div style="display: flex; flex-direction: column; gap: 12px;">
                    <div>
                        <label style="display: block; font-weight: 600; color: var(--text-secondary); margin-bottom: 4px; font-size: 0.9rem;">Trạng thái đơn</label>
                        <div style="padding: 10px; background: var(--bg-secondary); border-radius: 8px;">
                            <span class="status-badge <%= statusClass %>" style="white-space: nowrap;">
                                <i class="<%= statusIcon %>"></i>
                                <%= statusText %>
                            </span>
                        </div>
                    </div>
                    <div>
                        <label style="display: block; font-weight: 600; color: var(--text-secondary); margin-bottom: 4px; font-size: 0.9rem;">Người xử lý</label>
                        <div style="padding: 10px; background: var(--bg-secondary); border-radius: 8px; display: flex; align-items: center; gap: 8px;">
                            <% if (rfl.getProcessed_by() != null && rfl.getProcessed_by().getName() != null) { %>
                            <i class="fas fa-user-check" style="color: var(--success-color);"></i>
                            <span><%= rfl.getProcessed_by().getName() %></span>
                            <% } else { %>
                            <i class="fas fa-minus" style="color: var(--text-muted);"></i>
                            <span style="color: var(--text-muted);">Chưa được xử lý</span>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Lý do nghỉ phép -->
        <div style="margin-top: 32px; padding-top: 24px; border-top: 1px solid var(--border-color);">
            <h4 style="margin-bottom: 16px; color: var(--text-primary); font-size: 1.1rem; display: flex; align-items: center; gap: 8px;">
                <i class="fas fa-comment"></i> Lý do nghỉ phép
            </h4>
            <div style="padding: 16px; background: var(--bg-secondary); border-radius: 8px; border-left: 4px solid var(--primary-color);">
                <p style="margin: 0; line-height: 1.6; white-space: pre-wrap;"><%= rfl.getReason() != null ? rfl.getReason() : "-" %></p>
            </div>
        </div>

        <!-- Lý do hủy đơn (nếu có) -->
        <% if (rfl.getStatus() == 3 && rfl.getCancelNote() != null && !rfl.getCancelNote().trim().isEmpty()) { %>
        <div style="margin-top: 24px; padding-top: 24px; border-top: 1px solid var(--border-color);">
            <h4 style="margin-bottom: 16px; color: var(--text-primary); font-size: 1.1rem; display: flex; align-items: center; gap: 8px;">
                <i class="fas fa-ban" style="color: #ef4444;"></i> Lý do hủy đơn
            </h4>
            <div style="padding: 16px; background: #fee2e2; border-radius: 8px; border-left: 4px solid #ef4444;">
                <p style="margin: 0; line-height: 1.6; white-space: pre-wrap; color: #991b1b;"><%= rfl.getCancelNote() %></p>
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
        white-space: nowrap;
    }

    .status-cancelled {
        background: #f3f4f6;
        color: #6b7280;
    }

    @media (max-width: 768px) {
        .page-header > div {
            flex-direction: column;
            align-items: flex-start;
        }

        .page-header h1 {
            font-size: 1.5rem;
        }
    }
</style>

