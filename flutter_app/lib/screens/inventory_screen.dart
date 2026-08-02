import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final _api = ApiService();
  List<Product> _products = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() => _loading = true);
    try {
      _products = await _api.getProducts();
    } catch (_) {}
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: _products.isEmpty
            ? const Center(child: Text('No products yet'))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _products.length,
                itemBuilder: (context, index) => _ProductCard(product: _products[index]),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () { /* TODO: open add product dialog */ },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: Theme.of(context).textTheme.titleMedium),
                  Text('SKU: ${product.sku}', style: Theme.of(context).textTheme.bodySmall),
                  Text(product.category, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('¥${product.price.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.titleMedium),
                Text('Qty: ${product.quantity}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: product.quantity <= 5
                        ? Theme.of(context).colorScheme.error
                        : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
