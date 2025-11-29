/// Item model representing a material/item in the procurement system
/// Based on MATERIAL DATA SHEET structure
class Item {
  final String id;
  final String materialCode; // Material/Item code from data sheet
  final String name;
  final String? description;
  final String? specification; // Material specifications
  final String? unitOfMeasure; // UOM (e.g., pcs, kg, m, etc.)
  final String? barcode;
  final String? nfcId;
  final String currentLocation;
  final int quantity;
  final String? category;
  final String? supplier;
  final String? notes;
  final bool isOfficeStock; // Distinguishes office stock from warehouse
  final DateTime createdAt;
  final DateTime updatedAt;

  const Item({
    required this.id,
    required this.materialCode,
    required this.name,
    this.description,
    this.specification,
    this.unitOfMeasure,
    this.barcode,
    this.nfcId,
    required this.currentLocation,
    required this.quantity,
    this.category,
    this.supplier,
    this.notes,
    this.isOfficeStock = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Item copyWith({
    String? id,
    String? materialCode,
    String? name,
    String? description,
    String? specification,
    String? unitOfMeasure,
    String? barcode,
    String? nfcId,
    String? currentLocation,
    int? quantity,
    String? category,
    String? supplier,
    String? notes,
    bool? isOfficeStock,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Item(
      id: id ?? this.id,
      materialCode: materialCode ?? this.materialCode,
      name: name ?? this.name,
      description: description ?? this.description,
      specification: specification ?? this.specification,
      unitOfMeasure: unitOfMeasure ?? this.unitOfMeasure,
      barcode: barcode ?? this.barcode,
      nfcId: nfcId ?? this.nfcId,
      currentLocation: currentLocation ?? this.currentLocation,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      supplier: supplier ?? this.supplier,
      notes: notes ?? this.notes,
      isOfficeStock: isOfficeStock ?? this.isOfficeStock,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'materialCode': materialCode,
      'name': name,
      'description': description,
      'specification': specification,
      'unitOfMeasure': unitOfMeasure,
      'barcode': barcode,
      'nfcId': nfcId,
      'currentLocation': currentLocation,
      'quantity': quantity,
      'category': category,
      'supplier': supplier,
      'notes': notes,
      'isOfficeStock': isOfficeStock,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as String,
      materialCode: json['materialCode'] as String? ?? json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      specification: json['specification'] as String?,
      unitOfMeasure: json['unitOfMeasure'] as String?,
      barcode: json['barcode'] as String?,
      nfcId: json['nfcId'] as String?,
      currentLocation: json['currentLocation'] as String,
      quantity: json['quantity'] as int,
      category: json['category'] as String?,
      supplier: json['supplier'] as String?,
      notes: json['notes'] as String?,
      isOfficeStock: json['isOfficeStock'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

