import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:pos/app/data/utils/color.dart';
import 'package:pos/app/modules/home/controllers/home_controller.dart';

class PromoCard extends StatelessWidget {
  const PromoCard({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
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
      height: 250.h,
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = controller.promoProduct.value?.data ?? [];

        if (data.isEmpty) {
          return const Center(
            child: Text(
              "Tidak ada promo saat ini.",
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: data.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final product = data[index];
            final imageUrl = "${dotenv.env['IMG_URL']}/${product.image}";
            final originalPrice = product.hargaJual;
            final promoPercentage = product.percentage;
            final promoPrice =
                originalPrice - (originalPrice * promoPercentage / 100).round();

            final categoryIconUrl =
                "${dotenv.env['IMG_URL']}/${product.kategori.icon}";

            final isWishlisted = controller.isProductWishlisted(product.id);

            return Container(
              width: 180.w,
              margin: EdgeInsets.only(right: 15.w, bottom: 10.h),
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
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 120.h,
                              width: double.infinity,
                              color: Colors.grey[200],
                              child: Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress
                                                  .expectedTotalBytes!
                                          : null,
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 120.h,
                              width: double.infinity,
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
                            icon: Icon(
                              isWishlisted
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color:
                                  isWishlisted ? Colors.red : Colors.grey[600],
                            ),
                            onPressed: () {
                              controller.toggleWishlist(product.id);
                              Get.snackbar(
                                'Wishlist',
                                isWishlisted
                                    ? '${product.namaProduk} dihapus dari wishlist.'
                                    : '${product.namaProduk} ditambahkan ke wishlist.',
                                snackPosition: SnackPosition.BOTTOM,
                                duration: const Duration(seconds: 2),
                              );
                            },
                          ),
                        ),
                      ),
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
                          Row(
                            children: [
                              if (product.kategori.icon.isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.only(right: 4.w),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5.r),
                                    child: SvgPicture.network(
                                      categoryIconUrl,
                                      width: 16.w,
                                      height: 16.h,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) => Icon(
                                            HugeIcons.strokeRoundedSpoonAndFork,
                                            size: 16.sp,
                                            color: Colors.grey[600],
                                          ),
                                    ),
                                  ),
                                ),
                              Text(
                                product.kategori.kategori,
                                style: GoogleFonts.poppins(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          if (product.promo == 1 && product.percentage > 0)
                            Text(
                              formatRupiah(originalPrice),
                              style: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.red,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: Colors.red,
                                decorationThickness: 2,
                              ),
                            ),
                          SizedBox(height: 4.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                formatRupiah(
                                  product.promo == 1 && product.percentage > 0
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
                                    Get.snackbar(
                                      'Keranjang Belanja',
                                      '${product.namaProduk} ditambahkan ke keranjang.',
                                      snackPosition: SnackPosition.BOTTOM,
                                      duration: const Duration(seconds: 2),
                                      backgroundColor: Colors.green[100],
                                      colorText: Colors.green[800],
                                      icon: const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    HugeIcons.strokeRoundedShoppingCart01,
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
            );
          },
        );
      }),
    );
  }
}
