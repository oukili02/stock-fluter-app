class Product {
  final String id;
  final String name;
  final String description;
  final String categoryId;
  final double price;
  final int quantity;
  final int minStockLevel;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
    required this.price,
    required this.quantity,
    required this.minStockLevel,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isLowStock => quantity <= minStockLevel;
}
