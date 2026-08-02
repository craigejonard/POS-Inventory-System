package models

import "time"

type Product struct {
	ID        int64     `json:"id"`
	Name      string    `json:"name"`
	SKU       string    `json:"sku"`
	Price     float64   `json:"price"`
	Quantity  int       `json:"quantity"`
	Category  string    `json:"category"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

type Sale struct {
	ID        int64      `json:"id"`
	Items     []SaleItem `json:"items"`
	Total     float64    `json:"total"`
	CreatedAt time.Time  `json:"created_at"`
}

type SaleItem struct {
	ID        int64   `json:"id"`
	SaleID    int64   `json:"sale_id"`
	ProductID int64   `json:"product_id"`
	Name      string  `json:"product_name"`
	Price     float64 `json:"price"`
	Quantity  int     `json:"quantity"`
	Subtotal  float64 `json:"subtotal"`
}

type DashboardStats struct {
	TotalProducts  int     `json:"total_products"`
	LowStockCount  int     `json:"low_stock_count"`
	TodaySales     int     `json:"today_sales"`
	TodayRevenue   float64 `json:"today_revenue"`
}
