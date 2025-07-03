import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/app/data/home_provider.dart';
import 'package:pos/app/data/models/user.dart';
import 'package:pos/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart'; // Untuk kDebugMode

class SettingController extends GetxController {
  // Variabel reaktif untuk menyimpan data pengguna
  var user = Rxn<User>();

  @override
  void onInit() {
    super.onInit();
    // Memuat data pengguna saat controller diinisialisasi
    loadUser();
  }

  // Fungsi untuk memuat data pengguna dari provider
  Future<void> loadUser() async {
    try {
      // Asumsi HomeProvider().getUser() mengembalikan Future<User>
      final userData = await HomeProvider().getUser();
      user.value = userData;
    } catch (e) {
      if (kDebugMode) {
        print("❌ Gagal mengambil data user: $e");
      }
      Get.snackbar(
        'Error',
        'Gagal memuat data pengguna.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Fungsi logout dengan dialog konfirmasi
  Future<void> logout() async {
    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(), // Tutup dialog
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              // Hapus data dari SharedPreferences dan navigasi ke halaman login
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              Get.offAllNamed(Routes.LOGIN);
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
