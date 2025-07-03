import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos/app/routes/app_pages.dart';
import '../controllers/setting_controller.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});

  static const Color _primaryTextColor = Color(0xFF222B45);
  static const Color _secondaryTextColor = Color(0xFF8F9BB3);
  static const Color _accentColor = Color(0xff1b55f6);
  static const Color _backgroundColor = Color(0xFFF7F9FC);
  static const Color _dangerColor = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingController());

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          children: [
            // Gunakan Obx untuk merebuild widget ini saat data user berubah
            Obx(() {
              // Ambil data user dari controller
              final user = controller.user.value;
              return _buildProfileHeader(
                // Gunakan data user jika ada, jika tidak gunakan nilai default
                name: user?.name ?? "Nama Pengguna",
                email: user?.email ?? "email@pengguna.com",
                avatarUrl: user?.avatar, // Avatar bisa null
              );
            }),
            const SizedBox(height: 20),
            _buildMenuGroup(
              title: "AKUN SAYA",
              children: [
                _buildSettingTile(
                  icon: Icons.person_outline_rounded,
                  title: "Edit Profil",
                  onTap: () {
                    Get.toNamed(
                      Routes.PROFILE,
                      arguments: controller.user.value,
                    );
                  },
                ),
                _buildSettingTile(
                  icon: Icons.lock_outline_rounded,
                  title: "Ubah Password",
                  onTap: () {
                    Get.toNamed(Routes.CHANGE_PASSWORD);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildMenuGroup(
              title: "BANTUAN & INFORMASI",
              children: [
                _buildSettingTile(
                  icon: Icons.help_outline_rounded,
                  title: "Pusat Bantuan (FAQ)",
                  onTap: () {},
                ),
                _buildSettingTile(
                  icon: Icons.support_agent_rounded,
                  title: "Hubungi Kami",
                  onTap: () {},
                ),
                _buildSettingTile(
                  icon: Icons.shield_outlined,
                  title: "Kebijakan Privasi",
                  onTap: () {},
                ),
                _buildSettingTile(
                  icon: Icons.description_outlined,
                  title: "Syarat & Ketentuan",
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 30),
            // Tombol logout memanggil fungsi logout dari controller
            _buildLogoutButton(onTap: controller.logout),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader({
    required String name,
    required String email,
    String? avatarUrl,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: _accentColor,
            // Tampilkan gambar dari URL jika ada, jika tidak tampilkan ikon
            backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
            child:
                avatarUrl == null
                    ? const Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 35,
                    )
                    : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: _primaryTextColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: _secondaryTextColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Sisa widget (_buildMenuGroup, _buildSettingTile, _buildLogoutButton) tetap sama
  // ... (Salin sisa widget dari kode asli Anda di sini) ...
  Widget _buildMenuGroup({
    required String title,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8),
            child: Text(
              title,
              style: GoogleFonts.poppins(
                color: _secondaryTextColor,
                fontWeight: FontWeight.w500,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.05),
                  spreadRadius: 1,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: List.generate(children.length, (index) {
                return Column(
                  children: [
                    children[index],
                    if (index < children.length - 1)
                      const Divider(
                        height: 1,
                        thickness: 1,
                        indent: 56,
                        endIndent: 16,
                        color: _backgroundColor,
                      ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(27, 85, 246, 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: _accentColor, size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          color: _primaryTextColor,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
        color: _secondaryTextColor,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _buildLogoutButton({required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color.fromRGBO(229, 57, 53, 0.3)),
        ),
        tileColor: const Color.fromRGBO(229, 57, 53, 0.05),
        leading: const Icon(Icons.logout_rounded, color: _dangerColor),
        title: Text(
          'Logout',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: _dangerColor,
          ),
        ),
      ),
    );
  }
}
