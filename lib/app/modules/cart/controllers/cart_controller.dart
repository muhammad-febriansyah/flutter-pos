import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/models/cart.dart';
import 'package:pos/app/data/models/product.dart';
import 'package:pos/app/data/models/setting.dart';
import 'package:pos/app/modules/splashscreen/providers/splash_provider.dart';

class CartController extends GetxController {
  final RxList<CartItem> cartItems = <CartItem>[].obs;
  final RxInt subTotal = 0.obs;
  final RxInt ppnAmount = 0.obs;
  final RxInt biayaLayanan = 0.obs;
  final RxInt total = 0.obs;
  final setting = Rxn<Setting>();

  @override
  void onInit() {
    super.onInit();

    getSetting();

    ever(cartItems, (_) {
      _calculateTotals();
      everAll(
        cartItems.map((item) => item.quantity).toList(),
        (_) => _calculateTotals(),
      );
    });

    ever(setting, (_) => _calculateTotals());
  }

  void getSetting() async {
    try {
      final fetchedSetting = await SplashProvider().getSetting();
      setting.value = fetchedSetting;
    } catch (e) {
      Get.snackbar("Error", "Gagal ambil data setting");
      if (kDebugMode) print("Error getSetting: $e");
    }
  }

  void addItem(Datum product, {int quantity = 1}) {
    final index = cartItems.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      cartItems[index].updateQuantity(
        cartItems[index].quantity.value + quantity,
      );
    } else {
      cartItems.add(CartItem(product: product, quantity: quantity));
    }
  }

  void increaseQuantity(CartItem cartItem) {
    cartItem.updateQuantity(cartItem.quantity.value + 1);
    _calculateTotals();
  }

  void decreaseQuantity(CartItem cartItem) {
    if (cartItem.quantity.value > 1) {
      cartItem.updateQuantity(cartItem.quantity.value - 1);
    } else {
      removeItem(cartItem);
    }
    _calculateTotals();
  }

  void removeItem(CartItem cartItem) {
    cartItems.removeWhere((item) => item.product.id == cartItem.product.id);
  }

  void clearCart() {
    cartItems.clear();
  }

  void _calculateTotals() {
    int currentSubTotal = 0;
    for (var item in cartItems) {
      currentSubTotal += item.subtotal.value;
    }
    subTotal.value = currentSubTotal;

    final ppnPercent = (setting.value?.data.ppn ?? 0) / 100;
    final serviceFeePercent = setting.value?.data.biayaLainnya ?? 0;

    ppnAmount.value = (subTotal.value * ppnPercent).round();
    biayaLayanan.value = (subTotal.value * serviceFeePercent).round();
    total.value = subTotal.value + ppnAmount.value + biayaLayanan.value;
  }
}
