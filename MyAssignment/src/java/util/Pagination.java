package util;

/**
 * Utility class để quản lý thông tin pagination
 */
public class Pagination {
    private int currentPage;
    private int pageSize;
    private int totalRecords;
    private int totalPages;

    public Pagination(int currentPage, int pageSize, int totalRecords) {
        this.pageSize = pageSize > 0 ? pageSize : 10; // Default 10
        this.totalRecords = totalRecords;
        this.totalPages = (int) Math.ceil((double) totalRecords / this.pageSize);
        
        // Đảm bảo currentPage hợp lệ
        if (currentPage < 1) {
            this.currentPage = 1;
        } else if (currentPage > totalPages && totalPages > 0) {
            this.currentPage = totalPages;
        } else {
            this.currentPage = currentPage;
        }
    }

    public int getCurrentPage() {
        return currentPage;
    }

    public int getPageSize() {
        return pageSize;
    }

    public int getTotalRecords() {
        return totalRecords;
    }

    public int getTotalPages() {
        return totalPages;
    }

    /**
     * Tính offset để dùng trong SQL OFFSET clause
     */
    public int getOffset() {
        return (currentPage - 1) * pageSize;
    }

    /**
     * Kiểm tra có trang tiếp theo không
     */
    public boolean hasNext() {
        return currentPage < totalPages;
    }

    /**
     * Kiểm tra có trang trước đó không
     */
    public boolean hasPrevious() {
        return currentPage > 1;
    }

    /**
     * Lấy số record bắt đầu của trang hiện tại (cho hiển thị)
     */
    public int getStartRecord() {
        if (totalRecords == 0) {
            return 0;
        }
        return (currentPage - 1) * pageSize + 1;
    }

    /**
     * Lấy số record kết thúc của trang hiện tại (cho hiển thị)
     */
    public int getEndRecord() {
        int end = currentPage * pageSize;
        return end > totalRecords ? totalRecords : end;
    }
}