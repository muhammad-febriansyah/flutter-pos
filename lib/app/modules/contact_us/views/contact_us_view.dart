// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/contact_us_controller.dart';

// Palet Warna
const blueClr = Color(0xff1b55f6);
const kWhiteclr = Color(0xffF5F5F5);
const satu = Color(0xFF004FC2);
const dua = Color(0xFF0044AC);
const tiga = Color(0xFF01399A);

class ContactUsView extends GetView<ContactUsController> {
  const ContactUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteclr,
      body: CustomScrollView(
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
            automaticallyImplyLeading:
                false, // Menonaktifkan tombol back default
            leading: Container(
              margin: EdgeInsets.all(8.r),
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
                  size: 20.sp,
                ),
                onPressed: () => Get.back(),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [tiga, dua, blueClr],
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
                              borderRadius: BorderRadius.circular(30.r),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1.5.w,
                              ),
                            ),
                            child: Icon(
                              Icons.headset_mic_outlined, // Ikon disesuaikan
                              size: 40.sp,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 15.h),
                          Text(
                            'Hubungi Kami', // Teks disesuaikan
                            style: GoogleFonts.poppins(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Kami siap membantu Anda', // Sub-teks disesuaikan
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

          // == Content dengan flutter_screenutil ==
          SliverToBoxAdapter(
            child: Obx(() {
              if (controller.setting.value == null) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.r),
                    child: const CircularProgressIndicator(color: blueClr),
                  ),
                );
              }

              final data = controller.setting.value!.data;

              return Padding(
                padding: EdgeInsets.all(20.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderSection(data),
                    SizedBox(height: 30.h),
                    _buildContactCards(data),
                    SizedBox(height: 30.h),
                    _buildSocialMediaSection(data),
                    SizedBox(height: 30.h),
                    _buildDescriptionSection(data),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // Widget-widget di bawah ini juga disesuaikan dengan flutter_screenutil

  Widget _buildHeaderSection(dynamic data) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: blueClr.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80.w,
            height: 80.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Colors.white, Colors.transparent],
              ),
            ),
            child:
                data.logo.isNotEmpty
                    ? ClipOval(
                      child: Image.network(
                        "${dotenv.env['IMG_URL']}/${data.logo}",
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.business,
                            color: kWhiteclr,
                            size: 40.sp,
                          );
                        },
                      ),
                    )
                    : Icon(Icons.business, color: kWhiteclr, size: 40.sp),
          ),
          SizedBox(height: 15.h),
          Text(
            data.siteName,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: tiga,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5.h),
          Text(
            data.keyword,
            style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContactCards(dynamic data) {
    return Column(
      children: [
        _buildContactCard(
          icon: Icons.phone,
          title: 'Telepon',
          content: data.phone,
          onTap: () => _launchUrl('tel:${data.phone}'),
          color: blueClr,
        ),
        SizedBox(height: 15.h),
        _buildContactCard(
          icon: Icons.email,
          title: 'Email',
          content: data.email,
          onTap: () => _launchUrl('mailto:${data.email}'),
          color: dua,
        ),
        SizedBox(height: 15.h),
        _buildContactCard(
          icon: Icons.location_on,
          title: 'Alamat',
          content: data.address,
          onTap:
              () => _launchUrl(
                'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(data.address)}',
              ),
          color: tiga,
        ),
      ],
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String content,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: blueClr.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: color, size: 28.sp),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF2d3748),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 18.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMediaSection(dynamic data) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: blueClr.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Media Sosial',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: tiga,
            ),
          ),
          SizedBox(height: 15.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (data.fb.isNotEmpty)
                _buildSocialButton(
                  icon: HugeIcons.strokeRoundedFacebook02,
                  label: 'Facebook',
                  color: blueClr,
                  onTap: () => _launchUrl(data.fb),
                ),
              if (data.ig.isNotEmpty)
                _buildSocialButton(
                  icon: HugeIcons.strokeRoundedInstagram,
                  label: 'Instagram',
                  color: dua,
                  onTap: () => _launchUrl(data.ig),
                ),
              if (data.tiktok.isNotEmpty)
                _buildSocialButton(
                  icon: HugeIcons.strokeRoundedTiktok,
                  label: 'TikTok',
                  color: tiga,
                  onTap: () => _launchUrl(data.tiktok),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.1),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Icon(icon, color: color, size: 28.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(dynamic data) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: blueClr.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tentang Kami',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: tiga,
            ),
          ),
          SizedBox(height: 15.h),
          Text(
            data.description,
            style: TextStyle(
              fontSize: 15.sp,
              color: Colors.grey[700],
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        Get.snackbar(
          'Error',
          'Tidak dapat membuka link',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat membuka link',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
