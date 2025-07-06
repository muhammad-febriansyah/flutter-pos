// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:pos/app/data/utils/color.dart';
import 'package:pos/app/modules/cart/controllers/cart_controller.dart';
import 'package:pos/app/modules/home/controllers/home_controller.dart';
import 'package:pos/app/routes/app_pages.dart';

class PromoCard extends StatelessWidget {
  const PromoCard({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    String formatRupiah(int amount) {
      final NumberFormat currencyFormatter = NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp ',
        decimalDigits: 0,
      );
      return currencyFormatter.format(amount);
    }

    return SizedBox(
      width: double.infinity,
      height: 310.h,
      child: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: blueClr, strokeWidth: 3),
                SizedBox(height: 16.h),
                Text(
                  'Memuat promo...',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        final data = controller.promoProduct.value?.data ?? [];

        if (data.isEmpty) {
          return Center(
            child: Container(
              padding: EdgeInsets.all(32.w),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    HugeIcons.strokeRoundedSaleTag01,
                    size: 48.sp,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Tidak ada promo saat ini",
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Kembali lagi nanti untuk penawaran menarik",
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: data.length,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(left: 10.w, right: 16.w),
          itemBuilder: (context, index) {
            final product = data[index];
            final imageUrl = "${dotenv.env['IMG_URL']}/${product.image}";
            final originalPrice = product.hargaJual;
            final promoPercentage = product.percentage;
            final promoPrice =
                originalPrice - (originalPrice * promoPercentage / 100).round();

            final categoryIconUrl =
                "${dotenv.env['IMG_URL']}/${product.kategori.icon}";

            return Hero(
              tag: 'promo_${product.id}',
              child: Container(
                width: 200.w,
                margin: EdgeInsets.only(right: 16.w, bottom: 8.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      // Haptic feedback
                      HapticFeedback.lightImpact();

                      // Only fetch rating stats if not already loaded
                      if (!controller.productRatingStats.containsKey(
                        product.id,
                      )) {
                        controller.fetchAndSetProductRatingStats(product.id);
                      }
                      Get.toNamed(Routes.DETAILPRODUCT, arguments: product);
                    },
                    borderRadius: BorderRadius.circular(20.r),
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
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 140.h,
                                loadingBuilder: (
                                  context,
                                  child,
                                  loadingProgress,
                                ) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    height: 140.h,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20.r),
                                        topRight: Radius.circular(20.r),
                                      ),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircularProgressIndicator(
                                            value:
                                                loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                            strokeWidth: 3,
                                            color: blueClr,
                                          ),
                                          SizedBox(height: 8.h),
                                          Text(
                                            'Memuat...',
                                            style: GoogleFonts.poppins(
                                              fontSize: 10.sp,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 140.h,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20.r),
                                        topRight: Radius.circular(20.r),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          HugeIcons.strokeRoundedImage01,
                                          size: 32.sp,
                                          color: Colors.grey[400],
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          'Gambar tidak tersedia',
                                          style: GoogleFonts.poppins(
                                            fontSize: 10.sp,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),

                            // Gradient overlay untuk better contrast
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              height: 60.h,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.r),
                                    topRight: Radius.circular(20.r),
                                  ),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.3),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // Wishlist button
                            Positioned(
                              top: 12.h,
                              right: 12.w,
                              child: Obx(() {
                                final isWishlisted = controller
                                    .isProductWishlisted(product.id);
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
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
                                    icon: AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      child: Icon(
                                        isWishlisted
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color:
                                            isWishlisted
                                                ? Colors.red
                                                : Colors.grey[600],
                                        key: ValueKey(isWishlisted),
                                      ),
                                    ),
                                    onPressed: () {
                                      HapticFeedback.lightImpact();
                                      controller.toggleWishlist(product.id);
                                      Get.closeAllSnackbars();
                                    },
                                  ),
                                );
                              }),
                            ),

                            // Promo badge
                            if (product.promo == 1 && product.percentage > 0)
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
                                      colors: [Colors.red, Colors.red.shade700],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.red.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    "${product.percentage}% OFF",
                                    style: GoogleFonts.poppins(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),

                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(16.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Product name
                                Text(
                                  product.namaProduk,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[850],
                                    height: 1.3,
                                  ),
                                ),

                                SizedBox(height: 8.h),

                                // Category
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                        vertical: 4.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (product.kategori.icon.isNotEmpty)
                                            Padding(
                                              padding: EdgeInsets.only(
                                                right: 4.w,
                                              ),
                                              child: SvgPicture.network(
                                                categoryIconUrl,
                                                width: 14.w,
                                                height: 14.h,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) => Icon(
                                                      HugeIcons
                                                          .strokeRoundedSpoonAndFork,
                                                      size: 14.sp,
                                                      color: Colors.grey[600],
                                                    ),
                                              ),
                                            ),
                                          Text(
                                            product.kategori.kategori,
                                            style: GoogleFonts.poppins(
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 8.h),

                                // Rating
                                Obx(() {
                                  final productId = product.id;
                                  final ratingStats =
                                      controller.productRatingStats[productId];
                                  final hasRating =
                                      ratingStats != null &&
                                      ratingStats.totalRatings > 0;

                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 4.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          hasRating
                                              ? Colors.amber.shade50
                                              : Colors.grey[50],
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: Border.all(
                                        color:
                                            hasRating
                                                ? Colors.amber.shade200
                                                : Colors.grey[200]!,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color:
                                              hasRating
                                                  ? Colors.amber.shade600
                                                  : Colors.grey[400],
                                          size: 14.sp,
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          hasRating
                                              ? ratingStats.averageRating
                                                  .toStringAsFixed(1)
                                              : '0.0',
                                          style: GoogleFonts.poppins(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                hasRating
                                                    ? Colors.amber.shade700
                                                    : Colors.grey[500],
                                          ),
                                        ),
                                        Text(
                                          ratingStats != null
                                              ? ' (${ratingStats.totalRatings})'
                                              : ' (0)',
                                          style: GoogleFonts.poppins(
                                            fontSize: 10.sp,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),

                                const Spacer(),

                                // Price section
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (product.promo == 1 &&
                                        product.percentage > 0)
                                      Text(
                                        formatRupiah(originalPrice),
                                        style: GoogleFonts.poppins(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[500],
                                          decoration:
                                              TextDecoration.lineThrough,
                                          decorationColor: Colors.grey[500],
                                          decorationThickness: 1.5,
                                        ),
                                      ),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            formatRupiah(
                                              product.promo == 1 &&
                                                      product.percentage > 0
                                                  ? promoPrice
                                                  : originalPrice,
                                            ),
                                            style: GoogleFonts.poppins(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w700,
                                              color:
                                                  product.promo == 1 &&
                                                          product.percentage > 0
                                                      ? Colors.red.shade600
                                                      : Colors.green.shade700,
                                            ),
                                          ),
                                        ),

                                        // Add to cart button
                                        Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                blueClr,
                                                blueClr.withOpacity(0.8),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12.r,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: blueClr.withOpacity(0.3),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () {
                                                HapticFeedback.lightImpact();
                                                cartController.addItem(product);
                                              },
                                              borderRadius:
                                                  BorderRadius.circular(12.r),
                                              child: Padding(
                                                padding: EdgeInsets.all(10.w),
                                                child: Icon(
                                                  HugeIcons
                                                      .strokeRoundedShoppingCart02,
                                                  color: Colors.white,
                                                  size: 18.sp,
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
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
