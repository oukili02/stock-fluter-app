import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_flutter/presentation/screens/auth/login_screen.dart';
import 'package:stock_flutter/presentation/screens/auth/signup_screen.dart';
import 'package:stock_flutter/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:stock_flutter/presentation/screens/products/add_product_screen.dart';
import 'package:stock_flutter/presentation/screens/products/products_screen.dart';
import 'package:stock_flutter/presentation/screens/movements/movements_screen.dart';
import 'package:stock_flutter/presentation/screens/reports/reports_screen.dart';
import 'package:stock_flutter/providers/auth_providers.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateNotifierProvider);
  
  return GoRouter(
    initialLocation: authState == null ? '/login' : '/dashboard',
    redirect: (context, state) {
      final isLoggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/signup';
      
      if (authState == null) {
        return isLoggingIn ? null : '/login';
      } else {
        return isLoggingIn ? '/dashboard' : null;
      }
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/products',
        builder: (context, state) => const ProductsScreen(),
      ),
      GoRoute(
        path: '/products/add',
        builder: (context, state) => const AddProductScreen(),
      ),
      GoRoute(
        path: '/movements',
        builder: (context, state) => const MovementsScreen(),
      ),
      GoRoute(
        path: '/reports',
        builder: (context, state) => const ReportsScreen(),
      ),
    ],
  );
});
