// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pos/app/data/utils/color.dart';
import 'package:pos/app/routes/app_pages.dart';
import '../controllers/rating_controller.dart';

class RatingView extends GetView<RatingController> {
  const RatingView({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 690));

    final Map<String, dynamic> args = Get.arguments ?? {};
    final int productId = args['product_id'] ?? 0;
    final int transactionId = args['transaction_id'] ?? 0;
    final String productName = args['product_name'] ?? 'Produk';

    if (kDebugMode) {
      print(
        'RatingView: Arguments - productId: $productId, transactionId: $transactionId, productName: $productName',
      );
    }

    if (productId == 0 || transactionId == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar(
          'Error',
          'ID Produk atau ID Transaksi tidak valid.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        Get.back();
      });
      return _buildErrorScaffold();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.checkExistingRating(
        productId: productId,
        transactionId: transactionId,
      );
    });

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      // Body sekarang menggunakan CustomScrollView untuk SliverAppBar
      body: CustomScrollView(
        slivers: [
          // =============================================================
          // == SLIVERAPPBAR BARU DITERAPKAN DI SINI ==
          // =============================================================
          SliverAppBar(
            expandedHeight: 220.h,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading:
                false, // Menonaktifkan back button default
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
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [blueClr, dua, tiga], // Gradient disesuaikan
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
                              Icons.star_half_rounded, // Ikon disesuaikan
                              size: 40.sp,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 15.h),
                          Text(
                            'Berikan Rating', // Teks disesuaikan
                            style: GoogleFonts.poppins(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Bagaimana pengalaman Anda?', // Sub-teks disesuaikan
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
          // =============================================================
          // == KONTEN BODY ASLI DIBUNGKUS DALAM SliverToBoxAdapter ==
          // =============================================================
          SliverToBoxAdapter(
            child: Obx(() => _buildBody(productId, transactionId)),
          ),
        ],
      ),
    );
  }

  // Metode _buildAppBar() sudah tidak diperlukan dan bisa dihapus.

  Widget _buildBody(int productId, int transactionId) {
    if (kDebugMode) {
      print('UI State - isLoading: ${controller.isLoading}');
      print('UI State - hasExistingRating: ${controller.hasExistingRating}');
      print(
        'UI State - currentUserRating: ${controller.currentUserRating?.rating}',
      );
    }

    if (controller.isLoading) {
      return _buildLoadingView();
    }

    if (controller.hasExistingRating && controller.currentUserRating != null) {
      if (kDebugMode) {
        print('Displaying existing rating view');
      }
      return _buildExistingRatingView();
    }

    if (kDebugMode) {
      print('Displaying rating form');
    }
    return _buildRatingForm(productId, transactionId);
  }

  Widget _buildLoadingView() {
    return Center(
      child: Container(
        // Menambahkan padding atas agar tidak terlalu dekat dengan AppBar
        margin: EdgeInsets.only(top: 80.h),
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10.r,
                    offset: Offset(0, 5.h),
                  ),
                ],
              ),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    const Color(0xFF667eea),
                  ),
                  strokeWidth: 3.w,
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Memuat...',
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScaffold() {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Center(
        child: Container(
          padding: EdgeInsets.all(32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 80.sp, color: Colors.red),
              SizedBox(height: 16.h),
              Text(
                'Data tidak valid',
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExistingRatingView() {
    final rating = controller.currentUserRating!;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(), // Scroll dinonaktifkan
      padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 15.w),
      child: Column(
        children: [
          SizedBox(height: 40.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(32.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 20.r,
                  offset: Offset(0, 10.h),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 120.w,
                  height: 120.w,
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Lottie.asset(
                      'assets/animation/check.json',
                      width: 80.w,
                      height: 80.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  'Rating Berhasil Diberikan!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Terima kasih atas feedback Anda',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 32.h),
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return Icon(
                            index < rating.rating
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            color:
                                index < rating.rating
                                    ? Colors.amber
                                    : Colors.grey.shade300,
                            size: 32.sp,
                          );
                        }),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        _getRatingText(rating.rating),
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: _getRatingColor(rating.rating),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      if (rating.comment != null && rating.comment!.isNotEmpty)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Komentar Anda:',
                                style: GoogleFonts.poppins(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                rating.comment!,
                                style: GoogleFonts.poppins(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 32.h),
                Container(
                  width: double.infinity,
                  height: 40.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [blueClr, dua, tiga],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF667eea).withOpacity(0.3),
                        blurRadius: 10.r,
                        offset: Offset(0, 5.h),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.offAllNamed(Routes.BOTTOMNAVIGATION);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    child: Text(
                      'Kembali ke Beranda',
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h), // Padding bawah
        ],
      ),
    );
  }

  Widget _buildRatingForm(int productId, int transactionId) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(), // Scroll dinonaktifkan
      padding: EdgeInsets.all(15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(15.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 20.r,
                  offset: Offset(0, 10.h),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: ClipOval(
                    child: Container(
                      width: 200.w,
                      height: 200.w,
                      color: Colors.yellow.shade100,
                      child: Lottie.asset(
                        'assets/animation/star.json',
                        repeat: true,
                        animate: true,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  'Bagaimana pengalaman Anda?',
                  style: GoogleFonts.poppins(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Berikan rating untuk membantu pembeli lain',
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(15.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.08),
                  blurRadius: 15.r,
                  offset: Offset(0, 5.h),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Pilih Rating',
                  style: GoogleFonts.poppins(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final starValue = index + 1;
                    final isSelected = starValue <= controller.selectedRating;
                    return Flexible(
                      child: GestureDetector(
                        onTap: () => controller.setRating(starValue),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: EdgeInsets.symmetric(horizontal: 2.w),
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? Colors.amber.shade50
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            isSelected
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            color:
                                isSelected
                                    ? Colors.amber
                                    : Colors.grey.shade400,
                            size: 28.sp,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 16.h),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    _getRatingText(controller.selectedRating),
                    key: ValueKey(controller.selectedRating),
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: _getRatingColor(controller.selectedRating),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(15.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.08),
                  blurRadius: 15.r,
                  offset: Offset(0, 5.h),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.comment_outlined,
                      color: Colors.grey.shade600,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Komentar',
                      style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        'Opsional',
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                TextFormField(
                  controller: controller.commentController,
                  maxLines: 4,
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Ceritakan pengalaman Anda dengan produk ini...',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade500,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: BorderSide(
                        color: const Color(0xFF667eea),
                        width: 2.w,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: EdgeInsets.all(16.w),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32.h),
          Container(
            width: double.infinity,
            height: 45.h,
            decoration: BoxDecoration(
              gradient:
                  controller.selectedRating > 0
                      ? LinearGradient(
                        colors: [blueClr, dua],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      )
                      : null,
              color:
                  controller.selectedRating > 0 ? null : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow:
                  controller.selectedRating > 0
                      ? [
                        BoxShadow(
                          color: const Color(0xFF667eea).withOpacity(0.3),
                          blurRadius: 10.r,
                          offset: Offset(0, 5.h),
                        ),
                      ]
                      : null,
            ),
            child: ElevatedButton(
              onPressed:
                  controller.selectedRating > 0
                      ? () => _submitRating(productId, transactionId)
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.send_rounded,
                    color:
                        controller.selectedRating > 0
                            ? Colors.white
                            : Colors.grey.shade500,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Kirim Rating',
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color:
                          controller.selectedRating > 0
                              ? Colors.white
                              : Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return 'Sangat Buruk';
      case 2:
        return 'Buruk';
      case 3:
        return 'Biasa';
      case 4:
        return 'Baik';
      case 5:
        return 'Sangat Baik';
      default:
        return 'Pilih Rating';
    }
  }

  Color _getRatingColor(int rating) {
    switch (rating) {
      case 1:
        return Colors.red.shade600;
      case 2:
        return Colors.orange.shade600;
      case 3:
        return Colors.amber.shade600;
      case 4:
        return Colors.lightGreen.shade600;
      case 5:
        return Colors.green.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  void _submitRating(int productId, int transactionId) {
    if (!controller.validateRating()) return;

    controller.addRating(
      productId: productId,
      transactionId: transactionId,
      rating: controller.selectedRating,
      comment: controller.comment.isNotEmpty ? controller.comment : null,
    );
  }
}
