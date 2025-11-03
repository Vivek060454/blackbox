class TransactionModel {
  final int? id;
  final String dispenserNo;
  final double quantityFilled;
  final String vehicleNumber;
  final String paymentMode;
  final String? paymentProofPath;
  final double latitude;
  final double longitude;
  final DateTime createdAt;

  TransactionModel({
    this.id,
    required this.dispenserNo,
    required this.quantityFilled,
    required this.vehicleNumber,
    required this.paymentMode,
    this.paymentProofPath,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dispenserNo': dispenserNo,
      'quantityFilled': quantityFilled,
      'vehicleNumber': vehicleNumber,
      'paymentMode': paymentMode,
      'paymentProofPath': paymentProofPath,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as int?,
      dispenserNo: map['dispenserNo'] as String,
      quantityFilled: map['quantityFilled'] as double,
      vehicleNumber: map['vehicleNumber'] as String,
      paymentMode: map['paymentMode'] as String,
      paymentProofPath: map['paymentProofPath'] as String?,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}

