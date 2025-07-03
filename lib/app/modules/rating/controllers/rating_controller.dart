import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/models/rating.dart';
import 'package:pos/app/data/rating_provider.dart';

class RatingController extends GetxController {
  final RatingProvider _ratingProvider = RatingProvider();

  final _isLoading = false.obs;
  final _ratings = <RatingModel>[].obs;
  final _ratingStats = Rxn<RatingStats>();
  final _selectedRating = 0.obs;
  final _comment = ''.obs;
  final _hasExistingRating = false.obs;
  final _currentUserRating = Rxn<RatingModel>();

  final commentController = TextEditingController();

  bool get isLoading => _isLoading.value;
  List<RatingModel> get ratings => _ratings;
  RatingStats? get ratingStats => _ratingStats.value;
  int get selectedRating => _selectedRating.value;
  String get comment => _comment.value;
  bool get hasExistingRating => _hasExistingRating.value;
  RatingModel? get currentUserRating => _currentUserRating.value;

  @override
  void onInit() {
    super.onInit();
    commentController.addListener(() {
      _comment.value = commentController.text;
    });
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }

  void setRating(int rating) {
    _selectedRating.value = rating;
  }

  void resetForm() {
    _selectedRating.value = 0;
    commentController.clear();
    _comment.value = '';
    // JANGAN reset hasExistingRating dan currentUserRating di sini
    // karena ini akan menghapus data yang sudah ada
  }

  Future<void> addRating({
    required int productId,
    required int transactionId,
    required int rating,
    String? comment,
  }) async {
    if (kDebugMode) {
      print(
        'RatingController: Attempting to add rating for productId: $productId, transactionId: $transactionId, rating: $rating, comment: $comment',
      );
    }
    try {
      _isLoading.value = true;

      final response = await _ratingProvider.addRating(
        productId: productId,
        transactionId: transactionId,
        rating: rating,
        comment: comment,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Berhasil',
          'Rating berhasil ditambahkan',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Setelah berhasil menambahkan rating, langsung set state
        _hasExistingRating.value = true;

        // Buat RatingModel dari data yang baru saja dikirim
        _currentUserRating.value = RatingModel(
          id: 0, // ID akan diupdate dari response jika tersedia
          userId: 0, // Akan diupdate dari response jika tersedia
          produkId: productId,
          transactionId: transactionId,
          rating: rating,
          comment: comment,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Coba ambil data terbaru dari server (optional)
        await Future.delayed(Duration(milliseconds: 500)); // Tunggu sebentar
        await checkExistingRating(
          productId: productId,
          transactionId: transactionId,
        );

        await getRatingsByProduct(productId);
        await getRatingStats(productId);

        // Get.offAllNamed(Routes.BOTTOMNAVIGATION);
      } else {
        throw Exception('Gagal menambahkan rating: ${response.data}');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menambahkan rating: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> getRatingsByProduct(int productId) async {
    if (kDebugMode) {
      print('RatingController: Fetching ratings for productId: $productId');
    }
    try {
      _isLoading.value = true;

      final response = await _ratingProvider.getRatingsByProduct(productId);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        _ratings.value =
            data.map((json) => RatingModel.fromJson(json)).toList();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengambil rating: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> getRatingStats(int productId) async {
    if (kDebugMode) {
      print(
        'RatingController: Fetching rating stats for productId: $productId',
      );
    }
    try {
      final response = await _ratingProvider.getRatingStats(productId);

      if (response.statusCode == 200) {
        _ratingStats.value = RatingStats.fromJson(response.data['data']);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting rating stats: $e');
      }
    }
  }

  Future<void> checkExistingRating({
    required int productId,
    required int transactionId,
  }) async {
    if (kDebugMode) {
      print(
        'RatingController: Checking existing rating for productId: $productId, transactionId: $transactionId',
      );
    }
    try {
      _isLoading.value = true;

      final response = await _ratingProvider.checkExistingRating(
        productId: productId,
        transactionId: transactionId,
      );

      if (kDebugMode) {
        print('Response status code: ${response.statusCode}');
        print('Response data: ${response.data}');
      }

      if (response.statusCode == 200) {
        final data = response.data['data'];

        if (kDebugMode) {
          print('Data from response: $data');
        }

        if (data != null) {
          _hasExistingRating.value = true;
          _currentUserRating.value = RatingModel.fromJson(data);
          _selectedRating.value = _currentUserRating.value!.rating;
          commentController.text = _currentUserRating.value!.comment ?? '';

          if (kDebugMode) {
            print('Setting hasExistingRating to true');
            print('Current user rating: ${_currentUserRating.value?.rating}');
            print('Has existing rating: ${_hasExistingRating.value}');
          }
        } else {
          // Jika data null, cek apakah ini karena belum ada rating atau error
          if (kDebugMode) {
            print('No existing rating found - data is null');
          }

          // Hanya reset jika benar-benar tidak ada rating
          if (!_hasExistingRating.value) {
            _hasExistingRating.value = false;
            _currentUserRating.value = null;
            _selectedRating.value = 0;
            commentController.clear();
          }
        }
      } else if (response.statusCode == 404) {
        // 404 berarti memang belum ada rating
        if (kDebugMode) {
          print('No existing rating found - 404 response');
        }
        _hasExistingRating.value = false;
        _currentUserRating.value = null;
        _selectedRating.value = 0;
        commentController.clear();
      } else {
        if (kDebugMode) {
          print('API call failed with status code: ${response.statusCode}');
        }
        // Jangan reset state jika ada error server
        // Biarkan state sebelumnya tetap ada
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception in checkExistingRating: $e');
      }
      // Jangan reset state jika ada exception
      // Biarkan state sebelumnya tetap ada
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> updateRating({
    required int ratingId,
    required int rating,
    String? comment,
    required int productId,
  }) async {
    if (kDebugMode) {
      print(
        'RatingController: Attempting to update ratingId: $ratingId for productId: $productId, rating: $rating, comment: $comment',
      );
    }
    try {
      _isLoading.value = true;

      final response = await _ratingProvider.updateRating(
        ratingId: ratingId,
        rating: rating,
        comment: comment,
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Sukses!',
          'Terima kasih, rating kamu berhasil disimpan.',
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle, color: Colors.white),
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.all(16),
          borderRadius: 12,
        );

        // Update current user rating
        if (_currentUserRating.value != null) {
          _currentUserRating.value = _currentUserRating.value!.copyWith(
            rating: rating,
            comment: comment,
            updatedAt: DateTime.now(),
          );
        }

        await getRatingsByProduct(productId);
        await getRatingStats(productId);

        // Get.offAllNamed('/home');
      } else {
        throw Exception('Gagal memperbarui rating: ${response.data}');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memperbarui rating: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> deleteRating(int ratingId, int productId) async {
    if (kDebugMode) {
      print(
        'RatingController: Attempting to delete ratingId: $ratingId for productId: $productId',
      );
    }
    try {
      _isLoading.value = true;

      final response = await _ratingProvider.deleteRating(ratingId);

      if (response.statusCode == 200) {
        Get.snackbar(
          'Berhasil',
          'Rating berhasil dihapus',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Reset state setelah menghapus rating
        _hasExistingRating.value = false;
        _currentUserRating.value = null;
        _selectedRating.value = 0;
        commentController.clear();

        await getRatingsByProduct(productId);
        await getRatingStats(productId);
        // Get.offAllNamed('/home');
      } else {
        throw Exception('Gagal menghapus rating: ${response.data}');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menghapus rating: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> getUserRatings() async {
    if (kDebugMode) {
      print('RatingController: Fetching user ratings.');
    }
    try {
      _isLoading.value = true;

      final response = await _ratingProvider.getUserRatings();

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        _ratings.value =
            data.map((json) => RatingModel.fromJson(json)).toList();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengambil rating: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  bool validateRating() {
    if (_selectedRating.value < 1 || _selectedRating.value > 5) {
      Get.snackbar(
        'Error',
        'Pilih rating antara 1 sampai 5 bintang',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    return true;
  }
}
