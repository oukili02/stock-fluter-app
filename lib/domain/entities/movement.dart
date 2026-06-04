enum MovementType { entry, exit }

class Movement {
  final String id;
  final String productId;
  final MovementType type;
  final int quantity;
  final String reason;
  final String userId;
  final DateTime createdAt;

  Movement({
    required this.id,
    required this.productId,
    required this.type,
    required this.quantity,
    required this.reason,
    required this.userId,
    required this.createdAt,
  });
}
