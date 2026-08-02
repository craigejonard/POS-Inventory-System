import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/sale.dart';

class ApiService {
  // For Android emulator use 10.0.2.2, for physical device use your LAN IP
  static const String baseUrl = 'http://10.0.2.2:8080/api';

  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  // Products
  Future<List<Product>> getProducts() async {
    final response = await _client.get(Uri.parse('$baseUrl/products'));
    if (response.statusCode != 200) throw Exception('Failed to load products');
    final List<dynamic> data = jsonDecode(response.body) ?? [];
    return data.map((json) => Product.fromJson(json)).toList();
  }

  Future<Product> createProduct(Product product) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/products'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );
    if (response.statusCode != 201) throw Exception('Failed to create product');
    return Product.fromJson(jsonDecode(response.body));
  }

  Future<void> updateProduct(int id, Product product) async {
    final response = await _client.put(
      Uri.parse('$baseUrl/products/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );
    if (response.statusCode != 200) throw Exception('Failed to update product');
  }

  Future<void> deleteProduct(int id) async {
    final response = await _client.delete(Uri.parse('$baseUrl/products/$id'));
    if (response.statusCode != 200) throw Exception('Failed to delete product');
  }

  // Sales
  Future<List<Sale>> getSales() async {
    final response = await _client.get(Uri.parse('$baseUrl/sales'));
    if (response.statusCode != 200) throw Exception('Failed to load sales');
    final List<dynamic> data = jsonDecode(response.body) ?? [];
    return data.map((json) => Sale.fromJson(json)).toList();
  }

  Future<Sale> createSale(List<SaleItem> items) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/sales'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'items': items.map((i) => i.toJson()).toList()}),
    );
    if (response.statusCode != 201) throw Exception('Failed to create sale');
    return Sale.fromJson(jsonDecode(response.body));
  }

  // Dashboard
  Future<DashboardStats> getDashboardStats() async {
    final response = await _client.get(Uri.parse('$baseUrl/dashboard/stats'));
    if (response.statusCode != 200) throw Exception('Failed to load stats');
    return DashboardStats.fromJson(jsonDecode(response.body));
  }
}
