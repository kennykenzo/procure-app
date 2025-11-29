import 'package:procurement_scanner/models/transaction.dart';
import 'package:procurement_scanner/repositories/interfaces/transaction_repository.dart';
import 'package:procurement_scanner/utils/mock_data.dart';

/// Mock implementation of TransactionRepository
class MockTransactionRepository implements TransactionRepository {
  @override
  Future<List<Transaction>> getAllTransactions() async {
    return generateMockTransactions();
  }

  @override
  Future<List<Transaction>> getTransactionsForItem(String itemId) async {
    final transactions = await getAllTransactions();
    return transactions.where((txn) => txn.itemId == itemId).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  @override
  Future<List<Transaction>> getRecentTransactions({int limit = 10}) async {
    final transactions = await getAllTransactions();
    return transactions.take(limit).toList();
  }

  @override
  Future<void> addTransaction(Transaction transaction) async {
    // In real implementation, this would persist to database
  }
}

