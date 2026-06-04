import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_flutter/domain/entities/product.dart';
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
