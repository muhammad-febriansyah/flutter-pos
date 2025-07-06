// lib/app/modules/kebijakan_privasi/controllers/kebijakan_privasi_controller.dart

import 'package:get/get.dart';
import 'package:pos/app/data/kebijakan_privasi_provider.dart';
import 'package:pos/app/data/models/kebijakan_privasi.dart';

class KebijakanPrivasiController extends GetxController {
  final KebijakanPrivasiProvider provider = KebijakanPrivasiProvider();

  // State untuk menyimpan objek KebijakanPrivasi.
  // Inisialisasi dengan objek kosong untuk menghindari null error.
  var kebijakanPrivasi = KebijakanPrivasi.empty().obs;

  var isLoading = true.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchKebijakanPrivasi();
  }

  void fetchKebijakanPrivasi() async {
    try {
      isLoading(true);
      errorMessage('');

      final data = await provider.getKebijakanPrivasi();
      kebijakanPrivasi.value = data;
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }
}
