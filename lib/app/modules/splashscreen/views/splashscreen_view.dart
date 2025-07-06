// lib/app/modules/splashscreen/views/splashscreen_view.dart

// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/splashscreen_controller.dart';

// ✅ Palet warna soft yang baru
const softSkyBlue = Color(0xFFa2d2ff); // Biru langit pucat
const periwinkleBlue = Color(0xFFcdb4db); // Biru keunguan lembut
const dreamyBlue = Color(0xFFbde0fe); // Biru untuk aurora
const creamWhite = Color(0xFFFFF8E1); // Putih krem yang hangat

class SplashscreenView extends GetView<SplashscreenController> {
  const SplashscreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final setting = controller.setting.value;
        return Container(
          width: double.infinity,
          height: double.infinity,
          // ✅ Latar belakang menggunakan gradasi warna soft
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [softSkyBlue, periwinkleBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              _buildAuroraBackground(),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),
                    _buildLogo(setting),
                    SizedBox(height: 40.h),
                    _buildStatusSection(setting),
                    const Spacer(flex: 3),
                    _buildBranding(setting),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildAuroraBackground() {
    // ✅ Efek aurora menggunakan warna biru yang lebih halus
    const Color auroraColor = dreamyBlue;

    return Stack(
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(seconds: 8),
          builder: (context, value, child) {
            return Positioned(
              top: -150.h,
              left: -200.w + (value * 100).w,
              child: child!,
            );
          },
          child: _buildAuroraBlob(auroraColor, 400.w, 400.h),
        ),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(seconds: 10),
          builder: (context, value, child) {
            return Positioned(
              bottom: -200.h,
              right: -250.w + (value * 120).w,
              child: child!,
            );
          },
          child: _buildAuroraBlob(auroraColor.withOpacity(0.8), 500.w, 500.h),
        ),
      ],
    );
  }

  Widget _buildAuroraBlob(Color color, double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          // Opacity dibuat lebih tinggi karena background lebih terang
          colors: [color.withOpacity(0.6), Colors.transparent],
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 90.0, sigmaY: 90.0),
        child: Container(color: Colors.transparent),
      ),
    );
  }

  Widget _buildLogo(dynamic setting) {
    // Warna teks utama diganti agar lebih kontras di background terang
    final Color primaryTextColor = Colors.black.withOpacity(0.7);

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1200),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: 180.w,
            height: 180.h,
            // ✅ Efek kaca menggunakan warna krem yang hangat
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: creamWhite.withOpacity(0.3),
              border: Border.all(
                color: creamWhite.withOpacity(0.5),
                width: 1.5.w,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(90.r),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Padding(
                  padding: EdgeInsets.all(20.r),
                  child:
                      setting == null || setting.data.logo.isEmpty
                          ? _buildFallbackLogo(primaryTextColor)
                          : Image.network(
                            "${dotenv.env['IMG_URL']}/${setting.data.logo}",
                            fit: BoxFit.contain,
                            errorBuilder:
                                (context, error, stackTrace) =>
                                    _buildFallbackLogo(primaryTextColor),
                          ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFallbackLogo(Color iconColor) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [creamWhite.withOpacity(0.5), creamWhite.withOpacity(0.3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Icon(
        Icons.store_mall_directory_outlined,
        size: 70.sp,
        color: iconColor,
      ),
    );
  }

  Widget _buildStatusSection(dynamic setting) {
    // Warna teks disesuaikan agar terbaca di background terang
    final Color primaryTextColor = Colors.black.withOpacity(0.7);
    final Color secondaryTextColor = Colors.black.withOpacity(0.6);

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1500),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child:
              setting == null
                  ? Column(
                    children: [
                      SizedBox(
                        width: 24.w,
                        height: 24.h,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            primaryTextColor,
                          ),
                          strokeWidth: 2.5,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Menyiapkan data...',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: secondaryTextColor,
                        ),
                      ),
                    ],
                  )
                  : Text(
                    'Selamat Datang',
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: primaryTextColor,
                      letterSpacing: 0.5,
                    ),
                  ),
        );
      },
    );
  }

  Widget _buildBranding(dynamic setting) {
    if (setting == null) {
      return const SizedBox.shrink();
    }
    final Color brandingTextColor = Colors.black.withOpacity(0.6);

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1800),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20.h * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Column(
              children: [
                Text(
                  'Powered by',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: brandingTextColor,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  setting.data.siteName,
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: brandingTextColor.withOpacity(0.8),
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
