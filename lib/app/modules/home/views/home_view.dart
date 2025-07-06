import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../controllers/home_controller.dart';
import 'widget/card_header.dart';
import 'widget/kategori_widget.dart';
import 'widget/product_home.dart';
import 'widget/promo_card.dart';
import 'widget/search_result.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SmartRefresher(
          controller: controller.refreshController,
          onRefresh: controller.onRefresh,
          onLoading: controller.onLoading,
          enablePullDown: true,
          enablePullUp: false,
          header: const WaterDropHeader(),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CardHeader(),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Obx(() {
                    if (controller.isSearching.value) {
                      return SearchResults(controller: controller);
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        KategoriWidget(controller: controller),
                        SizedBox(height: 24.h),
                        Row(
                          children: [
                            Container(
                              width: 4.w,
                              height: 24.h,
                              decoration: BoxDecoration(
                                color: Colors.orange[600],
                                borderRadius: BorderRadius.circular(2.r),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "Promo Hari Ini",
                              style: GoogleFonts.poppins(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        PromoCard(controller: controller),
                        SizedBox(height: 24.h),

                        // Products section
                        Row(
                          children: [
                            Container(
                              width: 4.w,
                              height: 24.h,
                              decoration: BoxDecoration(
                                color: Colors.blue[600],
                                borderRadius: BorderRadius.circular(2.r),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "Produk Terbaru",
                              style: GoogleFonts.poppins(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        ProductHome(controller: controller),
                        SizedBox(height: 24.h),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
