import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stock_flutter/providers/auth_providers.dart';
import 'package:stock_flutter/providers/product_providers.dart';
import 'package:stock_flutter/providers/movement_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateNotifierProvider);
    final lowStockProducts = ref.watch(lowStockProductsProvider);
    final allProducts = ref.watch(allProductsProvider);

    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final totalSales = ref.watch(totalSalesProvider((startOfMonth, now)));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final authNotifier = ref.read(authStateNotifierProvider.notifier);
              await authNotifier.signOut();
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            if (user != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bienvenue ${user.name}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      '${user.email}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  ],
                ),
              ),

            // Stats Cards
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Total Produits',
                    value: allProducts.when(
                      data: (products) => '${products.length}',
                      loading: () => '...',
                      error: (_, __) => 'Erreur',
                    ),
                    icon: Icons.inventory_2,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    title: 'Stock Faible',
                    value: lowStockProducts.when(
                      data: (products) => '${products.length}',
                      loading: () => '...',
                      error: (_, __) => 'Erreur',
                    ),
                    icon: Icons.warning,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Ventes ce mois',
                    value: totalSales.when(
                      data: (sales) => '$sales',
                      loading: () => '...',
                      error: (_, __) => 'Erreur',
                    ),
                    icon: Icons.trending_up,
                    color: Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Low Stock Alert
            lowStockProducts.when(
              data: (products) {
                if (products.isEmpty) return const SizedBox();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Produits en Stock Faible',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return Card(
                          child: ListTile(
                            title: Text(product.name),
                            subtitle: Text('Stock: ${product.quantity}'),
                            trailing: Chip(
                              label: Text('${product.minStockLevel} min'),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (error, __) => Text('Erreur: $error'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: 'Produits',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Mouvements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Rapports',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/dashboard');
              break;
            case 1:
              context.go('/products');
              break;
            case 2:
              context.go('/movements');
              break;
            case 3:
              context.go('/reports');
              break;
          }
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    this.color = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: color,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
