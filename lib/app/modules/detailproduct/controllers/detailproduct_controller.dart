// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/home_provider.dart';
import 'package:pos/app/data/models/product.dart';

class DetailproductController extends GetxController {
  // Observable variables
  var isWishlisted = false.obs;
  var quantity = 1.obs;
  var selectedSize = ''.obs;
  var isDescriptionExpanded = false.obs;
  var isWishlistLoading = false.obs;

  // Product data - this should be passed from previous screen
  late Datum product;

  // Provider instance
  final HomeProvider _homeProvider = Get.find<HomeProvider>();

  @override
  void onInit() {
    super.onInit();
    // Get product data from arguments
    if (Get.arguments != null && Get.arguments is Datum) {
      product = Get.arguments as Datum;
      // Check if product is already in wishlist
      _checkWishlistStatus();
    }
  }

  // Check if current product is in wishlist
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

  // Toggle wishlist status with API integration
  Future<void> toggleWishlist() async {
    try {
      isWishlistLoading.value = true;

      bool success;
      if (isWishlisted.value) {
        // Remove from wishlist
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
        // Add to wishlist
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

  // Refresh wishlist status (useful when returning from wishlist page)
  Future<void> refreshWishlistStatus() async {
    await _checkWishlistStatus();
  }

  // Increment quantity (fixed method name)
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

  // Decrement quantity (fixed method name)
  void decreaseQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  // Toggle description expanded state
  void toggleDescription() {
    isDescriptionExpanded.value = !isDescriptionExpanded.value;
  }

  // Add to cart
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

    // Add your cart logic here
    Get.snackbar(
      'Keranjang',
      '${quantity.value} ${product.namaProduk} ditambahkan ke keranjang',
      backgroundColor: Colors.blue.withOpacity(0.1),
      colorText: Colors.blue[700],
      icon: const Icon(Icons.shopping_cart, color: Colors.blue),
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
    );

    // You can also navigate to cart or perform other actions
    // Get.toNamed('/cart');
  }

  // Calculate total price
  int get totalPrice => product.hargaJual * quantity.value;

  // Check if product has discount
  bool get hasDiscount => product.promo > 0;

  // Get discounted price
  int get discountedPrice => product.hargaJual - product.promo;

  // Get discount percentage (assuming it exists in the model)
  String get discountPercentage {
    if (hasDiscount) {
      double percentage = (product.promo / product.hargaJual) * 100;
      return percentage.toStringAsFixed(0);
    }
    return '0';
  }

  // Get formatted price with discount
  int get finalPrice => hasDiscount ? discountedPrice : product.hargaJual;

  // Get final total price with quantity and discount
  int get finalTotalPrice => finalPrice * quantity.value;
}
