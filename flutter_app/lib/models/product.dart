class Product {
  final int id;
  final String name;
  final String sku;
  final double price;
  final int quantity;
  final String category;
  final String createdAt;
  final String updatedAt;

  Product({
    this.id = 0,
    required this.name,
    required this.sku,
    required this.price,
    this.quantity = 0,
    this.category = '',
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        sku: json['sku'] ?? '',
        price: (json['price'] ?? 0).toDouble(),
        quantity: json['quantity'] ?? 0,
        category: json['category'] ?? '',
        createdAt: json['created_at'] ?? '',
        updatedAt: json['updated_at'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'sku': sku,
        'price': price,
        'quantity': quantity,
        'category': category,
      };
}
