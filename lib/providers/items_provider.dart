import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:procurement_scanner/models/item.dart';
import 'package:procurement_scanner/repositories/implementations/mock_item_repository.dart';
import 'package:procurement_scanner/repositories/interfaces/item_repository.dart';
import 'package:procurement_scanner/services/item_service.dart';

/// Repository provider - follows Dependency Inversion Principle
/// Can be easily swapped with database implementation
final itemRepositoryProvider = Provider<ItemRepository>((ref) {
  return MockItemRepository();
});

/// Service provider - follows Single Responsibility Principle
final itemServiceProvider = Provider<ItemService>((ref) {
  final repository = ref.watch(itemRepositoryProvider);
  return ItemService(repository);
});

/// Provider for items list - follows Open/Closed Principle
/// Can be extended without modifying existing code
final itemsProvider = FutureProvider<List<Item>>((ref) async {
  final service = ref.watch(itemServiceProvider);
  return await service.getAllItems();
});

/// Provider for item by ID
final itemByIdProvider = FutureProvider.family<Item?, String>((ref, id) async {
  final service = ref.watch(itemServiceProvider);
  return await service.getItemById(id);
});

/// Provider for categories
final categoriesProvider = FutureProvider<List<String>>((ref) async {
  final service = ref.watch(itemServiceProvider);
  return await service.getCategories();
});
