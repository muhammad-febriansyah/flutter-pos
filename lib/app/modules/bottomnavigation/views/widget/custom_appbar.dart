import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos/app/data/utils/color.dart';
import 'package:pos/app/modules/bottomnavigation/controllers/bottomnavigation_controller.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BottomnavigationController>();
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      leadingWidth: 180.w,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [blueClr, satu, tiga],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            CircleAvatar(
              radius: 17.r,
              backgroundImage: NetworkImage(
                controller.user.value?.avatar != null &&
                        controller.user.value!.avatar!.isNotEmpty
                    ? "${dotenv.env['IMG_URL']}/${controller.user.value!.avatar}"
                    : "https://ui-avatars.com/api/?name=${Uri.encodeComponent(controller.user.value?.name ?? 'User')}&background=ffffff&color=000000",
              ),
              backgroundColor: Colors.white,
            ),
            SizedBox(width: 8.w),
            Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.user.value?.name ?? 'Unknown',
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    controller.address.value,
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Container(
            width: 35.w,
            height: 35.h,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                HugeIcons.strokeRoundedHeartCheck,
                size: 22,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Container(
            width: 35.w,
            height: 35.h,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                HugeIcons.strokeRoundedShoppingCart01,
                size: 22,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
