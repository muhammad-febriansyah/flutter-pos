// To parse this JSON data, do
//
//     final setting = settingFromJson(jsonString);

import 'dart:convert';

Setting settingFromJson(String str) => Setting.fromJson(json.decode(str));

String settingToJson(Setting data) => json.encode(data.toJson());

class Setting {
  bool success;
  Data data;

  Setting({required this.success, required this.data});

  factory Setting.fromJson(Map<String, dynamic> json) =>
      Setting(success: json["success"], data: Data.fromJson(json["data"]));

  Map<String, dynamic> toJson() => {"success": success, "data": data.toJson()};
}

class Data {
  int id;
  String siteName;
  String keyword;
  String description;
  String email;
  String phone;
  String address;
  String fb;
  String ig;
  String tiktok;
  int ppn;
  int biayaLainnya;
  String logo;
  String thumbnail;
  DateTime createdAt;
  DateTime updatedAt;

  Data({
    required this.id,
    required this.siteName,
    required this.keyword,
    required this.description,
    required this.email,
    required this.phone,
    required this.address,
    required this.fb,
    required this.ig,
    required this.tiktok,
    required this.ppn,
    required this.biayaLainnya,
    required this.logo,
    required this.thumbnail,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    siteName: json["site_name"],
    keyword: json["keyword"],
    description: json["description"],
    email: json["email"],
    phone: json["phone"],
    address: json["address"],
    fb: json["fb"],
    ig: json["ig"],
    tiktok: json["tiktok"],
    ppn: json["ppn"],
    biayaLainnya: json["biaya_lainnya"],
    logo: json["logo"],
    thumbnail: json["thumbnail"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "site_name": siteName,
    "keyword": keyword,
    "description": description,
    "email": email,
    "phone": phone,
    "address": address,
    "fb": fb,
    "ig": ig,
    "tiktok": tiktok,
    "ppn": ppn,
    "biaya_lainnya": biayaLainnya,
    "logo": logo,
    "thumbnail": thumbnail,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
