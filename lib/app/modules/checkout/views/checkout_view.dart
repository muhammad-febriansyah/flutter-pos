// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:pos/app/data/utils/color.dart';
import 'package:pos/app/modules/cart/controllers/cart_controller.dart';
import 'package:pos/app/modules/checkout/controllers/checkout_controller.dart';
import 'package:flutter/foundation.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

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
    final CartController cartController = Get.find<CartController>();
    final controller = Get.put(CheckoutController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // --- AppBar Kustom dengan Desain Baru ---
          SliverAppBar(
            expandedHeight: 220.h,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: tiga, // Warna fallback
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
                              HugeIcons
                                  .strokeRoundedCreditCard, // Ikon disesuaikan untuk pembayaran
                              size: 40.sp,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 15.h),
                          Text(
                            'Pembayaran', // Teks disesuaikan
                            style: GoogleFonts.poppins(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Selesaikan pesanan Anda di sini', // Sub-teks disesuaikan
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
          // --- Konten Utama Halaman Checkout ---
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bagaimana Anda akan menikmati pesanan ini?',
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Obx(
                    () => Row(
                      children: [
                        Expanded(
                          child: _buildOrderTypeCard(
                            context,
                            'Makan di Sini',
                            'Duduk dan nikmati hidangan Anda.',
                            'dine_in',
                            controller.selectedOrderType.value,
                            (value) =>
                                controller.selectedOrderType.value = value!,
                            HugeIcons.strokeRoundedRestaurant01,
                          ),
                        ),
                        SizedBox(width: 15.w),
                        Expanded(
                          child: _buildOrderTypeCard(
                            context,
                            'Bawa Pulang',
                            'Siap untuk dibawa pulang.',
                            'take_away',
                            controller.selectedOrderType.value,
                            (value) =>
                                controller.selectedOrderType.value = value!,
                            HugeIcons.strokeRoundedDeliveryBox01,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25.h),
                  Obx(() {
                    if (controller.selectedOrderType.value == 'dine_in') {
                      return _buildTableSelectionGrid(context, controller);
                    } else if (controller.selectedOrderType.value ==
                        'take_away') {
                      return _buildTakeAwayInfoCard(context);
                    }
                    return const SizedBox.shrink();
                  }),
                  SizedBox(height: 25.h),
                  Container(
                    padding: EdgeInsets.all(18.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.08),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ringkasan Pesanan Anda',
                          style: GoogleFonts.poppins(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 15.h),
                        _buildSummaryRow(
                          'Total Pesanan (${cartController.cartItems.length} item)',
                          cartController.subTotal.value,
                        ),
                        _buildSummaryRow(
                          'Pajak PPN (${cartController.setting.value?.data.ppn ?? 0}%)',
                          cartController.ppnAmount.value,
                        ),
                        _buildSummaryRow(
                          'Biaya Layanan',
                          cartController.biayaLayanan.value,
                        ),
                        SizedBox(height: 10.h),
                        Divider(height: 1.h, color: Colors.grey[200]),
                        SizedBox(height: 10.h),
                        _buildSummaryRow(
                          'Total Akhir',
                          cartController.total.value,
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25.h),
                  Text(
                    'Pilih metode pembayaran yang Anda inginkan:',
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Obx(
                    () => Column(
                      children: [
                        _buildPaymentMethodCard(
                          context,
                          'Bayar Tunai',
                          'Bayar langsung di kasir dengan uang tunai.',
                          'cash',
                          controller.selectedPaymentMethod.value,
                          (value) =>
                              controller.selectedPaymentMethod.value = value!,
                          HugeIcons.strokeRoundedMoney03,
                        ),
                        SizedBox(height: 12.h),
                        _buildPaymentMethodCard(
                          context,
                          'Bayar Online (Midtrans)',
                          'Bayar via kartu kredit/debit, e-wallet, dll.',
                          'midtrans',
                          controller.selectedPaymentMethod.value,
                          (value) =>
                              controller.selectedPaymentMethod.value = value!,
                          HugeIcons.strokeRoundedCreditCard,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildCheckoutButton(context, cartController),
    );
  }

  // Widget-widget bantuan lainnya tetap sama
  // ... (Salin semua widget bantuan dari _buildSummaryRow hingga _buildCheckoutButton di sini)

  // Baris ringkasan pembayaran
  Widget _buildSummaryRow(String label, int amount, {bool isTotal = false}) {
    // ... (kode widget ini tetap sama)
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: isTotal ? 17.sp : 15.sp,
                fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
                color: isTotal ? Colors.black : Colors.grey[700],
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          SizedBox(width: 10.w),
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

  // Kartu pilihan jenis pesanan
  Widget _buildOrderTypeCard(
    BuildContext context,
    String title,
    String subtitle,
    String value,
    String groupValue,
    ValueChanged<String?> onChanged,
    IconData icon,
  ) {
    // ... (kode widget ini tetap sama)
    final bool isSelected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
        decoration: BoxDecoration(
          color: isSelected ? blueClr.withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: isSelected ? blueClr : Colors.grey[300]!,
            width: isSelected ? 2.w : 1.w,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  isSelected
                      ? blueClr.withOpacity(0.15)
                      : Colors.grey.withOpacity(0.05),
              spreadRadius: isSelected ? 2 : 1,
              blurRadius: isSelected ? 10 : 5,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 45.sp,
              color: isSelected ? blueClr : Colors.grey[600],
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 17.sp,
                fontWeight: FontWeight.bold,
                color: isSelected ? blueClr : Colors.black87,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            SizedBox(height: 6.h),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                color: isSelected ? blueClr.withOpacity(0.8) : Colors.grey[600],
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  // Kartu pilihan metode pembayaran
  Widget _buildPaymentMethodCard(
    BuildContext context,
    String title,
    String subtitle,
    String value,
    String groupValue,
    ValueChanged<String?> onChanged,
    IconData icon,
  ) {
    // ... (kode widget ini tetap sama)
    final bool isSelected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: isSelected ? blueClr.withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: isSelected ? blueClr : Colors.grey[300]!,
            width: isSelected ? 2.w : 1.w,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  isSelected
                      ? blueClr.withOpacity(0.15)
                      : Colors.grey.withOpacity(0.05),
              spreadRadius: isSelected ? 2 : 1,
              blurRadius: isSelected ? 10 : 5,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 30.sp,
              color: isSelected ? blueClr : Colors.grey[500],
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? blueClr.darken(0.1) : Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      color:
                          isSelected
                              ? blueClr.withOpacity(0.8)
                              : Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: blueClr, size: 24.sp),
          ],
        ),
      ),
    );
  }

  // Kartu info Bawa Pulang
  Widget _buildTakeAwayInfoCard(BuildContext context) {
    // ... (kode widget ini tetap sama)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Info Pesanan Anda',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 15.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.08),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                HugeIcons.strokeRoundedShoppingBag02,
                size: 60.sp,
                color: blueClr,
              ),
              SizedBox(height: 15.h),
              Text(
                'Pesanan Akan Dibawa Pulang',
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              SizedBox(height: 8.h),
              Text(
                'Pesanan ini tidak memerlukan meja. Silakan ambil pesanan Anda di konter.',
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTableSelectionGrid(
    BuildContext context,
    CheckoutController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pilih Meja yang Anda Inginkan',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 15.h),
        Padding(
          padding: EdgeInsets.only(bottom: 15.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLegendItem(Colors.green.shade400, 'Tersedia'),
              _buildLegendItem(Colors.red.shade400, 'Tidak Tersedia'),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(15.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.08),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: GetX<CheckoutController>(
            builder: (controller) {
              // Debug log untuk release mode
              print(
                'Table Grid Rebuilding. List length: ${controller.listMeja.length}',
              );
              print('Selected meja ID: ${controller.selectedMeja.value?.id}');

              if (controller.listMeja.isEmpty) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Center(
                    child: Text(
                      'Maaf, tidak ada meja yang tersedia.',
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                );
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 15.h,
                  childAspectRatio: 0.8,
                ),
                itemCount: controller.listMeja.length,
                itemBuilder: (context, index) {
                  final meja = controller.listMeja[index];
                  final bool isSelected =
                      controller.selectedMeja.value?.id == meja.id;
                  final bool isAvailable = meja.status == 'tersedia';

                  // Debug log untuk setiap item
                  print(
                    'Rendering Meja ${meja.nama} (ID: ${meja.id}), Status: ${meja.status}, IsSelected: $isSelected',
                  );

                  Color backgroundColor;
                  Color textColor;
                  Color borderColor;

                  if (isSelected) {
                    backgroundColor = blueClr;
                    textColor = Colors.white;
                    borderColor = blueClr.darken(0.1);
                  } else if (isAvailable) {
                    backgroundColor = Colors.green.shade50;
                    textColor = Colors.green.shade800;
                    borderColor = Colors.green.shade300;
                  } else {
                    backgroundColor = Colors.red.shade50;
                    textColor = Colors.red.shade800;
                    borderColor = Colors.red.shade300;
                  }

                  return GestureDetector(
                    onTap:
                        isAvailable
                            ? () {
                              print(
                                'Tapped on Meja ${meja.nama} (ID: ${meja.id})',
                              );

                              // Gunakan method selectMeja yang sudah diperbaiki
                              controller.selectMeja(meja);

                              print(
                                'Meja selected after tap: ${controller.selectedMeja.value?.nama}',
                              );
                            }
                            : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: borderColor,
                          width: isSelected ? 2.5.w : 1.w,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                isSelected
                                    ? blueClr.withOpacity(0.3)
                                    : Colors.grey.withOpacity(0.1),
                            spreadRadius: isSelected ? 2 : 1,
                            blurRadius: isSelected ? 8 : 4,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            HugeIcons.strokeRoundedTable02,
                            size: 35.sp,
                            color: textColor,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Meja ${meja.nama}',
                            style: GoogleFonts.poppins(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            'Max ${meja.kapasitas} Orang',
                            style: GoogleFonts.poppins(
                              fontSize: 11.sp,
                              color: textColor.withOpacity(0.8),
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // Item legenda
  Widget _buildLegendItem(Color color, String text) {
    // ... (kode widget ini tetap sama)
    return Row(
      children: [
        Container(
          width: 18.w,
          height: 18.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5.r),
            border: Border.all(color: Colors.grey.shade400, width: 0.5),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          text,
          style: GoogleFonts.poppins(fontSize: 13.sp, color: Colors.grey[700]),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }

  // Tombol checkout
  Widget _buildCheckoutButton(
    BuildContext context,
    CartController cartController,
  ) {
    // ... (kode widget ini tetap sama, hanya dipindahkan ke bottomNavigationBar)
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Obx(
        () => ElevatedButton(
          onPressed:
              controller.isLoading.value
                  ? null
                  : () {
                    if (controller.selectedOrderType.value.isEmpty) {
                      Get.snackbar(
                        'Penting!',
                        'Mohon pilih jenis pesanan (Makan di Sini / Bawa Pulang).',
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.orange.shade700,
                        colorText: Colors.white,
                        margin: EdgeInsets.all(15.w),
                        borderRadius: 10.r,
                      );
                      return;
                    }
                    if (controller.selectedOrderType.value == 'dine_in' &&
                        controller.selectedMeja.value == null) {
                      Get.snackbar(
                        'Penting!',
                        'Anda harus memilih meja untuk makan di sini.',
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.orange.shade700,
                        colorText: Colors.white,
                        margin: EdgeInsets.all(15.w),
                        borderRadius: 10.r,
                      );
                      return;
                    }
                    controller.processPayment(
                      cartController.cartItems.toList(),
                      cartController.total.value,
                      controller.selectedOrderType.value,
                    );
                  },
          style: ElevatedButton.styleFrom(
            backgroundColor: blueClr,
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, 50.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.r),
            ),
            elevation: 8,
            shadowColor: blueClr.withOpacity(0.4),
          ),
          child:
              controller.isLoading.value
                  ? SizedBox(
                    width: 24.w,
                    height: 24.w,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                  : Text(
                    'Selesaikan Pembayaran',
                    style: GoogleFonts.poppins(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
        ),
      ),
    );
  }
}

// Extension untuk menggelapkan warna
extension ColorDarken on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
