import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_flutter/data/datasources/auth_datasource.dart';
import 'package:stock_flutter/data/datasources/category_datasource.dart';
import 'package:stock_flutter/data/datasources/movement_datasource.dart';
import 'package:stock_flutter/data/datasources/product_datasource.dart';
import 'package:stock_flutter/data/repositories/auth_repository_impl.dart';
import 'package:stock_flutter/data/repositories/category_repository_impl.dart';
import 'package:stock_flutter/data/repositories/movement_repository_impl.dart';
import 'package:stock_flutter/data/repositories/product_repository_impl.dart';
import 'package:stock_flutter/domain/repositories/auth_repository.dart';
import 'package:stock_flutter/domain/repositories/category_repository.dart';
import 'package:stock_flutter/domain/repositories/movement_repository.dart';
import 'package:stock_flutter/domain/repositories/product_repository.dart';

// Firebase instances
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// DataSources
final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  final firestore = ref.watch(firestoreProvider);
  return AuthDataSourceImpl(auth, firestore);
});

final productDataSourceProvider = Provider<ProductDataSource>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return ProductDataSourceImpl(firestore);
});

final categoryDataSourceProvider = Provider<CategoryDataSource>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return CategoryDataSourceImpl(firestore);
});

final movementDataSourceProvider = Provider<MovementDataSource>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return MovementDataSourceImpl(firestore);
});

// Repositories
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authDataSource = ref.watch(authDataSourceProvider);
  return AuthRepositoryImpl(authDataSource);
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final productDataSource = ref.watch(productDataSourceProvider);
  final movementDataSource = ref.watch(movementDataSourceProvider);
  return ProductRepositoryImpl(productDataSource, movementDataSource);
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final categoryDataSource = ref.watch(categoryDataSourceProvider);
  return CategoryRepositoryImpl(categoryDataSource);
});

final movementRepositoryProvider = Provider<MovementRepository>((ref) {
  final movementDataSource = ref.watch(movementDataSourceProvider);
  return MovementRepositoryImpl(movementDataSource);
});
