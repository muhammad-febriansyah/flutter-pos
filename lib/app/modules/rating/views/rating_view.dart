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

    // Validasi arguments
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

    // Initialize data check
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.checkExistingRating(
        productId: productId,
        transactionId: transactionId,
      );
    });

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(),
      body: Obx(() => _buildBody(productId, transactionId)),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight.h + 10.h),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [blueClr, dua, tiga],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10.r,
              offset: Offset(0, 5.h),
            ),
          ],
        ),
        child: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Berikan Rating',
                      style: GoogleFonts.poppins(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
      appBar: _buildAppBar(),
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
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      scrollDirection: Axis.vertical,
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
                // Success Animation
                Container(
                  width: 120.w,
                  height: 120.w, // pastikan ini SAMA
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    shape: BoxShape.circle, // GUNAKAN INI
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

                // Success Message
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

                // Rating Display
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    children: [
                      // Stars
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

                      // Rating Text
                      Text(
                        _getRatingText(rating.rating),
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: _getRatingColor(rating.rating),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Comment if exists
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

                // Back Button
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
        ],
      ),
    );
  }

  Widget _buildRatingForm(int productId, int transactionId) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: EdgeInsets.all(15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),

          // Rating Animation Card
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
                      height:
                          200.w, // Pastikan width dan height sama untuk lingkaran
                      color: Colors.yellow.shade100, // Background opsional
                      child: Lottie.asset(
                        'assets/animation/star.json',
                        repeat: true,
                        animate: true,
                        fit:
                            BoxFit
                                .contain, // Hindari cover agar tidak keluar dari lingkaran
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

          // Rating Stars Card
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

                // Stars
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

                // Rating Text
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

          // Comment Card
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

          // Submit Button
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
