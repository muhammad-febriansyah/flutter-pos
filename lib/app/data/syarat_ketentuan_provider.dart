// lib/app/data/providers/syarat_ketentuan_provider.dart

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pos/app/data/models/syarat_ketentuan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SyaratKetentuanProvider {
  late Dio _dio;

  // Sesuaikan endpoint API Anda.
  final String _endpoint = "/syaratKetentuan";

  SyaratKetentuanProvider() {
    _dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['BACKEND_URL']!,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Accept': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          if (kDebugMode) {
            print('🚀 Dio Request: ${options.method} ${options.uri}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print(
              '✅ Dio Response [${response.statusCode}]: ${response.requestOptions.uri}',
            );
          }
          return handler.next(response);
        },
        onError: (e, handler) {
          if (kDebugMode) {
            print(
              '❌ Dio Error [${e.response?.statusCode}]: ${e.requestOptions.uri}',
            );
            print('Error Message: ${e.message}');
          }
          return handler.next(e);
        },
      ),
    );
  }

  /// Mengambil data Syarat & Ketentuan dari API
  Future<SyaratKetentuan> getSyaratKetentuan() async {
    try {
      final response = await _dio.get(_endpoint);

      if (response.statusCode == 200 && response.data['success'] == true) {
        return SyaratKetentuan.fromJson(response.data['data']);
      } else {
        throw Exception('Gagal memuat data: Format respons tidak sesuai.');
      }
    } on DioException catch (e) {
      throw Exception('Gagal terhubung ke server: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan tidak terduga: $e');
    }
  }
}
