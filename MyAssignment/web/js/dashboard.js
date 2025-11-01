/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

/* global AppUtils */

// Dashboard-specific functionality
document.addEventListener('DOMContentLoaded', function() {
    if (window.location.pathname.includes('/home')) {
        initializeDashboardFeatures();
    }
});

function initializeDashboardFeatures() {
    // Initialize dashboard widgets
    initializeStatsCards();
    initializeRecentRequests();
    initializeQuickActions();
    initializeNotifications();
    
    // Initialize auto-refresh
    initializeAutoRefresh();
}

function initializeStatsCards() {
    const statCards = document.querySelectorAll('.stat-card');
    
    statCards.forEach(card => {
        card.addEventListener('click', function() {
            const statType = this.getAttribute('data-stat-type');
            filterRequestsByStatus(statType);
        });
        
        // Add hover effect
        card.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-8px) scale(1.02)';
        });
        
        card.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0) scale(1)';
        });
    });
}

function filterRequestsByStatus(status) {
    const statusMap = {
        'total': null,
        'pending': 0,
        'approved': 1,
        'rejected': 2
    };
    
    const targetStatus = statusMap[status];
    const requestRows = document.querySelectorAll('.request-row');
    const tbody = document.querySelector('.table-container tbody');
    let visibleCount = 0;
    
    requestRows.forEach(row => {
        if (targetStatus === null) {
            // Show all
            row.style.display = '';
            visibleCount++;
        } else {
            // Filter by status
            const rowStatus = parseInt(row.getAttribute('data-status'));
            if (rowStatus === targetStatus) {
                row.style.display = '';
                visibleCount++;
            } else {
                row.style.display = 'none';
            }
        }
    });
    
    // Update active filter
    document.querySelectorAll('.stat-card').forEach(card => {
        card.classList.remove('active');
    });
    
    const activeCard = document.querySelector(`[data-stat-type="${status}"]`);
    if (activeCard) {
        activeCard.classList.add('active');
    }
    
    // Show message if no requests match filter
    let emptyRow = tbody.querySelector('.empty-filter-row');
    if (visibleCount === 0 && targetStatus !== null) {
        if (!emptyRow) {
            emptyRow = document.createElement('tr');
            emptyRow.className = 'empty-filter-row';
            emptyRow.innerHTML = `
                <td colspan="5" class="text-center">
                    <div class="empty-state">
                        <i class="fas fa-filter empty-state-icon"></i>
                        <h4 class="empty-state-title">No ${status} requests found</h4>
                        <p class="empty-state-message">There are no requests with this status.</p>
                    </div>
                </td>
            `;
            tbody.appendChild(emptyRow);
        }
        emptyRow.style.display = '';
    } else {
        if (emptyRow) {
            emptyRow.style.display = 'none';
        }
    }
}

function initializeRecentRequests() {
    // Removed request details modal functionality
}

// Modal functionality completely removed - request rows are no longer clickable
// Users should view request details via the /request/list page instead

function initializeQuickActions() {
    const quickActionButtons = document.querySelectorAll('.quick-action');
    
    quickActionButtons.forEach(button => {
        button.addEventListener('click', function() {
            const action = this.getAttribute('data-action');
            handleQuickAction(action);
        });
    });
}

function handleQuickAction(action) {
    switch (action) {
        case 'create-request':
            window.location.href = '../request/create';
            break;
        case 'view-requests':
            window.location.href = '../request/list';
            break;
        case 'review-requests':
            window.location.href = '../request/review';
            break;
        case 'view-agenda':
            window.location.href = '../division/agenda';
            break;
        default:
            console.log('Unknown quick action:', action);
    }
}

function initializeNotifications() {
    // Check for new notifications
    checkForNotifications();
    
    // Set up periodic notification check
    setInterval(checkForNotifications, 60000); // Every minute
}

function checkForNotifications() {
    // Simulate checking for notifications
    const hasNewNotifications = Math.random() > 0.7; // 30% chance
    
    if (hasNewNotifications) {
        showNotificationBadge();
    }
}

function showNotificationBadge() {
    const notificationIcon = document.querySelector('.notification-icon');
    if (notificationIcon) {
        notificationIcon.classList.add('has-notifications');
        
        // Add notification count
        const badge = document.createElement('span');
        badge.className = 'notification-badge';
        badge.textContent = '1';
        badge.style.cssText = `
            position: absolute;
            top: -8px;
            right: -8px;
            background: #dc3545;
            color: white;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            font-size: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
        `;
        
        notificationIcon.appendChild(badge);
    }
}

function initializeAutoRefresh() {
    // Auto-refresh dashboard every 5 minutes
    setInterval(() => {
        if (document.visibilityState === 'visible') {
            refreshDashboard();
        }
    }, 300000); // 5 minutes
}

function refreshDashboard() {
    // Show refresh indicator
    const refreshIndicator = document.createElement('div');
    refreshIndicator.className = 'refresh-indicator';
    refreshIndicator.innerHTML = '<span class="loading"></span> Refreshing...';
    refreshIndicator.style.cssText = `
        position: fixed;
        top: 20px;
        left: 50%;
        transform: translateX(-50%);
        background: rgba(0,0,0,0.8);
        color: white;
        padding: 10px 20px;
        border-radius: 20px;
        z-index: 1000;
        font-size: 14px;
    `;
    
    document.body.appendChild(refreshIndicator);
    
    // Simulate refresh
    setTimeout(() => {
        refreshIndicator.remove();
        AppUtils.showNotification('Dashboard refreshed', 'success');
    }, 2000);
}

// Export dashboard functions
window.Dashboard = {
    filterRequestsByStatus,
    handleQuickAction
};
