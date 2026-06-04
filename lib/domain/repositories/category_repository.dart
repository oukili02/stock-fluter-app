import 'package:stock_flutter/domain/entities/category.dart';

abstract class CategoryRepository {
  Future<void> addCategory(Category category);
  Future<void> updateCategory(Category category);
  Future<void> deleteCategory(String categoryId);
  Future<Category?> getCategory(String categoryId);
  Future<List<Category>> getAllCategories(String userId);
}
