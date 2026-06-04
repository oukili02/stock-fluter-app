import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stock_flutter/domain/entities/movement.dart';
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
    final productRef = _firestore
        .collection('users')
        .doc(movement.userId)
        .collection('products')
        .doc(movement.productId);

    final movementRef = _firestore
        .collection('users')
        .doc(movement.userId)
        .collection('movements')
        .doc(movement.id);

    await _firestore.runTransaction((transaction) async {
      final productDoc = await transaction.get(productRef);
      if (!productDoc.exists) {
        throw Exception('Produit introuvable');
      }

      final productData = productDoc.data() as Map<String, dynamic>;
      final currentQty = productData['quantity'] as int? ?? 0;
      final change = movement.quantity;

      int newQty;
      if (movement.type == MovementType.entry) {
        newQty = currentQty + change;
      } else {
        newQty = currentQty - change;
        if (newQty < 0) {
          throw Exception('Stock insuffisant pour cette vente');
        }
      }

      transaction.set(movementRef, movement.toJson());
      transaction.update(productRef, {
        'quantity': newQty,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    });
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
