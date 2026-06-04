import 'package:stock_flutter/domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    required String id,
    required String name,
    required String description,
    required String categoryId,
    required double price,
    required int quantity,
    required int minStockLevel,
    required String userId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
    id: id,
    name: name,
    description: description,
    categoryId: categoryId,
    price: price,
    quantity: quantity,
    minStockLevel: minStockLevel,
    userId: userId,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      categoryId: json['categoryId'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
      minStockLevel: json['minStockLevel'] ?? 0,
      userId: json['userId'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'categoryId': categoryId,
      'price': price,
      'quantity': quantity,
      'minStockLevel': minStockLevel,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
