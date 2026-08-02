package com.pos.inventory.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.pos.inventory.data.api.ApiService
import com.pos.inventory.data.api.dto.SaleDto
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class SalesViewModel @Inject constructor(
    private val api: ApiService,
) : ViewModel() {
    private val _sales = MutableStateFlow<List<SaleDto>>(emptyList())
    val sales = _sales.asStateFlow()

    private val _loading = MutableStateFlow(true)
    val loading = _loading.asStateFlow()

    init { refresh() }

    fun refresh() {
        viewModelScope.launch {
            _loading.value = true
            try { _sales.value = api.getSales() } catch (_: Exception) { }
            _loading.value = false
        }
    }
}

@Composable
fun SalesScreen(viewModel: SalesViewModel = hiltViewModel()) {
    val sales by viewModel.sales.collectAsState()
    val loading by viewModel.loading.collectAsState()

    if (loading) {
        Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
            CircularProgressIndicator()
        }
    } else if (sales.isEmpty()) {
        Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
            Text("No sales yet", style = MaterialTheme.typography.bodyLarge,
                color = MaterialTheme.colorScheme.onSurfaceVariant)
        }
    } else {
        LazyColumn(
            contentPadding = PaddingValues(16.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp),
        ) {
            items(sales, key = { it.id }) { sale ->
                SaleCard(sale)
            }
        }
    }
}

@Composable
private fun SaleCard(sale: SaleDto) {
    Card(Modifier.fillMaxWidth()) {
        Column(Modifier.padding(16.dp)) {
            Row(
                Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
            ) {
                Text("Sale #${sale.id}", style = MaterialTheme.typography.titleMedium)
                Text("¥%.0f".format(sale.total), style = MaterialTheme.typography.titleMedium)
            }
            Spacer(Modifier.height(4.dp))
            Text(sale.createdAt,
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant)
            if (sale.items.isNotEmpty()) {
                Spacer(Modifier.height(8.dp))
                sale.items.forEach { item ->
                    Text("${item.productName} x${item.quantity} — ¥%.0f".format(item.subtotal),
                        style = MaterialTheme.typography.bodySmall)
                }
            }
        }
    }
}
