// To parse this JSON data, do
//
//     final kategoriModel = kategoriModelFromJson(jsonString);

import 'dart:convert';

KategoriModel kategoriModelFromJson(String str) =>
    KategoriModel.fromJson(json.decode(str));

String kategoriModelToJson(KategoriModel data) => json.encode(data.toJson());

class KategoriModel {
  bool success;
  List<Datum> data;

  KategoriModel({required this.success, required this.data});

  factory KategoriModel.fromJson(Map<String, dynamic> json) => KategoriModel(
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
  String kategori;
  String slug;
  String icon;
  DateTime createdAt;
  DateTime updatedAt;

  Datum({
    required this.id,
    required this.kategori,
    required this.slug,
    required this.icon,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
