// To parse this JSON data, do
//
//     final wishlistModel = wishlistModelFromJson(jsonString);

import 'dart:convert';

WishlistModel wishlistModelFromJson(String str) =>
    WishlistModel.fromJson(json.decode(str));

String wishlistModelToJson(WishlistModel data) => json.encode(data.toJson());

class WishlistModel {
  List<Datum> data;
  bool success;

  WishlistModel({required this.data, required this.success});

  factory WishlistModel.fromJson(Map<String, dynamic> json) => WishlistModel(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "success": success,
  };
}

class Datum {
  int id;
  int userId;
  int produkId;
  DateTime createdAt;
  DateTime updatedAt;
  Produk produk;

  Datum({
    required this.id,
    required this.userId,
    required this.produkId,
    required this.createdAt,
    required this.updatedAt,
    required this.produk,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    userId: json["user_id"],
    produkId: json["produk_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    produk: Produk.fromJson(json["produk"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "produk_id": produkId,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "produk": produk.toJson(),
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
  String? image;
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
