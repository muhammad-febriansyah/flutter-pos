import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/models/setting.dart';
import 'package:pos/app/modules/splashscreen/providers/splash_provider.dart';
import 'package:pos/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashscreenController extends GetxController {
  final setting = Rxn<Setting>();

  @override
  void onInit() {
    super.onInit();
    getSetting();
    checkLogin();
  }

  void checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    Future.delayed(const Duration(seconds: 5), () {
      if (token != null) {
        Get.offAllNamed(Routes.BOTTOMNAVIGATION);
      } else {
        Get.offAllNamed(Routes.LOGIN);
      }
    });
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
