package com.pos.inventory.data.local

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "products")
data class ProductEntity(
    @PrimaryKey val id: Long,
    val name: String,
    val sku: String,
    val price: Double,
    val quantity: Int,
    val category: String,
)
