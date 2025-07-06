// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pos/app/data/utils/color.dart';
import 'package:pos/app/modules/favorite/views/widget/favorite_product.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../controllers/favorite_controller.dart';

class FavoriteView extends GetView<FavoriteController> {
  const FavoriteView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SmartRefresher(
        controller: controller.refreshController,
        onRefresh: controller.onRefresh,
        header: const WaterDropHeader(),
        child: CustomScrollView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverAppBar(
              expandedHeight: 220.h,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: Container(
                margin: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10.r,
                      offset: Offset(0, 4.h),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                  onPressed: () => Get.back(),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [blueClr, satu, tiga],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: -40.h,
                        left: -20.w,
                        child: Container(
                          width: 130.w,
                          height: 130.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -30.h,
                        right: -50.w,
                        child: Container(
                          width: 160.w,
                          height: 160.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.08),
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 30.h),
                            Container(
                              padding: EdgeInsets.all(20.r),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1.5.w,
                                ),
                              ),
                              child: Icon(
                                Icons.favorite_rounded,
                                size: 40.sp,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 15.h),
                            Text(
                              'Makanan Favorit',
                              style: GoogleFonts.poppins(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Cari produk kesukaanmu di sini',
                              style: GoogleFonts.poppins(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // --- Bagian search bar dibuat menjadi sliver terpisah ---
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                child: TextField(
                  controller: controller.searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari produk...',
                    prefixIcon: const Icon(HugeIcons.strokeRoundedSearch02),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => controller.clearSearch(),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.r),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF0F2F5),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10.h,
                      horizontal: 15.w,
                    ),
                  ),
                ),
              ),
            ),
            // --- Widget FavoriteProduct dipanggil langsung sebagai sliver ---
            // Tidak perlu Column atau SliverToBoxAdapter lagi di sini
            FavoriteProduct(controller: controller),
          ],
        ),
      ),
    );
  }
}
