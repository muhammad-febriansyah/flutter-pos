import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/models/kategori.dart';
import 'package:pos/app/data/models/product.dart';
import 'package:pos/app/data/models/user.dart';
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
    final response = await _dio.get('/user', data: {'id': idUser});
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
      return KategoriModel.fromJson(response.data); // ⬅️ langsung return model
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
}
