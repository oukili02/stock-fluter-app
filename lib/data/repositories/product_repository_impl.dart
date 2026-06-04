import 'package:stock_flutter/data/datasources/product_datasource.dart';
import 'package:stock_flutter/data/datasources/movement_datasource.dart';
import 'package:stock_flutter/data/models/product_model.dart';
import 'package:stock_flutter/domain/entities/product.dart';
import 'package:stock_flutter/domain/entities/movement.dart';
import 'package:stock_flutter/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductDataSource _productDataSource;
  final MovementDataSource _movementDataSource;

  ProductRepositoryImpl(this._productDataSource, this._movementDataSource);

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
  Future<void> deleteProduct(String productId, String userId) async {
    await _productDataSource.deleteProduct(productId, userId);
  }

  @override
  Future<Product?> getProduct(String productId, String userId) async {
    return await _productDataSource.getProduct(productId, userId);
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
    final movements = await _movementDataSource.getMovements(userId, startDate, endDate);
    final sales = movements.where((m) => m.type == MovementType.exit);

    final productSalesQty = <String, int>{};
    for (final movement in sales) {
      productSalesQty[movement.productId] = (productSalesQty[movement.productId] ?? 0) + movement.quantity;
    }

    final allProducts = await _productDataSource.getAllProducts(userId);

    allProducts.sort((a, b) {
      final qtyA = productSalesQty[a.id] ?? 0;
      final qtyB = productSalesQty[b.id] ?? 0;
      return qtyB.compareTo(qtyA);
    });

    return allProducts.where((p) => (productSalesQty[p.id] ?? 0) > 0).toList();
  }
}
