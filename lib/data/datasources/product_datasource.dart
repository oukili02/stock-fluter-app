import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stock_flutter/data/models/product_model.dart';

abstract class ProductDataSource {
  Future<void> addProduct(ProductModel product);
  Future<void> updateProduct(ProductModel product);
  Future<void> deleteProduct(String productId, String userId);
  Future<ProductModel?> getProduct(String productId, String userId);
  Future<List<ProductModel>> getAllProducts(String userId);
  Future<List<ProductModel>> getProductsByCategory(String userId, String categoryId);
  Future<List<ProductModel>> getLowStockProducts(String userId);
}

class ProductDataSourceImpl implements ProductDataSource {
  final FirebaseFirestore _firestore;

  ProductDataSourceImpl(this._firestore);

  @override
  Future<void> addProduct(ProductModel product) async {
    await _firestore
        .collection('users')
        .doc(product.userId)
        .collection('products')
        .doc(product.id)
        .set(product.toJson());
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    await _firestore
        .collection('users')
        .doc(product.userId)
        .collection('products')
        .doc(product.id)
        .update(product.toJson());
  }

  @override
  Future<void> deleteProduct(String productId, String userId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('products')
        .doc(productId)
        .delete();
  }

  @override
  Future<ProductModel?> getProduct(String productId, String userId) async {
    final doc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('products')
        .doc(productId)
        .get();

    if (!doc.exists) return null;
    return ProductModel.fromJson(doc.data() as Map<String, dynamic>);
  }

  @override
  Future<List<ProductModel>> getAllProducts(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('products')
        .get();

    return snapshot.docs
        .map((doc) => ProductModel.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String userId, String categoryId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('products')
        .where('categoryId', isEqualTo: categoryId)
        .get();

    return snapshot.docs
        .map((doc) => ProductModel.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<List<ProductModel>> getLowStockProducts(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('products')
        .get();

    return snapshot.docs
        .map((doc) => ProductModel.fromJson(doc.data()))
        .where((product) => product.isLowStock)
        .toList();
  }
}
