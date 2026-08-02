package com.pos.inventory.ui.navigation

import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Home
import androidx.compose.material.icons.filled.List
import androidx.compose.material.icons.filled.ShoppingCart
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.pos.inventory.ui.screens.DashboardScreen
import com.pos.inventory.ui.screens.InventoryScreen
import com.pos.inventory.ui.screens.SalesScreen

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AppNavigation() {
    val navController = rememberNavController()
    var selectedRoute by remember { mutableStateOf("dashboard") }

    Scaffold(
        topBar = {
            TopAppBar(title = { Text("POS Inventory") })
        },
        bottomBar = {
            NavigationBar {
                NavigationBarItem(
                    selected = selectedRoute == "dashboard",
                    onClick = {
                        selectedRoute = "dashboard"
                        navController.navigate("dashboard") {
                            popUpTo("dashboard") { inclusive = true }
                        }
                    },
                    icon = { Icon(Icons.Default.Home, contentDescription = "Dashboard") },
                    label = { Text("Dashboard") },
                )
                NavigationBarItem(
                    selected = selectedRoute == "inventory",
                    onClick = {
                        selectedRoute = "inventory"
                        navController.navigate("inventory") {
                            popUpTo("dashboard")
                        }
                    },
                    icon = { Icon(Icons.Default.List, contentDescription = "Inventory") },
                    label = { Text("Inventory") },
                )
                NavigationBarItem(
                    selected = selectedRoute == "sales",
                    onClick = {
                        selectedRoute = "sales"
                        navController.navigate("sales") {
                            popUpTo("dashboard")
                        }
                    },
                    icon = { Icon(Icons.Default.ShoppingCart, contentDescription = "Sales") },
                    label = { Text("Sales") },
                )
            }
        },
    ) { padding ->
        NavHost(
            navController = navController,
            startDestination = "dashboard",
            modifier = Modifier.padding(padding),
        ) {
            composable("dashboard") { DashboardScreen() }
            composable("inventory") { InventoryScreen() }
            composable("sales") { SalesScreen() }
        }
    }
}
