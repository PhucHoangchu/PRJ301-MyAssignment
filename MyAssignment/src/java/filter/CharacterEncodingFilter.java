package filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import java.io.IOException;

/**
 * Filter để set UTF-8 encoding cho tất cả requests và responses
 * Giúp xử lý tiếng Việt đúng cách
 * 
 * @author MWG
 */
public class CharacterEncodingFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Không cần init
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        // QUAN TRỌNG: Set encoding cho request TRƯỚC khi servlet đọc parameters
        // Nếu không set ở đây, request.getParameter() sẽ dùng encoding mặc định (ISO-8859-1)
        if (request.getCharacterEncoding() == null) {
            request.setCharacterEncoding("UTF-8");
        }
        
        // Set encoding cho response
        response.setCharacterEncoding("UTF-8");
        if (response.getContentType() == null || !response.getContentType().contains("charset")) {
            response.setContentType("text/html; charset=UTF-8");
        }
        
        // Tiếp tục filter chain
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Không cần cleanup
    }
}

