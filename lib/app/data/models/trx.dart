// To parse this JSON data, do
//
//     final transaksiModel = transaksiModelFromJson(jsonString);

import 'dart:convert';

TransaksiModel transaksiModelFromJson(String str) =>
    TransaksiModel.fromJson(json.decode(str));

String transaksiModelToJson(TransaksiModel data) => json.encode(data.toJson());

class TransaksiModel {
  bool success;
  List<Datum> data;

  TransaksiModel({required this.success, required this.data});

  factory TransaksiModel.fromJson(Map<String, dynamic> json) => TransaksiModel(
    success: json["success"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int id;
  String invoiceNumber;
  int userId;
  int customerId;
  Type type;
  int subTotal;
  int ppn;
  int biayaLayanan;
  int total;
  int laba;
  String? duitkuReference; // Changed to String? for nullable string
  Status status;
  String? paymentUrl; // Changed to String? for nullable string
  DateTime createdAt;
  DateTime updatedAt;
  int? mejaId;
  PaymentMethod paymentMethod;

  Datum({
    required this.id,
    required this.invoiceNumber,
    required this.userId,
    required this.customerId,
    required this.type,
    required this.subTotal,
    required this.ppn,
    required this.biayaLayanan,
    required this.total,
    required this.laba,
    this.duitkuReference, // Made optional for constructor
    this.status = Status.PENDING, // Set default status
    this.paymentUrl, // Made optional for constructor
    required this.createdAt,
    required this.updatedAt,
    this.mejaId, // Made optional for constructor
    required this.paymentMethod,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    invoiceNumber: json["invoice_number"],
    userId: json["user_id"],
    customerId: json["customer_id"],
    type: typeValues.map[json["type"]]!,
    subTotal: json["sub_total"],
    ppn: json["ppn"],
    biayaLayanan: json["biaya_layanan"],
    total: json["total"],
    laba: json["laba"],
    duitkuReference: json["duitku_reference"],
    status: statusValues.map[json["status"]]!,
    paymentUrl: json["payment_url"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    mejaId: json["meja_id"],
    paymentMethod: paymentMethodValues.map[json["payment_method"]]!,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "invoice_number": invoiceNumber,
    "user_id": userId,
    "customer_id": customerId,
    "type": typeValues.reverse[type],
    "sub_total": subTotal,
    "ppn": ppn,
    "biaya_layanan": biayaLayanan,
    "total": total,
    "laba": laba,
    "duitku_reference": duitkuReference,
    "status": statusValues.reverse[status],
    "payment_url": paymentUrl,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "meja_id": mejaId,
    "payment_method": paymentMethodValues.reverse[paymentMethod],
  };
}

enum PaymentMethod {
  CASH,
  DUITKU, // Added DUITKU
}

final paymentMethodValues = EnumValues({
  "cash": PaymentMethod.CASH,
  "duitku": PaymentMethod.DUITKU,
});

enum Status {
  PENDING, // Added PENDING
  COMPLETED, // Added COMPLETED (or use PAID if you prefer)
  CANCELLED, // Added CANCELLED
  FAILED, // Added FAILED
  PAID, // Keep PAID if it's a specific final status
}

final statusValues = EnumValues({
  "pending": Status.PENDING,
  "completed": Status.COMPLETED,
  "cancelled": Status.CANCELLED,
  "failed": Status.FAILED,
  "paid": Status.PAID,
});

enum Type { DINE_IN }

final typeValues = EnumValues({"dine_in": Type.DINE_IN});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
