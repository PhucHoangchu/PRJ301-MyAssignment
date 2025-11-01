<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.leave.RequestForLeave" %>
<%@page import="model.core.Employee" %>
<%@page import="java.util.ArrayList" %>
<jsp:include page="../util/header.jsp">
    <jsp:param name="pageTitle" value="Division Agenda - Leave Management System" />
</jsp:include>

<!-- Dashboard Header -->
<div class="dashboard-header">
    <div class="container">
        <h1 class="dashboard-title">
            <i class="fas fa-users"></i>
            Division Agenda
        </h1>
        <p class="dashboard-subtitle">Quản lý tình hình làm việc và nghỉ phép của phòng ban</p>
    </div>
</div>

<div class="container">
    <!-- Date Range Filter Card -->
    <div class="card" style="margin-bottom: 24px;">
        <div class="card-header">
            <h3 class="card-title">
                <i class="fas fa-filter"></i>
                Chọn khoảng thời gian
            </h3>
        </div>
        <div class="card-body">
            <form method="get" id="agenda-range-form">
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 20px; margin-bottom: 20px;">
                    <div class="form-field">
                        <label for="fromDate" style="display: flex; align-items: center; gap: 8px; margin-bottom: 10px; font-weight: 600; color: var(--text-primary);">
                            <i class="fas fa-calendar-alt" style="color: #667eea;"></i>
                            Từ ngày <span style="color: var(--danger-color);">*</span>
                        </label>
                        <div style="position: relative;">
                            <input 
                                type="date" 
                                name="from" 
                                id="fromDate" 
                                value="${rangeFrom}" 
                                required
                                style="width: 100%; padding: 14px 16px; padding-left: 44px; border: 2px solid var(--border-color); border-radius: var(--border-radius-sm); font-size: 15px; transition: all 0.3s ease; background: white;"
                            />
                            <i class="fas fa-calendar-alt" style="position: absolute; left: 16px; top: 50%; transform: translateY(-50%); color: var(--text-secondary); pointer-events: none;"></i>
                        </div>
                    </div>
                    <div class="form-field">
                        <label for="toDate" style="display: flex; align-items: center; gap: 8px; margin-bottom: 10px; font-weight: 600; color: var(--text-primary);">
                            <i class="fas fa-calendar-check" style="color: #48bb78;"></i>
                            Đến ngày <span style="color: var(--danger-color);">*</span>
                        </label>
                        <div style="position: relative;">
                            <input 
                                type="date" 
                                name="to" 
                                id="toDate" 
                                value="${rangeTo}" 
                                required
                                style="width: 100%; padding: 14px 16px; padding-left: 44px; border: 2px solid var(--border-color); border-radius: var(--border-radius-sm); font-size: 15px; transition: all 0.3s ease; background: white;"
                            />
                            <i class="fas fa-calendar-check" style="position: absolute; left: 16px; top: 50%; transform: translateY(-50%); color: var(--text-secondary); pointer-events: none;"></i>
                        </div>
                    </div>
                    <div class="form-field" style="display: flex; align-items: flex-end;">
                        <button type="submit" class="btn btn-primary" style="width: 100%; padding: 14px 20px; font-size: 16px;">
                            <i class="fas fa-search"></i>
                            Xem Agenda
                        </button>
                    </div>
                </div>
                <div style="padding: 14px 18px; background: linear-gradient(135deg, #f0f4ff 0%, #f8f9ff 100%); border-left: 4px solid #667eea; border-radius: var(--border-radius-sm); display: flex; align-items: center; gap: 12px;">
                    <div style="width: 40px; height: 40px; border-radius: 50%; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); display: flex; align-items: center; justify-content: center; color: white; flex-shrink: 0;">
                        <i class="fas fa-info-circle"></i>
                    </div>
                    <div style="flex: 1;">
                        <div style="font-weight: 600; color: var(--text-primary); margin-bottom: 4px;">Khoảng thời gian cố định 9 ngày</div>
                        <div style="font-size: 0.9rem; color: var(--text-secondary);">Hệ thống sẽ tự động điều chỉnh khoảng thời gian thành 9 ngày để khớp với bảng Agenda.</div>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Legend Card -->
    <div class="card" style="margin-bottom: 24px; padding: 20px;">
        <div style="display: flex; align-items: center; justify-content: center; gap: 40px; flex-wrap: wrap;">
            <div style="display: flex; align-items: center; gap: 12px; padding: 12px 20px; background: linear-gradient(135deg, #f0fdf4 0%, #dcfce7 100%); border-radius: var(--border-radius); border: 2px solid #86efac;">
                <div style="width: 40px; height: 40px; border-radius: 8px; background: linear-gradient(135deg, #48bb78 0%, #38a169 100%); box-shadow: 0 4px 12px rgba(72, 187, 120, 0.3); display: flex; align-items: center; justify-content: center; color: white;">
                    <i class="fas fa-check"></i>
                </div>
                <div>
                    <div style="font-weight: 700; color: #065f46; font-size: 1rem;">Đi làm</div>
                    <div style="font-size: 0.85rem; color: #047857;">Trạng thái làm việc bình thường</div>
                </div>
            </div>
            <div style="display: flex; align-items: center; gap: 12px; padding: 12px 20px; background: linear-gradient(135deg, #fef2f2 0%, #fee2e2 100%); border-radius: var(--border-radius); border: 2px solid #fca5a5;">
                <div style="width: 40px; height: 40px; border-radius: 8px; background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%); box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3); display: flex; align-items: center; justify-content: center; color: white;">
                    <i class="fas fa-umbrella-beach"></i>
                </div>
                <div>
                    <div style="font-weight: 700; color: #991b1b; font-size: 1rem;">Nghỉ phép</div>
                    <div style="font-size: 0.85rem; color: #b91c1c;">Đơn nghỉ phép đã được duyệt</div>
                </div>
            </div>
        </div>
    </div>

    <!-- Agenda Table Card -->
    <div class="card" style="padding: 0; overflow: hidden;">
        <div class="card-header" style="border-bottom: 2px solid var(--border-color);">
            <div style="display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 16px;">
                <h3 class="card-title" style="margin: 0;">
                    <i class="fas fa-table"></i>
                    Agenda Làm việc
                </h3>
                <% 
                java.util.ArrayList<Employee> empListCount = (java.util.ArrayList<Employee>) request.getAttribute("divisionEmployees");
                if (empListCount != null && !empListCount.isEmpty()) {
                %>
                    <div style="display: flex; align-items: center; gap: 12px;">
                        <span style="display: inline-flex; align-items: center; gap: 8px; padding: 8px 16px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; border-radius: 20px; font-size: 0.9rem; font-weight: 600;">
                            <i class="fas fa-users"></i>
                            <%= empListCount.size() %> nhân sự
                        </span>
                        <% 
                        java.util.ArrayList<java.sql.Date> dateRangeCount = (java.util.ArrayList<java.sql.Date>) request.getAttribute("dateRange");
                        if (dateRangeCount != null) {
                        %>
                            <span style="display: inline-flex; align-items: center; gap: 8px; padding: 8px 16px; background: #f0f4ff; color: #667eea; border-radius: 20px; font-size: 0.9rem; font-weight: 600;">
                                <i class="fas fa-calendar-days"></i>
                                <%= dateRangeCount.size() %> ngày
                            </span>
                        <% } %>
                    </div>
                <% } %>
            </div>
        </div>
        <div class="card-body" style="padding: 0;">
            <div class="agenda-table-wrapper" style="overflow-x: auto; position: relative;">
                <table class="agenda-table">
                    <colgroup>
                        <col class="employee-col" />
                        <%
                            java.util.ArrayList<java.sql.Date> dateRangeCol = (java.util.ArrayList<java.sql.Date>) request.getAttribute("dateRange");
                            if (dateRangeCol != null) {
                                for (int i = 0; i < dateRangeCol.size(); i++) {
                        %>
                        <col class="date-col" />
                        <%
                                }
                            }
                        %>
                    </colgroup>
                    <thead>
                        <tr>
                            <th class="sticky-col-header">
                                <div style="display: flex; align-items: center; gap: 10px; padding: 4px 0;">
                                    <i class="fas fa-user-friends" style="color: #667eea;"></i>
                                    <span>Nhân sự</span>
                                </div>
                            </th>
                            <% 
                                java.util.ArrayList<java.sql.Date> dateRange = (java.util.ArrayList<java.sql.Date>) request.getAttribute("dateRange");
                                java.text.SimpleDateFormat headerFmt = new java.text.SimpleDateFormat("dd/MM");
                                if (dateRange != null) {
                                    for (java.sql.Date d : dateRange) {
                            %>
                            <th class="date-header">
                                <div style="display: flex; flex-direction: column; align-items: center; gap: 6px;">
                                    <span style="font-weight: 700; font-size: 0.95rem; color: var(--text-primary);"><%= headerFmt.format(d) %></span>
                                    <span style="font-size: 0.75rem; color: var(--text-secondary); text-transform: uppercase; font-weight: 500;">
                                        <%= new java.text.SimpleDateFormat("EEE", new java.util.Locale("vi", "VN")).format(d) %>
                                    </span>
                                </div>
                            </th>
                            <%      }
                                }
                            %>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            java.util.ArrayList<Employee> empList = (java.util.ArrayList<Employee>) request.getAttribute("divisionEmployees");
                            java.util.Map<Integer, java.util.Set<java.sql.Date>> leaveDatesByEmployee = (java.util.Map<Integer, java.util.Set<java.sql.Date>>) request.getAttribute("leaveDatesByEmployee");
                            if (empList != null && !empList.isEmpty() && dateRange != null) {
                                for (Employee e : empList) {
                        %>
                        <tr class="agenda-row">
                            <td class="sticky-col-employee">
                                <div style="display: flex; align-items: center; gap: 12px;">
                                    <div style="width: 40px; height: 40px; border-radius: 50%; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); display: flex; align-items: center; justify-content: center; color: white; font-weight: 600; flex-shrink: 0; font-size: 0.9rem; box-shadow: 0 2px 8px rgba(102, 126, 234, 0.3);">
                                        <% 
                                        String initials = "";
                                        String name = (e.getName() != null && !e.getName().trim().isEmpty()) ? e.getName() : "";
                                        if (!name.isEmpty()) {
                                            String[] parts = name.trim().split("\\s+");
                                            if (parts.length > 0) {
                                                initials = parts[parts.length - 1].substring(0, Math.min(1, parts[parts.length - 1].length())).toUpperCase();
                                            }
                                        }
                                        if (initials.isEmpty()) initials = "?";
                                        %>
                                        <%= initials %>
                                    </div>
                                    <span class="employee-name" style="font-weight: 600; color: var(--text-primary); font-size: 0.95rem;"><%
                                        String displayName = (e.getName() != null && !e.getName().trim().isEmpty()) ? e.getName() : ("E#" + e.getId());
                                        out.print(displayName);
                                    %></span>
                                </div>
                            </td>
                            <%
                                java.util.Set<java.sql.Date> leaveDates = leaveDatesByEmployee != null ? leaveDatesByEmployee.get(e.getId()) : null;
                                for (java.sql.Date d : dateRange) {
                                    boolean isLeave = leaveDates != null && leaveDates.contains(d);
                            %>
                            <td class="agenda-cell <%= isLeave ? "leave" : "present" %>" 
                                title="<%= e.getName() != null ? e.getName() : "Employee" %> - <%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(d) %>: <%= isLeave ? "Nghỉ phép" : "Đi làm" %>">
                            </td>
                            <%      }
                            %>
                        </tr>
                        <% 
                            }
                        } else {
                        %>
                        <tr>
                            <td colspan="100%" class="text-center" style="padding: 80px 20px;">
                                <div class="empty-state">
                                    <div style="width: 80px; height: 80px; border-radius: 50%; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); display: flex; align-items: center; justify-content: center; margin: 0 auto 24px; color: white; font-size: 2rem;">
                                        <i class="fas fa-users"></i>
                                    </div>
                                    <h4 class="empty-state-title">Không có nhân sự để hiển thị</h4>
                                    <p class="empty-state-message">Kiểm tra lại dữ liệu phòng ban hoặc phạm vi quyền của bạn.</p>
                                    <a href="${pageContext.request.contextPath}/home" class="btn btn-primary" style="margin-top: 20px;">
                                        <i class="fas fa-home"></i>
                                        Về trang chủ
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
</div>

<jsp:include page="../util/footer.jsp" />

<style>
/* Form Field Focus */
.form-field input[type="date"]:focus {
    outline: none;
    border-color: #667eea;
    box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
}

.form-field input[type="date"]:hover {
    border-color: #cbd5e0;
}

/* Agenda Table Wrapper */
.agenda-table-wrapper {
    max-height: 70vh;
    overflow-y: auto;
    overflow-x: auto;
    padding: 16px;
    background: #f8fafc;
}

/* Agenda Table */
.agenda-table {
    width: 100%;
    border-collapse: separate;
    border-spacing: 4px;
    table-layout: fixed;
    background: transparent;
}

.employee-col {
    width: 200px;
    min-width: 180px;
}

.date-col {
    width: 70px;
    min-width: 70px;
}

/* Table Headers */
.agenda-table thead {
    position: sticky;
    top: 0;
    z-index: 30;
    background: transparent;
}

.sticky-col-header {
    position: sticky;
    left: 0;
    z-index: 35;
    background: linear-gradient(135deg, #ffffff 0%, #f8f9ff 100%);
    padding: 18px 20px;
    text-align: left;
    border: 2px solid #e2e8f0;
    border-radius: 10px 10px 10px 10px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

.date-header {
    padding: 16px 8px;
    text-align: center;
    border: 2px solid #e2e8f0;
    border-radius: 8px;
    background: linear-gradient(135deg, #ffffff 0%, #f8f9ff 100%);
    min-width: 70px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.04);
    transition: all 0.2s ease;
}

.date-header:hover {
    background: linear-gradient(135deg, #f8f9ff 0%, #f0f4ff 100%);
    border-color: #cbd5e0;
    transform: translateY(-1px);
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.08);
}

/* Table Body */
.agenda-row {
    transition: background-color 0.2s ease;
}

.agenda-row:hover {
    background-color: rgba(102, 126, 234, 0.02);
}

.sticky-col-employee {
    position: sticky;
    left: 0;
    z-index: 25;
    background: white;
    padding: 16px 20px;
    text-align: left;
    border: 2px solid #e2e8f0;
    border-radius: 10px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
    min-width: 180px;
    transition: all 0.2s ease;
}

.agenda-row:hover .sticky-col-employee {
    background: linear-gradient(135deg, #ffffff 0%, #f8f9ff 100%);
    border-color: #cbd5e0;
    box-shadow: 0 4px 12px rgba(102, 126, 234, 0.12);
    transform: translateX(-2px);
}

.employee-name {
    display: inline-block;
    max-width: 140px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}

/* Agenda Cells */
.agenda-cell {
    width: 70px;
    min-width: 70px;
    height: 70px;
    padding: 0;
    border: 3px solid rgba(0, 0, 0, 0.08);
    border-radius: 8px;
    text-align: center;
    vertical-align: middle;
    cursor: default;
    transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
    position: relative;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

.agenda-cell::before {
    content: '';
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    width: 0;
    height: 0;
    border-radius: 50%;
    background: rgba(255, 255, 255, 0.3);
    transition: all 0.3s ease;
}

.agenda-cell:hover::before {
    width: 100%;
    height: 100%;
    border-radius: 8px;
}

.present {
    background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
    border-color: rgba(34, 197, 94, 0.3);
}

.present:hover {
    background: linear-gradient(135deg, #16a34a 0%, #15803d 100%);
    border-color: rgba(34, 197, 94, 0.5);
    box-shadow: 0 4px 12px rgba(34, 197, 94, 0.25);
    transform: scale(1.05);
}

.leave {
    background: linear-gradient(135deg, #f43f5e 0%, #e11d48 100%);
    border-color: rgba(244, 63, 94, 0.3);
}

.leave:hover {
    background: linear-gradient(135deg, #e11d48 0%, #be123c 100%);
    border-color: rgba(244, 63, 94, 0.5);
    box-shadow: 0 4px 12px rgba(244, 63, 94, 0.25);
    transform: scale(1.05);
}

/* Empty State */
.empty-state {
    text-align: center;
    padding: 40px 20px;
}

.empty-state-title {
    font-size: 1.5rem;
    margin-bottom: 12px;
    color: var(--text-primary);
    font-weight: 700;
}

.empty-state-message {
    font-size: 1rem;
    line-height: 1.6;
    color: var(--text-secondary);
    margin-bottom: 0;
}

.text-center {
    text-align: center;
}

/* Responsive */
@media (max-width: 1024px) {
    .agenda-table-wrapper {
        padding: 12px;
    }
    
    .agenda-table {
        border-spacing: 3px;
    }
    
    .employee-col {
        width: 160px;
        min-width: 160px;
    }
    
    .date-col {
        width: 70px;
        min-width: 70px;
    }
    
    .sticky-col-employee {
        min-width: 160px;
        padding: 14px 16px;
        border-width: 2px;
    }
    
    .agenda-cell {
        width: 70px;
        min-width: 70px;
        height: 70px;
        border-width: 2px;
    }
    
    .date-header {
        min-width: 70px;
        padding: 14px 8px;
        border-width: 2px;
    }
}

@media (max-width: 768px) {
    .agenda-table-wrapper {
        padding: 8px;
    }
    
    .agenda-table {
        border-spacing: 2px;
    }
    
    .form-field {
        grid-column: 1 / -1;
    }
    
    .employee-col {
        width: 140px;
        min-width: 140px;
    }
    
    .date-col {
        width: 65px;
        min-width: 65px;
    }
    
    .sticky-col-employee {
        min-width: 140px;
        padding: 12px 14px;
        border-width: 2px;
    }
    
    .agenda-cell {
        width: 65px;
        min-width: 65px;
        height: 65px;
        border-width: 2px;
        border-radius: 6px;
    }
    
    .agenda-cell:hover {
        transform: scale(1.03);
    }
    
    .date-header {
        min-width: 65px;
        padding: 12px 6px;
        font-size: 0.85rem;
        border-width: 2px;
        border-radius: 8px;
    }
    
    .date-header:hover {
        transform: translateY(-1px);
    }
    
    .sticky-col-header {
        padding: 14px 16px;
        font-size: 0.9rem;
        border-width: 2px;
        border-radius: 8px;
    }
    
    .employee-name {
        font-size: 0.85rem;
        max-width: 100px;
    }
}
</style>

<script>
(function syncNineDays(){
    function toISO(d){
        const pad=n=>String(n).padStart(2,'0');
        return d.getFullYear()+"-"+pad(d.getMonth()+1)+"-"+pad(d.getDate());
    }
    function addDays(date, days){
        const d = new Date(date.getTime());
        d.setDate(d.getDate()+days);
        return d;
    }
    function parseInput(el){
        const v = el.value;
        if(!v) return null;
        const parts = v.split('-');
        if(parts.length!==3) return null;
        return new Date(Number(parts[0]), Number(parts[1])-1, Number(parts[2]));
    }
    const fromEl = document.getElementById('fromDate');
    const toEl = document.getElementById('toDate');
    if(!fromEl || !toEl) return;
    
    function ensureNineFromFrom(){
        const f = parseInput(fromEl);
        if(!f) return;
        const t = addDays(f, 8);
        toEl.value = toISO(t);
        // Visual feedback
        toEl.style.borderColor = '#667eea';
        toEl.style.transition = 'border-color 0.3s ease';
        setTimeout(() => {
            toEl.style.borderColor = '';
        }, 1000);
    }
    function ensureNineFromTo(){
        const t = parseInput(toEl);
        if(!t) return;
        const f = addDays(t, -8);
        fromEl.value = toISO(f);
        // Visual feedback
        fromEl.style.borderColor = '#667eea';
        fromEl.style.transition = 'border-color 0.3s ease';
        setTimeout(() => {
            fromEl.style.borderColor = '';
        }, 1000);
    }
    fromEl.addEventListener('change', ensureNineFromFrom);
    toEl.addEventListener('change', ensureNineFromTo);
    
    // Initialize on load
    (function init(){
        const f = parseInput(fromEl);
        const t = parseInput(toEl);
        if(f && t){
            const diff = Math.round((t - f) / (24*60*60*1000));
            if(diff !== 8){ ensureNineFromFrom(); }
        } else if(f){ ensureNineFromFrom(); }
        else if(t){ ensureNineFromTo(); }
    })();
})();
</script>
