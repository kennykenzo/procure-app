import 'package:procurement_scanner/models/item.dart';
import 'package:procurement_scanner/repositories/interfaces/item_repository.dart';

/// Service layer for item business logic
/// Follows Single Responsibility Principle - handles only item-related business logic
class ItemService {
  final ItemRepository _repository;

  ItemService(this._repository);

  /// Get all items
  Future<List<Item>> getAllItems() => _repository.getAllItems();

  /// Get item by ID
  Future<Item?> getItemById(String id) => _repository.getItemById(id);

  /// Add new item with validation
  Future<void> addItem(Item item) async {
    // Business logic validation
    if (item.name.isEmpty) {
      throw ArgumentError('Item name cannot be empty');
    }
    if (item.materialCode.isEmpty) {
      throw ArgumentError('Material code cannot be empty');
    }
    if (item.quantity < 0) {
      throw ArgumentError('Quantity cannot be negative');
    }
    
    await _repository.addItem(item);
  }

  /// Update item with validation
  Future<void> updateItem(Item item) async {
    // Business logic validation
    if (item.name.isEmpty) {
      throw ArgumentError('Item name cannot be empty');
    }
    if (item.quantity < 0) {
      throw ArgumentError('Quantity cannot be negative');
    }
    
    await _repository.updateItem(item);
  }

  /// Delete item
  Future<void> deleteItem(String id) => _repository.deleteItem(id);

  /// Search items
  Future<List<Item>> searchItems(String query) => _repository.searchItems(query);

  /// Filter by location
  Future<List<Item>> filterByLocation(String locationId) =>
      _repository.filterByLocation(locationId);

  /// Filter by category
  Future<List<Item>> filterByCategory(String category) =>
      _repository.filterByCategory(category);

  /// Get categories from all items
  Future<List<String>> getCategories() async {
    final items = await getAllItems();
    final categories = items
        .where((item) => item.category != null)
        .map((item) => item.category!)
        .toSet()
        .toList();
    categories.sort();
    return categories;
  }
}

