import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'package:pos/app/data/checkout_provider.dart';
import 'package:pos/app/data/models/cart.dart';
import 'package:pos/app/data/models/meja.dart';
import 'package:pos/app/modules/cart/controllers/cart_controller.dart';
import 'package:pos/app/modules/checkout/views/widget/midtrans_view.dart';
import 'package:pos/app/routes/app_pages.dart';

class CheckoutController extends GetxController {
  final selectedPaymentMethod = 'cash'.obs;
  final isLoading = false.obs;
  final selectedOrderType = 'dine_in'.obs;
  final listMeja = <DataMeja>[].obs;
  final selectedMeja = Rx<DataMeja?>(null);

  final CheckoutProvider _checkoutProvider = CheckoutProvider();
  final CartController cartController = Get.find<CartController>();

  @override
  void onInit() {
    super.onInit();
    fetchMejaData();

    ever(selectedOrderType, (String? orderType) {
      if (orderType == 'take_away' || orderType == 'delivery') {
        selectedMeja.value = null;
      } else if (orderType == 'dine_in') {
        if (selectedMeja.value == null && listMeja.isNotEmpty) {
          final meja = listMeja.firstWhereOrNull((m) => m.status == 'tersedia');
          if (meja != null) {
            selectedMeja.value = meja;
            selectedMeja.refresh();
          }
        }
      }
    });
  }

  Future<void> fetchMejaData() async {
    try {
      final mejaModel = await _checkoutProvider.fetchMeja();
      if (mejaModel.success && mejaModel.data.isNotEmpty) {
        listMeja.assignAll(mejaModel.data);
      } else {
        listMeja.clear();
      }
    } catch (e) {
      _showSnackbar(
        'Error',
        'Gagal mengambil data meja: ${e.toString()}',
        Colors.red,
      );
    }
  }

  void selectMeja(DataMeja meja) {
    if (meja.status == 'tersedia') {
      selectedMeja.value = meja;
    } else {
      _showSnackbar(
        'Peringatan',
        'Meja ${meja.nama} tidak tersedia.',
        Colors.orange,
      );
    }
  }

  void changePaymentMethod(String method) {
    if (['cash', 'midtrans'].contains(method)) {
      selectedPaymentMethod.value = method;
    }
  }

  void changeOrderType(String type) {
    if (['dine_in', 'take_away', 'delivery'].contains(type)) {
      selectedOrderType.value = type;
    }
  }

  int? _safeParseId(dynamic id) {
    if (id == null) return null;
    if (id is int) return id;
    return int.tryParse(id.toString());
  }

  bool _validateCartItems(List<CartItem> cartItems) {
    if (cartItems.isEmpty) {
      _showSnackbar('Kosong', 'Keranjang masih kosong.', Colors.orange);
      return false;
    }
    return true;
  }

  bool _validateOrderRequirements(String orderType) {
    if (orderType == 'dine_in' && selectedMeja.value == null) {
      _showSnackbar('Peringatan', 'Pilih meja untuk dine in.', Colors.orange);
      return false;
    }
    return true;
  }

  Future<void> processPayment(
    List<CartItem> cartItems,
    int totalAmount,
    String orderType,
  ) async {
    if (isLoading.value) return;
    isLoading.value = true;

    final List<CartItem> itemsForSuccessPage = List<CartItem>.from(cartItems);

    try {
      if (!_validateCartItems(cartItems) ||
          !_validateOrderRequirements(orderType)) {
        isLoading.value = false;
        return;
      }

      final formattedItems =
          cartItems.map((item) {
            final productId = _safeParseId(item.product.id);
            return {'id': productId, 'qty': item.quantity.value};
          }).toList();

      final prefs = await SharedPreferences.getInstance();
      final customerId = prefs.getInt('idUser');

      int? mejaId;
      if (orderType == 'dine_in' && selectedMeja.value != null) {
        mejaId = _safeParseId(selectedMeja.value!.id);
      }

      final payload = {
        'cartItems': formattedItems,
        'paymentMethod': selectedPaymentMethod.value,
        'customerId': customerId,
        'mejaId': mejaId,
        'type': orderType,
      };

      if (selectedPaymentMethod.value == 'cash') {
        payload['amountPaid'] = totalAmount;
      }

      final response = await _checkoutProvider.processSale(payload);

      if (response['success'] == true) {
        await _handleSuccessfulPayment(
          response,
          totalAmount,
          itemsForSuccessPage,
        );
      } else {
        _handleFailedPayment(response);
      }
    } catch (e) {
      _showSnackbar('Error', e.toString(), Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _handleSuccessfulPayment(
    Map<String, dynamic> response,
    int totalAmount,
    List<CartItem> purchasedItems,
  ) async {
    if (kDebugMode) {
      debugPrint(
        '=== CheckoutController Debug: Data yang akan dikirim ke SuccessView ===',
      );
      debugPrint('Total Amount: $totalAmount');
      debugPrint('Payment Method: ${selectedPaymentMethod.value}');
      debugPrint('Jumlah purchasedItems: ${purchasedItems.length}');

      if (purchasedItems.isNotEmpty) {
        debugPrint('Contoh item pertama:');
        debugPrint('  Nama Produk: ${purchasedItems.first.product.namaProduk}');
        debugPrint('  Quantity: ${purchasedItems.first.quantity.value}');
        debugPrint('  JSON: ${purchasedItems.first.toJson()}');
      } else {
        debugPrint('❌ purchasedItems kosong!');
      }

      try {
        final purchasedItemsJsonTest =
            purchasedItems.map((item) => item.toJson()).toList();
        debugPrint(
          '✅ Successfully converted to JSON: ${purchasedItemsJsonTest.length} items',
        );
        debugPrint(
          'First JSON item: ${purchasedItemsJsonTest.isNotEmpty ? purchasedItemsJsonTest.first : 'none'}',
        );

        final testParsing =
            purchasedItemsJsonTest
                .map((json) => CartItem.fromJson(json))
                .toList();
        debugPrint(
          '✅ Test parsing back successful: ${testParsing.length} items',
        );
      } catch (e, stackTrace) {
        debugPrint('❌ Error in JSON conversion/parsing: $e');
        debugPrint('❌ StackTrace: $stackTrace');
      }

      debugPrint('=== Akhir CheckoutController Debug ===');
    }

    cartController.clearCart();

    final purchasedItemsJson =
        purchasedItems.map((item) => item.toJson()).toList();

    if (selectedPaymentMethod.value == 'cash') {
      Get.offAllNamed(
        Routes.SUCCESS,
        arguments: {
          'message': response['message'],
          'invoice': response['invoice'],
          'change': response['change'],
          'status': response['status_penjualan'],
          'invoiceNumber': response['invoice']?['invoice_number'],
          'totalAmount': totalAmount,
          'purchasedItems': purchasedItemsJson,
          'paymentMethod': selectedPaymentMethod.value,
        },
      );
    } else if (selectedPaymentMethod.value == 'midtrans') {
      final snapToken = response['snapToken'];
      final midtransClientKey = dotenv.env['MIDTRANS_CLIENTKEY'];

      if (snapToken != null &&
          snapToken.toString().isNotEmpty &&
          midtransClientKey != null &&
          midtransClientKey.isNotEmpty) {
        final midtransResult = await Get.to(
          () => MidtransPaymentView(
            snapToken: snapToken.toString(),
            clientKey: midtransClientKey,
          ),
        );

        if (midtransResult != null) {
          if (midtransResult.isSuccess) {
            _showSnackbar(
              'Berhasil',
              'Pembayaran berhasil dikonfirmasi!',
              Colors.green,
            );
            Get.offAllNamed(
              Routes.SUCCESS,
              arguments: {
                'message': 'Pembayaran Midtrans berhasil!',
                'invoiceNumber': midtransResult.orderId,
                'status': 'paid',
                'totalAmount': totalAmount,
                'purchasedItems': purchasedItemsJson,
                'paymentMethod': selectedPaymentMethod.value,
              },
            );
          } else if (midtransResult.isCanceled) {
            _showSnackbar('Gagal', 'Pembayaran dibatalkan.', Colors.red);
            Get.back();
          } else if (midtransResult.isFailed) {
            _showSnackbar(
              'Gagal',
              'Pembayaran gagal. Status: ${midtransResult.transactionStatus}.',
              Colors.red,
            );
            Get.back();
          } else if (midtransResult.isPending) {
            _showSnackbar(
              'Pending',
              'Pembayaran masih tertunda. Status: ${midtransResult.transactionStatus}.',
              Colors.orange,
            );
            Get.back();
          } else {
            _showSnackbar(
              'Informasi',
              'Status pembayaran tidak dikenal: ${midtransResult.transactionStatus}.',
              Colors.blueGrey,
            );
            Get.back();
          }
        } else {
          _showSnackbar(
            'Informasi',
            'Pembayaran tidak diselesaikan atau ada masalah komunikasi dengan Midtrans.',
            Colors.blueGrey,
          );
          Get.back();
        }
      } else {
        _showSnackbar(
          'Error',
          'Snap Token atau Client Key Midtrans tidak tersedia atau kosong.',
          Colors.red,
        );
      }
    }
  }

  void _handleFailedPayment(Map<String, dynamic> response) {
    String errorMessage = response['message'] ?? 'Gagal memproses pembayaran.';
    _showSnackbar('Gagal Pembayaran', errorMessage, Colors.red);
  }

  void _showSnackbar(String title, String message, Color bgColor) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: bgColor,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(16),
    );
  }
}
