// ignore_for_file: unnecessary_null_comparison, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart'; // <-- Tambahkan import ini
import 'package:intl/intl.dart';
import 'package:pos/app/data/models/penjualan.dart';
// Hapus import color.dart jika warna sudah didefinisikan di sini
// import 'package:pos/app/data/utils/color.dart';
import '../controllers/detailorder_controller.dart';

// Definisi Warna yang dibutuhkan oleh AppBar baru
const blueClr = Color(0xff1b55f6);
const satu = Color(0xFF004FC2);
const dua = Color(0xFF0044AC);
const tiga = Color(0xFF01399A);

class DetailorderView extends GetView<DetailorderController> {
  const DetailorderView({super.key});

  // Helper methods tetap sama
  Color _getStatusColor(Status status) {
    switch (status) {
      case Status.PAID:
        return const Color(0xFF4CAF50);
      case Status.PENDING:
        return const Color(0xFFFF9800);
    }
  }

  IconData _getStatusIcon(Status status) {
    switch (status) {
      case Status.PAID:
        return Icons.check_circle_rounded;
      case Status.PENDING:
        return Icons.access_time_rounded;
    }
  }

  IconData _getTypeIcon(Type type) {
    switch (type) {
      case Type.DINE_IN:
        return Icons.restaurant_rounded;
      case Type.TAKE_AWAY:
        return Icons.shopping_bag_rounded;
    }
  }

  IconData _getPaymentMethodIcon(PaymentMethod paymentMethod) {
    switch (paymentMethod) {
      case PaymentMethod.CASH:
        return Icons.payments_rounded;
      case PaymentMethod.MIDTRANS:
        return Icons.credit_card_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.put(DetailorderController());
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    final Datum order = Get.arguments;
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          // == SLIVER APP BAR BARU ==
          SliverAppBar(
            expandedHeight: 220.h,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
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
                    colors: [tiga, dua, blueClr], // Variasi gradient
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
                child: Stack(
                  children: [
                    // Elemen dekoratif
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
                    // Konten Utama AppBar (disesuaikan dengan data order)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(16.r),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1.5.w,
                              ),
                            ),
                            child: Icon(
                              Icons.receipt_long_rounded, // Ikon disesuaikan
                              size: 32.sp,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            order.invoiceNumber, // Teks disesuaikan
                            style: GoogleFonts.poppins(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            // Sub-teks disesuaikan
                            DateFormat('dd MMMM yyyy, HH:mm').format(
                              order.createdAt.toUtc().add(
                                const Duration(hours: 7),
                              ),
                            ),
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          // Status Badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(
                                order.status,
                              ).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: _getStatusColor(order.status),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getStatusIcon(order.status),
                                  size: 14.sp,
                                  color: _getStatusColor(order.status),
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  order.status.name.toUpperCase(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: _getStatusColor(order.status),
                                  ),
                                ),
                              ],
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
          // Konten di bawah AppBar tetap sama
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard(order, currencyFormatter),
                  SizedBox(height: 20.h),
                  _buildOrderItemsSection(),
                  SizedBox(height: 20.h),
                  _buildPaymentSummaryCard(order, currencyFormatter),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildOrderItemsSection, _buildInfoCard, dan lainnya tetap sama
  Widget _buildOrderItemsSection() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Item Pesanan',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: 16.h),
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final data = controller.detailPenjualanList.value?.data ?? [];

            if (data.isEmpty) {
              return const Center(
                child: Text(
                  "Tidak ada data saat ini.",
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.length,
              separatorBuilder: (context, index) => Divider(height: 20.h),
              itemBuilder: (context, index) {
                final item = data[index];
                final currencyFormatter = NumberFormat.currency(
                  locale: 'id_ID',
                  symbol: 'Rp',
                  decimalDigits: 0,
                );

                return Row(
                  children: [
                    Container(
                      width: 60.w,
                      height: 60.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.r),
                        image:
                            item.produk.image != null
                                ? DecorationImage(
                                  image: NetworkImage(
                                    "${dotenv.env['IMG_URL']}/${item.produk.image}",
                                  ),
                                  fit: BoxFit.cover,
                                )
                                : null,
                      ),
                      child:
                          item.produk.image == null
                              ? Icon(
                                Icons.fastfood_rounded,
                                color: Colors.grey,
                                size: 24.sp,
                              )
                              : null,
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.produk.namaProduk,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            '${currencyFormatter.format(item.produk.hargaJual)} x ${item.qty}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      currencyFormatter.format(
                        item.qty * item.produk.hargaJual,
                      ),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF059669),
                      ),
                    ),
                  ],
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildInfoCard(Datum order, NumberFormat currencyFormatter) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informasi Transaksi',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  'Tipe Order',
                  order.type.toString().split('.').last.replaceAll('_', ' '),
                  _getTypeIcon(order.type),
                  const Color(0xFF667EEA),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildInfoItem(
                  'Pembayaran',
                  order.paymentMethod.toString().split('.').last.toUpperCase(),
                  _getPaymentMethodIcon(order.paymentMethod),
                  const Color(0xFF059669),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          if (order.mejaId != null)
            _buildInfoRow('Nomor Meja', 'Meja ${order.mejaId}'),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32.sp),
          SizedBox(height: 8.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E293B),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummaryCard(Datum order, NumberFormat currencyFormatter) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ringkasan Pembayaran',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: 16.h),
          _buildPaymentRow(
            'Sub Total',
            currencyFormatter.format(order.subTotal),
          ),
          if (order.ppn > 0) _buildPaymentRow('PPN', "${order.ppn} %"),
          if (order.biayaLayanan > 0)
            _buildPaymentRow(
              'Biaya Layanan',
              currencyFormatter.format(order.biayaLayanan),
            ),
          Divider(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Pembayaran',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
              ),
              Text(
                currencyFormatter.format(order.total),
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF059669),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
}
