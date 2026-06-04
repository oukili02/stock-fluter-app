import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_flutter/domain/entities/user.dart';
import 'package:stock_flutter/providers/repository_providers.dart';

// Current user state
final currentUserProvider = FutureProvider<User?>((ref) async {
  final authRepository = ref.watch(authRepositoryProvider);
  return await authRepository.getCurrentUser();
});

// Auth state notifier
final authStateNotifierProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthNotifier(authRepository);
});

class AuthNotifier extends StateNotifier<User?> {
  final authRepository;

  AuthNotifier(this.authRepository) : super(null) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final user = await authRepository.getCurrentUser();
    state = user;
  }

  Future<void> signUp(String email, String password, String name) async {
    try {
      final user = await authRepository.signUp(email, password, name);
      state = user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      final user = await authRepository.signIn(email, password);
      state = user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await authRepository.signOut();
      state = null;
    } catch (e) {
      rethrow;
    }
  }
}
