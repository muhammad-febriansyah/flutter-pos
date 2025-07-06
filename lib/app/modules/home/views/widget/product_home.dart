import 'package:flutter/material.dart';
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

class ProductHome extends StatelessWidget {
  const ProductHome({super.key, required this.controller});

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

    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(blueClr),
                strokeWidth: 3.w,
              ),
              SizedBox(height: 16.h),
              Text(
                "Memuat produk...",
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      }

      final promoData = controller.promoProduct.value?.data ?? [];

      if (promoData.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                HugeIcons.strokeRoundedShoppingBag03,
                size: 80.sp,
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
                "Kembali lagi nanti untuk penawaran menarik!",
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        itemCount: promoData.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemBuilder: (context, index) {
          final item = promoData[index];

          return Container(
            margin: EdgeInsets.only(bottom: 16.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.08),
                  spreadRadius: 0,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // Ambil rating hanya jika belum ada
                  if (!controller.productRatingStats.containsKey(item.id)) {
                    controller.fetchAndSetProductRatingStats(item.id);
                  }
                  Get.toNamed(Routes.DETAILPRODUCT, arguments: item);
                },
                borderRadius: BorderRadius.circular(16.r),
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Row(
                    children: [
                      // Product Image with enhanced styling
                      Hero(
                        tag: 'product-${item.id}',
                        child: Container(
                          width: 120.w,
                          height: 120.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 0,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: Stack(
                              children: [
                                Image.network(
                                  "${dotenv.env['IMG_URL']}/${item.image}",
                                  fit: BoxFit.cover,
                                  width: 120.w,
                                  height: 120.h,
                                  errorBuilder:
                                      (context, error, stackTrace) => Container(
                                        color: Colors.grey[100],
                                        child: Icon(
                                          Icons.image_not_supported_outlined,
                                          size: 40.sp,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                  loadingBuilder: (
                                    context,
                                    child,
                                    loadingProgress,
                                  ) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      color: Colors.grey[100],
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          value:
                                              loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                  : null,
                                          strokeWidth: 2.w,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                blueClr,
                                              ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                // Promo badge
                                Positioned(
                                  top: 8.h,
                                  left: 8.w,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 6.w,
                                      vertical: 2.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    child: Text(
                                      "PROMO",
                                      style: GoogleFonts.poppins(
                                        fontSize: 8.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 16.w),

                      // Product Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Name
                            Text(
                              item.namaProduk,
                              style: GoogleFonts.poppins(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[800],
                                height: 1.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                            SizedBox(height: 4.h),

                            // Product Description
                            Text(
                              item.deskripsi,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                color: Colors.grey[600],
                                fontSize: 12.sp,
                                height: 1.3,
                              ),
                            ),

                            SizedBox(height: 8.h),

                            // Category with improved styling
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 16.w,
                                    height: 16.h,
                                    padding: EdgeInsets.all(2.w),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    child: SvgPicture.network(
                                      "${dotenv.env['IMG_URL']}/${item.kategori.icon}",
                                      width: 12.w,
                                      height: 12.h,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    item.kategori.kategori,
                                    style: GoogleFonts.poppins(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 8.h),

                            // Rating Section with improved styling
                            Obx(() {
                              final productId = item.id;
                              final ratingStats =
                                  controller.productRatingStats[productId];

                              return Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange[50],
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(
                                    color: Colors.orange[200]!,
                                    width: 0.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.star_rounded,
                                      color:
                                          (ratingStats != null &&
                                                  ratingStats.totalRatings > 0)
                                              ? Colors.orange[400]
                                              : Colors.grey[400],
                                      size: 16.sp,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      (ratingStats != null &&
                                              ratingStats.totalRatings > 0)
                                          ? ratingStats.averageRating
                                              .toStringAsFixed(1)
                                          : '0.0',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                    Text(
                                      ratingStats != null
                                          ? ' (${ratingStats.totalRatings})'
                                          : ' (0)',
                                      style: GoogleFonts.poppins(
                                        fontSize: 10.sp,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),

                            SizedBox(height: 12.h),

                            // Price and Add to Cart Button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        formatRupiah(item.hargaJual),
                                        style: GoogleFonts.poppins(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.green[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Enhanced Add to Cart Button
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
                                    borderRadius: BorderRadius.circular(12.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: blueClr.withOpacity(0.3),
                                        spreadRadius: 0,
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        cartController.addItem(item);
                                        // Optional: Show snackbar
                                        Get.snackbar(
                                          "Berhasil!",
                                          "Produk ditambahkan ke keranjang",
                                          snackPosition: SnackPosition.BOTTOM,
                                          duration: const Duration(seconds: 2),
                                          backgroundColor: Colors.green,
                                          colorText: Colors.white,
                                          margin: EdgeInsets.all(16.w),
                                          borderRadius: 8.r,
                                        );
                                      },
                                      borderRadius: BorderRadius.circular(12.r),
                                      child: Padding(
                                        padding: EdgeInsets.all(12.w),
                                        child: Icon(
                                          HugeIcons.strokeRoundedShoppingCart02,
                                          color: Colors.white,
                                          size: 20.sp,
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
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
