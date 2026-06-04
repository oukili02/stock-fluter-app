import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_flutter/domain/entities/product.dart';
import 'package:stock_flutter/domain/entities/movement.dart';
import 'package:stock_flutter/providers/auth_providers.dart';
import 'package:stock_flutter/providers/repository_providers.dart';

// Get all products
final allProductsProvider = FutureProvider<List<Product>>((ref) async {
  final user = ref.watch(authStateNotifierProvider);
  if (user == null) return [];
  
  final productRepository = ref.watch(productRepositoryProvider);
  return await productRepository.getAllProducts(user.id);
});

// Get low stock products
final lowStockProductsProvider = FutureProvider<List<Product>>((ref) async {
  final user = ref.watch(authStateNotifierProvider);
  if (user == null) return [];
  
  final productRepository = ref.watch(productRepositoryProvider);
  return await productRepository.getLowStockProducts(user.id);
});

// Get products by category
final productsByCategoryProvider = FutureProvider.family<List<Product>, String>(
  (ref, categoryId) async {
    final user = ref.watch(authStateNotifierProvider);
    if (user == null) return [];
    
    final productRepository = ref.watch(productRepositoryProvider);
    return await productRepository.getProductsByCategory(user.id, categoryId);
  },
);

// Get top selling products
final topSellingProductsProvider = FutureProvider.family<List<Product>, (DateTime, DateTime)>(
  (ref, dateRange) async {
    final user = ref.watch(authStateNotifierProvider);
    if (user == null) return [];
    
    final productRepository = ref.watch(productRepositoryProvider);
    return await productRepository.getTopSellingProducts(user.id, dateRange.$1, dateRange.$2);
  },
);

// Get sales by category
final salesByCategoryProvider = FutureProvider.family<Map<String, int>, (DateTime, DateTime)>(
  (ref, dateRange) async {
    final user = ref.watch(authStateNotifierProvider);
    if (user == null) return {};

    final movementRepository = ref.watch(movementRepositoryProvider);
    final productRepository = ref.watch(productRepositoryProvider);
    final categoryRepository = ref.watch(categoryRepositoryProvider);

    final movements = await movementRepository.getMovements(user.id, dateRange.$1, dateRange.$2);
    final sales = movements.where((m) => m.type == MovementType.exit);

    final products = await productRepository.getAllProducts(user.id);
    final categories = await categoryRepository.getAllCategories(user.id);

    final productToCategory = {for (var p in products) p.id: p.categoryId};
    final categoryNames = {for (var c in categories) c.id: c.name};

    final categorySales = <String, int>{};
    for (final sale in sales) {
      final categoryId = productToCategory[sale.productId];
      if (categoryId != null) {
        final categoryName = categoryNames[categoryId] ?? 'Inconnu';
        categorySales[categoryName] = (categorySales[categoryName] ?? 0) + sale.quantity;
      }
    }
    return categorySales;
  },
);
