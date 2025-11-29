import 'package:procurement_scanner/models/transaction.dart';

/// Repository interface for transactions
/// Follows Dependency Inversion Principle
abstract class TransactionRepository {
  /// Get all transactions
  Future<List<Transaction>> getAllTransactions();

  /// Get transactions for specific item
  Future<List<Transaction>> getTransactionsForItem(String itemId);

  /// Get recent transactions
  Future<List<Transaction>> getRecentTransactions({int limit = 10});

  /// Add new transaction
  Future<void> addTransaction(Transaction transaction);
}

