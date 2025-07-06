import 'package:get/get.dart';

import '../controllers/kebijakan_privasi_controller.dart';

class KebijakanPrivasiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KebijakanPrivasiController>(
      () => KebijakanPrivasiController(),
    );
  }
}
