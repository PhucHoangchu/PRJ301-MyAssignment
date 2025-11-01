/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */
// Form validation functionality
document.addEventListener('DOMContentLoaded', function() {
    initializeFormValidation();
});

function initializeFormValidation() {
    const forms = document.querySelectorAll('form[data-validate]');
    
    forms.forEach(form => {
        form.addEventListener('submit', handleFormSubmit);
        
        // Real-time validation
        const inputs = form.querySelectorAll('input, textarea, select');
        inputs.forEach(input => {
            input.addEventListener('blur', validateField);
            input.addEventListener('input', clearFieldError);
        });
    });
}

function handleFormSubmit(event) {
    const form = event.target;
    const isValid = validateForm(form);
    
    if (!isValid) {
        event.preventDefault();
        showFormErrors(form);
    } else {
        // Show loading state
        showFormLoading(form);
    }
}

function validateForm(form) {
    let isValid = true;
    const inputs = form.querySelectorAll('input[required], textarea[required], select[required]');
    
    inputs.forEach(input => {
        if (!validateField({ target: input })) {
            isValid = false;
        }
    });
    
    // Custom validations
    if (form.id === 'create-request-form') {
        isValid = validateDateRange(form) && isValid;
    }
    
    return isValid;
}

function validateField(event) {
    const field = event.target;
    const value = field.value.trim();
    const fieldName = field.name;
    let isValid = true;
    let errorMessage = '';
    
    // Required field validation
    if (field.hasAttribute('required') && !value) {
        isValid = false;
        errorMessage = `${getFieldLabel(field)} is required`;
    }
    
    // Email validation
    if (field.type === 'email' && value) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(value)) {
            isValid = false;
            errorMessage = 'Please enter a valid email address';
        }
    }
    
    // Password validation (allow short demo passwords like "123")
    if (field.type === 'password' && value) {
        if (value.length < 3) {
            isValid = false;
            errorMessage = 'Password must be at least 3 characters long';
        }
    }
    
    // Date validation
    if (field.type === 'date' && value) {
        const selectedDate = new Date(value);
        const today = new Date();
        today.setHours(0, 0, 0, 0);
        
        if (selectedDate < today) {
            isValid = false;
            errorMessage = 'Date cannot be in the past';
        }
    }
    
    // Text length validation
    if (field.hasAttribute('maxlength')) {
        const maxLength = parseInt(field.getAttribute('maxlength'));
        if (value.length > maxLength) {
            isValid = false;
            errorMessage = `Maximum ${maxLength} characters allowed`;
        }
    }
    
    // Show/hide error
    if (isValid) {
        clearFieldError({ target: field });
    } else {
        showFieldError(field, errorMessage);
    }
    
    return isValid;
}

function validateDateRange(form) {
    const fromDate = form.querySelector('input[name="from"]');
    const toDate = form.querySelector('input[name="to"]');
    
    if (!fromDate || !toDate) return true;
    
    const from = new Date(fromDate.value);
    const to = new Date(toDate.value);
    
    if (from >= to) {
        showFieldError(toDate, 'End date must be after start date');
        return false;
    }
    
    // Check if date range is reasonable (not more than 30 days)
    const diffTime = Math.abs(to - from);
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    
    if (diffDays > 30) {
        showFieldError(toDate, 'Leave period cannot exceed 30 days');
        return false;
    }
    
    return true;
}

function showFieldError(field, message) {
    field.classList.add('error');
    
    // Remove existing error message
    const existingError = field.parentNode.querySelector('.field-error');
    if (existingError) {
        existingError.remove();
    }
    
    // Add new error message
    const errorDiv = document.createElement('div');
    errorDiv.className = 'field-error';
    errorDiv.textContent = message;
    errorDiv.style.cssText = `
        color: #dc3545;
        font-size: 14px;
        margin-top: 5px;
        display: block;
    `;
    
    field.parentNode.appendChild(errorDiv);
}

function clearFieldError(event) {
    const field = event.target;
    field.classList.remove('error');
    
    const errorDiv = field.parentNode.querySelector('.field-error');
    if (errorDiv) {
        errorDiv.remove();
    }
}

function showFormErrors(form) {
    const firstError = form.querySelector('.error');
    if (firstError) {
        firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
        firstError.focus();
    }
    
    AppUtils.showNotification('Please correct the errors in the form', 'error');
}

function showFormLoading(form) {
    const submitButton = form.querySelector('button[type="submit"]');
    if (submitButton) {
        const originalText = submitButton.textContent;
        submitButton.textContent = 'Processing...';
        submitButton.disabled = true;
        
        // Add loading spinner
        const spinner = document.createElement('span');
        spinner.className = 'loading';
        spinner.style.marginRight = '8px';
        submitButton.insertBefore(spinner, submitButton.firstChild);
        
        // Re-enable after 5 seconds (fallback)
        setTimeout(() => {
            submitButton.textContent = originalText;
            submitButton.disabled = false;
            const spinner = submitButton.querySelector('.loading');
            if (spinner) spinner.remove();
        }, 5000);
    }
}

function getFieldLabel(field) {
    const label = field.parentNode.querySelector('label');
    if (label) {
        return label.textContent.replace(':', '');
    }
    
    // Fallback to field name
    return field.name.charAt(0).toUpperCase() + field.name.slice(1);
}

// Real-time character counter
function initializeCharacterCounters() {
    const textareas = document.querySelectorAll('textarea[maxlength]');
    
    textareas.forEach(textarea => {
        const maxLength = parseInt(textarea.getAttribute('maxlength'));
        const counter = document.createElement('div');
        counter.className = 'character-counter';
        counter.style.cssText = `
            text-align: right;
            font-size: 12px;
            color: #6c757d;
            margin-top: 5px;
        `;
        
        textarea.parentNode.appendChild(counter);
        
        function updateCounter() {
            const currentLength = textarea.value.length;
            counter.textContent = `${currentLength}/${maxLength}`;
            
            if (currentLength > maxLength * 0.9) {
                counter.style.color = '#dc3545';
            } else if (currentLength > maxLength * 0.8) {
                counter.style.color = '#ffc107';
            } else {
                counter.style.color = '#6c757d';
            }
        }
        
        textarea.addEventListener('input', updateCounter);
        updateCounter(); // Initial count
    });
}

// Initialize character counters when DOM is loaded
document.addEventListener('DOMContentLoaded', initializeCharacterCounters);

