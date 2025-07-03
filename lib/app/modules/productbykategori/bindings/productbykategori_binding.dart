import 'package:get/get.dart';

import '../controllers/productbykategori_controller.dart';

class ProductbykategoriBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductbykategoriController>(
      () => ProductbykategoriController(),
    );
  }
}
