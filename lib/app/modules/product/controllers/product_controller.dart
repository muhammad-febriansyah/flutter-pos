import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/home_provider.dart';
import 'package:pos/app/data/models/product.dart';
import 'package:pos/app/data/models/rating.dart';
import 'package:pos/app/data/product_provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class ProductController extends GetxController {
  var product = Rxn<ProductModel>();
  var isLoading = false.obs;

  RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );

  final RxList<Datum> _filteredProducts = <Datum>[].obs;
  final TextEditingController searchController = TextEditingController();
  final RxString _searchQuery = ''.obs;

  final RxSet<int> _wishlistProductIds = <int>{}.obs;

  // ✅ Tambahan untuk rating
  final productRatingStats = RxMap<int, RatingStats>({});

  List<Datum> get displayedProducts => _filteredProducts;

  bool isProductWishlisted(int productId) {
    return _wishlistProductIds.contains(productId);
  }

  Future<void> toggleWishlist(int productId) async {
    if (_wishlistProductIds.contains(productId)) {
      _wishlistProductIds.remove(productId);
      try {
        final success = await HomeProvider().addToWishlist(productId);
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

  Future<void> loadWishlist() async {
    try {
      final wishlistIds = await ProductProvider().getWishlistProductIds();
      _wishlistProductIds.clear();
      _wishlistProductIds.addAll(wishlistIds);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat wishlist',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> getPromoProduct() async {
    EasyLoading.show(status: 'Loading...');
    isLoading.value = true;
    try {
      final data = await ProductProvider().getProduct();
      product.value = data;
      _filteredProducts.value = data.data;

      // ✅ Ambil rating semua produk
      await fetchAllRatingStats(data.data);
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        icon: const Icon(Icons.error, color: Colors.white),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss();
    }
  }

  void onRefresh() async {
    await Future.wait([getPromoProduct(), loadWishlist()]);
    refreshController.refreshCompleted();
  }

  void filterProducts(String query) {
    _searchQuery.value = query.toLowerCase();
    if (product.value?.data == null) {
      _filteredProducts.value = [];
      return;
    }

    if (query.isEmpty) {
      _filteredProducts.value = product.value!.data;
    } else {
      _filteredProducts.value =
          product.value!.data
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

  // ✅ Ambil rating satu produk berdasarkan ID
  Future<void> fetchAndSetProductRatingStats(int productId) async {
    if (productRatingStats.containsKey(productId)) return;

    try {
      final stats = await ProductProvider().getRatingStatsByProductId(
        productId,
      );
      productRatingStats[productId] = stats;
    } catch (e) {
      if (kDebugMode) {
        print("Error rating produk $productId: $e");
      }

      productRatingStats[productId] = RatingStats(
        averageRating: 0.0,
        totalRatings: 0,
        ratingDistribution: {},
      );
    }
  }

  // ✅ Ambil rating semua produk sekaligus
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
        print("Gagal load semua rating: $e");
      }
    }
  }

  @override
  void onInit() {
    getPromoProduct();
    loadWishlist(); // load wishlist di awal
    searchController.addListener(() {
      onSearchChanged(searchController.text);
    });
    super.onInit();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
