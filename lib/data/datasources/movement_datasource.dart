import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stock_flutter/data/models/movement_model.dart';

abstract class MovementDataSource {
  Future<void> addMovement(MovementModel movement);
  Future<List<MovementModel>> getMovements(String userId, DateTime startDate, DateTime endDate);
  Future<List<MovementModel>> getProductMovements(String productId, String userId);
}

class MovementDataSourceImpl implements MovementDataSource {
  final FirebaseFirestore _firestore;

  MovementDataSourceImpl(this._firestore);

  @override
  Future<void> addMovement(MovementModel movement) async {
    await _firestore
        .collection('users')
        .doc(movement.userId)
        .collection('movements')
        .doc(movement.id)
        .set(movement.toJson());
  }

  @override
  Future<List<MovementModel>> getMovements(String userId, DateTime startDate, DateTime endDate) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('movements')
        .where('createdAt', isGreaterThanOrEqualTo: startDate.toIso8601String())
        .where('createdAt', isLessThanOrEqualTo: endDate.toIso8601String())
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => MovementModel.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<List<MovementModel>> getProductMovements(String productId, String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('movements')
        .where('productId', isEqualTo: productId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => MovementModel.fromJson(doc.data()))
        .toList();
  }
}
