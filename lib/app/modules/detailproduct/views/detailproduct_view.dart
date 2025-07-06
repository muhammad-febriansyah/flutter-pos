// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:pos/app/data/utils/color.dart';
import 'package:pos/app/modules/cart/controllers/cart_controller.dart';
import '../controllers/detailproduct_controller.dart';

class DetailproductView extends GetView<DetailproductController> {
  const DetailproductView({super.key});

  // Palet Warna & Styling Konsisten
  static const Color _primaryTextColor = Color(0xFF222B45);
  static const Color _secondaryTextColor = Color(0xFF8F9BB3);
  static const Color _discountColor = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    // Inisialisasi controller di sini agar mudah diakses
    final CartController cartController = Get.find<CartController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Container(
              // Konten utama dengan latar belakang putih dan sudut atas melengkung
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Indikator "Drag Handle" untuk estetika
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      margin: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),

                  // Padding untuk semua konten di bawahnya
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProductHeader(),
                        SizedBox(height: 24.h),
                        _buildPriceAndDiscountSection(),
                        SizedBox(height: 24.h),
                        _buildStatusSection(),
                        SizedBox(height: 24.h),
                        _buildQuantitySelector(),
                        SizedBox(height: 24.h),
                        _buildDescription(),
                        SizedBox(height: 24.h),
                        // _buildSpecifications(),
                        // SizedBox(height: 120.h), // Padding untuk bottom bar
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Bottom bar didesain ulang untuk menampilkan total harga dinamis
      bottomNavigationBar: Obx(() => _buildBottomAddToCartBar(cartController)),
    );
  }

  /// AppBar dengan gambar full-width dan efek gradien.
  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 250.h, // Tinggi diperbesar untuk efek dramatis
      pinned: true,
      stretch: true,
      backgroundColor: Colors.white,
      elevation: 0,
      foregroundColor: Colors.white,
      leading: _buildAppBarButton(
        icon: Icons.arrow_back_ios_new,
        onPressed: () => Get.back(),
      ),
      actions: [
        Obx(
          () => _buildAppBarButton(
            icon:
                controller.isWishlisted.value
                    ? Icons.favorite
                    : Icons.favorite_border,
            onPressed: controller.toggleWishlist,
            color:
                controller.isWishlisted.value ? _discountColor : Colors.white,
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: 'product-${controller.product.id}',
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Gambar Produk
              Image.network(
                controller.product.image != null
                    ? "${dotenv.env['IMG_URL']}/${controller.product.image}"
                    : 'https://via.placeholder.com/400x400?text=No+Image',
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => _buildImagePlaceholder(),
              ),
              // Gradien overlay agar ikon status bar dan tombol terlihat jelas
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.5),
                      Colors.black.withOpacity(0.2),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.25, 1.0],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Tombol AppBar dengan efek glassmorphism.
  Widget _buildAppBarButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: IconButton(
              icon: Icon(icon, color: color ?? Colors.white, size: 20.sp),
              onPressed: onPressed,
            ),
          ),
        ),
      ),
    );
  }

  /// Placeholder jika gambar gagal dimuat.
  Widget _buildImagePlaceholder() {
    return Container(
      color: Colors.grey.shade200,
      child: Center(
        child: Icon(
          Icons.photo_size_select_actual_outlined,
          color: Colors.grey.shade400,
          size: 60.sp,
        ),
      ),
    );
  }

  /// Header: Kategori (dengan ikon), Nama Produk.
  Widget _buildProductHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Menampilkan ikon dari kategori
            Image.network(
              "${dotenv.env['IMG_URL']}/${controller.product.kategori.icon}",
              width: 20.w,
              height: 20.w,
              errorBuilder:
                  (c, o, s) =>
                      Icon(Icons.category_outlined, size: 20.w, color: blueClr),
            ),
            SizedBox(width: 8.w),
            Text(
              controller.product.kategori.kategori,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: blueClr,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          controller.product.namaProduk,
          style: GoogleFonts.poppins(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: _primaryTextColor,
            height: 1.3,
          ),
        ),
      ],
    );
  }

  /// Bagian Harga dan Diskon.
  Widget _buildPriceAndDiscountSection() {
    final hasDiscount = controller.product.promo > 0;
    final discountedPrice =
        controller.product.hargaJual - controller.product.promo;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: blueClr.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Price',
                style: TextStyle(fontSize: 14.sp, color: _secondaryTextColor),
              ),
              SizedBox(height: 4.h),
              Text(
                'Rp ${_formatCurrency(hasDiscount ? discountedPrice : controller.product.hargaJual)}',
                style: GoogleFonts.poppins(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: blueClr,
                ),
              ),
              if (hasDiscount) ...[
                SizedBox(height: 4.h),
                Text(
                  'Rp ${_formatCurrency(controller.product.hargaJual)}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: _secondaryTextColor,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ],
          ),
          if (hasDiscount)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: _discountColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                '${controller.product.percentage}% OFF',
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Bagian Status: Stok dan Ketersediaan (isActive).
  Widget _buildStatusSection() {
    return Row(
      children: [
        _buildStatusChip(
          icon: Icons.inventory_2_outlined,
          label:
              'Stock: ${controller.product.stok} ${controller.product.satuan.satuan}',
          color: controller.product.stok > 0 ? Colors.green : _discountColor,
        ),
        SizedBox(width: 12.w),
        _buildStatusChip(
          icon:
              controller.product.isActive == 1
                  ? Icons.check_circle_outline
                  : Icons.remove_circle_outline,
          label: controller.product.isActive == 1 ? 'Available' : 'Unavailable',
          color:
              controller.product.isActive == 1 ? Colors.green : Colors.orange,
        ),
      ],
    );
  }

  Widget _buildStatusChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16.sp, color: color),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Pemilih Kuantitas.
  Widget _buildQuantitySelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Quantity',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: _primaryTextColor,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            children: [
              _buildQuantityButton(
                icon: Icons.remove,
                onPressed: controller.decreaseQuantity,
              ),
              Container(
                width: 50.w,
                alignment: Alignment.center,
                child: Obx(
                  () => Text(
                    controller.quantity.value.toString(),
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: _primaryTextColor,
                    ),
                  ),
                ),
              ),
              _buildQuantityButton(
                icon: Icons.add,
                onPressed: controller.increaseQuantity,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: _primaryTextColor, size: 20.sp),
      splashRadius: 20,
    );
  }

  /// Deskripsi produk yang bisa di-expand.
  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Description'),
        SizedBox(height: 10.h),
        Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.product.deskripsi,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: _secondaryTextColor,
                  height: 1.7,
                ),
                maxLines: controller.isDescriptionExpanded.value ? null : 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8.h),
              GestureDetector(
                onTap: controller.toggleDescription,
                child: Text(
                  controller.isDescriptionExpanded.value
                      ? 'Show Less'
                      : 'Read More...',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: blueClr,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Judul untuk setiap seksi.
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: _primaryTextColor,
      ),
    );
  }

  /// Bottom bar dengan total harga dinamis dan tombol CTA.
  Widget _buildBottomAddToCartBar(CartController cartController) {
    final hasDiscount = controller.product.promo > 0;
    final pricePerItem =
        hasDiscount
            ? controller.product.hargaJual - controller.product.promo
            : controller.product.hargaJual;
    final totalPrice = pricePerItem * controller.quantity.value;

    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
        border: Border(
          top: BorderSide(color: Colors.grey.shade200, width: 1.5),
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Harga',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: _secondaryTextColor,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Rp ${_formatCurrency(totalPrice)}',
                    style: GoogleFonts.poppins(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: _primaryTextColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            Flexible(
              flex: 4,
              child: ElevatedButton.icon(
                onPressed:
                    controller.product.stok > 0
                        ? () {
                          cartController.addItem(
                            controller.product,
                            quantity: controller.quantity.value,
                          );
                          _showSuccessSnackbar();
                        }
                        : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: blueClr,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: 16.h,
                    horizontal: 20.w,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  elevation: 2,
                  shadowColor: blueClr.withOpacity(0.4),
                  disabledBackgroundColor: Colors.grey.shade400,
                ),
                icon: Icon(
                  HugeIcons.strokeRoundedShoppingCart02,
                  size: 20.w,
                  color: Colors.white,
                ),
                label: Text(
                  'Add to Cart',
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Notifikasi sukses.
  void _showSuccessSnackbar() {
    Get.snackbar(
      'Success!',
      '${controller.quantity.value}x ${controller.product.namaProduk} added to cart.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
      duration: const Duration(seconds: 2),
      margin: EdgeInsets.all(16.w),
      borderRadius: 12.r,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  /// Format angka menjadi format mata uang Rupiah.
  String _formatCurrency(int amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: '',
      decimalDigits: 0,
    );
    return formatter.format(amount).trim();
  }
}
