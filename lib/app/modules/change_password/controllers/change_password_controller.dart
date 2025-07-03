import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:pos/app/data/profile_provider.dart'; // Sembunyikan Response dari GetX

class ChangePasswordController extends GetxController {
  // State untuk loading
  var isLoading = false.obs;

  // Controller untuk text fields
  late TextEditingController currentPasswordC;
  late TextEditingController newPasswordC;
  late TextEditingController confirmPasswordC;

  // State untuk visibility password
  var isCurrentObscure = true.obs;
  var isNewObscure = true.obs;
  var isConfirmObscure = true.obs;

  final ProfileProvider _provider = ProfileProvider();

  @override
  void onInit() {
    super.onInit();
    currentPasswordC = TextEditingController();
    newPasswordC = TextEditingController();
    confirmPasswordC = TextEditingController();
  }

  Future<void> updatePassword() async {
    // Validasi client-side
    if (currentPasswordC.text.isEmpty ||
        newPasswordC.text.isEmpty ||
        confirmPasswordC.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Semua field harus diisi',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (newPasswordC.text != confirmPasswordC.text) {
      Get.snackbar(
        'Error',
        'Password baru tidak cocok',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      await _provider.updatePassword(
        currentPassword: currentPasswordC.text,
        newPassword: newPasswordC.text,
        newPasswordConfirmation: confirmPasswordC.text,
      );

      // Jika berhasil
      Get.back(); // Kembali ke halaman setting
      Get.snackbar(
        'Sukses',
        'Password berhasil diperbarui!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      // Menampilkan error dari provider
      Get.snackbar(
        'Gagal',
        e.toString().replaceAll("Exception: ", ""), // Membersihkan pesan error
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    currentPasswordC.dispose();
    newPasswordC.dispose();
    confirmPasswordC.dispose();
    super.onClose();
  }
}
