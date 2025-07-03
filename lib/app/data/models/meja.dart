// app/data/models/meja_model.dart
import 'dart:convert';

MejaModel mejaModelFromJson(String str) => MejaModel.fromJson(json.decode(str));
String mejaModelToJson(MejaModel data) => json.encode(data.toJson());

class MejaModel {
  bool success;
  List<DataMeja> data;

  MejaModel({required this.success, required this.data});

  factory MejaModel.fromJson(Map<String, dynamic> json) => MejaModel(
    success: json["success"],
    data: List<DataMeja>.from(json["data"].map((x) => DataMeja.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class DataMeja {
  int id;
  String nama;
  String status;
  int kapasitas;
  DateTime createdAt;
  DateTime updatedAt;

  DataMeja({
    required this.id,
    required this.nama,
    required this.status,
    required this.kapasitas,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DataMeja.fromJson(Map<String, dynamic> json) => DataMeja(
    // Safely parse 'id' to an integer.
    // If json["id"] is a String (e.g., "1"), it will be parsed to 1.
    // If it's already an int (e.g., 1), it will be used directly.
    // If it's null, it defaults to 0 or you can handle as needed (e.g., throw error).
    id:
        int.tryParse(json["id"].toString()) ??
        0, // Using toString() to handle both int and String inputs
    nama: json["nama"],
    status: json["status"],
    kapasitas: json["kapasitas"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nama": nama,
    "status": status,
    "kapasitas": kapasitas,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };

  // Add for easy comparison in dropdown/selection
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DataMeja && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
