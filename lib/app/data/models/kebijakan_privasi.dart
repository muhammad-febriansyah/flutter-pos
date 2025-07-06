// lib/app/data/models/kebijakan_privasi_model.dart

import 'dart:convert';

// Fungsi helper untuk mem-parsing JSON string menjadi objek KebijakanPrivasi
KebijakanPrivasi kebijakanPrivasiFromJson(String str) =>
    KebijakanPrivasi.fromJson(json.decode(str)['data']);

class KebijakanPrivasi {
  final int id;
  final String body;

  KebijakanPrivasi({required this.id, required this.body});

  // Factory constructor untuk membuat instance dari map (JSON object)
  factory KebijakanPrivasi.fromJson(Map<String, dynamic> json) =>
      KebijakanPrivasi(id: json["id"], body: json["body"]);

  // Factory constructor untuk membuat instance kosong/default
  factory KebijakanPrivasi.empty() => KebijakanPrivasi(id: 0, body: '');
}
