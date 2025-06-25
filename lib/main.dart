import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import ScreenUtil
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import flutter_dotenv
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'package:flutter_easyloading/flutter_easyloading.dart'; // Import Flutter EasyLoading

import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
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

// Function to configure EasyLoading
void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..lineWidth = 2.0
    ..radius = 10.0
    ..progressColor =
        Colors
            .white // Adjust colors as per your theme
    ..backgroundColor =
        Colors
            .blue // Adjust colors as per your theme
    ..indicatorColor =
        Colors
            .white // Adjust colors as per your theme
    ..textColor =
        Colors
            .white // Adjust colors as per your theme
    ..maskColor = Colors.blue.shade400
    ..maskType = EasyLoadingMaskType.black
    ..userInteractions = false
    ..dismissOnTap = false;
}
