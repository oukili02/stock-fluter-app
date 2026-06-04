import 'package:stock_flutter/domain/entities/movement.dart';

class MovementModel extends Movement {
  MovementModel({
    required String id,
    required String productId,
    required MovementType type,
    required int quantity,
    required String reason,
    required String userId,
    required DateTime createdAt,
  }) : super(
    id: id,
    productId: productId,
    type: type,
    quantity: quantity,
    reason: reason,
    userId: userId,
    createdAt: createdAt,
  );

  factory MovementModel.fromJson(Map<String, dynamic> json) {
    return MovementModel(
      id: json['id'] ?? '',
      productId: json['productId'] ?? '',
      type: json['type'] == 'entry' ? MovementType.entry : MovementType.exit,
      quantity: json['quantity'] ?? 0,
      reason: json['reason'] ?? '',
      userId: json['userId'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'type': type == MovementType.entry ? 'entry' : 'exit',
      'quantity': quantity,
      'reason': reason,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
