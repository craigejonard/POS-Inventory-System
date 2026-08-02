package com.pos.inventory.data.api

import com.pos.inventory.data.api.dto.CreateSaleRequest
import com.pos.inventory.data.api.dto.ProductDto
import com.pos.inventory.data.api.dto.SaleDto
import com.pos.inventory.data.api.dto.DashboardStatsDto
import retrofit2.http.*

interface ApiService {

    @GET("products")
    suspend fun getProducts(): List<ProductDto>

    @GET("products/{id}")
    suspend fun getProduct(@Path("id") id: Long): ProductDto

    @POST("products")
    suspend fun createProduct(@Body product: ProductDto): ProductDto

    @PUT("products/{id}")
    suspend fun updateProduct(@Path("id") id: Long, @Body product: ProductDto)

    @DELETE("products/{id}")
    suspend fun deleteProduct(@Path("id") id: Long)

    @GET("sales")
    suspend fun getSales(): List<SaleDto>

    @POST("sales")
    suspend fun createSale(@Body sale: CreateSaleRequest): SaleDto

    @GET("dashboard/stats")
    suspend fun getDashboardStats(): DashboardStatsDto
}
