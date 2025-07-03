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
        return const Center(child: CircularProgressIndicator());
      }

      final promoData = controller.promoProduct.value?.data ?? [];

      if (promoData.isEmpty) {
        return const Center(
          child: Text(
            "Tidak ada promo saat ini.",
            style: TextStyle(color: Colors.grey),
          ),
        );
      }

      return ListView.builder(
        itemCount: promoData.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final item = promoData[index];

          return InkWell(
            onTap: () {
              // Ambil rating hanya jika belum ada
              if (!controller.productRatingStats.containsKey(item.id)) {
                controller.fetchAndSetProductRatingStats(item.id);
              }
              Get.toNamed(Routes.DETAILPRODUCT, arguments: item);
            },
            child: Padding(
              padding: EdgeInsets.only(bottom: 15.h),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        bottomLeft: Radius.circular(16.r),
                      ),
                      child: Image.network(
                        "${dotenv.env['IMG_URL']}/${item.image}",
                        fit: BoxFit.cover,
                        width: 130.w,
                        height: 150.h,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                const Icon(Icons.broken_image),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.namaProduk,
                              style: GoogleFonts.poppins(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              item.deskripsi,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13.sp,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 4.w),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5.r),
                                    child: SvgPicture.network(
                                      "${dotenv.env['IMG_URL']}/${item.kategori.icon}",
                                      width: 20.w,
                                      height: 20.h,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Text(
                                  item.kategori.kategori,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),

                            /// ⭐⭐ Bagian RATING ⭐⭐
                            Obx(() {
                              final productId = item.id;
                              final ratingStats =
                                  controller.productRatingStats[productId];

                              return Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color:
                                        (ratingStats != null &&
                                                ratingStats.totalRatings > 0)
                                            ? Colors.amber
                                            : Colors.grey,
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
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    ratingStats != null
                                        ? ' (${ratingStats.totalRatings})'
                                        : ' (0)',
                                    style: GoogleFonts.poppins(
                                      fontSize: 10.sp,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              );
                            }),

                            SizedBox(height: 8.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  formatRupiah(item.hargaJual),
                                  style: GoogleFonts.poppins(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
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
                                      cartController.addItem(item);
                                    },
                                    icon: Icon(
                                      HugeIcons.strokeRoundedShoppingCart02,
                                    ),
                                    color: Colors.white,
                                    iconSize: 20.sp,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
