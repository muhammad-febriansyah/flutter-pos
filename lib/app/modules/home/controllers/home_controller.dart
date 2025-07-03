import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/home_provider.dart';
import 'package:pos/app/data/models/kategori.dart';
import 'package:pos/app/data/models/product.dart';
import 'package:pos/app/data/models/user.dart';
import 'package:pos/app/data/models/rating.dart';
import 'package:pos/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class HomeController extends GetxController {
  var user = Rxn<User>();
  var kategoriModel = Rxn<KategoriModel>();
  var promoProduct = Rxn<ProductModel>();
  var productHome = Rxn<ProductModel>();

  var searchQuery = ''.obs;
  var filteredPromoProducts = <dynamic>[].obs;
  var filteredProducts = <dynamic>[].obs;
  var isSearching = false.obs;

  final isLoading = false.obs;

  final RxSet<int> _wishlistProductIds = <int>{}.obs;
  var productRatings = RxMap<int, List<RatingModel>>({});
  var productRatingStats = RxMap<int, RatingStats>({});

  final RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );

  bool isProductWishlisted(int productId) {
    return _wishlistProductIds.contains(productId);
  }

  Future<void> toggleWishlist(int productId) async {
    final HomeProvider homeProvider = Get.find<HomeProvider>();

    if (_wishlistProductIds.contains(productId)) {
      _wishlistProductIds.remove(productId);
      try {
        bool success = await homeProvider.removeFromWishlist(productId);
        if (success) {
          productHome.value?.data.removeWhere((item) => item.id == productId);
          promoProduct.value?.data.removeWhere((item) => item.id == productId);
          performSearch();
          EasyLoading.showSuccess('Produk berhasil dihapus dari wishlist.');
        } else {
          _wishlistProductIds.add(productId);
          EasyLoading.showError('Gagal menghapus produk dari wishlist.');
        }
      } catch (e) {
        if (kDebugMode) print("Error removing from wishlist: $e");
        _wishlistProductIds.add(productId);
        EasyLoading.showError(
          'Terjadi kesalahan saat menghapus dari wishlist.',
        );
      }
    } else {
      _wishlistProductIds.add(productId);
      try {
        bool success = await homeProvider.addToWishlist(productId);
        if (success) {
          EasyLoading.showSuccess('Produk ditambahkan ke wishlist.');
        } else {
          _wishlistProductIds.remove(productId);
          EasyLoading.showError('Gagal menambahkan produk ke wishlist.');
        }
      } catch (e) {
        if (kDebugMode) print("Error adding to wishlist: $e");
        _wishlistProductIds.remove(productId);
        EasyLoading.showError(
          'Terjadi kesalahan saat menambahkan ke wishlist.',
        );
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    if (!Get.isRegistered<HomeProvider>()) {
      Get.put(HomeProvider());
    }

    loadUser();
    getKategori();
    getPromoProduct();
    getProduct();
    loadWishlist();
    ever(searchQuery, (_) => performSearch());
  }

  Future<void> loadWishlist() async {
    try {
      final HomeProvider homeProvider = Get.find<HomeProvider>();
      final List<int> ids = await homeProvider.getWishlistProductIds();
      _wishlistProductIds.clear();
      _wishlistProductIds.addAll(ids);
      if (kDebugMode) {
        print("Wishlist loaded: $_wishlistProductIds");
      }
    } catch (e) {
      if (kDebugMode) {
        print("❌ Gagal memuat wishlist: $e");
      }
      Get.snackbar(
        'Error Wishlist',
        'Gagal memuat daftar keinginan Anda.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  Future<void> onRefresh() async {
    try {
      await Future.wait([
        getKategori(),
        getPromoProduct(),
        getProduct(),
        loadWishlist(),
      ]);
      refreshController.refreshCompleted();
    } catch (e) {
      refreshController.refreshFailed();
      Get.snackbar(
        'Error Refresh',
        'Gagal memperbarui data: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  Future<void> onLoading() async {
    refreshController.loadComplete();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    isSearching.value = query.isNotEmpty;
  }

  void performSearch() {
    if (searchQuery.value.isEmpty) {
      filteredPromoProducts.clear();
      filteredProducts.clear();
      isSearching.value = false;
      return;
    }

    final query = searchQuery.value.toLowerCase();

    if (promoProduct.value?.data != null) {
      filteredPromoProducts.value =
          promoProduct.value!.data
              .where(
                (product) =>
                    product.namaProduk.toLowerCase().contains(query) ||
                    product.deskripsi.toLowerCase().contains(query) ||
                    product.kategori.kategori.toLowerCase().contains(query),
              )
              .toList();
    }

    if (productHome.value?.data != null) {
      filteredProducts.value =
          productHome.value!.data
              .where(
                (product) =>
                    product.namaProduk.toLowerCase().contains(query) ||
                    product.deskripsi.toLowerCase().contains(query) ||
                    product.kategori.kategori.toLowerCase().contains(query),
              )
              .toList();
    }
  }

  void clearSearch() {
    searchQuery.value = '';
    isSearching.value = false;
  }

  Future<void> loadUser() async {
    try {
      HomeProvider().getUser().then((user) {
        this.user.value = user;
      });
    } catch (e) {
      if (kDebugMode) print("❌ Gagal ambil user: $e");
      Get.snackbar(
        'Error User',
        'Gagal memuat data pengguna.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  Future<void> getKategori() async {
    try {
      isLoading.value = true;
      final data = await HomeProvider().fetchKategori();
      kategoriModel.value = data;
    } catch (e) {
      Get.snackbar(
        'Error Kategori',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getPromoProduct() async {
    try {
      isLoading.value = true;
      final data = await HomeProvider().promoProduct();
      promoProduct.value = data;
      if (searchQuery.value.isNotEmpty) performSearch();

      // Fetch rating stats for promo products
      await _fetchRatingStatsForProducts(data.data);
    } catch (e) {
      Get.snackbar(
        'Error Promo',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getProduct() async {
    try {
      isLoading.value = true;
      final data = await HomeProvider().productHome();
      productHome.value = data;
      if (searchQuery.value.isNotEmpty) performSearch();

      // Fetch rating stats for home products
      await _fetchRatingStatsForProducts(data.data);
    } catch (e) {
      Get.snackbar(
        'Error Produk',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // New method to fetch rating stats for multiple products
  Future<void> _fetchRatingStatsForProducts(List<dynamic> products) async {
    if (products.isEmpty) return;

    final HomeProvider homeProvider = Get.find<HomeProvider>();

    // Fetch ratings for all products in parallel
    try {
      await Future.wait(
        products.map((product) async {
          try {
            final stats = await homeProvider.getRatingStatsByProductId(
              product.id,
            );
            productRatingStats[product.id] = stats;
          } catch (e) {
            if (kDebugMode) {
              print(
                "Error fetching rating stats for product ${product.id}: $e",
              );
            }
            // Set default stats on error
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
        print("Error fetching rating stats: $e");
      }
    }
  }

  Future<void> fetchAndSetProductRatingStats(int productId) async {
    // Check if we already have the rating stats
    if (productRatingStats.containsKey(productId)) {
      return; // No need to fetch again
    }

    EasyLoading.show(status: 'Memuat rating...');
    try {
      final HomeProvider homeProvider = Get.find<HomeProvider>();
      final stats = await homeProvider.getRatingStatsByProductId(productId);
      productRatingStats[productId] = stats;
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar(
        'Error Rating',
        'Gagal memuat rating produk.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAllNamed(Routes.LOGIN);
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }
}
