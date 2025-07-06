// lib/app/modules/faq/views/faq_view.dart

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import ScreenUtil
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos/app/data/utils/color.dart';
import '../controllers/faq_controller.dart';

class FaqView extends GetView<FaqController> {
  const FaqView({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi ScreenUtil jika belum dilakukan di root aplikasi
    // ScreenUtil.init(context, designSize: const Size(375, 812), minTextAdapt: true, splitScreenMode: true);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        scrollDirection: Axis.vertical,
        shrinkWrap: false,
        slivers: [
          // Modern App Bar dengan glassmorphism effect
          SliverAppBar(
            expandedHeight: 220.h, // Menggunakan .h untuk tinggi
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: Container(
              margin: EdgeInsets.all(
                8.r,
              ), // Menggunakan .r untuk radius/margin seragam
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
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
                  Icons.arrow_back_ios_new,
                  color: const Color(0xFF1A202C),
                  size: 20.sp, // Menggunakan .sp untuk ukuran ikon
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [blueClr, dua, tiga],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    // Decorative circles
                    Positioned(
                      top: -50.h,
                      right: -30.w,
                      child: Container(
                        width: 150.w,
                        height: 150.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -20.h,
                      left: -40.w,
                      child: Container(
                        width: 120.w,
                        height: 120.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                    ),
                    // Main content
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 30.h),
                          Container(
                            padding: EdgeInsets.all(20.r),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(30.r),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1.5.w,
                              ),
                            ),
                            child: Icon(
                              Icons.quiz_rounded,
                              size: 40.sp,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 15.h),
                          Text(
                            'Pertanyaan yang Sering',
                            style: GoogleFonts.poppins(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w300,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          Text(
                            'Diajukan',
                            style: GoogleFonts.poppins(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Temukan jawaban dari pertanyaan umum',
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

          // FAQ Content
          SliverToBoxAdapter(
            child: Obx(() {
              // Loading State
              if (controller.isLoading.value) {
                return SizedBox(
                  height: 400.h,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(20.r),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20.r,
                                offset: Offset(0, 10.h),
                              ),
                            ],
                          ),
                          child: const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF667EEA),
                            ),
                            strokeWidth: 3,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          'Loading FAQ...',
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Error State
              if (controller.errorMessage.isNotEmpty) {
                return Container(
                  margin: EdgeInsets.all(20.r),
                  padding: EdgeInsets.all(30.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20.r,
                        offset: Offset(0, 10.h),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20.r),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Icon(
                          Icons.error_outline_rounded,
                          color: const Color(0xFFF87171),
                          size: 50.sp,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'Oops! Something went wrong',
                        style: GoogleFonts.poppins(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        controller.errorMessage.value,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          color: const Color(0xFF6B7280),
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 25.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => controller.fetchFaqs(),
                          icon: Icon(Icons.refresh_rounded, size: 20.sp),
                          label: Text(
                            'Try Again',
                            style: GoogleFonts.poppins(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF667EEA),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              // FAQ List
              return Container(
                padding: EdgeInsets.all(20.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stats card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.r),
                      margin: EdgeInsets.only(bottom: 25.h),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF667EEA).withOpacity(0.3),
                            blurRadius: 20.r,
                            offset: Offset(0, 10.h),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12.r),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(
                              Icons.lightbulb_outline_rounded,
                              color: Colors.white,
                              size: 24.sp,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${controller.faqList.length} Questions Available',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'Tap any question to see the answer',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.sp,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // FAQ Items
                    ...controller.faqList.asMap().entries.map((entry) {
                      final index = entry.key;
                      final faq = entry.value;

                      return Container(
                        margin: EdgeInsets.only(bottom: 16.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10.r,
                              offset: Offset(0, 4.h),
                            ),
                          ],
                        ),
                        child: Theme(
                          data: Theme.of(
                            context,
                          ).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            tilePadding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 8.h,
                            ),
                            leading: Container(
                              padding: EdgeInsets.all(8.r),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF667EEA).withOpacity(0.1),
                                    const Color(0xFF764BA2).withOpacity(0.1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Text(
                                '${index + 1}',
                                style: GoogleFonts.poppins(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF667EEA),
                                ),
                              ),
                            ),
                            title: Text(
                              faq.question,
                              style: GoogleFonts.poppins(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1F2937),
                                height: 1.3,
                              ),
                            ),
                            iconColor: const Color(0xFF667EEA),
                            collapsedIconColor: const Color(0xFF9CA3AF),
                            childrenPadding: EdgeInsets.fromLTRB(
                              20.w,
                              0,
                              20.w,
                              20.h,
                            ),
                            expandedCrossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 1.h,
                                margin: EdgeInsets.only(bottom: 16.h),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFF667EEA).withOpacity(0.3),
                                      const Color(0xFF764BA2).withOpacity(0.3),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(16.r),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: const Color(0xFFE2E8F0),
                                    width: 1.w,
                                  ),
                                ),
                                child: Text(
                                  faq.answer,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14.sp,
                                    color: const Color(0xFF4B5563),
                                    height: 1.6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),

                    // Bottom spacing
                    SizedBox(height: 40.h),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
