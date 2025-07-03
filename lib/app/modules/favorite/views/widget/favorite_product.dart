import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:pos/app/data/models/product.dart';
import 'package:pos/app/data/utils/color.dart';
import 'package:pos/app/modules/favorite/controllers/favorite_controller.dart';
import 'package:pos/app/routes/app_pages.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
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

    return SizedBox(
      width: double.infinity,
      child: Obx(() {
        final data = controller.filteredFavorites;
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

        return SmartRefresher(
          controller: controller.refreshController,
          onRefresh: controller.onRefresh,
          header: const WaterDropHeader(),
          child: GridView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: data.length,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.all(15.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15.w,
              mainAxisSpacing: 15.h,
              childAspectRatio: 0.49,
            ),
            itemBuilder: (context, index) {
              final product = data[index];
              final imageUrl =
                  product.produk.image != null
                      ? "$imgBaseUrl/${product.produk.image}"
                      : 'https://via.placeholder.com/150';

              final originalPrice = product.produk.hargaJual;
              final promoPercentage = product.produk.percentage;
              final promoPrice =
                  originalPrice - (originalPrice * promoPercentage ~/ 100);

              final categoryIconUrl =
                  product.produk.kategori.icon.isNotEmpty
                      ? "$imgBaseUrl/${product.produk.kategori.icon}"
                      : '';

              final avgRating = controller.getAverageRating(product.produkId);
              // final totalRating = controller.getTotalRatings(product.produkId);

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
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15.r),
                              topRight: Radius.circular(15.r),
                            ),
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 120.h,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return Container(
                                  height: 120.h,
                                  color: Colors.grey[200],
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 120.h,
                                  color: Colors.grey[200],
                                  child: Icon(
                                    Icons.broken_image,
                                    size: 50.sp,
                                    color: Colors.grey[400],
                                  ),
                                );
                              },
                            ),
                          ),
                          Positioned(
                            top: 8.h,
                            right: 8.w,
                            child: CircleAvatar(
                              radius: 18.r,
                              backgroundColor: Colors.white.withAlpha(220),
                              child: IconButton(
                                iconSize: 20.sp,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                icon: Obx(() {
                                  final isWishlisted = controller
                                      .isProductWishlisted(product.produkId);
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
                                onPressed: () {
                                  controller.toggleWishlist(product.produkId);
                                },
                              ),
                            ),
                          ),
                          if (product.produk.promo == 1 &&
                              product.produk.percentage > 0)
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
                                  "${product.produk.percentage}% OFF",
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
                          padding: EdgeInsets.all(12.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.produk.namaProduk,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[850],
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Row(
                                children: [
                                  ...List.generate(
                                    5,
                                    (i) => Icon(
                                      i < avgRating.floor()
                                          ? Icons.star
                                          : Icons.star_border,
                                      size: 14.sp,
                                      color:
                                          avgRating > 0
                                              ? Colors.amber
                                              : Colors.grey[400],
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    avgRating > 0
                                        ? (avgRating.toStringAsFixed(1))
                                        : '(0.0)',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12.sp,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 4.h),
                              Row(
                                children: [
                                  if (categoryIconUrl.isNotEmpty)
                                    Padding(
                                      padding: EdgeInsets.only(right: 4.w),
                                      child: SvgPicture.network(
                                        categoryIconUrl,
                                        width: 16.w,
                                        height: 16.h,
                                        errorBuilder:
                                            (context, error, _) => Icon(
                                              HugeIcons
                                                  .strokeRoundedSpoonAndFork,
                                              size: 16.sp,
                                              color: Colors.grey[600],
                                            ),
                                      ),
                                    )
                                  else
                                    Icon(
                                      HugeIcons.strokeRoundedSpoonAndFork,
                                      size: 16.sp,
                                      color: Colors.grey[600],
                                    ),
                                  Expanded(
                                    child: Text(
                                      product.produk.kategori.kategori,
                                      style: GoogleFonts.poppins(
                                        fontSize: 11.sp,
                                        color: Colors.grey[600],
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              if (product.produk.promo == 1 &&
                                  product.produk.percentage > 0)
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
                                      product.produk.promo == 1 &&
                                              product.produk.percentage > 0
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
                                        cartController.addItem(
                                          product.produk as Datum,
                                        );
                                        Get.snackbar(
                                          'Berhasil Ditambahkan',
                                          '${product.produk.namaProduk} ditambahkan ke keranjang.',
                                          snackPosition: SnackPosition.TOP,
                                          icon: Icon(
                                            Icons.check_circle_sharp,
                                            color: Colors.white,
                                            size: 18.sp,
                                          ),
                                          backgroundColor: Colors.green,
                                          colorText: Colors.white,
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
          ),
        );
      }),
    );
  }
}
