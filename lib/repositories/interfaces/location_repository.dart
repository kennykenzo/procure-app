import 'package:procurement_scanner/models/location.dart';

/// Repository interface for locations
/// Follows Dependency Inversion Principle
abstract class LocationRepository {
  /// Get all locations
  Future<List<Location>> getAllLocations();

  /// Get location by ID
  Future<Location?> getLocationById(String id);

  /// Add new location
  Future<void> addLocation(Location location);

  /// Update existing location
  Future<void> updateLocation(Location location);

  /// Delete location
  Future<void> deleteLocation(String id);
}

