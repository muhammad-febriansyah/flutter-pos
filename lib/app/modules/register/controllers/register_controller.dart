import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/models/setting.dart';
import 'package:pos/app/data/register_provider.dart';
import 'package:pos/app/routes/app_pages.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart'; // Import ini

class RegisterController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final nameError = ''.obs;
  final emailError = ''.obs;
  final passwordError = ''.obs;
  final confirmPasswordError = ''.obs;
  final phoneError = ''.obs;
  final setting = Rxn<Setting>();

  var isPasswordHidden = true.obs;
  var isPasswordConfirmHidden = true.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void togglePasswordConfirmVisibility() {
    isPasswordConfirmHidden.value = !isPasswordConfirmHidden.value;
  }

  void getSetting() async {
    try {
      setting.value = await RegisterProvider().fetchSetting();
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

  final isLoading = false.obs;
  final Dio _dio = Dio(); // Inisialisasi Dio
  bool _validateFields() {
    nameError.value = '';
    emailError.value = '';
    passwordError.value = '';
    confirmPasswordError.value = '';
    phoneError.value = '';

    bool isValid = true;

    if (nameController.text.trim().isEmpty) {
      nameError.value = 'Nama lengkap tidak boleh kosong.';
      isValid = false;
    }
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
    if (confirmPasswordController.text.trim().isEmpty) {
      confirmPasswordError.value = 'Konfirmasi kata sandi tidak boleh kosong.';
      isValid = false;
    }
    if (passwordController.text != confirmPasswordController.text) {
      confirmPasswordError.value =
          'Kata sandi dan konfirmasi kata sandi tidak cocok.';
      isValid = false;
    }
    if (phoneController.text.trim().isEmpty) {
      phoneError.value = 'Nomor telepon tidak boleh kosong.';
      isValid = false;
    }

    return isValid;
  }

  Future<void> register() async {
    if (!_validateFields()) {
      Get.snackbar(
        'Validasi Gagal',
        'Mohon isi semua kolom yang wajib dengan benar.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        icon: const Icon(
          Icons.warning_rounded,
          color: Colors.white,
        ), // Ikon untuk validasi gagal
      );
      return;
    }

    EasyLoading.show(status: 'Sedang mendaftar...');

    try {
      final response = await _dio.post(
        '${dotenv.env['BACKEND_URL']}/register',
        data: {
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
          'phone': phoneController.text.trim(),
          'address':
              addressController.text.trim().isEmpty
                  ? null
                  : addressController.text.trim(),
        },
      );

      EasyLoading.dismiss();

      if (response.statusCode == 201) {
        Get.snackbar(
          'Sukses',
          response.data['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: const Icon(
            Icons.check_circle_rounded,
            color: Colors.white,
          ), // Ikon untuk sukses
        );
        Get.offAllNamed(Routes.LOGIN);
      } else {
        Get.snackbar(
          'Gagal Registrasi',
          response.data['message'] ?? 'Terjadi kesalahan saat registrasi.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: const Icon(
            Icons.error_rounded,
            color: Colors.white,
          ), // Ikon untuk gagal
        );
      }
    } on DioException catch (e) {
      EasyLoading.dismiss();

      if (e.response != null) {
        if (e.response?.statusCode == 422) {
          final errors = e.response?.data['errors'];
          String errorMessage = 'Terjadi kesalahan validasi:\n';
          if (errors != null) {
            nameError.value = '';
            emailError.value = '';
            passwordError.value = '';
            confirmPasswordError.value = '';
            phoneError.value = '';

            errors.forEach((key, value) {
              if (key == 'name') nameError.value = value[0];
              if (key == 'email') emailError.value = value[0];
              if (key == 'password') passwordError.value = value[0];
              if (key == 'phone') phoneError.value = value[0];
              errorMessage += '- ${value[0]}\n';
            });
          }
          Get.snackbar(
            'Error Validasi',
            errorMessage,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 5),
            icon: const Icon(
              Icons.error_outline_rounded,
              color: Colors.white,
            ), // Ikon untuk error validasi backend
          );
        } else {
          Get.snackbar(
            'Gagal Registrasi',
            e.response?.data['message'] ??
                'Terjadi kesalahan: ${e.response?.statusCode}',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            icon: const Icon(
              Icons.cancel_rounded,
              color: Colors.white,
            ), // Ikon untuk error respons non-422
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Terjadi kesalahan jaringan: ${e.message}',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: const Icon(
            Icons.wifi_off_rounded,
            color: Colors.white,
          ), // Ikon untuk error jaringan
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar(
        'Error',
        'Terjadi kesalahan tak terduga: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(
          Icons.bug_report_rounded,
          color: Colors.white,
        ), // Ikon untuk error umum
      );
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
