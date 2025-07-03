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
import 'package:lottie/lottie.dart'; // Import Lottie package

// ... semua import tetap seperti sebelumnya ...
// Tidak ada perubahan di bagian import

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
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15.w,
              mainAxisSpacing: 15.h,
              childAspectRatio: 0.51,
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
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          // ✅ Image
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15.r),
                              topRight: Radius.circular(15.r),
                            ),
                            child: Image.network(
                              imageUrl,
                              width: double.infinity,
                              height: 120.h,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (_, __, ___) => Container(
                                    color: Colors.grey[300],
                                    width: double.infinity,
                                    height: 120.h,
                                    child: Icon(
                                      Icons.broken_image,
                                      size: 50.sp,
                                    ),
                                  ),
                            ),
                          ),

                          // ❤️ Wishlist
                          Positioned(
                            top: 8.h,
                            right: 8.w,
                            child: CircleAvatar(
                              radius: 18.r,
                              backgroundColor: Colors.white.withOpacity(0.9),
                              child: IconButton(
                                iconSize: 20.sp,
                                padding: EdgeInsets.zero,
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
                                            ? Colors.red
                                            : Colors.grey[600],
                                  );
                                }),
                                onPressed:
                                    () => controller.toggleWishlist(product.id),
                              ),
                            ),
                          ),

                          // 🔥 Promo Badge
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
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),

                      // 👇 Detail Produk
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
                                ),
                              ),

                              SizedBox(height: 4.h),

                              // ✅ Rating Bintang
                              Row(
                                children: [
                                  ...List.generate(
                                    5,
                                    (i) => Icon(
                                      i < averageRating.round()
                                          ? Icons.star
                                          : Icons.star_border,
                                      size: 14.sp,
                                      color:
                                          averageRating == 0
                                              ? Colors.grey[400]
                                              : Colors.amber,
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    "${averageRating.toStringAsFixed(1)} ($totalRating)",
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 4.h),

                              // 🍴 Kategori
                              Row(
                                children: [
                                  if (categoryIconUrl.isNotEmpty)
                                    SvgPicture.network(
                                      categoryIconUrl,
                                      width: 16.w,
                                      height: 16.h,
                                      placeholderBuilder:
                                          (_) => Icon(
                                            HugeIcons.strokeRoundedSpoonAndFork,
                                            size: 16.sp,
                                            color: Colors.grey,
                                          ),
                                      errorBuilder:
                                          (_, __, ___) => Icon(
                                            HugeIcons.strokeRoundedSpoonAndFork,
                                            size: 16.sp,
                                            color: Colors.grey,
                                          ),
                                    ),
                                  SizedBox(width: 4.w),
                                  Expanded(
                                    child: Text(
                                      product.kategori.kategori,
                                      style: GoogleFonts.poppins(
                                        fontSize: 11.sp,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const Spacer(),

                              // 💰 Harga
                              if (product.promo == 1 && product.percentage > 0)
                                Text(
                                  formatRupiah(originalPrice),
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.sp,
                                    color: Colors.red,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              SizedBox(height: 4.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    formatRupiah(
                                      product.promo == 1 &&
                                              product.percentage > 0
                                          ? promoPrice
                                          : originalPrice,
                                    ),
                                    style: GoogleFonts.poppins(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
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
                                          '${product.namaProduk} ke keranjang.',
                                          backgroundColor: Colors.green,
                                          colorText: Colors.white,
                                          icon: const Icon(
                                            Icons.check_circle,
                                            color: Colors.white,
                                          ),
                                          snackPosition: SnackPosition.TOP,
                                        );
                                      },
                                      icon: Icon(
                                        HugeIcons.strokeRoundedShoppingCart02,
                                        size: 18.sp,
                                        color: Colors.white,
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
          ),
        );
      }),
    );
  }
}
