import 'package:procurement_scanner/models/item.dart';

/// Repository interface for items
/// Follows Dependency Inversion Principle - depend on abstractions
abstract class ItemRepository {
  /// Get all items
  Future<List<Item>> getAllItems();

  /// Get item by ID
  Future<Item?> getItemById(String id);

  /// Add new item
  Future<void> addItem(Item item);

  /// Update existing item
  Future<void> updateItem(Item item);

  /// Delete item
  Future<void> deleteItem(String id);

  /// Search items by query
  Future<List<Item>> searchItems(String query);

  /// Filter items by location
  Future<List<Item>> filterByLocation(String locationId);

  /// Filter items by category
  Future<List<Item>> filterByCategory(String category);
}

