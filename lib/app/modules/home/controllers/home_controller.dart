import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/home_provider.dart';
import 'package:pos/app/data/models/kategori.dart';
import 'package:pos/app/data/models/product.dart';
import 'package:pos/app/data/models/user.dart';
import 'package:pos/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  var user = Rxn<User>();
  var kategoriModel = Rxn<KategoriModel>();
  var promoProduct = Rxn<ProductModel>();
  var productHome = Rxn<ProductModel>();

  final isLoading = false.obs;

  final RxSet<int> _wishlistProductIds = <int>{}.obs;
  bool isProductWishlisted(int productId) {
    return _wishlistProductIds.contains(productId);
  }

  void toggleWishlist(int productId) {
    if (_wishlistProductIds.contains(productId)) {
      _wishlistProductIds.remove(productId);
    } else {
      _wishlistProductIds.add(productId);
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadUser();
    getKategori();
    getPromoProduct();
    getProduct();
  }

  Future<void> loadUser() async {
    try {
      HomeProvider().getUser().then((user) {
        this.user.value = user;
      });
    } catch (e) {
      if (kDebugMode) {
        print("❌ Gagal ambil user: $e");
      }
    }
  }

  Future<void> getKategori() async {
    try {
      isLoading.value = true;
      final data = await HomeProvider().fetchKategori(); // return KategoriModel
      kategoriModel.value = data;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getPromoProduct() async {
    try {
      isLoading.value = true;
      final data = await HomeProvider().promoProduct();
      promoProduct.value = data;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getProduct() async {
    try {
      isLoading.value = true;
      final data = await HomeProvider().productHome();
      productHome.value = data;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAllNamed(Routes.LOGIN);
  }
}
