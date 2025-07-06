// lib/app/modules/syarat_ketentuan/controllers/syarat_ketentuan_controller.dart

import 'package:get/get.dart';
import 'package:pos/app/data/models/syarat_ketentuan.dart';
import 'package:pos/app/data/syarat_ketentuan_provider.dart';

class SyaratKetentuanController extends GetxController {
  final SyaratKetentuanProvider provider = SyaratKetentuanProvider();

  var syaratKetentuan = SyaratKetentuan.empty().obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSyaratKetentuan();
  }

  void fetchSyaratKetentuan() async {
    try {
      isLoading(true);
      errorMessage('');

      final data = await provider.getSyaratKetentuan();
      syaratKetentuan.value = data;
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }
}
