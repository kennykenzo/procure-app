import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:procurement_scanner/models/transaction.dart';
import 'package:procurement_scanner/repositories/implementations/mock_transaction_repository.dart';
import 'package:procurement_scanner/repositories/interfaces/transaction_repository.dart';

/// Repository provider - follows Dependency Inversion Principle
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return MockTransactionRepository();
});

/// Provider for transactions list - follows Open/Closed Principle
final transactionsProvider = FutureProvider<List<Transaction>>((ref) async {
  final repository = ref.watch(transactionRepositoryProvider);
  return await repository.getAllTransactions();
});

/// Provider for transactions by item ID
final transactionsByItemProvider = FutureProvider.family<List<Transaction>, String>((ref, itemId) async {
  final repository = ref.watch(transactionRepositoryProvider);
  return await repository.getTransactionsForItem(itemId);
});

/// Provider for recent transactions
final recentTransactionsProvider = FutureProvider.family<List<Transaction>, int>((ref, limit) async {
  final repository = ref.watch(transactionRepositoryProvider);
  return await repository.getRecentTransactions(limit: limit);
});
