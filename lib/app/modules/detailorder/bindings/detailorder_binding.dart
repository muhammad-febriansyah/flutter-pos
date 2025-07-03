import 'package:get/get.dart';

import '../controllers/detailorder_controller.dart';

class DetailorderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailorderController>(
      () => DetailorderController(),
    );
  }
}
