package handlers

import (
	"net/http"

	"pos-inventory-system/internal/database"
	"pos-inventory-system/internal/models"

	"github.com/gin-gonic/gin"
)

func GetDashboardStats(c *gin.Context) {
	var stats models.DashboardStats

	database.DB.QueryRow("SELECT COUNT(*) FROM products").Scan(&stats.TotalProducts)
	database.DB.QueryRow("SELECT COUNT(*) FROM products WHERE quantity <= 5").Scan(&stats.LowStockCount)
	database.DB.QueryRow("SELECT COUNT(*) FROM sales WHERE DATE(created_at) = DATE('now')").Scan(&stats.TodaySales)
	database.DB.QueryRow("SELECT COALESCE(SUM(total), 0) FROM sales WHERE DATE(created_at) = DATE('now')").Scan(&stats.TodayRevenue)

	c.JSON(http.StatusOK, stats)
}
