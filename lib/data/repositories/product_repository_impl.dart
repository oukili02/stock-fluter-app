import 'package:stock_flutter/data/datasources/product_datasource.dart';
import 'package:stock_flutter/data/models/product_model.dart';
import 'package:stock_flutter/domain/entities/product.dart';
import 'package:stock_flutter/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductDataSource _productDataSource;

  ProductRepositoryImpl(this._productDataSource);

  @override
  Future<void> addProduct(Product product) async {
    final productModel = ProductModel(
      id: product.id,
      name: product.name,
      description: product.description,
      categoryId: product.categoryId,
      price: product.price,
      quantity: product.quantity,
      minStockLevel: product.minStockLevel,
      userId: product.userId,
      createdAt: product.createdAt,
      updatedAt: product.updatedAt,
    );
    await _productDataSource.addProduct(productModel);
  }

  @override
  Future<void> updateProduct(Product product) async {
    final productModel = ProductModel(
      id: product.id,
      name: product.name,
      description: product.description,
      categoryId: product.categoryId,
      price: product.price,
      quantity: product.quantity,
      minStockLevel: product.minStockLevel,
      userId: product.userId,
      createdAt: product.createdAt,
      updatedAt: DateTime.now(),
    );
    await _productDataSource.updateProduct(productModel);
  }

  @override
  Future<void> deleteProduct(String productId) async {
    await _productDataSource.deleteProduct(productId);
  }

  @override
  Future<Product?> getProduct(String productId) async {
    return await _productDataSource.getProduct(productId);
  }

  @override
  Future<List<Product>> getAllProducts(String userId) async {
    return await _productDataSource.getAllProducts(userId);
  }

  @override
  Future<List<Product>> getProductsByCategory(String userId, String categoryId) async {
    return await _productDataSource.getProductsByCategory(userId, categoryId);
  }

  @override
  Future<List<Product>> getLowStockProducts(String userId) async {
    return await _productDataSource.getLowStockProducts(userId);
  }

  @override
  Future<List<Product>> getTopSellingProducts(String userId, DateTime startDate, DateTime endDate) async {
    // This would require joining with movements data - implement in next phase
    throw UnimplementedError();
  }
}
