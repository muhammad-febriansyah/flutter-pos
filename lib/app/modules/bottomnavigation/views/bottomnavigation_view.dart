import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pos/app/data/utils/color.dart';
import 'package:pos/app/modules/bottomnavigation/views/widget/custom_appbar.dart';
import 'package:pos/app/modules/home/views/home_view.dart';
import 'package:pos/app/modules/order/views/order_view.dart';
import 'package:pos/app/modules/product/views/product_view.dart';
import 'package:pos/app/modules/setting/views/setting_view.dart';

import '../controllers/bottomnavigation_controller.dart';

class BottomnavigationView extends GetView<BottomnavigationController> {
  const BottomnavigationView({super.key});

  final List<Widget> _pages = const [
    HomeView(),
    ProductView(),
    OrderView(),
    SettingView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: CustomAppBar(),
        body: _pages[controller.currentIndex.value],
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
          child: BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            backgroundColor: Colors.white,
            onTap: (index) {
              controller.currentIndex.value = index;
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: satu,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: GoogleFonts.poppins(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: GoogleFonts.poppins(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(HugeIcons.strokeRoundedHome01),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(HugeIcons.strokeRoundedSpoonAndFork),
                label: 'Product',
              ),
              BottomNavigationBarItem(
                icon: Icon(HugeIcons.strokeRoundedShoppingBagCheck),
                label: 'Order',
              ),
              BottomNavigationBarItem(
                icon: Icon(HugeIcons.strokeRoundedSettings01),
                label: 'Setting',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
