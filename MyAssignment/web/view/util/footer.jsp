    <% if (session.getAttribute("auth") != null) { %>
        </div>
    </main>
    
    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="footer-content">
                <div class="footer-section">
                    <h4>Leave Management System</h4>
                    <p>Streamline your leave requests and approvals</p>
                </div>
                <div class="footer-section">
                    <h4>Quick Links</h4>
                    <ul>
                        <li><a href="${pageContext.request.contextPath}/home"><i class="fas fa-home"></i> Home</a></li>
                        <li><a href="${pageContext.request.contextPath}/request/create"><i class="fas fa-plus-circle"></i> Create Request</a></li>
                        <li><a href="${pageContext.request.contextPath}/request/list"><i class="fas fa-list"></i> My Requests</a></li>
                        <li><a href="${pageContext.request.contextPath}/division/agenda"><i class="fas fa-users"></i> Division Agenda</a></li>
                    </ul>
                </div>
                
            </div>
            <div class="footer-bottom">
                <p>&copy; 2024 Leave Management System. All rights reserved.</p>
            </div>
        </div>
    </footer>
    <% } else { %>
    </div>
    <% } %>
    
    <!-- JavaScript -->
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    <script src="${pageContext.request.contextPath}/js/form-validation.js"></script>
    <script src="${pageContext.request.contextPath}/js/dashboard.js"></script>
</body>
</html>