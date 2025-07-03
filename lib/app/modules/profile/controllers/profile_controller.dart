import 'dart:io';

import 'package:dio/dio.dart'; // Impor untuk FormData & MultipartFile
import 'package:flutter/material.dart';
// [FIX] Sembunyikan MultipartFile & FormData dari GetX untuk menghindari konflik
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:image_picker/image_picker.dart';
import 'package:pos/app/data/models/user.dart';
import 'package:pos/app/data/profile_provider.dart';
import 'package:pos/app/modules/setting/controllers/setting_controller.dart';

// Nama class sesuai permintaan Anda
class ProfileController extends GetxController {
  var isLoading = false.obs;

  // Controller untuk text fields
  late TextEditingController nameC;
  late TextEditingController emailC;
  late TextEditingController phoneC;
  late TextEditingController addressC;

  // State untuk menyimpan file gambar yang dipilih
  var pickedImage = Rxn<File>();
  final ImagePicker _picker = ImagePicker();

  // Provider untuk API
  final ProfileProvider _provider = ProfileProvider();

  // Menyimpan data user awal
  final User user = Get.arguments;

  @override
  void onInit() {
    super.onInit();
    // Inisialisasi controller dengan data user saat ini
    nameC = TextEditingController(text: user.name);
    emailC = TextEditingController(text: user.email);
    phoneC = TextEditingController(text: user.phone); // Handle null phone
    addressC = TextEditingController(text: user.address); // Handle null address
  }

  // Fungsi untuk memilih gambar dari galeri
  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        pickedImage.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memilih gambar: $e');
    }
  }

  // Fungsi untuk mengirim data update ke API
  Future<void> updateProfile() async {
    // Validasi sederhana
    if (nameC.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Nama tidak boleh kosong',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Siapkan data untuk dikirim
      Map<String, dynamic> data = {
        'name': nameC.text,
        'phone': phoneC.text,
        'address': addressC.text,
      };

      // Tambahkan file gambar jika ada yang dipilih
      if (pickedImage.value != null) {
        data['avatar'] = await MultipartFile.fromFile(
          pickedImage.value!.path,
          filename: pickedImage.value!.path.split('/').last,
        );
      }

      // Buat FormData
      final formData = FormData.fromMap(data);

      // Panggil provider
      final response = await _provider.updateProfile(formData);

      if (response.statusCode == 200) {
        // Refresh data di halaman setting
        Get.find<SettingController>().loadUser();
        Get.back(); // Kembali ke halaman setting
        Get.snackbar(
          'Sukses',
          'Profil berhasil diperbarui!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    // Hapus controller untuk menghindari memory leak
    nameC.dispose();
    emailC.dispose();
    phoneC.dispose();
    addressC.dispose();
    super.onClose();
  }
}
