import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/models/rating.dart';
import 'package:pos/app/data/models/wishlist.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistProvider extends GetConnect {
  late Dio _dio;
  WishlistProvider() {
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
  Future<WishlistModel> getWishlist() async {
    final res = await _dio.get("/wishlist");
    if (res.statusCode == 200 && res.data['success'] == true) {
      if (kDebugMode) {
        print("res: ${res.data}");
      }
      return WishlistModel.fromJson(res.data);
    } else {
      throw Exception('Failed to load product');
    }
  }

  Future<bool> addToWishlist(int productId) async {
    try {
      final res = await _dio.post(
        "/wishlist/add",
        data: {'produk_id': productId},
      );
      return res.statusCode == 200;
    } catch (e) {
      if (kDebugMode) print("❌ Error addToWishlist: $e");
      return false;
    }
  }

  Future<bool> removeFromWishlist(int productId) async {
    try {
      final res = await _dio.post(
        "/wishlist/remove",
        data: {'produk_id': productId},
      );
      return res.statusCode == 200;
    } catch (e) {
      if (kDebugMode) print("❌ Error removeFromWishlist: $e");
      return false;
    }
  }

  Future<RatingStats> getRatingStatsByProductId(int productId) async {
    try {
      final response = await _dio.get('/ratings/stats/$productId');
      if (response.statusCode == 200 && response.data['success'] == true) {
        if (kDebugMode) {
          print(
            "Rating stats for product $productId fetched: ${response.data['data']}",
          );
        }
        return RatingStats.fromJson(response.data['data']);
      } else {
        throw Exception(
          'Failed to load rating stats: ${response.data['message'] ?? response.statusCode}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching rating stats for product $productId: $e");
      }
      // Return a default RatingStats object on error or if no data
      return RatingStats(
        averageRating: 0.0,
        totalRatings: 0,
        ratingDistribution: {},
      );
    }
  }
}
