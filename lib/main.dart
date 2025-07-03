// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import ScreenUtil
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import flutter_dotenv
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'package:flutter_easyloading/flutter_easyloading.dart'; // Import Flutter EasyLoading
import 'package:intl/date_symbol_data_local.dart'; // Add this import
import 'package:pos/app/data/utils/color.dart';

import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await initializeDateFormatting(
    'id_ID',
    null,
  ); // Initialize for Indonesian locale
  configLoading();

  runApp(
    ScreenUtilInit(
      designSize: const Size(360, 690), // Your design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: "Application",
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
          builder: EasyLoading.init(), // Crucial for EasyLoading to work
        );
      },
    ),
  );
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..lineWidth = 2.0
    ..radius = 10.0
    ..progressColor = kWhiteclr
    ..backgroundColor =
        blueClr // Ganti dengan warna utama kamu
    ..indicatorColor = kWhiteclr
    ..textColor = kWhiteclr
    ..maskColor = satu.withOpacity(0.3) // Bisa juga pakai `dua` atau `tiga`
    ..maskType = EasyLoadingMaskType.custom
    ..userInteractions = false
    ..dismissOnTap = false;
}
