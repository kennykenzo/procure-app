/// Location model representing a physical location where items can be stored
/// Supports both Warehouse and Office locations
class Location {
  final String id;
  final String name;
  final String? description;
  final String? address;
  final bool isWarehouse; // true for warehouse, false for office
  final String? warehouseCode; // Warehouse code if applicable

  const Location({
    required this.id,
    required this.name,
    this.description,
    this.address,
    this.isWarehouse = true,
    this.warehouseCode,
  });

  Location copyWith({
    String? id,
    String? name,
    String? description,
    String? address,
    bool? isWarehouse,
    String? warehouseCode,
  }) {
    return Location(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      isWarehouse: isWarehouse ?? this.isWarehouse,
      warehouseCode: warehouseCode ?? this.warehouseCode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'isWarehouse': isWarehouse,
      'warehouseCode': warehouseCode,
    };
  }

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      address: json['address'] as String?,
      isWarehouse: json['isWarehouse'] as bool? ?? true,
      warehouseCode: json['warehouseCode'] as String?,
    );
  }
}

