import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/models/product.dart';
import 'package:pos/app/data/models/rating.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductProvider extends GetConnect {
  late Dio _dio;

  ProductProvider() {
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

  Future<ProductModel> getProduct() async {
    final res = await _dio.get("/product");
    if (res.statusCode == 200 && res.data['success'] == true) {
      return ProductModel.fromJson(res.data);
    } else {
      throw Exception('Failed to load product');
    }
  }

  Future<ProductModel> getProductByKategori({
    // ignore: non_constant_identifier_names
    required String kategori_id,
  }) async {
    final res = await _dio.get("/productByKategori/$kategori_id");
    if (res.statusCode == 200 && res.data['success'] == true) {
      return ProductModel.fromJson(res.data);
    } else {
      throw Exception('Failed to load product');
    }
  }

  Future<List<int>> getWishlistProductIds() async {
    final response = await _dio.get('/wishlist');
    if (response.statusCode == 200) {
      final List data = response.data['data'];
      return data.map<int>((item) => item['produk_id'] as int).toList();
    } else {
      throw Exception('Failed to fetch wishlist product IDs');
    }
  }

  Future<bool> addToWishlist(int productId) async {
    try {
      final response = await _dio.post(
        '/wishlist/add',
        data: {'produk_id': productId},
      );

      return response.statusCode == 201 || response.statusCode == 200;
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        return true; // Sudah ada, tidak masalah
      }
      rethrow;
    }
  }

  Future<bool> removeFromWishlist(int productId) async {
    final res = await _dio.post(
      '/wishlist/remove',
      data: {'produk_id': productId},
    );
    return res.statusCode == 200 && res.data['success'] == true;
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
