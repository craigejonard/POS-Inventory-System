package handlers

import (
	"net/http"

	"pos-inventory-system/internal/database"
	"pos-inventory-system/internal/models"

	"github.com/gin-gonic/gin"
)

func GetProducts(c *gin.Context) {
	rows, err := database.DB.Query(
		"SELECT id, name, sku, price, quantity, category, created_at, updated_at FROM products ORDER BY name")
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	defer rows.Close()

	var products []models.Product
	for rows.Next() {
		var p models.Product
		if err := rows.Scan(&p.ID, &p.Name, &p.SKU, &p.Price, &p.Quantity, &p.Category, &p.CreatedAt, &p.UpdatedAt); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		products = append(products, p)
	}
	c.JSON(http.StatusOK, products)
}

func GetProduct(c *gin.Context) {
	id := c.Param("id")
	var p models.Product
	err := database.DB.QueryRow(
		"SELECT id, name, sku, price, quantity, category, created_at, updated_at FROM products WHERE id = ?", id).
		Scan(&p.ID, &p.Name, &p.SKU, &p.Price, &p.Quantity, &p.Category, &p.CreatedAt, &p.UpdatedAt)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "product not found"})
		return
	}
	c.JSON(http.StatusOK, p)
}

func CreateProduct(c *gin.Context) {
	var p models.Product
	if err := c.ShouldBindJSON(&p); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	result, err := database.DB.Exec(
		"INSERT INTO products (name, sku, price, quantity, category) VALUES (?, ?, ?, ?, ?)",
		p.Name, p.SKU, p.Price, p.Quantity, p.Category)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	p.ID, _ = result.LastInsertId()
	c.JSON(http.StatusCreated, p)
}

func UpdateProduct(c *gin.Context) {
	id := c.Param("id")
	var p models.Product
	if err := c.ShouldBindJSON(&p); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	_, err := database.DB.Exec(
		"UPDATE products SET name = ?, sku = ?, price = ?, quantity = ?, category = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?",
		p.Name, p.SKU, p.Price, p.Quantity, p.Category, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "product updated"})
}

func DeleteProduct(c *gin.Context) {
	id := c.Param("id")
	_, err := database.DB.Exec("DELETE FROM products WHERE id = ?", id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "product deleted"})
}
