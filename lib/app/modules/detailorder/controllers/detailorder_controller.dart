import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/models/detail_penjualan.dart';
import 'package:pos/app/data/models/penjualan.dart';
import 'package:pos/app/data/success_provider.dart';

class DetailorderController extends GetxController {
  final Datum order = Get.arguments;
  final isLoading = false.obs;
  final error = ''.obs;
  final detailPenjualanList = Rxn<DetailPenjualanModel>();

  @override
  void onInit() {
    super.onInit();
    getDetail();
  }

  Future<void> getDetail() async {
    final invoice = order.invoiceNumber;
    if (kDebugMode) {
      print("ini invoice: $invoice");
    }
    try {
      isLoading.value = true;

      final data = await SuccessProvider().getProductDetail(
        invoiceNumber: invoice,
      );
      detailPenjualanList.value = data;
      if (kDebugMode) {
        print(
          "Berhasil ambil detail invoice $invoice: ${data.data.length} item",
        );
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
