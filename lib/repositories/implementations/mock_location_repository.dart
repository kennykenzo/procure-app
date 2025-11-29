import 'package:procurement_scanner/models/location.dart';
import 'package:procurement_scanner/repositories/interfaces/location_repository.dart';
import 'package:procurement_scanner/utils/mock_data.dart';

/// Mock implementation of LocationRepository
class MockLocationRepository implements LocationRepository {
  @override
  Future<List<Location>> getAllLocations() async {
    return generateMockLocations();
  }

  @override
  Future<Location?> getLocationById(String id) async {
    final locations = await getAllLocations();
    try {
      return locations.firstWhere((location) => location.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> addLocation(Location location) async {
    // In real implementation, this would persist to database
  }

  @override
  Future<void> updateLocation(Location location) async {
    // In real implementation, this would update database
  }

  @override
  Future<void> deleteLocation(String id) async {
    // In real implementation, this would delete from database
  }
}

