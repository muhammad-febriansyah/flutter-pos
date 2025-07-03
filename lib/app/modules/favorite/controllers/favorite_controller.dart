import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/models/rating.dart';
import 'package:pos/app/data/models/wishlist.dart';
import 'package:pos/app/data/wishlist_provider.dart';
import 'package:pos/app/data/home_provider.dart'; // untuk getRatingStatsByProductId
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class FavoriteController extends GetxController {
  final wishlistProvider = WishlistProvider();
  final homeProvider = HomeProvider();

  var wishlistModel = Rxn<WishlistModel>();
  final RxSet<int> wishlistProductIds = <int>{}.obs;
  final RxList<Datum> filteredFavorites = <Datum>[].obs;
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  final RxBool isLoading = false.obs;
  final RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );

  // 🔥 Tambahan untuk rating
  final RxMap<int, RatingStats> productRatingStats = RxMap<int, RatingStats>();

  @override
  void onInit() {
    super.onInit();
    fetchWishlist();
    searchController.addListener(() {
      searchQuery.value = searchController.text;
    });
    debounce(
      searchQuery,
      (_) => filterFavorites(),
      time: Duration(milliseconds: 300),
    );
  }

  void onRefresh() async {
    await fetchWishlist();
    refreshController.refreshCompleted();
  }

  Future<void> fetchWishlist() async {
    try {
      isLoading.value = true;
      EasyLoading.show(status: 'Memuat wishlist...');
      final res = await wishlistProvider.getWishlist();

      wishlistModel.value = res;
      wishlistProductIds.clear();
      wishlistProductIds.addAll(res.data.map((item) => item.produkId));
      filteredFavorites.value = res.data;

      // Fetch rating untuk setiap produk dalam wishlist
      await _fetchRatingsForWishlist(res.data);
    } catch (e) {
      if (kDebugMode) print("❌ ERROR in fetchWishlist: $e");
      Get.snackbar(
        'Error',
        'Gagal memuat wishlist: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss();
    }
  }

  // 🔥 Tambahan: Ambil rating untuk produk dalam wishlist
  Future<void> _fetchRatingsForWishlist(List<Datum> data) async {
    for (var item in data) {
      final productId = item.produkId;
      if (!productRatingStats.containsKey(productId)) {
        try {
          final stats = await homeProvider.getRatingStatsByProductId(productId);
          productRatingStats[productId] = stats;
        } catch (e) {
          if (kDebugMode) print("❌ Failed to fetch rating for $productId: $e");
          productRatingStats[productId] = RatingStats(
            averageRating: 0.0,
            totalRatings: 0,
            ratingDistribution: {},
          );
        }
      }
    }
  }

  void filterFavorites() {
    final query = searchQuery.value.toLowerCase();
    if (query.isEmpty) {
      filteredFavorites.value = wishlistModel.value?.data ?? [];
      return;
    }

    filteredFavorites.value =
        wishlistModel.value?.data.where((item) {
          final nama = item.produk.namaProduk.toLowerCase();
          final kategori = item.produk.kategori.kategori.toLowerCase();
          return nama.contains(query) || kategori.contains(query);
        }).toList() ??
        [];
  }

  bool isProductWishlisted(int productId) {
    return wishlistProductIds.contains(productId);
  }

  // ✅ Getter rating di UI
  double getAverageRating(int productId) =>
      productRatingStats[productId]?.averageRating ?? 0.0;

  int getTotalRatings(int productId) =>
      productRatingStats[productId]?.totalRatings ?? 0;

  Future<void> toggleWishlist(int productId) async {
    if (wishlistProductIds.contains(productId)) {
      wishlistProductIds.remove(productId);
      final success = await wishlistProvider.removeFromWishlist(productId);
      if (!success) {
        wishlistProductIds.add(productId); // rollback
        EasyLoading.showError('Gagal menghapus dari wishlist');
      } else {
        wishlistModel.value?.data.removeWhere(
          (item) => item.produkId == productId,
        );
        filteredFavorites.removeWhere((item) => item.produkId == productId);
        productRatingStats.remove(productId); // remove rating juga
        EasyLoading.showSuccess('Berhasil dihapus dari wishlist');
      }
    } else {
      wishlistProductIds.add(productId);
      final success = await wishlistProvider.addToWishlist(productId);
      if (!success) {
        wishlistProductIds.remove(productId);
        EasyLoading.showError('Gagal menambahkan ke wishlist');
      } else {
        await fetchWishlist();
        EasyLoading.showSuccess('Berhasil ditambahkan ke wishlist');
      }
    }
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
