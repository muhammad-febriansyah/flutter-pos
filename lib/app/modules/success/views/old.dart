import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:pos/app/data/models/detail_penjualan.dart';
import 'package:pos/app/data/utils/color.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../controllers/success_controller.dart';
import '../../../routes/app_pages.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart'; // Import the package

class SuccessView extends GetView<SuccessController> {
  const SuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          if (controller.isLoading.value) {
            return SmartRefresher(
              controller: controller.refreshController,
              onRefresh: controller.onRefresh,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Memuat detail transaksi...',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }

          if (controller.detailPenjualanList.value == null ||
              controller.detailPenjualanList.value!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 50),
                  const SizedBox(height: 16),
                  Text(
                    'Gagal memuat detail transaksi atau data kosong.',
                    style: GoogleFonts.poppins(fontSize: 16, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pastikan nomor invoice benar atau coba lagi.',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      controller.getDetailPenjualan();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blueClr,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text('Coba Lagi', style: GoogleFonts.poppins()),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () {
                      Get.offAllNamed(Routes.BOTTOMNAVIGATION);
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: blueClr),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          HugeIcons.strokeRoundedHome10,
                          color: blueClr,
                          size: 18.h,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Kembali ke Beranda',
                          style: GoogleFonts.poppins(color: blueClr),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          final Penjualan dataPenjualanUtama =
              controller.detailPenjualanList.value!.first.penjualan;
          final List<DataPenjualan> purchasedItems =
              controller.detailPenjualanList.value!;

          final String invoiceNumber = dataPenjualanUtama.invoiceNumber;
          final String status = dataPenjualanUtama.status;
          final int totalAmount = dataPenjualanUtama.total;
          final String paymentMethod = dataPenjualanUtama.paymentMethod;

          // Determine the main title and message based on status
          final String mainStatusTitle =
              status == 'paid' ? 'Pembayaran Berhasil!' : 'Menunggu Pembayaran';
          final String statusMessage =
              status == 'paid'
                  ? 'Transaksi Anda telah berhasil diproses.'
                  : 'Transaksi ini masih menunggu konfirmasi pembayaran. Silakan selesaikan pembayaran agar pesanan dapat diproses.';
          final Color statusTitleColor =
              status == 'paid' ? Colors.green.shade700 : Colors.orange.shade700;

          return SmartRefresher(
            controller: controller.refreshController,
            onRefresh: controller.onRefresh,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: ClipPath(
                      clipper: MultipleRoundedCurveClipper(),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(20.sp),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            15.r,
                          ), // BorderRadius is not needed with ClipPath
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              status == 'paid'
                                  ? 'assets/animation/check.json'
                                  : 'assets/animation/warning.json', // Assuming 'warning.json' is suitable for pending
                              width: 100.w,
                              height: 100.h,
                              repeat: true,
                              animate: true,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              mainStatusTitle, // Dynamic title
                              style: GoogleFonts.poppins(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: statusTitleColor, // Dynamic color
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              statusMessage, // Dynamic message
                              style: GoogleFonts.poppins(
                                fontSize: 14.sp,
                                color: Colors.grey.shade600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              currencyFormatter.format(totalAmount),
                              style: GoogleFonts.poppins(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 24.h),
                            // --- Transaction Details Section ---
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Detail Transaksi',
                                style: GoogleFonts.poppins(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Divider(
                              height: 20.h,
                              thickness: 1,
                              color: Colors.grey.shade200,
                            ),
                            _buildDetailRow(
                              'Status Pembayaran',
                              status == 'paid'
                                  ? 'Lunas'
                                  : 'Menunggu', // Changed to "Menunggu"
                              isBoldValue: true,
                              valueColor:
                                  status == 'paid'
                                      ? Colors.green.shade700
                                      : Colors
                                          .orange
                                          .shade700, // Color for pending
                            ),
                            _buildDetailRow(
                              'Metode Pembayaran',
                              paymentMethod.capitalizeFirst!,
                            ),
                            _buildDetailRow('Nomor Transaksi', invoiceNumber),

                            SizedBox(height: 20.h),
                            // --- Rincian Pembelian Section ---
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Rincian Pembelian',
                                style: GoogleFonts.poppins(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Divider(
                              height: 20.h,
                              thickness: 1,
                              color: Colors.grey.shade200,
                            ),
                            purchasedItems.isNotEmpty
                                ? Column(
                                  children: _buildPurchasedItemsList(
                                    purchasedItems,
                                    currencyFormatter,
                                  ),
                                )
                                : Center(
                                  child: Text(
                                    'Data rincian pembelian tidak tersedia',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14.sp,
                                      color: Colors.grey.shade600,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                            SizedBox(
                              height: 30.h,
                            ), // Add some space before the button
                            ElevatedButton(
                              onPressed: () {
                                Get.offAllNamed(Routes.BOTTOMNAVIGATION);
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                backgroundColor: blueClr,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                minimumSize: Size(
                                  double.infinity,
                                  0,
                                ), // Ensure it takes full width
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    HugeIcons.strokeRoundedHome10,
                                    color: Colors.white,
                                    size: 18.h,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'Kembali ke Home',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Add some space before the button
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isBoldValue = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: Colors.grey.shade700,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: isBoldValue ? FontWeight.w600 : FontWeight.normal,
              color: valueColor ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPurchasedItemsList(
    List<DataPenjualan> items,
    NumberFormat currencyFormatter,
  ) {
    List<Widget> list = [];
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      final subtotal = item.qty * item.produk.hargaJual;
      list.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.produk.namaProduk,
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    color: Colors.black87,
                  ),
                ),
              ),
              Text(
                'x${item.qty}',
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                currencyFormatter.format(subtotal),
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      );
      if (i < items.length - 1) {
        list.add(
          Divider(height: 10.h, thickness: 0.5, color: Colors.grey.shade200),
        );
      }
    }
    return list;
  }
}
