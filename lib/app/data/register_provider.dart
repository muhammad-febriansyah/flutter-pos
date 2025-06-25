import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/models/setting.dart';

class RegisterProvider extends GetConnect {
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
}
