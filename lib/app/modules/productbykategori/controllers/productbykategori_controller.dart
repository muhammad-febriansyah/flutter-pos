import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/models/product.dart';
import 'package:pos/app/data/models/rating.dart';
import 'package:pos/app/data/product_provider.dart';

class ProductbykategoriController extends GetxController {
  late final int idKategori;

  final isLoading = false.obs;
  final Rxn<List<Datum>> _allProductsByKategori = Rxn<List<Datum>>();
  final Rxn<List<Datum>> filteredProducts = Rxn<List<Datum>>();

  final TextEditingController searchController = TextEditingController();

  final RxSet<int> _wishlistProductIds = <int>{}.obs;

  final RxMap<int, RatingStats> productRatingStats = RxMap<int, RatingStats>();

  bool isProductWishlisted(int productId) {
    return _wishlistProductIds.contains(productId);
  }

  Future<void> toggleWishlist(int productId) async {
    final isCurrentlyWishlisted = _wishlistProductIds.contains(productId);

    if (isCurrentlyWishlisted) {
      _wishlistProductIds.remove(productId);
    } else {
      _wishlistProductIds.add(productId);
    }

    try {
      final success = await ProductProvider().addToWishlist(productId);
      if (success) {
        Get.snackbar(
          isCurrentlyWishlisted ? 'Berhasil' : 'Sukses',
          isCurrentlyWishlisted
              ? 'Produk dihapus dari wishlist'
              : 'Produk ditambahkan ke wishlist',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(12),
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        throw Exception('Operasi wishlist gagal dari server');
      }
    } catch (e) {
      if (isCurrentlyWishlisted) {
        _wishlistProductIds.add(productId);
      } else {
        _wishlistProductIds.remove(productId);
      }

      Get.snackbar(
        'Gagal',
        'Terjadi kesalahan, coba lagi nanti.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      if (kDebugMode) {
        print('Error toggling wishlist: $e');
      }
    }
  }

  Future<void> getProductByKategori() async {
    try {
      isLoading.value = true;
      final res = await ProductProvider().getProductByKategori(
        kategori_id: idKategori.toString(),
      );

      if (res.success == true && res.data.isNotEmpty) {
        _allProductsByKategori.value = res.data;
        filteredProducts.value = res.data;
        await fetchAllRatingStats(res.data);
      } else {
        _allProductsByKategori.value = [];
        filteredProducts.value = [];
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat produk. Periksa koneksi Anda.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      if (kDebugMode) print('❌ Error ambil produk kategori: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void onSearchChanged(String query) {
    if (query.isEmpty) {
      filteredProducts.value = _allProductsByKategori.value;
    } else {
      if (_allProductsByKategori.value == null) return;

      final lowerCaseQuery = query.toLowerCase();
      filteredProducts.value =
          _allProductsByKategori.value!
              .where((p) => p.namaProduk.toLowerCase().contains(lowerCaseQuery))
              .toList();
    }
  }

  void clearSearch() {
    searchController.clear();
    onSearchChanged('');
  }

  Future<void> fetchAllRatingStats(List<Datum> products) async {
    if (products.isEmpty) return;
    try {
      await Future.wait(
        products.map((product) async {
          try {
            final stats = await ProductProvider().getRatingStatsByProductId(
              product.id,
            );
            productRatingStats[product.id] = stats;
          } catch (_) {
            productRatingStats[product.id] = RatingStats(
              averageRating: 0.0,
              totalRatings: 0,
              ratingDistribution: {},
            );
          }
        }),
      );
    } catch (e) {
      if (kDebugMode) {
        print("❌ Gagal memuat statistik rating: $e");
      }
    }
  }

  Future<void> loadWishlist() async {
    try {
      final wishlistIds = await ProductProvider().getWishlistProductIds();
      _wishlistProductIds.clear();
      _wishlistProductIds.addAll(wishlistIds);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Gagal memuat wishlist: $e');
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    try {
      final args = Get.arguments;
      if (args is Map && args['id'] != null) {
        idKategori = args['id'];
        getProductByKategori();
        loadWishlist();
        searchController.addListener(
          () => onSearchChanged(searchController.text),
        );
      } else {
        throw Exception('ID Kategori tidak ditemukan pada argumen');
      }
    } catch (e) {
      Get.snackbar(
        'Error Kritis',
        'Kategori tidak valid atau tidak ditemukan.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      if (kDebugMode) print('❌ onInit error: $e');
      Get.back();
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
