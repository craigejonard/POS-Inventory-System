import 'package:flutter/material.dart';
import '../models/sale.dart';
import '../services/api_service.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final _api = ApiService();
  List<Sale> _sales = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() => _loading = true);
    try {
      _sales = await _api.getSales();
    } catch (_) {}
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    if (_sales.isEmpty) {
      return const Center(child: Text('No sales yet'));
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _sales.length,
        itemBuilder: (context, index) => _SaleCard(sale: _sales[index]),
      ),
    );
  }
}

class _SaleCard extends StatelessWidget {
  final Sale sale;
  const _SaleCard({required this.sale});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Sale #${sale.id}', style: Theme.of(context).textTheme.titleMedium),
                Text('¥${sale.total.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 4),
            Text(sale.createdAt, style: Theme.of(context).textTheme.bodySmall),
            if (sale.items.isNotEmpty) ...[
              const SizedBox(height: 8),
              ...sale.items.map((item) => Text(
                '${item.productName} x${item.quantity} — ¥${item.subtotal.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.bodySmall,
              )),
            ],
          ],
        ),
      ),
    );
  }
}
