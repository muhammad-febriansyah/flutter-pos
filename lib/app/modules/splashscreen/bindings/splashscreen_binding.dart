import 'package:get/get.dart';
import 'package:pos/app/modules/splashscreen/providers/splash_provider.dart';

import '../controllers/splashscreen_controller.dart';

class SplashscreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashscreenController>(() => SplashscreenController());
    Get.lazyPut<SplashProvider>(() => SplashProvider());
  }
}
