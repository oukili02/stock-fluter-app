import 'package:stock_flutter/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> signUp(String email, String password, String name);
  Future<User> signIn(String email, String password);
  Future<void> signOut();
  Future<User?> getCurrentUser();
  Future<bool> isUserLoggedIn();
}
