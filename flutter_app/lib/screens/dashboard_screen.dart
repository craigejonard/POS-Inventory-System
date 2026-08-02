import 'package:flutter/material.dart';
import '../models/sale.dart';
import '../services/api_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _api = ApiService();
  DashboardStats _stats = DashboardStats();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() => _loading = true);
    try {
      _stats = await _api.getDashboardStats();
    } catch (_) {}
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Overview', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: _StatCard(label: 'Products', value: '${_stats.totalProducts}')),
            const SizedBox(width: 12),
            Expanded(child: _StatCard(
              label: 'Low Stock',
              value: '${_stats.lowStockCount}',
              isWarning: _stats.lowStockCount > 0,
            )),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _StatCard(label: "Today's Sales", value: '${_stats.todaySales}')),
            const SizedBox(width: 12),
            Expanded(child: _StatCard(label: 'Revenue', value: '¥${_stats.todayRevenue.toStringAsFixed(0)}')),
          ]),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final bool isWarning;

  const _StatCard({required this.label, required this.value, this.isWarning = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 4),
            Text(value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isWarning ? Theme.of(context).colorScheme.error : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
