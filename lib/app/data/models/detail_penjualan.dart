// To parse this JSON data, do
//
//     final detailPenjualanModel = detailPenjualanModelFromJson(jsonString);

import 'dart:convert';

DetailPenjualanModel detailPenjualanModelFromJson(String str) =>
    DetailPenjualanModel.fromJson(json.decode(str));

String detailPenjualanModelToJson(DetailPenjualanModel data) =>
    json.encode(data.toJson());

class DetailPenjualanModel {
  bool success;
  List<DataPenjualan> data;

  DetailPenjualanModel({required this.success, required this.data});

  factory DetailPenjualanModel.fromJson(Map<String, dynamic> json) =>
      DetailPenjualanModel(
        success: json["success"],
        data: List<DataPenjualan>.from(
          json["data"].map((x) => DataPenjualan.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class DataPenjualan {
  int id;
  int penjualanId;
  int produkId;
  int qty;
  DateTime createdAt;
  DateTime updatedAt;
  Produk produk;
  Penjualan penjualan;

  DataPenjualan({
    required this.id,
    required this.penjualanId,
    required this.produkId,
    required this.qty,
    required this.createdAt,
    required this.updatedAt,
    required this.produk,
    required this.penjualan,
  });

  factory DataPenjualan.fromJson(Map<String, dynamic> json) => DataPenjualan(
    id: json["id"],
    penjualanId: json["penjualan_id"],
    produkId: json["produk_id"],
    qty: json["qty"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    produk: Produk.fromJson(json["produk"]),
    penjualan: Penjualan.fromJson(json["penjualan"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "penjualan_id": penjualanId,
    "produk_id": produkId,
    "qty": qty,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "produk": produk.toJson(),
    "penjualan": penjualan.toJson(),
  };
}

class Penjualan {
  int id;
  String invoiceNumber;
  int userId;
  int customerId;
  String type;
  int subTotal;
  int ppn;
  int biayaLayanan;
  int total;
  int laba;
  dynamic duitkuReference;
  String status;
  dynamic midtransTransactionId;
  dynamic paymentUrl;
  dynamic midtransSnapToken;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic mejaId;
  String paymentMethod;

  Penjualan({
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
  });

  factory Penjualan.fromJson(Map<String, dynamic> json) => Penjualan(
    id: json["id"],
    invoiceNumber: json["invoice_number"],
    userId: json["user_id"],
    customerId: json["customer_id"],
    type: json["type"],
    subTotal: json["sub_total"],
    ppn: json["ppn"],
    biayaLayanan: json["biaya_layanan"],
    total: json["total"],
    laba: json["laba"],
    duitkuReference: json["duitku_reference"],
    status: json["status"],
    midtransTransactionId: json["midtrans_transaction_id"],
    paymentUrl: json["payment_url"],
    midtransSnapToken: json["midtrans_snap_token"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    mejaId: json["meja_id"],
    paymentMethod: json["payment_method"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "invoice_number": invoiceNumber,
    "user_id": userId,
    "customer_id": customerId,
    "type": type,
    "sub_total": subTotal,
    "ppn": ppn,
    "biaya_layanan": biayaLayanan,
    "total": total,
    "laba": laba,
    "duitku_reference": duitkuReference,
    "status": status,
    "midtrans_transaction_id": midtransTransactionId,
    "payment_url": paymentUrl,
    "midtrans_snap_token": midtransSnapToken,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "meja_id": mejaId,
    "payment_method": paymentMethod,
  };
}

class Produk {
  int id;
  int kategoriId;
  int satuanId;
  String namaProduk;
  String slug;
  String deskripsi;
  int hargaBeli;
  int hargaJual;
  int promo;
  int percentage;
  int stok;
  int isActive;
  String image;
  DateTime createdAt;
  DateTime updatedAt;
  Kategori kategori;
  Satuan satuan;

  Produk({
    required this.id,
    required this.kategoriId,
    required this.satuanId,
    required this.namaProduk,
    required this.slug,
    required this.deskripsi,
    required this.hargaBeli,
    required this.hargaJual,
    required this.promo,
    required this.percentage,
    required this.stok,
    required this.isActive,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.kategori,
    required this.satuan,
  });

  factory Produk.fromJson(Map<String, dynamic> json) => Produk(
    id: json["id"],
    kategoriId: json["kategori_id"],
    satuanId: json["satuan_id"],
    namaProduk: json["nama_produk"],
    slug: json["slug"],
    deskripsi: json["deskripsi"],
    hargaBeli: json["harga_beli"],
    hargaJual: json["harga_jual"],
    promo: json["promo"],
    percentage: json["percentage"],
    stok: json["stok"],
    isActive: json["is_active"],
    image: json["image"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    kategori: Kategori.fromJson(json["kategori"]),
    satuan: Satuan.fromJson(json["satuan"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "kategori_id": kategoriId,
    "satuan_id": satuanId,
    "nama_produk": namaProduk,
    "slug": slug,
    "deskripsi": deskripsi,
    "harga_beli": hargaBeli,
    "harga_jual": hargaJual,
    "promo": promo,
    "percentage": percentage,
    "stok": stok,
    "is_active": isActive,
    "image": image,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "kategori": kategori.toJson(),
    "satuan": satuan.toJson(),
  };
}

class Kategori {
  int id;
  String kategori;
  String slug;
  String icon;
  DateTime createdAt;
  DateTime updatedAt;

  Kategori({
    required this.id,
    required this.kategori,
    required this.slug,
    required this.icon,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Kategori.fromJson(Map<String, dynamic> json) => Kategori(
    id: json["id"],
    kategori: json["kategori"],
    slug: json["slug"],
    icon: json["icon"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "kategori": kategori,
    "slug": slug,
    "icon": icon,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class Satuan {
  int id;
  String satuan;
  DateTime createdAt;
  DateTime updatedAt;

  Satuan({
    required this.id,
    required this.satuan,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Satuan.fromJson(Map<String, dynamic> json) => Satuan(
    id: json["id"],
    satuan: json["satuan"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "satuan": satuan,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
