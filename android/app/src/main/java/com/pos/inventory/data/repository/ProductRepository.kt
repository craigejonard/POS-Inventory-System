package com.pos.inventory.data.repository

import com.pos.inventory.data.api.ApiService
import com.pos.inventory.data.api.dto.ProductDto
import com.pos.inventory.data.local.ProductDao
import com.pos.inventory.data.local.ProductEntity
import kotlinx.coroutines.flow.Flow
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class ProductRepository @Inject constructor(
    private val api: ApiService,
    private val dao: ProductDao,
) {
    fun observeProducts(): Flow<List<ProductEntity>> = dao.observeAll()

    suspend fun refresh() {
        val remote = api.getProducts()
        val entities = remote.map { it.toEntity() }
        dao.upsertAll(entities)
        dao.deleteStale(entities.map { it.id })
    }

    suspend fun create(product: ProductDto): ProductDto = api.createProduct(product)

    suspend fun update(id: Long, product: ProductDto) = api.updateProduct(id, product)

    suspend fun delete(id: Long) {
        api.deleteProduct(id)
        refresh()
    }

    private fun ProductDto.toEntity() = ProductEntity(
        id = id, name = name, sku = sku,
        price = price, quantity = quantity, category = category,
    )
}
