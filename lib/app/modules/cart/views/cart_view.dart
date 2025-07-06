// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:pos/app/data/models/cart.dart';
import 'package:pos/app/data/utils/color.dart';
import 'package:pos/app/modules/cart/controllers/cart_controller.dart';
import 'package:pos/app/modules/checkout/views/checkout_view.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  String formatRupiah(int amount) {
    final NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return currencyFormatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    Get.put(controller);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/animation/bag.json',
                  width: 200.w,
                  height: 200.h,
                  repeat: true,
                  animate: true,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 20.h),
                Text(
                  "Ups! Belum ada item nih..",
                  style: GoogleFonts.poppins(
                    fontSize: 20.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "Silakan tambahkan item terlebih dahulu untuk memproses transaksi.",
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h),
                ElevatedButton.icon(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: Text(
                    "Lanjut Belanja",
                    style: GoogleFonts.poppins(
                      fontSize: 15.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: blueClr,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 220.h,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor:
                  tiga, // Warna fallback jika gradient tidak tampil
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
                                Icons
                                    .shopping_cart_outlined, // Ikon disesuaikan
                                size: 40.sp,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 15.h),
                            Obx(
                              () => Text(
                                'Keranjang Saya (${controller.cartItems.length})', // Teks disesuaikan
                                style: GoogleFonts.poppins(
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Periksa kembali item belanjaan Anda', // Sub-teks disesuaikan
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
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final item = controller.cartItems[index];
                  return _buildCartItemCard(item);
                }, childCount: controller.cartItems.length),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: Obx(
        () =>
            controller.cartItems.isEmpty
                ? const SizedBox.shrink()
                : _buildSummaryAndCheckoutButton(context),
      ),
    );
  }

  Widget _buildCartItemCard(CartItem item) {
    // ... (kode widget ini tetap sama)
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Image.network(
              item.product.image != null && item.product.image!.isNotEmpty
                  ? '${dotenv.env['IMG_URL']}/${item.product.image}'
                  : 'https://via.placeholder.com/80',
              width: 80.w,
              height: 80.h,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    width: 80.w,
                    height: 80.h,
                    color: Colors.grey[200],
                    child: Icon(
                      Icons.broken_image,
                      size: 40.sp,
                      color: Colors.grey[400],
                    ),
                  ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.namaProduk,
                  style: GoogleFonts.poppins(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.h),
                Text(
                  formatRupiah(item.product.hargaJual),
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    controller.decreaseQuantity(item);
                  },
                  child: Icon(
                    Icons.remove,
                    size: 20.sp,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(width: 10.w),
                Obx(
                  () => Text(
                    '${item.quantity.value}',
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                GestureDetector(
                  onTap: () {
                    controller.increaseQuantity(item);
                  },
                  child: Icon(Icons.add, size: 20.sp, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryAndCheckoutButton(BuildContext context) {
    // ... (kode widget ini tetap sama, hanya dipindahkan ke bottomNavigationBar)
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSummaryRow(
              'Subtotal (${controller.cartItems.length} items)',
              controller.subTotal.value,
            ),
            _buildSummaryRow(
              'PPN (${controller.setting.value!.data.ppn}%)',
              controller.ppnAmount.value,
            ),
            _buildSummaryRow('Biaya Layanan ', controller.biayaLayanan.value),
            SizedBox(height: 10.h),
            Divider(height: 1.h, color: Colors.grey[300]),
            SizedBox(height: 10.h),
            _buildSummaryRow('Total', controller.total.value, isTotal: true),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () {
                Get.to(() => const CheckoutView());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: blueClr,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                elevation: 0,
              ),
              child: Text(
                'Lanjut ke Pembayaran',
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, int amount, {bool isTotal = false}) {
    // ... (kode widget ini tetap sama)
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: isTotal ? 17.sp : 15.sp,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
              color: isTotal ? Colors.black : Colors.grey[700],
            ),
          ),
          Text(
            formatRupiah(amount),
            style: GoogleFonts.poppins(
              fontSize: isTotal ? 17.sp : 15.sp,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
              color: isTotal ? Colors.black : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
