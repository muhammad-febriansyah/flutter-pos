// lib/app/modules/change_password/views/change_password_view.dart

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Impor ScreenUtil
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi ScreenUtil untuk UI responsif
    ScreenUtil.init(context, designSize: const Size(360, 690));

    // Skema Warna Baru
    const Color blueClr = Color(0xff1b55f6);
    const Color kWhiteclr = Color(0xffF5F5F5);
    const Color satu = Color(
      0xFF004FC2,
    ); // Biru sangat gelap (untuk glossy effect)
    const Color dua = Color(
      0xFF0044AC,
    ); // Biru sangat gelap (untuk glossy effect)
    const Color tiga = Color(
      0xFF01399A,
    ); // Biru sangat gelap (untuk glossy effect)

    // Warna Tambahan
    const Color primaryColor = blueClr;
    const Color secondaryColor = Color(
      0xFF4C82F7,
    ); // Tetap untuk gradasi tombol
    const Color bgColor = kWhiteclr;
    const Color subtextColor = Color(0xFF8A8A8A);
    const Color cardColor = Colors.white;
    const Color successColor = Color(0xFF38A169);

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280.h,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: Container(
              margin: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: cardColor.withOpacity(0.95),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Colors.white, width: 2.w),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.1),
                    blurRadius: 20.r,
                    offset: Offset(0, 4.h),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: primaryColor,
                  size: 20.sp,
                ),
                onPressed: () => Get.back(),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [satu, dua, tiga], // Menggunakan warna glossy baru
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -60.h,
                      right: -40.w,
                      child: Container(
                        width: 200.w,
                        height: 200.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.white.withOpacity(0.15),
                              Colors.white.withOpacity(0.05),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -30.h,
                      left: -50.w,
                      child: Container(
                        width: 150.w,
                        height: 150.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.white.withOpacity(0.12),
                              Colors.white.withOpacity(0.03),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.1),
                            Colors.white.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 60.h),
                          Container(
                            padding: EdgeInsets.all(24.r),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(24.r),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 2.w,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20.r,
                                  offset: Offset(0, 10.h),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.security_rounded,
                              size: 48.sp,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 24.h),
                          Text(
                            'Change Your',
                            style: GoogleFonts.inter(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w300,
                              color: Colors.white.withOpacity(0.9),
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            'Password',
                            style: GoogleFonts.inter(
                              fontSize: 36.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              'Secure your account with a new password',
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withOpacity(0.9),
                              ),
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
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.all(24.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(28.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.08),
                            blurRadius: 30.r,
                            spreadRadius: 0,
                            offset: Offset(0, 8.h),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ubah Password',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp,
                              color: primaryColor,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Masukkan password lama dan password baru Anda',
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              color: subtextColor,
                            ),
                          ),
                          SizedBox(height: 32.h),
                          _buildPasswordField(
                            controller: controller.currentPasswordC,
                            label: 'Password Saat Ini',
                            hint: 'Masukkan password lama',
                            icon: Icons.lock_outline_rounded,
                            isObscure: controller.isCurrentObscure,
                            primaryColor: primaryColor,
                            subtextColor: subtextColor,
                          ),
                          SizedBox(height: 24.h),
                          _buildPasswordField(
                            controller: controller.newPasswordC,
                            label: 'Password Baru',
                            hint: 'Masukkan password baru',
                            icon: Icons.lock_reset_rounded,
                            isObscure: controller.isNewObscure,
                            primaryColor: primaryColor,
                            subtextColor: subtextColor,
                          ),
                          SizedBox(height: 24.h),
                          _buildPasswordField(
                            controller: controller.confirmPasswordC,
                            label: 'Konfirmasi Password Baru',
                            hint: 'Ulangi password baru',
                            icon: Icons.verified_user_rounded,
                            isObscure: controller.isConfirmObscure,
                            primaryColor: primaryColor,
                            subtextColor: subtextColor,
                          ),
                          SizedBox(height: 24.h),
                          Container(
                            padding: EdgeInsets.all(16.r),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: primaryColor.withOpacity(0.1),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline_rounded,
                                      color: primaryColor,
                                      size: 20.sp,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'Syarat Password',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.sp,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12.h),
                                _buildRequirement('Minimal 8 karakter'),
                                _buildRequirement(
                                  'Mengandung huruf besar dan kecil',
                                ),
                                _buildRequirement('Mengandung angka'),
                                _buildRequirement('Mengandung karakter khusus'),
                              ],
                            ),
                          ),
                          SizedBox(height: 32.h),
                          _buildSaveButton(primaryColor, secondaryColor),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Container(
                      padding: EdgeInsets.all(20.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: successColor.withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.lightbulb_outline_rounded,
                                color: successColor,
                                size: 20.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Tips Keamanan',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.sp,
                                  color: successColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Gunakan password yang unik dan jangan sama dengan akun lain. Pertimbangkan untuk menggunakan password manager.',
                            style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              color: subtextColor,
                              height: 1.4,
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
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required RxBool isObscure,
    required Color primaryColor,
    required Color subtextColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
            color: primaryColor,
          ),
        ),
        SizedBox(height: 8.h),
        Obx(
          () => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  blurRadius: 10.r,
                  offset: Offset(0, 2.h),
                ),
              ],
            ),
            child: TextFormField(
              controller: controller,
              obscureText: isObscure.value,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.poppins(
                  color: subtextColor.withOpacity(0.7),
                  fontSize: 14.sp,
                ),
                prefixIcon: Container(
                  margin: EdgeInsets.all(12.r),
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(icon, color: primaryColor, size: 20.sp),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    isObscure.value
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    color: subtextColor,
                    size: 20.sp,
                  ),
                  onPressed: () {
                    isObscure.value = !isObscure.value;
                  },
                ),
                filled: true,
                fillColor: const Color(0xFFFAFAFA),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 18.h,
                  horizontal: 16.w,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.1)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: primaryColor, width: 2.w),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRequirement(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            color: Colors.grey.withOpacity(0.6),
            size: 16.sp,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                color: Colors.grey.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(Color primaryColor, Color secondaryColor) {
    return Obx(
      () => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: InkWell(
          onTap:
              controller.isLoading.value
                  ? null
                  : () => controller.updatePassword(),
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            width: double.infinity,
            height: 56.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:
                    controller.isLoading.value
                        ? [Colors.grey.shade400, Colors.grey.shade500]
                        : [primaryColor, secondaryColor],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: (controller.isLoading.value
                          ? Colors.grey.shade400
                          : primaryColor)
                      .withOpacity(0.3),
                  blurRadius: 15.r,
                  offset: Offset(0, 5.h),
                ),
              ],
            ),
            child: Center(
              child:
                  controller.isLoading.value
                      ? Padding(
                        // FIX: Menambahkan padding agar tidak overflow
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: FittedBox(
                          // FIX: Membungkus Row dengan FittedBox agar ukurannya menyesuaikan
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20.w,
                                height: 20.h,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                'Menyimpan...',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.save_rounded,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Simpan Password',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
            ),
          ),
        ),
      ),
    );
  }
}
