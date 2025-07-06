// lib/app/modules/kebijakan_privasi/views/kebijakan_privasi_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Impor untuk ukuran responsif
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart'; // Impor untuk font kustom
import 'package:pos/app/data/utils/color.dart';
import '../controllers/kebijakan_privasi_controller.dart';

class KebijakanPrivasiView extends GetView<KebijakanPrivasiController> {
  const KebijakanPrivasiView({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi ScreenUtil untuk ukuran responsif

    // Definisi warna untuk gradient

    return Scaffold(
      backgroundColor: Colors.white,
      // Menggunakan CustomScrollView untuk mengakomodasi SliverAppBar
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220.h, // Menggunakan .h untuk tinggi
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor:
                Colors
                    .transparent, // Latar belakang transparan agar gradient terlihat
            leading: Container(
              margin: EdgeInsets.all(8.r), // Menggunakan .r untuk radius/margin
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
                onPressed:
                    () => Get.back(), // Menggunakan Get.back() untuk navigasi
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
                    // Lingkaran dekoratif
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
                    // Konten utama di dalam header
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
                              Icons.privacy_tip_outlined, // Ikon disesuaikan
                              size: 40.sp,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 15.h),
                          Text(
                            'Kebijakan Privasi', // Teks disesuaikan
                            style: GoogleFonts.poppins(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Privasi Anda adalah prioritas kami', // Sub-teks disesuaikan
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
          // Konten utama halaman (data kebijakan privasi)
          SliverToBoxAdapter(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(
                    color: Color(0xFF3182CE),
                  ),
                );
              }

              if (controller.errorMessage.isNotEmpty) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_off,
                          color: Colors.grey[400],
                          size: 60,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          controller.errorMessage.value,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () => controller.fetchKebijakanPrivasi(),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Coba Lagi'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3182CE),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Widget Html untuk merender string HTML
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Html(
                  data: controller.kebijakanPrivasi.value.body,
                  style: {
                    "h3": Style(
                      fontSize: FontSize(18),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3748),
                    ),
                    "p": Style(
                      fontSize: FontSize(15),
                      lineHeight: const LineHeight(1.5),
                      color: const Color(0xFF4A5568),
                    ),
                    "ul": Style(padding: HtmlPaddings.only(left: 20)),
                    "li": Style(
                      fontSize: FontSize(15),
                      lineHeight: const LineHeight(1.6),
                      color: const Color(0xFF4A5568),
                    ),
                    "strong": Style(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3748),
                    ),
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
