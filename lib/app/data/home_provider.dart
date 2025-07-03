import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/models/kategori.dart';
import 'package:pos/app/data/models/product.dart';
import 'package:pos/app/data/models/user.dart';
import 'package:pos/app/data/models/rating.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeProvider extends GetConnect {
  late Dio _dio;
  HomeProvider() {
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

  Future<User> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final idUser = prefs.getInt('idUser');
    final response = await _dio.get('/userprofile', data: {'id': idUser});
    if (kDebugMode) {
      print(response.data['user']);
    }
    return User.fromJson(response.data['user']);
  }

  Future<KategoriModel> fetchKategori() async {
    final response = await _dio.get('/kategori');

    if (response.statusCode == 200 && response.data['success'] == true) {
      if (kDebugMode) {
        print("res: ${response.data}");
      }
      return KategoriModel.fromJson(response.data);
    } else {
      throw Exception('Failed to load kategori');
    }
  }

  Future<ProductModel> promoProduct() async {
    final res = await _dio.get("/promoProduct");
    if (res.statusCode == 200 && res.data['success'] == true) {
      if (kDebugMode) {
        print("res: ${res.data}");
      }
      return ProductModel.fromJson(res.data);
    } else {
      throw Exception('Failed to load product');
    }
  }

  Future<ProductModel> productHome() async {
    final res = await _dio.get("/productHome");
    if (res.statusCode == 200 && res.data['success'] == true) {
      if (kDebugMode) {
        print("res: ${res.data}");
      }
      return ProductModel.fromJson(res.data);
    } else {
      throw Exception('Failed to load product');
    }
  }

  Future<List<int>> getWishlistProductIds() async {
    try {
      final response = await _dio.get('/wishlist');
      if (response.statusCode == 200 && response.data['success'] == true) {
        if (kDebugMode) {
          print("Wishlist fetched: ${response.data['data']}");
        }
        final List data = response.data['data'];

        return data.map<int>((item) => item['produk_id'] as int).toList();
      } else {
        throw Exception(
          'Failed to load wishlist: ${response.data['message'] ?? response.statusCode}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching wishlist: $e");
      }
      return [];
    }
  }

  Future<bool> addToWishlist(int productId) async {
    try {
      final response = await _dio.post(
        '/wishlist/add',
        data: {'produk_id': productId},
      );
      if (response.statusCode == 201 && response.data['success'] == true) {
        if (kDebugMode) {
          print("Produk $productId berhasil ditambahkan ke wishlist.");
        }
        return true;
      } else {
        throw Exception(
          'Failed to add to wishlist: ${response.data['message'] ?? response.statusCode}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error adding to wishlist: $e");
      }
      return false;
    }
  }

  Future<bool> removeFromWishlist(int productId) async {
    try {
      final response = await _dio.post(
        '/wishlist/remove',
        data: {'produk_id': productId},
      );
      if (response.statusCode == 200 && response.data['success'] == true) {
        if (kDebugMode) {
          print("Produk $productId berhasil dihapus dari wishlist.");
        }
        return true;
      } else {
        throw Exception(
          'Failed to remove from wishlist: ${response.data['message'] ?? response.statusCode}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error removing from wishlist: $e");
      }
      return false;
    }
  }

  // This method can remain if you still need to fetch individual raw ratings
  // For product cards, getRatingStatsByProductId is more efficient
  Future<List<RatingModel>> getRatingsByProductId(int productId) async {
    try {
      final response = await _dio.get('/ratings/product/$productId');
      if (response.statusCode == 200 && response.data['success'] == true) {
        if (kDebugMode) {
          print(
            "Ratings for product $productId fetched: ${response.data['data']}",
          );
        }
        final List data = response.data['data'];
        return data.map((json) => RatingModel.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load ratings: ${response.data['message'] ?? response.statusCode}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching ratings for product $productId: $e");
      }
      return [];
    }
  }

  // New method to fetch rating statistics
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
