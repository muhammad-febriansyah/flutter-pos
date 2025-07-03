import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import dotenv
import 'package:get/get.dart';
import 'package:pos/app/data/models/meja.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutProvider extends GetConnect {
  late Dio _dio;

  CheckoutProvider() {
    _dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['BACKEND_URL']!, // Use dotenv to get base URL
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
            print('➡️ Dio Request: ${options.method} ${options.uri}');
            print('Headers: ${options.headers}');
            if (options.data != null) {
              // Ensure sensitive data is not printed in production logs
              print('Data: ${options.data}');
            }
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print(
              '⬅️ Dio Response ${response.statusCode}: ${response.requestOptions.uri}',
            );
            print('Response Data: ${response.data}');
          }
          return handler.next(response);
        },
        onError: (e, handler) {
          if (kDebugMode) {
            print('❌ Dio Error: ${e.message}');
            if (e.response != null) {
              print('Error Response Data: ${e.response?.data}');
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  /// Fetches table data from the backend.
  Future<MejaModel> fetchMeja() async {
    try {
      final res = await _dio.get(
        '/meja',
      ); // Your API endpoint for fetching tables
      if (res.statusCode == 200 && res.data['success'] == true) {
        if (kDebugMode) {
          print("Meja API Response Success.");
        }
        return MejaModel.fromJson(res.data);
      } else {
        // Handle non-200 success or success: false explicitly
        throw Exception(
          'Failed to load meja: ${res.statusCode} - ${res.data['message'] ?? 'Unknown error'}',
        );
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print(
          'DioException fetching meja: ${e.response?.statusCode} - ${e.message}',
        );
        if (e.response?.data != null) {
          print('DioException response data: ${e.response!.data}');
        }
      }
      // Re-throw or return a structured error for UI
      throw Exception(
        'Network error or server issue fetching meja: ${e.message}',
      );
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected error fetching meja: $e');
      }
      throw Exception(
        'An unexpected error occurred while fetching meja: ${e.toString()}',
      );
    }
  }

  /// Processes a sale, handling both cash and Midtrans payments.
  /// Sends the sales payload to the backend.
  Future<Map<String, dynamic>> processSale(Map<String, dynamic> payload) async {
    try {
      if (kDebugMode) {
        print('=== PAYLOAD VALIDATION (Provider Level) ===');
        if (payload['cartItems'] is List) {
          for (int i = 0; i < payload['cartItems'].length; i++) {
            var item = payload['cartItems'][i];
            print(
              'CartItem[$i]: id=${item['id']} (${item['id'].runtimeType}), qty=${item['qty']} (${item['qty'].runtimeType})',
            );
          }
        }
        print('========================');
      }

      final res = await _dio.post('/sales/process', data: payload);

      if (res.statusCode == 200 && res.data['success'] == true) {
        if (kDebugMode) {
          print("Process Sale API Response Success.");
        }
        return res.data;
      } else {
        // Return structured error on non-success from backend
        return {
          'success': false,
          'message':
              res.data['message'] ??
              'Failed to process sale. Unknown error from server.',
          'errors': res.data['errors'] ?? {},
          'status_code': res.statusCode,
        };
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print(
          'DioException processing sale: ${e.response?.statusCode} - ${e.message}',
        );
        if (e.response?.data != null) {
          print('DioException response data: ${e.response!.data}');
        }
        print('Full DioException: $e');
        print('DioException stackTrace: ${e.stackTrace}');
      }
      // Return structured error for DioException
      return {
        'success': false,
        'message':
            e.response?.data['message'] ??
            'Network error or server issue: ${e.message}',
        'errors': e.response?.data['errors'] ?? {},
        'status_code': e.response?.statusCode ?? 500,
      };
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Unexpected error processing sale: $e');
        print('StackTrace: $stackTrace');
      }
      // Return structured error for any other unexpected exceptions
      return {
        'success': false,
        'message': 'An unexpected error occurred: ${e.toString()}',
        'status_code': 500,
      };
    }
  }

  // NOTE: checkDuitkuTransactionStatus method is removed as it's no longer needed for Midtrans.
}
