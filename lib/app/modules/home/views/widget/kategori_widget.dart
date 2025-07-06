// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos/app/modules/home/controllers/home_controller.dart';
import 'package:pos/app/routes/app_pages.dart';

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
        // Header Section
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 4.w,
                    height: 24.h,
                    decoration: BoxDecoration(
                      color: Colors.green[600],
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "Kategori",
                    style: GoogleFonts.poppins(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),

        // Categories List
        SizedBox(
          width: double.infinity,
          child: Obx(() {
            if (controller.isLoading.value) {
              return _buildShimmerLoading();
            }
            final data = controller.kategoriModel.value?.data ?? [];
            if (data.isEmpty) {
              return _buildEmptyState();
            }
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Row(
                children:
                    data.asMap().entries.map((entry) {
                      final index = entry.key;
                      final kategori = entry.value;
                      return _buildCategoryCard(kategori, index);
                    }).toList(),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(dynamic kategori, int index) {
    return Container(
      margin: EdgeInsets.only(right: 12.w),
      child: InkWell(
        onTap: () {
          Get.toNamed(
            Routes.PRODUCTBYKATEGORI,
            arguments: {
              'id': kategori.id,
              'nama': kategori.kategori,
              'icon': kategori.icon,
            },
          );
        },
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            gradient: LinearGradient(
              colors: [
                _getGradientColor(index).withOpacity(0.1),
                _getGradientColor(index).withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon Container
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: _getGradientColor(index).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: SvgPicture.network(
                    "${dotenv.env['IMG_URL']}/${kategori.icon}",
                    width: 24.w,
                    height: 24.h,
                    colorFilter: ColorFilter.mode(
                      _getGradientColor(index),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              // Category Name
              Text(
                kategori.kategori,
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Row(
        children: List.generate(
          5,
          (index) => Container(
            margin: EdgeInsets.only(right: 12.w),
            width: 120.w,
            height: 64.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Center(
              child: Container(
                width: 20.w,
                height: 20.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 120.h,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category_outlined,
              size: 32.sp,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 8.h),
            Text(
              "Belum ada kategori",
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getGradientColor(int index) {
    final colors = [
      Colors.blue.shade600,
      Colors.green.shade600,
      Colors.orange.shade600,
      Colors.purple.shade600,
      Colors.red.shade600,
      Colors.teal.shade600,
      Colors.indigo.shade600,
      Colors.pink.shade600,
    ];
    return colors[index % colors.length];
  }
}
