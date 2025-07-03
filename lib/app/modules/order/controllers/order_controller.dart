import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/models/penjualan.dart';
import 'package:pos/app/data/order_provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class OrderController extends GetxController {
  final order = Rxn<PenjualanModel>();
  final isLoading = true.obs;
  final searchTerm = ''.obs;

  RefreshController refreshControllerOrder = RefreshController(
    initialRefresh: false,
  );

  @override
  void onInit() {
    getOrder();
    super.onInit();
  }

  void onRefresh() async {
    await getOrder();
    refreshControllerOrder.refreshCompleted();
  }

  Future<void> getOrder() async {
    isLoading.value = true;
    try {
      final fetchedOrder = await OrderProvider().getOrder();
      order.value = fetchedOrder;
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal ambil data order: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      if (kDebugMode) print("Error getOrder: $e");
    } finally {
      isLoading.value = false;
    }
  }

  List<Datum> get filteredOrders {
    if (order.value == null || order.value!.data.isEmpty) {
      return [];
    }

    if (searchTerm.value.isEmpty) {
      return order.value!.data;
    }

    final lowerCaseSearchTerm = searchTerm.value.toLowerCase();
    return order.value!.data.where((ord) {
      final formattedDate =
          DateFormat(
            'dd-MM-yyyy HH:mm',
          ).format(ord.createdAt.toLocal()).toLowerCase();

      return ord.invoiceNumber.toLowerCase().contains(lowerCaseSearchTerm) ||
          ord.status.toString().toLowerCase().contains(lowerCaseSearchTerm) ||
          ord.type.toString().toLowerCase().contains(lowerCaseSearchTerm) ||
          formattedDate.contains(lowerCaseSearchTerm);
    }).toList();
  }
}
