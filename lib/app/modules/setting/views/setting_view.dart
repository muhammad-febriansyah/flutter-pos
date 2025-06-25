import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/setting_controller.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingController());
    return Scaffold(
      appBar: AppBar(title: const Text('SettingView'), centerTitle: true),
      body: Center(
        child: InkWell(
          child: Text('SettingView is working', style: TextStyle(fontSize: 20)),
          onTap: () => controller.logout(),
        ),
      ),
    );
  }
}
