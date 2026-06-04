import 'package:stock_flutter/data/datasources/auth_datasource.dart';
import 'package:stock_flutter/domain/entities/user.dart';
import 'package:stock_flutter/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _authDataSource;

  AuthRepositoryImpl(this._authDataSource);

  @override
  Future<User> signUp(String email, String password, String name) {
    return _authDataSource.signUp(email, password, name);
  }

  @override
  Future<User> signIn(String email, String password) {
    return _authDataSource.signIn(email, password);
  }

  @override
  Future<void> signOut() {
    return _authDataSource.signOut();
  }

  @override
  Future<User?> getCurrentUser() {
    return _authDataSource.getCurrentUser();
  }

  @override
  Future<bool> isUserLoggedIn() async {
    final user = await getCurrentUser();
    return user != null;
  }
}
