// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:pos/app/data/models/rating.dart';
import 'package:pos/app/data/utils/color.dart';
import 'package:pos/app/routes/app_pages.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:pos/app/data/models/product.dart'; // Import Datum model
import 'package:pos/app/modules/cart/controllers/cart_controller.dart';
import 'package:lottie/lottie.dart'; // Import Lottie package

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.displayedProducts,
    required this.isProductWishlisted,
    required this.toggleWishlist,
    required this.productRatingStats, // ✅ ini ditambahkan
    this.refreshController,
    this.onRefresh,
    this.isLoading = false,
  });

  final List<Datum> displayedProducts;
  final bool Function(int productId) isProductWishlisted;
  final void Function(int productId) toggleWishlist;
  final RefreshController? refreshController;
  final VoidCallback? onRefresh;
  final bool isLoading;
  final Map<int, RatingStats> productRatingStats;

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();
    final String imgBaseUrl = dotenv.env['IMG_URL'] ?? '';

    String formatRupiah(int amount) {
      final currencyFormatter = NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp ',
        decimalDigits: 0,
      );
      return currencyFormatter.format(amount);
    }

    if (isLoading && displayedProducts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (displayedProducts.isEmpty) {
      return Center(
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

    Widget content = GridView.builder(
      itemCount: displayedProducts.length,
      padding: EdgeInsets.all(15.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15.w,
        mainAxisSpacing: 15.h,
        childAspectRatio: 0.48,
      ),
      itemBuilder: (context, index) {
        final product = displayedProducts[index];
        final imageUrl =
            product.image?.isNotEmpty == true
                ? "$imgBaseUrl/${product.image}"
                : 'https://via.placeholder.com/150';

        final originalPrice = product.hargaJual;
        final promoPercentage = product.percentage;
        final promoPrice =
            originalPrice - (originalPrice * promoPercentage / 100).round();
        final categoryIconUrl =
            product.kategori.icon.isNotEmpty
                ? "$imgBaseUrl/${product.kategori.icon}"
                : '';
        final rating = productRatingStats[product.id];
        final avgRating = rating?.averageRating ?? 0.0;

        return InkWell(
          onTap: () => Get.toNamed(Routes.DETAILPRODUCT, arguments: product),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image & Badge & Favorite
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(15.r),
                      ),
                      child: Image.network(
                        imageUrl,
                        width: double.infinity,
                        height: 120.h,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) => Container(
                              height: 120.h,
                              width: double.infinity,
                              color: Colors.grey[200],
                              child: Icon(
                                Icons.broken_image,
                                size: 50.sp,
                                color: Colors.grey,
                              ),
                            ),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 120.h,
                            width: double.infinity,
                            color: Colors.grey[200],
                            child: Center(child: CircularProgressIndicator()),
                          );
                        },
                      ),
                    ),
                    // Favorite Button
                    Positioned(
                      top: 8.h,
                      right: 8.w,
                      child: CircleAvatar(
                        radius: 18.r,
                        backgroundColor: Colors.white.withOpacity(0.9),
                        child: IconButton(
                          iconSize: 20.sp,
                          padding: EdgeInsets.zero,
                          icon: Obx(() {
                            final wishlisted = isProductWishlisted(product.id);
                            return Icon(
                              wishlisted
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: wishlisted ? Colors.red : Colors.grey[600],
                            );
                          }),
                          onPressed: () => toggleWishlist(product.id),
                        ),
                      ),
                    ),
                    // Promo Badge
                    if (product.promo == 1 && product.percentage > 0)
                      Positioned(
                        top: 8.h,
                        left: 8.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            "${product.percentage}% OFF",
                            style: GoogleFonts.poppins(
                              fontSize: 10.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                // Product Info
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.namaProduk,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[850],
                          ),
                        ),
                        SizedBox(height: 4.h),

                        // ⭐ Rating Stars + Average
                        Row(
                          children: [
                            ...List.generate(5, (i) {
                              return Icon(
                                i < avgRating.floor()
                                    ? Icons.star
                                    : Icons.star_border,
                                size: 14.sp,
                                color:
                                    avgRating > 0
                                        ? Colors.amber
                                        : Colors.grey[400],
                              );
                            }),
                            if (avgRating > 0) ...[
                              SizedBox(width: 4.w),
                              Text(
                                avgRating.toStringAsFixed(1),
                                style: GoogleFonts.poppins(
                                  fontSize: 11.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 4.h),

                        // Kategori
                        Row(
                          children: [
                            if (categoryIconUrl.isNotEmpty)
                              SvgPicture.network(
                                categoryIconUrl,
                                width: 16.w,
                                height: 16.h,
                                placeholderBuilder:
                                    (_) => SizedBox(width: 16.w),
                                errorBuilder:
                                    (_, __, ___) => Icon(
                                      HugeIcons.strokeRoundedSpoonAndFork,
                                      size: 16.sp,
                                      color: Colors.grey[600],
                                    ),
                              )
                            else
                              Icon(
                                HugeIcons.strokeRoundedSpoonAndFork,
                                size: 16.sp,
                                color: Colors.grey[600],
                              ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Text(
                                product.kategori.kategori,
                                style: GoogleFonts.poppins(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),

                        // Harga Coret
                        if (product.promo == 1 && product.percentage > 0)
                          Text(
                            formatRupiah(originalPrice),
                            style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.red,
                              decoration: TextDecoration.lineThrough,
                              decorationThickness: 1.5,
                            ),
                          ),

                        SizedBox(height: 4.h),

                        // Harga & Keranjang
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formatRupiah(
                                (product.promo == 1 && product.percentage > 0)
                                    ? promoPrice
                                    : originalPrice,
                              ),
                              style: GoogleFonts.poppins(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.green[700],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: blueClr,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  cartController.addItem(product);
                                  Get.snackbar(
                                    'Berhasil Ditambahkan',
                                    '${product.namaProduk} ditambahkan ke keranjang.',
                                    snackPosition: SnackPosition.TOP,
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,
                                    icon: Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                      size: 20.sp,
                                    ),
                                  );
                                },
                                icon: Icon(
                                  HugeIcons.strokeRoundedShoppingCart02,
                                  color: Colors.white,
                                  size: 18.sp,
                                ),
                                padding: EdgeInsets.all(8.w),
                                constraints: const BoxConstraints(),
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
    );

    if (refreshController != null && onRefresh != null) {
      return SmartRefresher(
        controller: refreshController!,
        onRefresh: onRefresh!,
        child: content,
      );
    } else {
      return content;
    }
  }
}
