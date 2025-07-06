// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/home_provider.dart';
import 'package:pos/app/data/models/product.dart';

class DetailproductController extends GetxController {
  var isWishlisted = false.obs;
  var quantity = 1.obs;
  var selectedSize = ''.obs;
  var isDescriptionExpanded = false.obs;
  var isWishlistLoading = false.obs;

  late Datum product;

  final HomeProvider _homeProvider = Get.find<HomeProvider>();

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;

    if (arguments != null) {
      bool productInitialized = false;

      if (arguments is Datum) {
        product = arguments;
        productInitialized = true;
      } else if (arguments is Map) {
        try {
          product = Datum.fromJson(arguments as Map<String, dynamic>);
          productInitialized = true;
        } catch (e) {
          if (kDebugMode) {
            print("Error converting Map to Datum: $e");
          }
          Get.snackbar('Error', 'Data produk tidak valid.');
          Get.back();
        }
      }

      if (productInitialized) {
        _checkWishlistStatus();
      } else {
        Get.snackbar('Error', 'Tipe data produk tidak dikenali.');
        Get.back();
      }
    } else {
      Get.snackbar('Error', 'Tidak ada produk yang dipilih.');
      Get.back();
    }
  }

  Future<void> _checkWishlistStatus() async {
    try {
      isWishlistLoading.value = true;
      final wishlistIds = await _homeProvider.getWishlistProductIds();
      isWishlisted.value = wishlistIds.contains(product.id);
    } catch (e) {
      if (kDebugMode) {
        print('Error checking wishlist status: $e');
      }
    } finally {
      isWishlistLoading.value = false;
    }
  }

  Future<void> toggleWishlist() async {
    try {
      isWishlistLoading.value = true;
      bool success;
      if (isWishlisted.value) {
        success = await _homeProvider.removeFromWishlist(product.id);
        if (success) {
          isWishlisted.value = false;
          Get.snackbar(
            'Wishlist',
            'Produk dihapus dari wishlist',
            backgroundColor: Colors.grey.withOpacity(0.1),
            colorText: Colors.grey[700],
            icon: const Icon(Icons.favorite_border, color: Colors.grey),
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          Get.snackbar(
            'Error',
            'Gagal menghapus produk dari wishlist',
            backgroundColor: Colors.red.withOpacity(0.1),
            colorText: Colors.red[700],
            icon: const Icon(Icons.error, color: Colors.red),
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        success = await _homeProvider.addToWishlist(product.id);
        if (success) {
          isWishlisted.value = true;
          Get.snackbar(
            'Wishlist',
            'Produk ditambahkan ke wishlist',
            backgroundColor: Colors.green.withOpacity(0.1),
            colorText: Colors.green[700],
            icon: const Icon(Icons.favorite, color: Colors.red),
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          Get.snackbar(
            'Error',
            'Gagal menambahkan produk ke wishlist',
            backgroundColor: Colors.red.withOpacity(0.1),
            colorText: Colors.red[700],
            icon: const Icon(Icons.error, color: Colors.red),
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error toggling wishlist: $e');
      }
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat mengakses wishlist',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red[700],
        icon: const Icon(Icons.error, color: Colors.red),
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isWishlistLoading.value = false;
    }
  }

  Future<void> refreshWishlistStatus() async {
    await _checkWishlistStatus();
  }

  void increaseQuantity() {
    if (quantity.value < product.stok) {
      quantity.value++;
    } else {
      Get.snackbar(
        'Stok Terbatas',
        'Jumlah tidak boleh melebihi stok yang tersedia',
        backgroundColor: Colors.orange.withOpacity(0.1),
        colorText: Colors.orange[700],
        icon: const Icon(Icons.warning, color: Colors.orange),
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void decreaseQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  void toggleDescription() {
    isDescriptionExpanded.value = !isDescriptionExpanded.value;
  }

  void addToCart() {
    if (product.stok <= 0) {
      Get.snackbar(
        'Stok Habis',
        'Produk ini sedang tidak tersedia',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red[700],
        icon: const Icon(Icons.error, color: Colors.red),
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.snackbar(
      'Keranjang',
      '${quantity.value} ${product.namaProduk} ditambahkan ke keranjang',
      backgroundColor: Colors.blue.withOpacity(0.1),
      colorText: Colors.blue[700],
      icon: const Icon(Icons.shopping_cart, color: Colors.blue),
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  int get totalPrice => product.hargaJual * quantity.value;
  bool get hasDiscount => product.promo > 0;
  int get discountedPrice => product.hargaJual - product.promo;

  String get discountPercentage {
    if (hasDiscount) {
      double percentage = (product.promo / product.hargaJual) * 100;
      return percentage.toStringAsFixed(0);
    }
    return '0';
  }

  int get finalPrice => hasDiscount ? discountedPrice : product.hargaJual;
  int get finalTotalPrice => finalPrice * quantity.value;
}
