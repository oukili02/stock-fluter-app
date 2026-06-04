import 'package:stock_flutter/data/datasources/movement_datasource.dart';
import 'package:stock_flutter/data/models/movement_model.dart';
import 'package:stock_flutter/domain/entities/movement.dart';
import 'package:stock_flutter/domain/repositories/movement_repository.dart';

class MovementRepositoryImpl implements MovementRepository {
  final MovementDataSource _movementDataSource;

  MovementRepositoryImpl(this._movementDataSource);

  @override
  Future<void> addMovement(Movement movement) async {
    final movementModel = MovementModel(
      id: movement.id,
      productId: movement.productId,
      type: movement.type,
      quantity: movement.quantity,
      reason: movement.reason,
      userId: movement.userId,
      createdAt: movement.createdAt,
    );
    await _movementDataSource.addMovement(movementModel);
  }

  @override
  Future<List<Movement>> getMovements(String userId, DateTime startDate, DateTime endDate) async {
    return await _movementDataSource.getMovements(userId, startDate, endDate);
  }

  @override
  Future<List<Movement>> getProductMovements(String productId) async {
    throw UnimplementedError('Use getProductMovements in datasource with userId');
  }

  @override
  Future<int> getTotalSales(String userId, DateTime startDate, DateTime endDate) async {
    final movements = await _movementDataSource.getMovements(userId, startDate, endDate);
    return movements
        .where((m) => m.type == MovementType.exit)
        .fold(0, (sum, m) => sum + m.quantity);
  }
}
