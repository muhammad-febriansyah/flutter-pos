import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos/app/modules/home/controllers/home_controller.dart';

class KategoriWidget extends StatelessWidget {
  const KategoriWidget({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Kategori",
          style: GoogleFonts.poppins(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15.h),
        SizedBox(
          width: double.infinity,
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            final data = controller.kategoriModel.value?.data ?? [];
            if (data.isEmpty) {
              return const Center(child: Text("Tidak ada kategori."));
            }
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              child: Row(
                children:
                    data.map((kategori) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Chip(
                          label: Text(
                            kategori.kategori,
                            style: GoogleFonts.poppins(fontSize: 15.sp),
                          ),
                          avatar: SvgPicture.network(
                            "${dotenv.env['IMG_URL']}/${kategori.icon}",
                            width: 25.w,
                            height: 25.h,
                          ),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                            side: const BorderSide(color: Colors.grey),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            );
          }),
        ),
      ],
    );
  }
}
