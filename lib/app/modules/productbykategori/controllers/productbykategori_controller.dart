// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/models/product.dart';
import 'package:pos/app/data/models/rating.dart';
import 'package:pos/app/data/product_provider.dart';

class ProductbykategoriController extends GetxController {
  late final int idKategori;

  final Rxn<List<Datum>> _allProductsByKategori = Rxn<List<Datum>>();
  var product = Rxn<List<Datum>>(); // Filtered or full product list

  final TextEditingController searchController = TextEditingController();
  final RxString _searchQuery = ''.obs;

  // Wishlist logic
  final RxSet<int> _wishlistProductIds = <int>{}.obs;

  // Rating stats (similar to ProductController)
  final productRatingStats = RxMap<int, RatingStats>({});

  bool isProductWishlisted(int productId) {
    return _wishlistProductIds.contains(productId);
  }

  Future<void> toggleWishlist(int productId) async {
    if (_wishlistProductIds.contains(productId)) {
      _wishlistProductIds.remove(productId);
      try {
        final success = await ProductProvider().addToWishlist(productId);
        if (!success) {
          _wishlistProductIds.add(productId); // rollback
          EasyLoading.showError('Gagal menghapus dari wishlist');
        } else {
          EasyLoading.showSuccess('Berhasil dihapus dari wishlist');
        }
      } catch (_) {
        _wishlistProductIds.add(productId); // rollback
        EasyLoading.showError('Terjadi kesalahan saat menghapus');
      }
    } else {
      _wishlistProductIds.add(productId);
      try {
        final success = await ProductProvider().addToWishlist(productId);
        if (!success) {
          _wishlistProductIds.remove(productId); // rollback
          EasyLoading.showError('Gagal menambahkan ke wishlist');
        } else {
          EasyLoading.showSuccess('Berhasil ditambahkan ke wishlist');
        }
      } catch (e) {
        _wishlistProductIds.remove(productId); // rollback
        if (kDebugMode) {
          print('Error adding to wishlist: $e');
        }
        EasyLoading.showError('Terjadi kesalahan saat menambahkan');
      }
    }
  }

  Future<void> getProductByKategori() async {
    try {
      EasyLoading.show(status: 'Memuat...');
      final res = await ProductProvider().getProductByKategori(
        kategori_id: idKategori.toString(),
      );

      if (res.success == true && res.data.isNotEmpty) {
        _allProductsByKategori.value = res.data;
        product.value = res.data;

        // Ambil rating untuk semua produk di kategori ini
        await fetchAllRatingStats(res.data);
      } else {
        product.value = [];
      }
    } catch (e) {
      if (kDebugMode) print('❌ Error ambil produk kategori: $e');
      EasyLoading.showError('Gagal memuat produk');
    } finally {
      EasyLoading.dismiss();
    }
  }

  void filterProducts(String query) {
    _searchQuery.value = query.toLowerCase();

    if (_allProductsByKategori.value == null) {
      product.value = [];
      return;
    }

    if (query.isEmpty) {
      product.value = _allProductsByKategori.value;
    } else {
      product.value =
          _allProductsByKategori.value!
              .where(
                (p) => p.namaProduk.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    }
  }

  void onSearchChanged(String query) {
    filterProducts(query);
  }

  void clearSearch() {
    searchController.clear();
    filterProducts('');
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
        print("❌ Gagal load rating kategori: $e");
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
        print('❌ Gagal load wishlist: $e');
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;

    if (args is Map && args['id'] != null) {
      idKategori = args['id'];
      getProductByKategori();
      loadWishlist(); // load juga wishlistnya
    } else {
      if (kDebugMode) print('❌ ID Kategori tidak ditemukan!');
    }

    searchController.addListener(() {
      onSearchChanged(searchController.text);
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
