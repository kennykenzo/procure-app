import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:procurement_scanner/models/location.dart';
import 'package:procurement_scanner/repositories/implementations/mock_location_repository.dart';
import 'package:procurement_scanner/repositories/interfaces/location_repository.dart';

/// Repository provider - follows Dependency Inversion Principle
final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  return MockLocationRepository();
});

/// Provider for locations list - follows Open/Closed Principle
final locationsProvider = FutureProvider<List<Location>>((ref) async {
  final repository = ref.watch(locationRepositoryProvider);
  return await repository.getAllLocations();
});

/// Provider for location by ID
final locationByIdProvider = FutureProvider.family<Location?, String>((ref, id) async {
  final repository = ref.watch(locationRepositoryProvider);
  return await repository.getLocationById(id);
});
