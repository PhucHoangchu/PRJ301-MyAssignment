<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.iam.User" %>
<%@page import="model.core.Employee" %>
<%@page import="model.core.Division" %>
<jsp:include page="../util/header.jsp" />

<!-- Page Header -->
<div class="page-header" style="margin-bottom: 32px;">
    <div>
        <h1 style="font-size: 2rem; font-weight: 700; color: var(--text-primary); margin: 0 0 8px 0; display: flex; align-items: center; gap: 12px;">
            <i class="fas fa-file-alt" style="color: #667eea;"></i>
            Đơn xin nghỉ phép
        </h1>
        <p style="color: var(--text-secondary); margin: 0;">Tạo đơn xin nghỉ phép mới</p>
    </div>
</div>

<!-- Form Card -->
<div class="card" style="max-width: 800px; margin: 0 auto;">
    <div class="card-header">
        <h3 class="card-title">
            <i class="fas fa-calendar-check"></i>
            Thông tin đơn nghỉ phép
        </h3>
    </div>
    <div class="card-body">
        <!-- User Info Section -->
        <div class="user-info-section" style="background: linear-gradient(135deg, #f8f9ff 0%, #f0f4ff 100%); padding: 20px; border-radius: var(--border-radius-sm); margin-bottom: 28px; border-left: 4px solid #667eea;">
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px;">
                <%
                    User u = (User) session.getAttribute("auth");
                    String userName = (u != null && u.getEmployee() != null && u.getEmployee().getName() != null) ? u.getEmployee().getName() : "Unknown";
                    String roleName = "";
                    if (u != null && u.getRoles() != null && !u.getRoles().isEmpty() && u.getRoles().get(0).getName() != null) {
                        roleName = u.getRoles().get(0).getName();
                    }
                    String depName = (u != null && u.getEmployee() != null && u.getEmployee().getDivision() != null && u.getEmployee().getDivision().getName() != null)
                            ? u.getEmployee().getDivision().getName() : "N/A";
                %>
                <div style="display: flex; align-items: center; gap: 10px;">
                    <div style="width: 40px; height: 40px; border-radius: 50%; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); display: flex; align-items: center; justify-content: center; color: white; font-weight: 600;">
                        <i class="fas fa-user"></i>
                    </div>
                    <div>
                        <div style="font-size: 0.85rem; color: var(--text-secondary);">Người tạo</div>
                        <div style="font-weight: 600; color: var(--text-primary);"><%= userName %></div>
                    </div>
                </div>
                <div style="display: flex; align-items: center; gap: 10px;">
                    <div style="width: 40px; height: 40px; border-radius: 50%; background: linear-gradient(135deg, #48bb78 0%, #38a169 100%); display: flex; align-items: center; justify-content: center; color: white; font-weight: 600;">
                        <i class="fas fa-user-tag"></i>
                    </div>
                    <div>
                        <div style="font-size: 0.85rem; color: var(--text-secondary);">Chức danh</div>
                        <div style="font-weight: 600; color: var(--text-primary);"><%= roleName %></div>
                    </div>
                </div>
                <div style="display: flex; align-items: center; gap: 10px;">
                    <div style="width: 40px; height: 40px; border-radius: 50%; background: linear-gradient(135deg, #06b6d4 0%, #0891b2 100%); display: flex; align-items: center; justify-content: center; color: white; font-weight: 600;">
                        <i class="fas fa-building"></i>
                    </div>
                    <div>
                        <div style="font-size: 0.85rem; color: var(--text-secondary);">Phòng ban</div>
                        <div style="font-weight: 600; color: var(--text-primary);"><%= depName %></div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Error Message -->
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error" style="margin-bottom: 24px;">
                <i class="fas fa-exclamation-circle"></i>
                <span><%= request.getAttribute("error") %></span>
            </div>
        <% } %>

        <!-- Form -->
        <form action="${pageContext.request.contextPath}/request/create" method="post" id="leaveRequestForm">
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin-bottom: 24px;">
                <div class="form-field">
                    <label for="from" style="display: flex; align-items: center; gap: 8px; margin-bottom: 8px; font-weight: 600; color: var(--text-primary);">
                        <i class="fas fa-calendar-alt" style="color: #667eea;"></i>
                        Từ ngày <span style="color: var(--danger-color);">*</span>
                    </label>
                    <div style="position: relative;">
                        <input 
                            type="date" 
                            id="from" 
                            name="from" 
                            required 
                            style="width: 100%; padding: 14px 16px; padding-left: 44px; border: 2px solid var(--border-color); border-radius: var(--border-radius-sm); font-size: 15px; transition: all 0.3s ease; background: white;"
                            onchange="validateDateRange()"
                        >
                        <i class="fas fa-calendar-alt" style="position: absolute; left: 16px; top: 50%; transform: translateY(-50%); color: var(--text-secondary); pointer-events: none;"></i>
                    </div>
                    <div style="font-size: 0.85rem; color: var(--text-secondary); margin-top: 6px;">
                        <i class="fas fa-info-circle"></i> Ngày bắt đầu nghỉ phép
                    </div>
                </div>
                
                <div class="form-field">
                    <label for="to" style="display: flex; align-items: center; gap: 8px; margin-bottom: 8px; font-weight: 600; color: var(--text-primary);">
                        <i class="fas fa-calendar-check" style="color: #48bb78;"></i>
                        Tới ngày <span style="color: var(--danger-color);">*</span>
                    </label>
                    <div style="position: relative;">
                        <input 
                            type="date" 
                            id="to" 
                            name="to" 
                            required 
                            style="width: 100%; padding: 14px 16px; padding-left: 44px; border: 2px solid var(--border-color); border-radius: var(--border-radius-sm); font-size: 15px; transition: all 0.3s ease; background: white;"
                            onchange="validateDateRange()"
                        >
                        <i class="fas fa-calendar-check" style="position: absolute; left: 16px; top: 50%; transform: translateY(-50%); color: var(--text-secondary); pointer-events: none;"></i>
                    </div>
                    <div style="font-size: 0.85rem; color: var(--text-secondary); margin-top: 6px;">
                        <i class="fas fa-info-circle"></i> Ngày kết thúc nghỉ phép
                    </div>
                </div>
            </div>

            <div class="form-field" style="margin-bottom: 24px;">
                <label for="leave_type" style="display: flex; align-items: center; gap: 8px; margin-bottom: 8px; font-weight: 600; color: var(--text-primary);">
                    <i class="fas fa-tags" style="color: #8b5cf6;"></i>
                    Loại nghỉ phép <span style="color: var(--danger-color);">*</span>
                </label>
                <div style="position: relative;">
                    <select 
                        id="leave_type" 
                        name="leave_type" 
                        required
                        style="width: 100%; padding: 14px 16px; padding-left: 44px; border: 2px solid var(--border-color); border-radius: var(--border-radius-sm); font-size: 15px; transition: all 0.3s ease; background: white; cursor: pointer; appearance: none;"
                    >
                        <option value="">-- Chọn loại nghỉ phép --</option>
                        <option value="annual">🏖️ Nghỉ phép năm</option>
                        <option value="sick">🏥 Nghỉ ốm</option>
                        <option value="personal">👤 Việc riêng</option>
                        <option value="unpaid">💼 Nghỉ không lương</option>
                        <option value="maternity">👶 Nghỉ thai sản</option>
                        <option value="paternity">👨‍👩‍👦 Nghỉ chăm sóc con</option>
                        <option value="other">📝 Khác</option>
                    </select>
                    <i class="fas fa-tags" style="position: absolute; left: 16px; top: 50%; transform: translateY(-50%); color: var(--text-secondary); pointer-events: none;"></i>
                    <i class="fas fa-chevron-down" style="position: absolute; right: 16px; top: 50%; transform: translateY(-50%); color: var(--text-secondary); pointer-events: none;"></i>
                </div>
                <div style="font-size: 0.85rem; color: var(--text-secondary); margin-top: 6px;">
                    <i class="fas fa-info-circle"></i> Vui lòng chọn loại nghỉ phép phù hợp
                </div>
            </div>

            <div class="form-field" style="margin-bottom: 28px;">
                <label for="reason" style="display: flex; align-items: center; gap: 8px; margin-bottom: 8px; font-weight: 600; color: var(--text-primary);">
                    <i class="fas fa-comment-alt" style="color: #f59e0b;"></i>
                    Lý do <span style="color: var(--danger-color);">*</span>
                </label>
                <div style="position: relative;">
                    <textarea 
                        id="reason" 
                        name="reason" 
                        placeholder="Nhập lý do xin nghỉ phép của bạn..." 
                        required 
                        rows="6"
                        style="width: 100%; padding: 16px; padding-left: 44px; border: 2px solid var(--border-color); border-radius: var(--border-radius-sm); font-size: 15px; font-family: inherit; resize: vertical; transition: all 0.3s ease; background: white; min-height: 140px;"
                        oninput="updateCharCount()"
                    ></textarea>
                    <i class="fas fa-comment-alt" style="position: absolute; left: 16px; top: 16px; color: var(--text-secondary); pointer-events: none;"></i>
                </div>
                <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 6px;">
                    <div style="font-size: 0.85rem; color: var(--text-secondary);">
                        <i class="fas fa-info-circle"></i> Vui lòng mô tả rõ lý do xin nghỉ phép
                    </div>
                    <div id="charCount" style="font-size: 0.85rem; color: var(--text-secondary);">0 ký tự</div>
                </div>
            </div>

            <!-- Form Actions -->
            <div style="display: flex; justify-content: flex-end; gap: 12px; padding-top: 24px; border-top: 1px solid var(--border-color);">
                <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary">
                    <i class="fas fa-times"></i>
                    Hủy
                </a>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-paper-plane"></i>
                    Gửi đơn
                </button>
            </div>
        </form>
    </div>
</div>

<jsp:include page="../util/footer.jsp" />

<style>
.page-header {
    margin-bottom: 32px;
}

.form-field input:focus,
.form-field textarea:focus,
.form-field select:focus {
    outline: none;
    border-color: #667eea;
    box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
}

.form-field input:hover,
.form-field textarea:hover,
.form-field select:hover {
    border-color: #cbd5e0;
}

.alert {
    padding: 16px 20px;
    border-radius: 10px;
    margin-bottom: 20px;
    border-left: 4px solid;
    display: flex;
    align-items: center;
    gap: 12px;
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

.user-info-section {
    animation: fadeInUp 0.5s ease-out;
}

@keyframes fadeInUp {
    from {
        opacity: 0;
        transform: translateY(10px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

@media (max-width: 768px) {
    .page-header h1 {
        font-size: 1.5rem;
    }
    
    .user-info-section > div {
        grid-template-columns: 1fr;
    }
    
    .form-field input,
    .form-field textarea {
        font-size: 16px; /* Prevent zoom on iOS */
    }
}
</style>

<script>
function validateDateRange() {
    const fromDate = document.getElementById('from').value;
    const toDate = document.getElementById('to').value;
    
    if (fromDate && toDate) {
        if (new Date(fromDate) > new Date(toDate)) {
            alert('Ngày bắt đầu không được sau ngày kết thúc!');
            document.getElementById('to').value = '';
        }
    }
}

function updateCharCount() {
    const textarea = document.getElementById('reason');
    const charCount = document.getElementById('charCount');
    const length = textarea.value.length;
    charCount.textContent = length + ' ký tự';
    
    if (length > 500) {
        charCount.style.color = 'var(--danger-color)';
    } else if (length > 300) {
        charCount.style.color = 'var(--warning-color)';
    } else {
        charCount.style.color = 'var(--text-secondary)';
    }
}

// Set minimum date to today
document.addEventListener('DOMContentLoaded', function() {
    const today = new Date().toISOString().split('T')[0];
    document.getElementById('from').setAttribute('min', today);
    document.getElementById('to').setAttribute('min', today);
    
    // Auto-update 'to' date min when 'from' date changes
    document.getElementById('from').addEventListener('change', function() {
        const fromDate = this.value;
        if (fromDate) {
            document.getElementById('to').setAttribute('min', fromDate);
        }
    });
});
</script>
