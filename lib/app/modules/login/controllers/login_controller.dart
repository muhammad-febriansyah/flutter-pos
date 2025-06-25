import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'package:pos/app/data/models/setting.dart';
import 'package:pos/app/modules/login/providers/login_provider.dart';
import 'package:pos/app/routes/app_pages.dart';

class LoginController extends GetxController {
  final setting = Rxn<Setting>();
  final LoginProvider _provider = Get.put(LoginProvider());

  RxBool isLoading = false.obs;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final emailError = ''.obs;
  final passwordError = ''.obs;
  var isPasswordHidden = true.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void getSetting() async {
    try {
      setting.value = await _provider.fetchSetting();
    } catch (e) {
      Get.snackbar("Error", e.toString());
      debugPrint(e.toString());
    }
  }

  @override
  void onInit() {
    super.onInit();
    getSetting();
  }

  bool _validateFields() {
    emailError.value = '';
    passwordError.value = '';

    bool isValid = true;

    if (emailController.text.trim().isEmpty) {
      emailError.value = 'Email tidak boleh kosong.';
      isValid = false;
    } else if (!GetUtils.isEmail(emailController.text.trim())) {
      emailError.value = 'Format email tidak valid.';
      isValid = false;
    }

    if (passwordController.text.trim().isEmpty) {
      passwordError.value = 'Kata sandi tidak boleh kosong.';
      isValid = false;
    } else if (passwordController.text.trim().length < 6) {
      passwordError.value = 'Kata sandi minimal 6 karakter.';
      isValid = false;
    }

    return isValid;
  }

  Future<void> login() async {
    if (!_validateFields()) {
      Get.snackbar(
        'Validasi Gagal',
        'Mohon isi email dan kata sandi dengan benar.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        icon: const Icon(Icons.warning_rounded, color: Colors.white),
      );
      return;
    }

    EasyLoading.show(status: 'Sedang masuk...');
    isLoading.value = true;
    final success = await _provider.login(
      email: emailController.text,
      password: passwordController.text,
    );

    EasyLoading.dismiss();

    try {
      if (success) {
        isLoading.value = false;
        Get.snackbar(
          'Informasi',
          "Anda berhasil masuk.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
        );
        Get.offAllNamed(Routes.BOTTOMNAVIGATION);
      } else {
        isLoading.value = false;
        Get.snackbar(
          'Login Gagal',
          "Email atau password yang Anda masukkan salah.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: const Icon(Icons.error_rounded, color: Colors.white),
        );
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", e.toString());
      debugPrint(e.toString());
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
