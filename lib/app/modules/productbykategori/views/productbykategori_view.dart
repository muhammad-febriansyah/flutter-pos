// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:pos/app/data/models/product.dart';
import 'package:pos/app/data/utils/color.dart';
import 'package:pos/app/modules/cart/controllers/cart_controller.dart';
import 'package:pos/app/routes/app_pages.dart';
import '../controllers/productbykategori_controller.dart';
import 'package:lottie/lottie.dart';

class ProductbykategoriView extends GetView<ProductbykategoriController> {
  const ProductbykategoriView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProductbykategoriController());
    Get.put(CartController());
    final String kategori = Get.arguments?['nama'] ?? 'Kategori';
    final String iconKategori = Get.arguments?['icon'];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC), // Background utama yang netral
      body: CustomScrollView(
        slivers: [
          _buildNewSliverAppBar(kategori, iconKategori: iconKategori),
          // Anda bisa menggunakan kembali widget search bar dan product content dari kode lama
          _buildSearchBar(kategori),
          _buildProductContent(),
        ],
      ),
    );
  }

  // --- STYLE APPBAR BARU ---
  SliverAppBar _buildNewSliverAppBar(String kategori, {String? iconKategori}) {
    return SliverAppBar(
      expandedHeight: 220, // Anda bisa ganti dengan 220.h jika pakai ScreenUtil
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor:
          Colors
              .transparent, // Dibuat transparan agar background FlexibleSpaceBar terlihat
      leading: Container(
        margin: const EdgeInsets.all(8), // 8.r
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12), // 12.r
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10, // 10.r
              offset: const Offset(0, 4), // Offset(0, 4.h)
            ),
          ],
        ),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: const Color(0xFF1A202C),
            size: 20, // 20.sp
          ),
          onPressed: () {
            // Aksi ketika tombol kembali ditekan, contoh: Get.back()
            if (Get.key.currentState?.canPop() ?? false) {
              Get.back();
            }
          },
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          // Dekorasi utama untuk background yang bisa mengembang
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [tiga, dua, blueClr], // Variasi gradient
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          child: Stack(
            children: [
              // Elemen dekoratif lingkaran di belakang (efek bokeh)
              Positioned(
                top: -40, // -40.h
                left: -20, // -20.w
                child: Container(
                  width: 130, // 130.w
                  height: 130, // 130.h
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              Positioned(
                bottom: -30, // -30.h
                right: -50, // -50.w
                child: Container(
                  width: 160, // 160.w
                  height: 160, // 160.h
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.08),
                  ),
                ),
              ),
              // Konten utama di tengah
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30), // 30.h
                    // Kontainer ikon dengan style glassmorphism
                    Container(
                      padding: const EdgeInsets.all(20), // 20.r
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30), // 30.r
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1.5, // 1.5.w
                        ),
                      ),
                      child: SvgPicture.network(
                        "${dotenv.env['IMG_URL']}/$iconKategori",
                        width: 50.w, // 50.w
                        height: 50.h, // 50.h
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 15), // 15.h
                    // Judul Utama
                    Text(
                      kategori, // Teks bisa disesuaikan
                      style: GoogleFonts.poppins(
                        fontSize: 28, // 28.sp
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8), // 8.h
                    // Sub-judul
                    Text(
                      'Pilih menu favorit, pesan, dan nikmati', // Sub-teks bisa disesuaikan
                      style: GoogleFonts.poppins(
                        fontSize: 14, // 14.sp
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget di bawah ini adalah salinan dari kode Anda sebelumnya untuk kelengkapan
  SliverToBoxAdapter _buildSearchBar(String kategori) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20.r,
              offset: Offset(0, 8.h),
            ),
          ],
        ),
        child: TextField(
          controller: controller.searchController,
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1A202C),
          ),
          decoration: InputDecoration(
            hintText: 'Cari di kategori $kategori...',
            hintStyle: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: Colors.grey[400],
            ),
            prefixIcon: Container(
              padding: EdgeInsets.all(12.w),
              child: Icon(
                HugeIcons.strokeRoundedSearch02,
                size: 20.sp,
                color: Colors.grey[500],
              ),
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear, size: 20.sp, color: Colors.grey[500]),
              onPressed: () => controller.clearSearch(),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.r),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              vertical: 16.h,
              horizontal: 20.w,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductContent() {
    return Obx(() {
      if (controller.isLoading.value &&
          (controller.filteredProducts.value == null ||
              controller.filteredProducts.value!.isEmpty)) {
        return SliverFillRemaining(
          child: Center(
            child: Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 20.r,
                    offset: Offset(0, 8.h),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      const Color(0xFF6A5AE0),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Memuat produk...',
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      if (controller.filteredProducts.value != null &&
          controller.filteredProducts.value!.isEmpty) {
        return SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Container(
              margin: EdgeInsets.all(24.w),
              padding: EdgeInsets.all(32.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 20.r,
                    offset: Offset(0, 8.h),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(
                    'assets/animation/bag.json',
                    width: 180.w,
                    height: 180.h,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Yah, produk tidak ditemukan!",
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A202C),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Coba kata kunci lain atau periksa nanti ya.",
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }
      return SliverToBoxAdapter(child: ProductCard(controller: controller));
    });
  }
}

// Widget ProductCard tidak perlu diubah, bisa gunakan yang lama
class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.controller});
  final ProductbykategoriController controller;

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();
    String formatRupiah(dynamic amount) {
      final NumberFormat currencyFormatter = NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp ',
        decimalDigits: 0,
      );
      if (amount is int) {
        return currencyFormatter.format(amount);
      } else if (amount is double) {
        return currencyFormatter.format(amount);
      }
      return 'Rp 0';
    }

    final String imgBaseUrl = dotenv.env['IMG_URL'] ?? '';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GridView.builder(
        itemCount: controller.filteredProducts.value!.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15.w,
          mainAxisSpacing: 20.h,
          childAspectRatio: 0.45,
        ),
        itemBuilder: (context, index) {
          final Datum product = controller.filteredProducts.value![index];
          final String imageUrl =
              product.image != null && product.image!.isNotEmpty
                  ? "$imgBaseUrl/${product.image}"
                  : '';

          final originalPrice = product.hargaJual;
          final promoPercentage = product.percentage;
          final promoPrice =
              originalPrice - (originalPrice * promoPercentage / 100).round();

          final ratingStat = controller.productRatingStats[product.id];
          final double averageRating = ratingStat?.averageRating ?? 0.0;
          final int totalRating = ratingStat?.totalRatings ?? 0;

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 20.r,
                  offset: Offset(0, 8.h),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: InkWell(
              onTap:
                  () => Get.toNamed(Routes.DETAILPRODUCT, arguments: product),
              borderRadius: BorderRadius.circular(24.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image Section
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24.r),
                          topRight: Radius.circular(24.r),
                        ),
                        child: Container(
                          height: 140.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.grey[50]!, Colors.grey[100]!],
                            ),
                          ),
                          child: Stack(
                            children: [
                              Image.network(
                                imageUrl,
                                width: double.infinity,
                                height: 140.h,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (_, __, ___) => Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.grey[100]!,
                                            Colors.grey[200]!,
                                          ],
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.image_outlined,
                                        size: 40.sp,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                              ),
                              // Gradient overlay
                              Container(
                                height: 140.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.03),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Wishlist Button
                      Positioned(
                        top: 12.h,
                        right: 12.w,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 12.r,
                                offset: Offset(0, 4.h),
                              ),
                            ],
                          ),
                          child: IconButton(
                            iconSize: 18.sp,
                            padding: EdgeInsets.all(8.w),
                            constraints: const BoxConstraints(),
                            icon: Obx(() {
                              final isWishlisted = controller
                                  .isProductWishlisted(product.id);
                              return Icon(
                                isWishlisted
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color:
                                    isWishlisted
                                        ? Colors.red[400]
                                        : Colors.grey[500],
                              );
                            }),
                            onPressed:
                                () => controller.toggleWishlist(product.id),
                          ),
                        ),
                      ),
                      // Discount Badge
                      if (product.promo == 1 && (product.percentage) > 0)
                        Positioned(
                          top: 12.h,
                          left: 12.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.red[400]!, Colors.red[600]!],
                              ),
                              borderRadius: BorderRadius.circular(16.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.withOpacity(0.3),
                                  blurRadius: 8.r,
                                  offset: Offset(0, 4.h),
                                ),
                              ],
                            ),
                            child: Text(
                              "${product.percentage}% OFF",
                              style: GoogleFonts.poppins(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  // Product Info Section
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Name
                          Text(
                            product.namaProduk,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A202C),
                              height: 1.2,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          // Rating
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                color: Colors.amber.withOpacity(0.2),
                                width: 1.w,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star_rounded,
                                  size: 16.sp,
                                  color:
                                      averageRating == 0
                                          ? Colors.grey[400]
                                          : Colors.amber[600],
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  averageRating == 0
                                      ? "0.0"
                                      : averageRating.toStringAsFixed(1),
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        averageRating == 0
                                            ? Colors.grey[500]
                                            : Colors.amber[700],
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  "($totalRating)",
                                  style: GoogleFonts.poppins(
                                    fontSize: 11.sp,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          // Price Section
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Original Price (if discounted)
                              if (product.promo == 1 &&
                                  (product.percentage) > 0)
                                Text(
                                  formatRupiah(originalPrice),
                                  style: GoogleFonts.poppins(
                                    fontSize: 11.sp,
                                    color: Colors.grey[500],
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor: Colors.grey[400],
                                    decorationThickness: 2,
                                  ),
                                ),
                              SizedBox(
                                height:
                                    (product.promo == 1 &&
                                            (product.percentage) > 0)
                                        ? 4.h
                                        : 0,
                              ),
                              // Current Price & Add to Cart
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      formatRupiah(
                                        product.promo == 1 &&
                                                (product.percentage) > 0
                                            ? promoPrice
                                            : originalPrice,
                                      ),
                                      style: GoogleFonts.poppins(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w700,
                                        color:
                                            product.promo == 1 &&
                                                    (product.percentage) > 0
                                                ? Colors.red[600]
                                                : const Color(0xFF059669),
                                      ),
                                    ),
                                  ),
                                  // Add to Cart Button
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [blueClr, tiga],
                                      ),
                                      borderRadius: BorderRadius.circular(16.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0xFF6A5AE0,
                                          ).withOpacity(0.3),
                                          blurRadius: 12.r,
                                          offset: Offset(0, 6.h),
                                        ),
                                      ],
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          cartController.addItem(product);
                                        },
                                        borderRadius: BorderRadius.circular(
                                          16.r,
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.all(12.w),
                                          child: Icon(
                                            HugeIcons
                                                .strokeRoundedShoppingCart02,
                                            size: 18.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
