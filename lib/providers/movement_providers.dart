import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_flutter/domain/entities/movement.dart';
import 'package:stock_flutter/providers/auth_providers.dart';
import 'package:stock_flutter/providers/repository_providers.dart';

// Get movements for date range
final movementsProvider = FutureProvider.family<List<Movement>, (DateTime, DateTime)>(
  (ref, dateRange) async {
    final user = ref.watch(authStateNotifierProvider);
    if (user == null) return [];
    
    final movementRepository = ref.watch(movementRepositoryProvider);
    return await movementRepository.getMovements(user.id, dateRange.$1, dateRange.$2);
  },
);

// Get total sales for date range
final totalSalesProvider = FutureProvider.family<int, (DateTime, DateTime)>(
  (ref, dateRange) async {
    final user = ref.watch(authStateNotifierProvider);
    if (user == null) return 0;
    
    final movementRepository = ref.watch(movementRepositoryProvider);
    return await movementRepository.getTotalSales(user.id, dateRange.$1, dateRange.$2);
  },
);
