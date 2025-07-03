import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/models/detail_penjualan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SuccessProvider extends GetConnect {
  late Dio _dio;
  SuccessProvider() {
    _dio = Dio(
      BaseOptions(
        baseUrl:
            dotenv
                .env['BACKEND_URL']!, // Pastikan BACKEND_URL di .env sudah benar!
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
          return handler.next(options);
        },
        onError: (e, handler) {
          if (kDebugMode) {
            print('❌ Dio Error: ${e.message}');
          }
          return handler.next(e);
        },
      ),
    );
  }

  // Ubah tipe kembalian ke DetailPenjualanModel
  Future<DetailPenjualanModel> getProductDetail({
    required String invoiceNumber,
  }) async {
    // Pastikan endpoint ini sesuai dengan API backend Anda
    final response = await _dio.get('/detailcheckout/$invoiceNumber');

    if (response.statusCode == 200 && response.data['success'] == true) {
      if (kDebugMode) {
        print("API Response: ${response.data}"); // Log respons untuk debug
      }
      // Parse respons ke DetailPenjualanModel
      return DetailPenjualanModel.fromJson(response.data);
    } else {
      // Lebih spesifik jika bisa:
      String errorMessage = 'Gagal memuat detail penjualan.';
      if (response.data != null &&
          response.data is Map &&
          response.data['message'] != null) {
        errorMessage = response.data['message'];
      }
      throw Exception(errorMessage);
    }
  }
}
