import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/models/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider extends GetConnect {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BACKEND_URL']!,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  Future<Setting> fetchSetting() async {
    final response = await _dio.get('/setting');
    if (kDebugMode) {
      print(response.data);
    }
    return Setting.fromJson(response.data);
  }

  Future<bool> login({required String email, required String password}) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {'email': email, 'password': password},
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (kDebugMode) {
        print('Login response: ${response.data}');
      }

      final token = response.data['token'];
      final data = response.data['user'];

      if (token != null && data != null && data['id'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setBool("status", true);
        await prefs.setInt("idUser", data['id']);
        if (kDebugMode) print('🔐 Token disimpan: $token');
        return true;
      } else {
        if (kDebugMode) print('⚠️ Token atau data user tidak ditemukan.');
        return false;
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ Login error: ${e.response?.data}');
      }
      if (e.response?.statusCode == 422) {
        return false;
      } else {
        rethrow;
      }
    }
  }
}
