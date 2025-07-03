import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RatingProvider extends GetConnect {
  late final dio.Dio _dio;

  RatingProvider() {
    _dio = dio.Dio(
      dio.BaseOptions(
        baseUrl:
            dotenv
                .env['BACKEND_URL']!, // Pastikan BACKEND_URL di .env sudah benar
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Accept': 'application/json'},
      ),
    );

    // Menambahkan interceptor untuk menambahkan token otorisasi ke setiap request
    _dio.interceptors.add(
      dio.InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          if (kDebugMode) {
            print('Dio Request: ${options.method} ${options.path}');
            print('Dio Request Headers: ${options.headers}');
            print('Dio Request Data: ${options.data}');
            print('Dio Request Query Parameters: ${options.queryParameters}');
          }
          return handler.next(options);
        },
        onError: (e, handler) {
          // Menampilkan detail error Dio di debug console
          if (kDebugMode) {
            print('Dio Error: ${e.message}');
            if (e.response != null) {
              print(
                'Dio Error Response Status Code: ${e.response!.statusCode}',
              );
              print('Dio Error Response Data: ${e.response!.data}');
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  // Menambahkan rating baru
  Future<dio.Response> addRating({
    required int productId, // Nama parameter sudah sesuai dengan backend
    required int transactionId,
    required int rating,
    String? comment,
  }) async {
    try {
      final response = await _dio.post(
        '/product-ratings', // Endpoint sesuai dengan rute Laravel
        data: {
          'product_id': productId, // Kunci data sesuai dengan validasi Laravel
          'transaction_id': transactionId,
          'rating': rating,
          'comment': comment,
        },
      );
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error adding rating: $e');
      }
      rethrow;
    }
  }

  // Mengambil rating untuk produk tertentu
  Future<dio.Response> getRatingsByProduct(int productId) async {
    try {
      return await _dio.get('/ratings/product/$productId'); // Endpoint sesuai
    } catch (e) {
      if (kDebugMode) {
        print('Error getting ratings: $e');
      }
      rethrow;
    }
  }

  // Mengambil rating yang diberikan oleh user yang sedang login
  Future<dio.Response> getUserRatings() async {
    try {
      return await _dio.get('/ratings/user'); // Endpoint sesuai
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user ratings: $e');
      }
      rethrow;
    }
  }

  // Mengupdate rating yang sudah ada
  Future<dio.Response> updateRating({
    required int ratingId,
    required int rating,
    String? comment,
  }) async {
    try {
      return await _dio.put(
        '/ratings/$ratingId', // Endpoint sesuai
        data: {'rating': rating, 'comment': comment},
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error updating rating: $e');
      }
      rethrow;
    }
  }

  // Menghapus rating
  Future<dio.Response> deleteRating(int ratingId) async {
    try {
      return await _dio.delete('/ratings/$ratingId'); // Endpoint sesuai
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting rating: $e');
      }
      rethrow;
    }
  }

  // Mengecek rating yang sudah ada untuk produk dan transaksi tertentu
  Future<dio.Response> checkExistingRating({
    required int productId, // Nama parameter sudah sesuai
    required int transactionId,
  }) async {
    try {
      return await _dio.get(
        '/ratings/check', // Endpoint sesuai
        queryParameters: {
          'product_id': productId, // Kunci query parameter sesuai
          'transaction_id': transactionId,
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error checking existing rating: $e');
      }
      rethrow;
    }
  }

  // Mengambil statistik rating untuk produk tertentu
  Future<dio.Response> getRatingStats(int productId) async {
    try {
      return await _dio.get('/ratings/stats/$productId'); // Endpoint sesuai
    } catch (e) {
      if (kDebugMode) {
        print('Error getting rating stats: $e');
      }
      rethrow;
    }
  }
}
