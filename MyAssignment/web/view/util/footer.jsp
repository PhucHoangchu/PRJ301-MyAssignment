    <% if (session.getAttribute("auth") != null) { %>
        </div>
    </main>
    
    <!-- Footer -->
    <footer class="footer">
        <div class="container">
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