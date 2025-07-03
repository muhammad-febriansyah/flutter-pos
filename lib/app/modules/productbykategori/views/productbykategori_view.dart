// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos/app/data/utils/color.dart';
import 'package:hugeicons/hugeicons.dart'; // Import HugeIcons
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import ScreenUtil
import 'package:pos/app/modules/productbykategori/views/productByKategori.dart';
import '../controllers/productbykategori_controller.dart';

class ProductbykategoriView extends GetView<ProductbykategoriController> {
  const ProductbykategoriView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProductbykategoriController());

    final kategori = Get.arguments['nama'];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [blueClr, satu, tiga],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Icon back
                Positioned(
                  left: 16,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    '$kategori',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
              child: TextField(
                controller: controller.searchController,
                decoration: InputDecoration(
                  hintText: 'Cari produk di kategori ini...',
                  prefixIcon: const Icon(HugeIcons.strokeRoundedSearch02),
                  suffixIcon:
                      controller.searchController.text.isNotEmpty
                          ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () => controller.clearSearch(),
                          )
                          : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10.h,
                    horizontal: 15.w,
                  ),
                ),
                style: const TextStyle(
                  color: Colors.black,
                ), // Ensure typed text is visible
              ),
            ),
            Expanded(
              child: Obx(() {
                final products = controller.product.value;
                return ProductCard(
                  displayedProducts: products ?? [],
                  isProductWishlisted: controller.isProductWishlisted,
                  toggleWishlist: controller.toggleWishlist,
                  productRatingStats: controller.productRatingStats,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
