import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stock_flutter/data/models/user_model.dart';

abstract class AuthDataSource {
  Future<UserModel> signUp(String email, String password, String name);
  Future<UserModel> signIn(String email, String password);
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
}

class AuthDataSourceImpl implements AuthDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthDataSourceImpl(
    this._firebaseAuth,
    this._firestore,
  );

  @override
  Future<UserModel> signUp(String email, String password, String name) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) throw Exception('User creation failed');

      final userModel = UserModel(
        id: user.uid,
        email: email,
        name: name,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(user.uid).set(userModel.toJson());

      return userModel;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> signIn(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) throw Exception('Sign in failed');

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) throw Exception('User not found in Firestore');

      return UserModel.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;

    return UserModel.fromJson(doc.data() as Map<String, dynamic>);
  }
}
