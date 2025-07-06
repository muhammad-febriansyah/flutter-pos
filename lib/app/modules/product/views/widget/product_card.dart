// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:pos/app/data/utils/color.dart';
import 'package:pos/app/modules/product/controllers/product_controller.dart';
import 'package:pos/app/routes/app_pages.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:pos/app/modules/cart/controllers/cart_controller.dart';
import 'package:lottie/lottie.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.controller});
  final ProductController controller;

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

    final String imgBaseUrl = dotenv.env['IMG_URL'] ?? '';

    return SizedBox(
      width: double.infinity,
      child: Obx(() {
        final data = controller.displayedProducts;
        if (controller.isLoading.value && data.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (data.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/animation/bag.json',
                  width: 200.w,
                  height: 200.h,
                ),
                SizedBox(height: 5.h),
                Text(
                  "Yah, produk belum tersedia!",
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  "Coba cari kategori lain atau periksa nanti ya.",
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return SmartRefresher(
          controller: controller.refreshController,
          onRefresh: controller.onRefresh,
          header: const WaterDropHeader(),
          child: GridView.builder(
            itemCount: data.length,
            padding: EdgeInsets.all(15.w),
            shrinkWrap: true,
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            scrollDirection: Axis.vertical,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15.w,
              mainAxisSpacing: 15.h,
              childAspectRatio: 0.43,
            ),
            itemBuilder: (context, index) {
              final product = data[index];
              final String imageUrl =
                  product.image != null && product.image!.isNotEmpty
                      ? "$imgBaseUrl/${product.image}"
                      : 'https://via.placeholder.com/150';

              final originalPrice = product.hargaJual;
              final promoPercentage = product.percentage;
              final promoPrice =
                  originalPrice -
                  (originalPrice * promoPercentage / 100).round();

              final String categoryIconUrl =
                  product.kategori.icon.isNotEmpty
                      ? "$imgBaseUrl/${product.kategori.icon}"
                      : '';

              // ✅ Ambil rating stats
              final ratingStat = controller.productRatingStats[product.id];
              final double averageRating = ratingStat?.averageRating ?? 0.0;
              final int totalRating = ratingStat?.totalRatings ?? 0;

              return InkWell(
                onTap:
                    () => Get.toNamed(Routes.DETAILPRODUCT, arguments: product),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          // ✅ Enhanced Image with Gradient Overlay
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
                                        width: double.infinity,
                                        height: 130.h,
                                        child: Icon(
                                          Icons.broken_image_outlined,
                                          size: 50.sp,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                ),
                                // Subtle gradient overlay
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

                          // ❤️ Enhanced Wishlist Button
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
                                      .isProductWishlisted(product.id);
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
                                onPressed:
                                    () => controller.toggleWishlist(product.id),
                              ),
                            ),
                          ),

                          // 🔥 Enhanced Promo Badge
                          if (product.promo == 1 && product.percentage > 0)
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
                                    colors: [
                                      Colors.red[400]!,
                                      Colors.red[600]!,
                                    ],
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
                                  "${product.percentage}% OFF",
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

                      // 👇 Enhanced Product Details
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(14.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product Name
                              Text(
                                product.namaProduk,
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

                              // ✅ Enhanced Rating with Better Design
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
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 6.h),

                              // 🍴 Enhanced Category
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
                                              HugeIcons
                                                  .strokeRoundedSpoonAndFork,
                                              size: 14.sp,
                                              color: Colors.blue[600],
                                            ),
                                        errorBuilder:
                                            (_, __, ___) => Icon(
                                              HugeIcons
                                                  .strokeRoundedSpoonAndFork,
                                              size: 14.sp,
                                              color: Colors.blue[600],
                                            ),
                                      ),
                                    SizedBox(width: 4.w),
                                    Flexible(
                                      child: Text(
                                        product.kategori.kategori,
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

                              // 💰 Enhanced Price Section
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (product.promo == 1 &&
                                      product.percentage > 0)
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                            fontWeight: FontWeight.bold,
                                            color:
                                                product.promo == 1 &&
                                                        product.percentage > 0
                                                    ? Colors.red[600]
                                                    : Colors.green[700],
                                          ),
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
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
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
                                            onTap: () {
                                              cartController.addItem(product);
                                              Get.snackbar(
                                                'Berhasil Ditambahkan',
                                                '${product.namaProduk} ke keranjang.',
                                                backgroundColor:
                                                    Colors.green[600],
                                                colorText: Colors.white,
                                                icon: Container(
                                                  padding: EdgeInsets.all(4.w),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.2),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    Icons.check_circle,
                                                    color: Colors.white,
                                                    size: 18.sp,
                                                  ),
                                                ),
                                                snackPosition:
                                                    SnackPosition.TOP,
                                                duration: const Duration(
                                                  seconds: 2,
                                                ),
                                                margin: EdgeInsets.all(10.w),
                                                borderRadius: 12.r,
                                              );
                                            },
                                            borderRadius: BorderRadius.circular(
                                              12.r,
                                            ),
                                            child: Container(
                                              padding: EdgeInsets.all(10.w),
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
      }),
    );
  }
}
