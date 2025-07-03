// To parse this JSON data, do
//
//     final penjualanModel = penjualanModelFromJson(jsonString);

import 'dart:convert';

PenjualanModel penjualanModelFromJson(String str) =>
    PenjualanModel.fromJson(json.decode(str));

String penjualanModelToJson(PenjualanModel data) => json.encode(data.toJson());

class PenjualanModel {
  bool success;
  List<Datum> data;

  PenjualanModel({required this.success, required this.data});

  factory PenjualanModel.fromJson(Map<String, dynamic> json) => PenjualanModel(
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
  dynamic duitkuReference;
  Status status;
  String? midtransTransactionId;
  String? paymentUrl;
  String? midtransSnapToken;
  DateTime createdAt;
  DateTime updatedAt;
  int? mejaId;
  PaymentMethod paymentMethod;
  dynamic produk;

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
    required this.duitkuReference,
    required this.status,
    required this.midtransTransactionId,
    required this.paymentUrl,
    required this.midtransSnapToken,
    required this.createdAt,
    required this.updatedAt,
    required this.mejaId,
    required this.paymentMethod,
    required this.produk,
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
    midtransTransactionId: json["midtrans_transaction_id"],
    paymentUrl: json["payment_url"],
    midtransSnapToken: json["midtrans_snap_token"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    mejaId: json["meja_id"],
    paymentMethod: paymentMethodValues.map[json["payment_method"]]!,
    produk: json["produk"],
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
    "midtrans_transaction_id": midtransTransactionId,
    "payment_url": paymentUrl,
    "midtrans_snap_token": midtransSnapToken,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "meja_id": mejaId,
    "payment_method": paymentMethodValues.reverse[paymentMethod],
    "produk": produk,
  };
}

enum PaymentMethod { CASH, MIDTRANS }

final paymentMethodValues = EnumValues({
  "cash": PaymentMethod.CASH,
  "midtrans": PaymentMethod.MIDTRANS,
});

enum Status { PAID, PENDING }

final statusValues = EnumValues({
  "paid": Status.PAID,
  "pending": Status.PENDING,
});

enum Type { DINE_IN, TAKE_AWAY }

final typeValues = EnumValues({
  "dine_in": Type.DINE_IN,
  "take_away": Type.TAKE_AWAY,
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
