// // app/modules/login/views/google_login_webview.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:get/get.dart';
// import 'package:pos/app/routes/app_pages.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:pos/app/data/providers/api_provider.dart';
// import 'package:pos/app/modules/login/controllers/login_controller.dart';
// import 'dart:convert';
// import 'package:dio/dio.dart' as dio; // <--- This line is critical!

// class GoogleLoginWebview extends StatefulWidget {
//   const GoogleLoginWebview({super.key});

//   @override
//   State<GoogleLoginWebview> createState() => _GoogleLoginWebviewState();
// }

// class _GoogleLoginWebviewState extends State<GoogleLoginWebview> {
//   late final WebViewController _controller;
//   final ApiProvider _apiProvider = Get.find<ApiProvider>();
//   final LoginController _loginController = Get.find<LoginController>();

//   @override
//   void initState() {
//     super.initState();

//     final String googleLoginUrl = _apiProvider.getGoogleLoginUrl();

//     _controller =
//         WebViewController()
//           ..setJavaScriptMode(JavaScriptMode.unrestricted)
//           ..setNavigationDelegate(
//             NavigationDelegate(
//               onProgress: (int progress) {
//                 // ...
//               },
//               onPageStarted: (String url) {
//                 debugPrint('Page started loading: $url');
//               },
//               onPageFinished: (String url) {
//                 debugPrint('Page finished loading: $url');
//               },
//               onWebResourceError: (WebResourceError error) {
//                 debugPrint('Web resource error: ${error.description}');
//                 Get.snackbar(
//                   'Error',
//                   'Terjadi kesalahan saat memuat halaman login Google.',
//                   snackPosition: SnackPosition.BOTTOM,
//                   backgroundColor: Colors.red,
//                 );
//                 Get.back();
//               },
//               onNavigationRequest: (NavigationRequest request) async {
//                 debugPrint('Navigating to: ${request.url}');

//                 final String laravelCallbackUrl =
//                     '${_apiProvider.getBackendBaseUrl()}/api/auth/google/callback';

//                 if (request.url.startsWith(laravelCallbackUrl)) {
//                   debugPrint(
//                     'Intercepted Laravel callback URL: ${request.url}',
//                   );
//                   _fetchGoogleCallbackResult(request.url);
//                   return NavigationDecision.prevent;
//                 }
//                 return NavigationDecision.navigate;
//               },
//             ),
//           )
//           ..loadRequest(Uri.parse(googleLoginUrl));
//   }

//   Future<void> _fetchGoogleCallbackResult(String callbackUrl) async {
//     try {
//       // THIS IS WHERE THE PREVIOUS ERROR WAS SOLVED BY ADDING 'dio.Dio get dio => _dio;' IN ApiProvider
//       // And where the 'prefix_shadowed_by_local_declaration' error might occur if 'dio' was used locally.
//       // Now, by ensuring 'import 'package:dio/dio.dart' as dio;' here, the context is clear.
//       final response = await _apiProvider.client.get(
//         callbackUrl,
//       ); // Accessing the Dio instance from ApiProvider

//       if (response.statusCode == 200) {
//         final token = response.data['token'];
//         final userData = response.data['user'];

//         await _loginController.handleGoogleLoginCallback(
//           token,
//           jsonEncode(userData),
//         );
//         Get.offAllNamed(Routes.HOME);
//       } else {
//         Get.snackbar(
//           'Error',
//           response.data['message'] ??
//               'Gagal mendapatkan data login Google dari server.',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//         );
//       }
//     } on dio.DioException catch (e) {
//       // <--- ALSO ensure this uses dio.DioException
//       Get.snackbar(
//         'Error',
//         'Error saat memproses callback Google: ${e.toString()}',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//       );
//     } finally {
//       Get.back();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Masuk dengan Google')),
//       body: WebViewWidget(controller: _controller),
//     );
//   }
// }
