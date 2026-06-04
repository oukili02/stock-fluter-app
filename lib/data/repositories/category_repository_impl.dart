import 'package:stock_flutter/data/datasources/category_datasource.dart';
import 'package:stock_flutter/data/models/category_model.dart';
import 'package:stock_flutter/domain/entities/category.dart';
import 'package:stock_flutter/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryDataSource _categoryDataSource;

  CategoryRepositoryImpl(this._categoryDataSource);

  @override
  Future<void> addCategory(Category category) async {
    final categoryModel = CategoryModel(
      id: category.id,
      name: category.name,
      description: category.description,
      userId: category.userId,
      createdAt: category.createdAt,
      updatedAt: category.updatedAt,
    );
    await _categoryDataSource.addCategory(categoryModel);
  }

  @override
  Future<void> updateCategory(Category category) async {
    final categoryModel = CategoryModel(
      id: category.id,
      name: category.name,
      description: category.description,
      userId: category.userId,
      createdAt: category.createdAt,
      updatedAt: DateTime.now(),
    );
    await _categoryDataSource.updateCategory(categoryModel);
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    throw UnimplementedError('Use deleteCategory in datasource with userId');
  }

  @override
  Future<Category?> getCategory(String categoryId) async {
    throw UnimplementedError('Use getCategory in datasource with userId');
  }

  @override
  Future<List<Category>> getAllCategories(String userId) async {
    return await _categoryDataSource.getAllCategories(userId);
  }
}
