import 'package:procurement_scanner/models/item.dart';
import 'package:procurement_scanner/repositories/interfaces/item_repository.dart';
import 'package:procurement_scanner/utils/mock_data.dart';

/// Mock implementation of ItemRepository
/// Follows Open/Closed Principle - can be extended without modification
class MockItemRepository implements ItemRepository {
  @override
  Future<List<Item>> getAllItems() async {
    return generateMockItems();
  }

  @override
  Future<Item?> getItemById(String id) async {
    final items = await getAllItems();
    try {
      return items.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> addItem(Item item) async {
    // In real implementation, this would persist to database
    // For now, mock data is read-only
  }

  @override
  Future<void> updateItem(Item item) async {
    // In real implementation, this would update database
  }

  @override
  Future<void> deleteItem(String id) async {
    // In real implementation, this would delete from database
  }

  @override
  Future<List<Item>> searchItems(String query) async {
    if (query.isEmpty) return await getAllItems();
    
    final items = await getAllItems();
    final lowerQuery = query.toLowerCase();
    
    return items.where((item) {
      return item.name.toLowerCase().contains(lowerQuery) ||
          (item.barcode?.toLowerCase().contains(lowerQuery) ?? false) ||
          (item.category?.toLowerCase().contains(lowerQuery) ?? false) ||
          item.materialCode.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  @override
  Future<List<Item>> filterByLocation(String locationId) async {
    final items = await getAllItems();
    return items.where((item) => item.currentLocation == locationId).toList();
  }

  @override
  Future<List<Item>> filterByCategory(String category) async {
    final items = await getAllItems();
    return items.where((item) => item.category == category).toList();
  }
}

