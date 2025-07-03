// ignore_for_file: deprecated_member_use

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

class SearchResults extends StatelessWidget {
  const SearchResults({super.key, required this.controller});

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

    Widget buildProductCard(dynamic item) {
      return Padding(
        padding: EdgeInsets.only(bottom: 15.h),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
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
                  width: 110.w,
                  height: 120.h,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        width: 110.w,
                        height: 120.h,
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                        ),
                      ),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formatRupiah(item.hargaJual),
                            style: GoogleFonts.poppins(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
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
                                Get.snackbar(
                                  'Berhasil',
                                  '${item.namaProduk} ditambahkan ke keranjang',
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                  duration: const Duration(seconds: 2),
                                  snackPosition: SnackPosition.TOP,
                                );
                              },
                              icon: const Icon(
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
      );
    }

    return Obx(() {
      if (!controller.isSearching.value) {
        return const SizedBox.shrink();
      }

      final totalResults =
          controller.filteredPromoProducts.length +
          controller.filteredProducts.length;

      if (totalResults == 0) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 20.h),
          padding: EdgeInsets.all(20.w),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(Icons.search_off, size: 60.sp, color: Colors.grey[400]),
              SizedBox(height: 16.h),
              Text(
                'Tidak ada hasil',
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Coba gunakan kata kunci lain',
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search results header
          Container(
            margin: EdgeInsets.only(bottom: 16.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: blueClr.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: blueClr.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: blueClr, size: 20.sp),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'Hasil pencarian "${controller.searchQuery.value}" ($totalResults item)',
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: blueClr,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Promo products section
          if (controller.filteredPromoProducts.isNotEmpty) ...[
            Text(
              "Promo (${controller.filteredPromoProducts.length})",
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.orange[700],
              ),
            ),
            SizedBox(height: 12.h),
            ListView.builder(
              itemCount: controller.filteredPromoProducts.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return buildProductCard(
                  controller.filteredPromoProducts[index],
                );
              },
            ),
            SizedBox(height: 20.h),
          ],

          // Regular products section
          if (controller.filteredProducts.isNotEmpty) ...[
            Text(
              "Produk (${controller.filteredProducts.length})",
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12.h),
            ListView.builder(
              itemCount: controller.filteredProducts.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return buildProductCard(controller.filteredProducts[index]);
              },
            ),
          ],
        ],
      );
    });
  }
}
