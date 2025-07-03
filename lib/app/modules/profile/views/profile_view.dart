// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  // [FIX] Palet warna diubah sesuai permintaan.
  final Color primaryColor = const Color(0xff1b55f6);
  final Color secondaryColor = const Color(
    0xFF4C82F7,
  ); // Warna sekunder disesuaikan
  final Color bgColor = const Color(0xFFF8F7FF);
  final Color textColor = const Color(0xFF333333);
  final Color subtextColor = const Color(0xFF8A8A8A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // [FIX] AppBar ditambahkan langsung ke Scaffold dengan warna primer.
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Edit Profil',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [bgColor, Colors.white],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: [
            const SizedBox(height: 30),
            _buildHeader(primaryColor, secondaryColor, textColor, subtextColor),
            const SizedBox(height: 40),
            _buildFormCard(textColor, subtextColor, primaryColor),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Bagian Header: Avatar, Nama, dan Email
  Widget _buildHeader(
    Color primaryColor,
    Color secondaryColor,
    Color textColor,
    Color subtextColor,
  ) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Obx(
              () => Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [primaryColor, secondaryColor],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 74,
                  backgroundColor: Colors.transparent,
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        controller.pickedImage.value != null
                            ? FileImage(controller.pickedImage.value!)
                            : (controller.user.avatar != null
                                ? NetworkImage(controller.user.avatar!)
                                : null),
                    child:
                        controller.pickedImage.value == null &&
                                controller.user.avatar == null
                            ? Icon(
                              Icons.person_outline_rounded,
                              size: 80,
                              color: Colors.grey.shade300,
                            )
                            : null,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () => controller.pickImage(),
              borderRadius: BorderRadius.circular(30),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, secondaryColor],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          controller.nameC.text,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: textColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          controller.emailC.text,
          style: GoogleFonts.poppins(fontSize: 16, color: subtextColor),
        ),
      ],
    );
  }

  // Kartu yang membungkus semua form input
  Widget _buildFormCard(
    Color textColor,
    Color subtextColor,
    Color primaryColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildFormField(
            controller: controller.nameC,
            label: 'Nama Lengkap',
            icon: HugeIcons.strokeRoundedUser02,
            primaryColor: primaryColor,
            subtextColor: subtextColor,
          ),
          const SizedBox(height: 20),
          _buildFormField(
            controller: controller.emailC,
            label: 'Email',
            icon: HugeIcons.strokeRoundedMail02,
            readOnly: true,
            primaryColor: primaryColor,
            subtextColor: subtextColor,
          ),
          const SizedBox(height: 20),
          _buildFormField(
            controller: controller.phoneC,
            label: 'Nomor Telepon',
            icon: HugeIcons.strokeRoundedWhatsapp,
            keyboardType: TextInputType.phone,
            primaryColor: primaryColor,
            subtextColor: subtextColor,
          ),
          const SizedBox(height: 20),
          _buildFormField(
            controller: controller.addressC,
            label: 'Alamat',
            icon: Icons.location_on_rounded,
            maxLines: 3,
            primaryColor: primaryColor,
            subtextColor: subtextColor,
          ),
          const SizedBox(height: 30),
          _buildSaveButton(primaryColor, secondaryColor),
        ],
      ),
    );
  }

  // Desain baru untuk setiap input field
  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color primaryColor,
    required Color subtextColor,
    bool readOnly = false,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: subtextColor),
        floatingLabelStyle: GoogleFonts.poppins(
          color: primaryColor,
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: Icon(icon, color: subtextColor),
        filled: true,
        fillColor: readOnly ? Colors.grey.shade100 : const Color(0xFFF8F7FF),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
      ),
    );
  }

  // Desain baru untuk tombol simpan dengan gradasi
  Widget _buildSaveButton(Color primaryColor, Color secondaryColor) {
    return Obx(
      () => InkWell(
        onTap:
            controller.isLoading.value
                ? null
                : () => controller.updateProfile(),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, secondaryColor],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Center(
            child:
                controller.isLoading.value
                    ? const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    )
                    : Text(
                      'Simpan Perubahan',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
          ),
        ),
      ),
    );
  }
}
