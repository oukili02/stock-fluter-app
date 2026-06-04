import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_flutter/providers/movement_providers.dart';
import 'package:stock_flutter/providers/product_providers.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, 1);
    _endDate = now;
  }

  @override
  Widget build(BuildContext context) {
    final lowStockProducts = ref.watch(lowStockProductsProvider);
    final totalSales = ref.watch(totalSalesProvider((_startDate!, _endDate!)));
    final allProducts = ref.watch(allProductsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rapports & Statistiques'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Range Picker
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _startDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() => _startDate = picked);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Du: ${_startDate?.toLocal().toString().split(' ')[0] ?? 'Date'}',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _endDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() => _endDate = picked);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Au: ${_endDate?.toLocal().toString().split(' ')[0] ?? 'Date'}',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Summary Stats
            Text(
              'Résumé',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.trending_up, color: Colors.green, size: 32),
                          const SizedBox(height: 12),
                          totalSales.when(
                            data: (sales) => Text(
                              '$sales',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: Colors.green,
                                  ),
                            ),
                            loading: () => const CircularProgressIndicator(),
                            error: (_, __) => const Text('Erreur'),
                          ),
                          const SizedBox(height: 4),
                          const Text('Ventes'),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.inventory_2, color: Colors.blue, size: 32),
                          const SizedBox(height: 12),
                          allProducts.when(
                            data: (products) => Text(
                              '${products.length}',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: Colors.blue,
                                  ),
                            ),
                            loading: () => const CircularProgressIndicator(),
                            error: (_, __) => const Text('Erreur'),
                          ),
                          const SizedBox(height: 4),
                          const Text('Produits'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Low Stock Alert
            Text(
              'Produits en Stock Faible',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            lowStockProducts.when(
              data: (products) {
                if (products.isEmpty) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Column(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green, size: 48),
                            const SizedBox(height: 12),
                            const Text('Tous les produits sont en bon stock'),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const Icon(Icons.warning, color: Colors.orange),
                        title: Text(product.name),
                        subtitle: Text('Stock: ${product.quantity}/${product.minStockLevel}'),
                        trailing: Chip(
                          backgroundColor: Colors.orange.shade100,
                          label: Text(
                            '${(product.quantity / product.minStockLevel * 100).toStringAsFixed(0)}%',
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (error, __) => Text('Erreur: $error'),
            ),
            const SizedBox(height: 24),

            // Inventory Value
            Text(
              'Valeur du Stock',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            allProducts.when(
              data: (products) {
                final totalValue = products.fold<double>(
                  0,
                  (sum, product) => sum + (product.price * product.quantity),
                );

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Text(
                          '${totalValue.toStringAsFixed(2)}€',
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                color: Colors.deepPurple,
                              ),
                        ),
                        const SizedBox(height: 8),
                        const Text('Valeur totale du stock'),
                      ],
                    ),
                  ),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (error, __) => Text('Erreur: $error'),
            ),
          ],
        ),
      ),
    );
  }
}
