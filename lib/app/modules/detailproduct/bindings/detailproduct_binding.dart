import 'package:get/get.dart';

import '../controllers/detailproduct_controller.dart';

class DetailproductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailproductController>(
      () => DetailproductController(),
    );
  }
}
