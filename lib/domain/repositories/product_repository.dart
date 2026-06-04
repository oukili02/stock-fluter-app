import 'package:stock_flutter/domain/entities/product.dart';

abstract class ProductRepository {
  Future<void> addProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(String productId, String userId);
  Future<Product?> getProduct(String productId, String userId);
  Future<List<Product>> getAllProducts(String userId);
  Future<List<Product>> getProductsByCategory(String userId, String categoryId);
  Future<List<Product>> getLowStockProducts(String userId);
  Future<List<Product>> getTopSellingProducts(String userId, DateTime startDate, DateTime endDate);
}
