import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/models/setting.dart';
import 'package:pos/app/modules/splashscreen/providers/splash_provider.dart';

class ContactUsController extends GetxController {
  final setting = Rxn<Setting>();
  @override
  void onInit() {
    super.onInit();
    getSetting();
  }

  void getSetting() async {
    try {
      SplashProvider().getSetting().then((setting) {
        this.setting.value = setting;
      });
    } catch (e) {
      Get.snackbar("Error", "Gagal ambil data setting");
      if (kDebugMode) print("Error getSetting: $e");
    }
  }
}
