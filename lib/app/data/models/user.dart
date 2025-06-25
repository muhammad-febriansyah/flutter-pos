// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  User user;
  String message;
  bool success;

  UserModel({required this.user, required this.message, required this.success});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    user: User.fromJson(json["user"]),
    message: json["message"],
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
    "message": message,
    "success": success,
  };
}

class User {
  int id;
  String name;
  String email;
  dynamic googleId;
  dynamic emailVerifiedAt;
  String phone;
  String address;
  dynamic avatar;
  String role;
  int isActive;
  DateTime createdAt;
  DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.googleId,
    required this.emailVerifiedAt,
    required this.phone,
    required this.address,
    required this.avatar,
    required this.role,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    googleId: json["google_id"],
    emailVerifiedAt: json["email_verified_at"],
    phone: json["phone"],
    address: json["address"],
    avatar: json["avatar"],
    role: json["role"],
    isActive: json["is_active"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "google_id": googleId,
    "email_verified_at": emailVerifiedAt,
    "phone": phone,
    "address": address,
    "avatar": avatar,
    "role": role,
    "is_active": isActive,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
