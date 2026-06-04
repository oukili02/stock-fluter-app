import 'package:stock_flutter/domain/entities/category.dart';

class CategoryModel extends Category {
  CategoryModel({
    required String id,
    required String name,
    required String description,
    required String userId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
    id: id,
    name: name,
    description: description,
    userId: userId,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
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
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
