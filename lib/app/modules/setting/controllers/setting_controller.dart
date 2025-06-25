import 'package:get/get.dart';
import 'package:pos/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingController extends GetxController {
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAllNamed(Routes.LOGIN);
  }
}
