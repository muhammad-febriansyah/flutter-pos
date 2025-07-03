// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xff1b55f6);
    const Color secondaryColor = Color(0xFF4C82F7);
    const Color bgColor = Color(0xFFF8F7FF);
    const Color subtextColor = Color(0xFF8A8A8A);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Ubah Password',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(24),
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
                _buildPasswordField(
                  controller: controller.currentPasswordC,
                  label: 'Password Saat Ini',
                  isObscure: controller.isCurrentObscure,
                  primaryColor: primaryColor,
                  subtextColor: subtextColor,
                ),
                const SizedBox(height: 20),
                _buildPasswordField(
                  controller: controller.newPasswordC,
                  label: 'Password Baru',
                  isObscure: controller.isNewObscure,
                  primaryColor: primaryColor,
                  subtextColor: subtextColor,
                ),
                const SizedBox(height: 20),
                _buildPasswordField(
                  controller: controller.confirmPasswordC,
                  label: 'Konfirmasi Password Baru',
                  isObscure: controller.isConfirmObscure,
                  primaryColor: primaryColor,
                  subtextColor: subtextColor,
                ),
                const SizedBox(height: 30),
                _buildSaveButton(primaryColor, secondaryColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required RxBool isObscure,
    required Color primaryColor,
    required Color subtextColor,
  }) {
    return Obx(
      () => TextFormField(
        controller: controller,
        obscureText: isObscure.value,
        style: GoogleFonts.poppins(),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(color: subtextColor),
          floatingLabelStyle: GoogleFonts.poppins(
            color: primaryColor,
            fontWeight: FontWeight.w600,
          ),
          prefixIcon: Icon(Icons.lock_outline_rounded, color: subtextColor),
          suffixIcon: IconButton(
            icon: Icon(
              isObscure.value ? Icons.visibility_off : Icons.visibility,
              color: subtextColor,
            ),
            onPressed: () {
              isObscure.value = !isObscure.value;
            },
          ),
          filled: true,
          fillColor: const Color(0xFFF8F7FF),
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
      ),
    );
  }

  Widget _buildSaveButton(Color primaryColor, Color secondaryColor) {
    return Obx(
      () => InkWell(
        onTap:
            controller.isLoading.value
                ? null
                : () => controller.updatePassword(),
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
                      'Simpan Password',
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
