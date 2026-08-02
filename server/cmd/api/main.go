package main

import (
	"log"

	"pos-inventory-system/internal/database"
	"pos-inventory-system/internal/handlers"

	"github.com/gin-gonic/gin"
)

func main() {
	database.Init("pos.db")

	r := gin.Default()

	r.LoadHTMLGlob("templates/**/*")
	r.Static("/static", "./static")

	r.GET("/", func(c *gin.Context) {
		c.HTML(200, "pages/dashboard.html", nil)
	})

	api := r.Group("/api")
	{
		api.GET("/products", handlers.GetProducts)
		api.GET("/products/:id", handlers.GetProduct)
		api.POST("/products", handlers.CreateProduct)
		api.PUT("/products/:id", handlers.UpdateProduct)
		api.DELETE("/products/:id", handlers.DeleteProduct)

		api.GET("/sales", handlers.GetSales)
		api.POST("/sales", handlers.CreateSale)

		api.GET("/dashboard/stats", handlers.GetDashboardStats)
	}

	log.Println("Server starting on :8080")
	r.Run(":8080")
}
