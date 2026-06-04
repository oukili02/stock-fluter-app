import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stock_flutter/data/models/category_model.dart';

abstract class CategoryDataSource {
  Future<void> addCategory(CategoryModel category);
  Future<void> updateCategory(CategoryModel category);
  Future<void> deleteCategory(String categoryId, String userId);
  Future<CategoryModel?> getCategory(String categoryId, String userId);
  Future<List<CategoryModel>> getAllCategories(String userId);
}

class CategoryDataSourceImpl implements CategoryDataSource {
  final FirebaseFirestore _firestore;

  CategoryDataSourceImpl(this._firestore);

  @override
  Future<void> addCategory(CategoryModel category) async {
    await _firestore
        .collection('users')
        .doc(category.userId)
        .collection('categories')
        .doc(category.id)
        .set(category.toJson());
  }

  @override
  Future<void> updateCategory(CategoryModel category) async {
    await _firestore
        .collection('users')
        .doc(category.userId)
        .collection('categories')
        .doc(category.id)
        .update(category.toJson());
  }

  @override
  Future<void> deleteCategory(String categoryId, String userId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('categories')
        .doc(categoryId)
        .delete();
  }

  @override
  Future<CategoryModel?> getCategory(String categoryId, String userId) async {
    final doc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('categories')
        .doc(categoryId)
        .get();

    if (!doc.exists) return null;
    return CategoryModel.fromJson(doc.data() as Map<String, dynamic>);
  }

  @override
  Future<List<CategoryModel>> getAllCategories(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('categories')
        .get();

    return snapshot.docs
        .map((doc) => CategoryModel.fromJson(doc.data()))
        .toList();
  }
}
