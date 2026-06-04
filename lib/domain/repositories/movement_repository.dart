import 'package:stock_flutter/domain/entities/movement.dart';

abstract class MovementRepository {
  Future<void> addMovement(Movement movement);
  Future<List<Movement>> getMovements(String userId, DateTime startDate, DateTime endDate);
  Future<List<Movement>> getProductMovements(String productId);
  Future<int> getTotalSales(String userId, DateTime startDate, DateTime endDate);
}
