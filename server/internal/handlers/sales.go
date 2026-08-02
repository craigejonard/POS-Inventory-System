package handlers

import (
	"net/http"

	"pos-inventory-system/internal/database"
	"pos-inventory-system/internal/models"

	"github.com/gin-gonic/gin"
)

func GetSales(c *gin.Context) {
	rows, err := database.DB.Query("SELECT id, total, created_at FROM sales ORDER BY created_at DESC")
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	defer rows.Close()

	var sales []models.Sale
	for rows.Next() {
		var s models.Sale
		if err := rows.Scan(&s.ID, &s.Total, &s.CreatedAt); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		sales = append(sales, s)
	}
	c.JSON(http.StatusOK, sales)
}

func CreateSale(c *gin.Context) {
	var sale models.Sale
	if err := c.ShouldBindJSON(&sale); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	tx, err := database.DB.Begin()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	var total float64
	for i := range sale.Items {
		sale.Items[i].Subtotal = sale.Items[i].Price * float64(sale.Items[i].Quantity)
		total += sale.Items[i].Subtotal
	}
	sale.Total = total

	result, err := tx.Exec("INSERT INTO sales (total) VALUES (?)", sale.Total)
	if err != nil {
		tx.Rollback()
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	sale.ID, _ = result.LastInsertId()

	for _, item := range sale.Items {
		_, err := tx.Exec(
			"INSERT INTO sale_items (sale_id, product_id, product_name, price, quantity, subtotal) VALUES (?, ?, ?, ?, ?, ?)",
			sale.ID, item.ProductID, item.Name, item.Price, item.Quantity, item.Subtotal)
		if err != nil {
			tx.Rollback()
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}

		_, err = tx.Exec("UPDATE products SET quantity = quantity - ? WHERE id = ?", item.Quantity, item.ProductID)
		if err != nil {
			tx.Rollback()
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
	}

	if err := tx.Commit(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, sale)
}
