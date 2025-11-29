/// Transaction type enum
enum TransactionType {
  scanIn,
  scanOut,
  transfer,
}

/// Transaction model representing a scan in/out or transfer operation
/// Based on Office Stock Register structure
class Transaction {
  final String id;
  final String itemId;
  final String? materialCode; // Material code for quick reference
  final TransactionType type;
  final String? fromLocation;
  final String? toLocation;
  final int quantity;
  final String? unitOfMeasure; // UOM for the transaction
  final DateTime timestamp;
  final String? userId;
  final String? remarks; // Additional remarks/notes

  const Transaction({
    required this.id,
    required this.itemId,
    this.materialCode,
    required this.type,
    this.fromLocation,
    this.toLocation,
    required this.quantity,
    this.unitOfMeasure,
    required this.timestamp,
    this.userId,
    this.remarks,
  });

  Transaction copyWith({
    String? id,
    String? itemId,
    String? materialCode,
    TransactionType? type,
    String? fromLocation,
    String? toLocation,
    int? quantity,
    String? unitOfMeasure,
    DateTime? timestamp,
    String? userId,
    String? remarks,
  }) {
    return Transaction(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      materialCode: materialCode ?? this.materialCode,
      type: type ?? this.type,
      fromLocation: fromLocation ?? this.fromLocation,
      toLocation: toLocation ?? this.toLocation,
      quantity: quantity ?? this.quantity,
      unitOfMeasure: unitOfMeasure ?? this.unitOfMeasure,
      timestamp: timestamp ?? this.timestamp,
      userId: userId ?? this.userId,
      remarks: remarks ?? this.remarks,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemId': itemId,
      'materialCode': materialCode,
      'type': type.name,
      'fromLocation': fromLocation,
      'toLocation': toLocation,
      'quantity': quantity,
      'unitOfMeasure': unitOfMeasure,
      'timestamp': timestamp.toIso8601String(),
      'userId': userId,
      'remarks': remarks,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      itemId: json['itemId'] as String,
      materialCode: json['materialCode'] as String?,
      type: TransactionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => TransactionType.scanIn,
      ),
      fromLocation: json['fromLocation'] as String?,
      toLocation: json['toLocation'] as String?,
      quantity: json['quantity'] as int,
      unitOfMeasure: json['unitOfMeasure'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      userId: json['userId'] as String?,
      remarks: json['remarks'] as String?,
    );
  }
}

