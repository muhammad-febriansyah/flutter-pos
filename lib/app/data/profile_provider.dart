import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider {
  late Dio _dio;

  ProfileProvider() {
    _dio = Dio(
      BaseOptions(
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

  // Fungsi untuk update profil
  Future<Response> updateProfile(FormData formData) async {
    try {
      // Ambil token dari SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception("User not authenticated");
      }

      // Kirim request POST ke endpoint update
      final response = await _dio.post(
        '/user/update',
        data: formData,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return response;
    } on DioException catch (e) {
      // Tangani error dari Dio (misal: koneksi, server error)
      if (kDebugMode) {
        print("Dio Error in updateProfile: ${e.response?.data ?? e.message}");
      }
      throw Exception(
        e.response?.data['message'] ?? 'Failed to update profile',
      );
    } catch (e) {
      if (kDebugMode) {
        print("Generic Error in updateProfile: $e");
      }
      throw Exception('An unexpected error occurred.');
    }
  }

  Future<Response> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception("User not authenticated");
      }

      // Kirim request POST ke endpoint ganti password
      final response = await _dio.post(
        '/user/change-password',
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
          'new_password_confirmation': newPasswordConfirmation,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return response;
    } on DioException catch (e) {
      // Tangani error dari Dio, terutama untuk pesan validasi dari Laravel
      if (kDebugMode) {
        print("Dio Error in updatePassword: ${e.response?.data ?? e.message}");
      }
      // Lempar pesan error dari server jika ada, jika tidak, lempar pesan umum
      throw Exception(
        e.response?.data['message'] ?? 'Gagal memperbarui password',
      );
    } catch (e) {
      if (kDebugMode) {
        print("Generic Error in updatePassword: $e");
      }
      throw Exception('Terjadi kesalahan yang tidak terduga.');
    }
  }
}
