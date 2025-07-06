// lib/app/modules/favorite/views/widget/favorite_product.dart
// ✨ KODE YANG SUDAH DIPERBAIKI ✨

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
// Pastikan kedua model ini di-import
import 'package:pos/app/data/models/product.dart' as product_model;
import 'package:pos/app/data/models/wishlist.dart' as wishlist_model;
import 'package:pos/app/data/utils/color.dart';
import 'package:pos/app/modules/favorite/controllers/favorite_controller.dart';
import 'package:pos/app/routes/app_pages.dart';
import 'package:pos/app/modules/cart/controllers/cart_controller.dart';
import 'package:lottie/lottie.dart';

class FavoriteProduct extends StatelessWidget {
  const FavoriteProduct({super.key, required this.controller});
  final FavoriteController controller;

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();
    final String imgBaseUrl = dotenv.env['IMG_URL'] ?? '';

    String formatRupiah(int amount) {
      final NumberFormat currencyFormatter = NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp ',
        decimalDigits: 0,
      );
      return currencyFormatter.format(amount);
    }

    return Obx(() {
      final data = controller.filteredFavorites;
      if (controller.isLoading.value && data.isEmpty) {
        return const SliverFillRemaining(
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (data.isEmpty) {
        return SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/animation/bag.json',
                  width: 200.w,
                  height: 200.h,
                  repeat: true,
                  animate: true,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 5.h),
                Text(
                  "Yah, belum ada produk favorit!",
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  "Tambahkan produk yang kamu suka ke favorit ya.",
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }

      return SliverPadding(
        padding: EdgeInsets.all(15.w),
        sliver: SliverGrid.builder(
          itemCount: data.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15.w,
            mainAxisSpacing: 15.h,
            childAspectRatio: 0.43,
          ),
          itemBuilder: (context, index) {
            // Tipe data dari controller adalah Datum dari wishlist model
            final wishlist_model.Datum favoriteItem = data[index];
            final productFromWishlist =
                favoriteItem.produk; // Ini adalah objek 'Produk' dari wishlist

            // ✅ PERBAIKAN: Konversi objek 'Produk' dari wishlist menjadi 'Datum' dari product model
            // Ini mengasumsikan model 'Produk' punya method toJson() dan model 'Datum' punya fromJson()
            final productForApp = product_model.Datum.fromJson(
              productFromWishlist.toJson(),
            );

            final imageUrl =
                productForApp.image != null
                    ? "$imgBaseUrl/${productForApp.image}"
                    : 'https://via.placeholder.com/150';

            final originalPrice = productForApp.hargaJual;
            final promoPercentage = productForApp.percentage;
            final promoPrice =
                originalPrice - (originalPrice * promoPercentage ~/ 100);

            final categoryIconUrl =
                productForApp.kategori.icon.isNotEmpty
                    ? "$imgBaseUrl/${productForApp.kategori.icon}"
                    : '';

            final double avgRating = controller.getAverageRating(
              favoriteItem.produkId,
            );
            final int totalRating = controller.getTotalRatings(
              favoriteItem.produkId,
            );

            return InkWell(
              // ✅ PERBAIKAN 1: Kirim objek produk yang sudah dikonversi ke halaman detail
              onTap:
                  () => Get.toNamed(
                    Routes.DETAILPRODUCT,
                    arguments:
                        productForApp, // Gunakan objek yang sudah benar tipenya
                  ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.r),
                            topRight: Radius.circular(20.r),
                          ),
                          child: Stack(
                            children: [
                              Image.network(
                                imageUrl,
                                width: double.infinity,
                                height: 130.h,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (_, __, ___) => Container(
                                      width: double.infinity,
                                      height: 130.h,
                                      color: Colors.grey[200],
                                      child: Icon(
                                        Icons.broken_image_outlined,
                                        size: 50.sp,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                              ),
                              Container(
                                width: double.infinity,
                                height: 130.h,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.05),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 10.h,
                          right: 10.w,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: IconButton(
                              iconSize: 20.sp,
                              padding: EdgeInsets.all(8.w),
                              constraints: const BoxConstraints(),
                              icon: Obx(() {
                                final isWishlisted = controller
                                    .isProductWishlisted(favoriteItem.produkId);
                                return Icon(
                                  isWishlisted
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color:
                                      isWishlisted
                                          ? Colors.red[400]
                                          : Colors.grey[600],
                                );
                              }),
                              onPressed: () {
                                controller.toggleWishlist(
                                  favoriteItem.produkId,
                                );
                              },
                            ),
                          ),
                        ),

                        if (productForApp.promo == 1 &&
                            productForApp.percentage > 0)
                          Positioned(
                            top: 10.h,
                            left: 10.w,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.red[400]!, Colors.red[600]!],
                                ),
                                borderRadius: BorderRadius.circular(12.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.red.withOpacity(0.3),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                "${productForApp.percentage}% OFF",
                                style: GoogleFonts.poppins(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(14.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              productForApp.namaProduk,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[800],
                                height: 1.2,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: Colors.amber.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 14.sp,
                                    color:
                                        avgRating == 0
                                            ? Colors.grey[400]
                                            : Colors.amber[600],
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    avgRating.toStringAsFixed(1),
                                    style: GoogleFonts.poppins(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          avgRating == 0
                                              ? Colors.grey[500]
                                              : Colors.amber[700],
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    "($totalRating)",
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: Colors.blue.withOpacity(0.1),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (categoryIconUrl.isNotEmpty)
                                    SvgPicture.network(
                                      categoryIconUrl,
                                      width: 14.w,
                                      height: 14.h,
                                      colorFilter: ColorFilter.mode(
                                        Colors.blue[600]!,
                                        BlendMode.srcIn,
                                      ),
                                      placeholderBuilder:
                                          (_) => Icon(
                                            HugeIcons.strokeRoundedSpoonAndFork,
                                            size: 14.sp,
                                            color: Colors.blue[600],
                                          ),
                                    )
                                  else
                                    Icon(
                                      HugeIcons.strokeRoundedSpoonAndFork,
                                      size: 14.sp,
                                      color: Colors.blue[600],
                                    ),
                                  SizedBox(width: 4.w),
                                  Flexible(
                                    child: Text(
                                      productForApp.kategori.kategori,
                                      style: GoogleFonts.poppins(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.blue[600],
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            if (productForApp.promo == 1 &&
                                productForApp.percentage > 0)
                              Text(
                                formatRupiah(originalPrice),
                                style: GoogleFonts.poppins(
                                  fontSize: 12.sp,
                                  color: Colors.grey[500],
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: Colors.grey[400],
                                  decorationThickness: 2,
                                ),
                              ),
                            SizedBox(height: 2.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    formatRupiah(
                                      productForApp.promo == 1 &&
                                              productForApp.percentage > 0
                                          ? promoPrice
                                          : originalPrice,
                                    ),
                                    style: GoogleFonts.poppins(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          productForApp.promo == 1 &&
                                                  productForApp.percentage > 0
                                              ? Colors.red[600]
                                              : Colors.green[700],
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        blueClr,
                                        blueClr.withOpacity(0.8),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: blueClr.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      // ✅ PERBAIKAN 2: Tambahkan produk yang sudah dikonversi ke keranjang
                                      onTap: () {
                                        cartController.addItem(
                                          productForApp, // Gunakan objek yang sudah benar tipenya
                                        );
                                        Get.snackbar(
                                          'Berhasil Ditambahkan',
                                          '${productForApp.namaProduk} ke keranjang.',
                                          backgroundColor: Colors.green[600],
                                          colorText: Colors.white,
                                          icon: Container(
                                            padding: EdgeInsets.all(4.w),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(
                                                0.2,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.check_circle,
                                              color: Colors.white,
                                              size: 18.sp,
                                            ),
                                          ),
                                          snackPosition: SnackPosition.TOP,
                                          duration: const Duration(seconds: 2),
                                          margin: EdgeInsets.all(10.w),
                                          borderRadius: 12.r,
                                        );
                                      },
                                      borderRadius: BorderRadius.circular(12.r),
                                      child: Container(
                                        padding: EdgeInsets.all(10.w),
                                        child: Icon(
                                          HugeIcons.strokeRoundedShoppingCart02,
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
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
