// pos/app/data/models/product.dart
// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  bool success;
  List<Datum> data;

  ProductModel({required this.success, required this.data});

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
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
  int kategoriId;
  int satuanId;
  String namaProduk; // Pastikan ini nama properti yang benar
  String slug;
  String deskripsi;
  int hargaBeli;
  int hargaJual; // Pastikan ini nama properti yang benar
  int promo;
  int percentage;
  int stok;
  int isActive;
  String? image;
  DateTime createdAt;
  DateTime updatedAt;
  Kategori kategori;
  Satuan satuan;

  Datum({
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

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    kategoriId: json["kategori_id"],
    satuanId: json["satuan_id"],
    // Pastikan key ini sesuai dengan JSON dari API Anda
    namaProduk: json["nama_produk"],
    slug: json["slug"],
    deskripsi: json["deskripsi"],
    hargaBeli: json["harga_beli"],
    // Pastikan key ini sesuai dengan JSON dari API Anda
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
    // Pastikan key ini sesuai untuk dikirim ke API Anda
    "nama_produk": namaProduk,
    "slug": slug,
    "deskripsi": deskripsi,
    "harga_beli": hargaBeli,
    // Pastikan key ini sesuai untuk dikirim ke API Anda
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
