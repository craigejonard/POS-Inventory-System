package com.pos.inventory.data.api.dto

import com.google.gson.annotations.SerializedName

data class ProductDto(
    val id: Long = 0,
    val name: String = "",
    val sku: String = "",
    val price: Double = 0.0,
    val quantity: Int = 0,
    val category: String = "",
    @SerializedName("created_at") val createdAt: String = "",
    @SerializedName("updated_at") val updatedAt: String = "",
)

data class SaleDto(
    val id: Long = 0,
    val items: List<SaleItemDto> = emptyList(),
    val total: Double = 0.0,
    @SerializedName("created_at") val createdAt: String = "",
)

data class SaleItemDto(
    @SerializedName("product_id") val productId: Long = 0,
    @SerializedName("product_name") val productName: String = "",
    val price: Double = 0.0,
    val quantity: Int = 0,
    val subtotal: Double = 0.0,
)

data class CreateSaleRequest(
    val items: List<SaleItemDto>,
)

data class DashboardStatsDto(
    @SerializedName("total_products") val totalProducts: Int = 0,
    @SerializedName("low_stock_count") val lowStockCount: Int = 0,
    @SerializedName("today_sales") val todaySales: Int = 0,
    @SerializedName("today_revenue") val todayRevenue: Double = 0.0,
)
