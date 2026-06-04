import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_flutter/domain/entities/category.dart';
import 'package:stock_flutter/providers/auth_providers.dart';
import 'package:stock_flutter/providers/repository_providers.dart';

// Get all categories
final allCategoriesProvider = FutureProvider<List<Category>>((ref) async {
  final user = ref.watch(authStateNotifierProvider);
  if (user == null) return [];
  
  final categoryRepository = ref.watch(categoryRepositoryProvider);
  return await categoryRepository.getAllCategories(user.id);
});
