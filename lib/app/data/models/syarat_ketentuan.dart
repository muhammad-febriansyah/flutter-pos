// lib/app/data/models/syarat_ketentuan_model.dart

import 'dart:convert';

// Fungsi helper untuk mem-parsing JSON string menjadi objek SyaratKetentuan
SyaratKetentuan syaratKetentuanFromJson(String str) =>
    SyaratKetentuan.fromJson(json.decode(str)['data']);

class SyaratKetentuan {
  final int id;
  final String body;

  SyaratKetentuan({required this.id, required this.body});

  // Factory constructor untuk membuat instance dari map (JSON object)
  factory SyaratKetentuan.fromJson(Map<String, dynamic> json) =>
      SyaratKetentuan(id: json["id"], body: json["body"]);

  // Factory constructor untuk membuat instance kosong/default
  factory SyaratKetentuan.empty() => SyaratKetentuan(id: 0, body: '');
}
