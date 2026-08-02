class Sale {
  final int id;
  final List<SaleItem> items;
  final double total;
  final String createdAt;

  Sale({
    this.id = 0,
    required this.items,
    this.total = 0,
    this.createdAt = '',
  });

  factory Sale.fromJson(Map<String, dynamic> json) => Sale(
        id: json['id'] ?? 0,
        items: (json['items'] as List?)
                ?.map((e) => SaleItem.fromJson(e))
                .toList() ??
            [],
        total: (json['total'] ?? 0).toDouble(),
        createdAt: json['created_at'] ?? '',
      );
}

class SaleItem {
  final int productId;
  final String productName;
  final double price;
  final int quantity;
  final double subtotal;

  SaleItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    this.subtotal = 0,
  });

  factory SaleItem.fromJson(Map<String, dynamic> json) => SaleItem(
        productId: json['product_id'] ?? 0,
        productName: json['product_name'] ?? '',
        price: (json['price'] ?? 0).toDouble(),
        quantity: json['quantity'] ?? 0,
        subtotal: (json['subtotal'] ?? 0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'product_name': productName,
        'price': price,
        'quantity': quantity,
      };
}

class DashboardStats {
  final int totalProducts;
  final int lowStockCount;
  final int todaySales;
  final double todayRevenue;

  DashboardStats({
    this.totalProducts = 0,
    this.lowStockCount = 0,
    this.todaySales = 0,
    this.todayRevenue = 0,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) => DashboardStats(
        totalProducts: json['total_products'] ?? 0,
        lowStockCount: json['low_stock_count'] ?? 0,
        todaySales: json['today_sales'] ?? 0,
        todayRevenue: (json['today_revenue'] ?? 0).toDouble(),
      );
}
