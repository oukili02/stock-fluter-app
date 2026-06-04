import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stock_flutter/providers/product_providers.dart';

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(allProductsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gérer Produits'),
        centerTitle: true,
      ),
      body: products.when(
        data: (productList) {
          if (productList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2,
                    size: 64,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aucun produit',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ajoutez votre premier produit',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: productList.length,
            itemBuilder: (context, index) {
              final product = productList[index];
              return Card(
                child: ListTile(
                  title: Text(product.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text('Stock: ${product.quantity}'),
                      Text('Prix: ${product.price}€'),
                    ],
                  ),
                  trailing: product.isLowStock
                      ? const Icon(Icons.warning, color: Colors.orange)
                      : null,
                  isThreeLine: true,
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, __) => Center(child: Text('Erreur: $error')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/products/add'),
        label: const Text('Ajouter Produit'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
