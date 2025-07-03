import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/models/detail_penjualan.dart'; // Import model DetailPenjualanModel dan Datum
import 'package:pos/app/data/success_provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart'; // Import SuccessProvider Anda

class SuccessController extends GetxController {
  var detailPenjualanList = Rx<List<DataPenjualan>?>(null);
  final String? invoiceNumber = Get.arguments?['invoiceNumber'];
  RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );
  var isLoading = false.obs;

  void onRefresh() async {
    await getDetailPenjualan();
    refreshController.refreshCompleted();
  }

  @override
  void onInit() {
    super.onInit();

    // Debugging: Cetak invoice number yang diterima
    if (kDebugMode) {
      print('=== SuccessController Init Debug ===');
      print('Invoice Number from arguments: $invoiceNumber');
      print('=== End SuccessController Init Debug ===');
    }

    // Panggil API hanya jika invoiceNumber valid
    if (invoiceNumber != null && invoiceNumber!.isNotEmpty) {
      getDetailPenjualan();
    } else {
      if (kDebugMode) {
        print('Error: Invoice Number is null or empty. Cannot fetch details.');
      }
      Get.snackbar(
        'Error',
        'Nomor Invoice tidak ditemukan. Gagal memuat detail.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      // Set list menjadi kosong agar UI menampilkan pesan "data kosong"
      detailPenjualanList.value = [];
    }
  }

  Future<void> getDetailPenjualan() async {
    isLoading(true); // Mulai loading
    try {
      if (kDebugMode) {
        print('Fetching detail for invoice number: $invoiceNumber');
      }
      final responseModel = await SuccessProvider().getProductDetail(
        invoiceNumber: invoiceNumber!,
      );

      if (responseModel.success && responseModel.data.isNotEmpty) {
        detailPenjualanList.value = responseModel.data;
      } else {
        detailPenjualanList.value = [];
        Get.snackbar(
          'Info',
          'Tidak ada detail transaksi ditemukan untuk invoice ini.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Tangani error saat memanggil API
      if (kDebugMode) {
        print('Error fetching detail penjualan: $e');
      }
      Get.snackbar(
        'Error',
        'Gagal memuat detail transaksi: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      detailPenjualanList.value = null;
    } finally {
      isLoading(false); // Selesai loading
    }
  }
}
