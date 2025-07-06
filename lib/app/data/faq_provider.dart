// lib/app/data/providers/faq_provider.dart

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pos/app/data/models/faq.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FaqProvider {
  late Dio _dio;

  // Endpoint untuk FAQ, sesuaikan jika berbeda
  final String _faqEndpoint = "/faq";

  FaqProvider() {
    _dio = Dio(
      BaseOptions(
        // Pastikan .env file Anda sudah ada dan berisi BACKEND_URL
        baseUrl: dotenv.env['BACKEND_URL']!,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
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

  /// Mengambil daftar FAQ dari API
  Future<List<Faq>> getFaqs() async {
    try {
      final response = await _dio.get(_faqEndpoint);

      if (response.statusCode == 200 && response.data['success'] == true) {
        // Parsing data list dari JSON
        final List<dynamic> faqData = response.data['data'];
        return faqData.map((json) => Faq.fromJson(json)).toList();
      } else {
        // Lemparkan error jika request tidak berhasil atau format data salah
        throw Exception(
          'Failed to load FAQs: ${response.data['message'] ?? 'Unknown error'}',
        );
      }
    } on DioException catch (e) {
      // Menangani error spesifik dari Dio (misal: timeout, no internet)
      throw Exception('Failed to load FAQs: ${e.message}');
    } catch (e) {
      // Menangani error lainnya
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
